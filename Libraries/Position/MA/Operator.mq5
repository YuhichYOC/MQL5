#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_OPERATOR_H
#define D_OPERATOR_H

#ifndef IG_TRADE_MQH
#define IG_TRADE_MQH
#include <Trade\Trade.mqh>
#endif

#ifndef IG_OPEN_PATTERNS
#define IG_OPEN_PATTERNS
#include "OpenPatterns\Pattern01.mq5"
#include "OpenPatterns\Pattern02.mq5"
#endif

#ifndef IG_CLOSE_PATTERS
#define IG_CLOSE_PATTERS
#include "ClosePatterns\Pattern01.mq5"
#include "ClosePatterns\Pattern02.mq5"
#endif

#ifndef IG_POSITION_LIST
#define IG_POSITION_LIST
#include "..\..\PositionInfo\PositionList.mq5"
#endif

#ifndef IG_MARKET_INFO
#define IG_MARKET_INFO
#include "..\..\MarketInfo\MarketInfo.mq5"
#endif

#ifndef IG_DATETIME_UTIL
#define IG_DATETIME_UTIL
#include "..\..\DateTime\DateTimeUtil.mq5"
#endif

class Operator {
public:
    Operator(void);
    ~Operator(void);

    void Initialize(string symbol);

    void Run(CTrade &trade, MovingAverage &s, MovingAverage &l);

private:
    string m_symbol;
    datetime m_downTimeTo;

    OpenPattern01 m_op1;
    OpenPattern02 m_op2;
    ClosePattern01 m_cp1;
    ClosePattern02 m_cp2;
    PositionList m_pl;
    DateTimeUtil m_du;

    void Pattern01(CTrade &trade);
    void Pattern02(CTrade &trade);
};

#endif

#ifndef D_OPERATOR_B
#define D_OPERATOR_B

void Operator::Operator() {}

void Operator::~Operator() {}

void Operator::Initialize(string symbol) {
    m_symbol = symbol;
    m_downTimeTo = TimeCurrent();
}

void Operator::Run(CTrade &trade, MovingAverage &s, MovingAverage &l) {
    bool isOpenPattern01 = m_op1.IsPattern01(s, l);
    bool isOpenPattern02 = m_op2.IsPattern02(s, l);
    bool isClosePattern01 = m_cp1.IsPattern01(s, l);
    bool isClosePattern02 = m_cp2.IsPattern02(s, l);

    if (m_downTimeTo > TimeCurrent()) {
        return;
    }
    m_downTimeTo = m_du.AddHours(TimeCurrent(), 1);

    m_pl.Fetch();
    if (!m_pl.FetchSuccess()) {
        return;
    }

    if (m_pl.GetSize() > 0 && (isClosePattern01 || isClosePattern02)) {
        for (int i = 0; i < m_pl.GetSize(); i++) {
            if (m_pl.Symbol(i) == m_symbol) {
                trade.PositionClosePartial(m_symbol, m_pl.TicketNumber(i), 3);
            }
        }
    }

    if (isOpenPattern01) {
        Pattern01(trade);
    }
    else if (isOpenPattern02) {
        Pattern02(trade);
    }
}

void Operator::Pattern01(CTrade &trade) {
    MarketInfo mi;
    trade.PositionOpen(
        m_symbol,
        ORDER_TYPE_BUY,
        0.1,
        mi.Ask(m_symbol),
        0,
        0
    );
}

void Operator::Pattern02(CTrade &trade) {
    MarketInfo mi;
    trade.PositionOpen(
        m_symbol,
        ORDER_TYPE_SELL,
        0.1,
        mi.Bid(m_symbol),
        0,
        0
    );
}

#endif
