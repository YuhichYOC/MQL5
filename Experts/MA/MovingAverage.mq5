#property copyright "Copyright 2022, YuhichYOC"

#ifndef IG_TRADE_MQH
#define IG_TRADE_MQH
#include <Trade\Trade.mqh>
#endif

#ifndef IG_OPERATOR
#define IG_OPERATOR
#include "..\..\Libraries\Position\MA\Operator.mq5"
#endif

#ifndef IG_DATETIME_UTIL
#define IG_DATETIME_UTIL
#include "..\..\Libraries\DateTime\DateTimeUtil.mq5"
#endif

CTrade ExtTrade;
Operator op;
OpenTimeChecker oc;

#define MA_MAGIC 1234501

#ifndef D_MOVING_AVERAGE_ADV_H
#define D_MOVING_AVERAGE_ADV_H

class MovingAverageAdv {
public:
    MovingAverageAdv(void);
    ~MovingAverageAdv(void);

    void Initialize(CTrade &trade, string symbol);
    bool InitializeSuccess(void);

    void OnTick(void);

private:
    CTrade m_trade;
    string m_symbol;
    MovingAverage m_maShortSpan;
    MovingAverage m_maLongSpan;
    Operator m_op;
};

#endif

#ifndef D_MOVING_AVERAGE_ADV_B
#define D_MOVING_AVERAGE_ADV_B

void MovingAverageAdv::MovingAverageAdv() {}

void MovingAverageAdv::~MovingAverageAdv() {}

void MovingAverageAdv::Initialize(CTrade &trade, string symbol) {
    m_trade = trade;
    m_symbol = symbol;
    m_maShortSpan.Initialize(m_symbol, PERIOD_H1, 25, 20, 1);
    m_maLongSpan.Initialize(m_symbol, PERIOD_H1, 95, 89, 1);
    m_op.Initialize(m_symbol);
}

bool MovingAverageAdv::InitializeSuccess() {
    return m_maShortSpan.InitializeSuccess() && m_maLongSpan.InitializeSuccess();
}

void MovingAverageAdv::OnTick() {
    m_maShortSpan.Calc();
    m_maLongSpan.Calc();
    m_op.Run(m_trade, m_maShortSpan, m_maLongSpan);
}

#endif

MovingAverageAdv a;

int OnInit() {
    a.Initialize(ExtTrade, _Symbol);
    if (a.InitializeSuccess()) {
        return INIT_SUCCEEDED;
    }
    return INIT_FAILED;
}

void OnTick() {
    if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
        return;
    }

    if (!oc.IsOpen(_Symbol)) {
        return;
    }

    a.OnTick();
}

void OnDeinit(const int reason) {}
