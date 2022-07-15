#property library
#property copyright "Copyright 2022, YuhichYOC"

class PositionList {
public:
    PositionList(void);
    ~PositionList(void);

    void Fetch(void);
    bool FetchSuccess(void);
    int GetSize(void);

    ulong TicketNumber(int);
    string Symbol(int);
    long PositionType(int);
    double OpenPrice(int);
    double SL(int);
    double TP(int);

private:
    int m_ticketsTotal;
    ulong m_tickets[];
    string m_symbols[];
    long m_positionTypes[];
    double m_openPrices[];
    double m_sl[];
    double m_tp[];
    bool m_fetchSuccess;
};

void PositionList::PositionList() {
    m_ticketsTotal = 0;
}

void PositionList::~PositionList() {}

void PositionList::Fetch() {
    m_ticketsTotal = PositionsTotal();
    if (ArrayResize(m_tickets, m_ticketsTotal, 0) == -1
        || ArrayResize(m_symbols, m_ticketsTotal, 0) == -1
        || ArrayResize(m_positionTypes, m_ticketsTotal, 0) == -1
        || ArrayResize(m_openPrices, m_ticketsTotal, 0) == -1
        || ArrayResize(m_sl, m_ticketsTotal, 0) == -1
        || ArrayResize(m_tp, m_ticketsTotal, 0) == -1) {
        m_fetchSuccess = false;
        return;
    }

    for (int i = 0; i < m_ticketsTotal; i++) {
        m_tickets[i] = PositionGetTicket(i);
        if (m_tickets[i] == 0) {
            m_fetchSuccess = false;
            return;
        }
        if (!PositionGetInteger(POSITION_TYPE, m_positionTypes[i])
            || !PositionGetString(POSITION_SYMBOL, m_symbols[i])
            || !PositionGetDouble(POSITION_PRICE_OPEN, m_openPrices[i])
            || !PositionGetDouble(POSITION_SL, m_sl[i])
            || !PositionGetDouble(POSITION_TP, m_tp[i])) {
            m_fetchSuccess = false;
            return;
        }
    }

    m_fetchSuccess = true;
}

bool PositionList::FetchSuccess() {
    return m_fetchSuccess;
}

int PositionList::GetSize() {
    return m_ticketsTotal;
}

ulong PositionList::TicketNumber(int index) {
    return m_tickets[index];
}

string PositionList::Symbol(int index) {
    return m_symbols[index];
}

long PositionList::PositionType(int index) {
    return m_positionTypes[index];
}

double PositionList::OpenPrice(int index) {
    return m_openPrices[index];
}

double PositionList::SL(int index) {
    return m_sl[index];
}

double PositionList::TP(int index) {
    return m_tp[index];
}
