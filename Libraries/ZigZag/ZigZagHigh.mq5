#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_ZIGZAG_HIGH_H
#define D_ZIGZAG_HIGH_H

#ifndef IG_HIGH
#define IG_HIGH
#include "..\Price\High.mq5"
#endif

class ZigZagHigh {
public:
    ZigZagHigh(void);
    ~ZigZagHigh(void);

    void Initialize(
        string symbol,
        ENUM_TIMEFRAMES period,
        int size,
        double deviation
    );
    bool InitializeSuccess(void);

    double High(void);
    int HighAt(void);
    bool Found(void);
    void Find(void);
    void Find(int rangeStart);
    void Append(int);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    double m_deviation;

    High m_h;

    double m_provisionalHigh;
    int m_provisionalHighAt;
    double m_high;
    int m_highAt;
    bool m_found;

    void FindProvisionalHigh(int, int);
    void FindHigh(int, int);
};

#endif

#ifndef D_ZIGZAG_HIGH_B
#define D_ZIGZAG_HIGH_B

void ZigZagHigh::ZigZagHigh() {}

void ZigZagHigh::~ZigZagHigh() {}

void ZigZagHigh::Initialize(
    string symbol,
    ENUM_TIMEFRAMES period,
    int size,
    double deviation
) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    m_deviation = deviation;
    m_h.Initialize(m_symbol, m_period, m_size);
}

bool ZigZagHigh::InitializeSuccess() {
    return m_h.InitializeSuccess();
}

double ZigZagHigh::High() {
    return m_high;
}

int ZigZagHigh::HighAt() {
    return m_highAt;
}

bool ZigZagHigh::Found() {
    return m_found;
}

void ZigZagHigh::Find() {
    m_h.Fill();
    m_found = false;
    for (int i = 0; i < m_size; i++) {
        FindProvisionalHigh(0, i);
        FindHigh(m_provisionalHighAt, i);
        if (m_found) {
            return;
        }
    }
}

void ZigZagHigh::Find(int rangeStart) {
    m_found = false;
    for (int i = rangeStart; i < m_size; i++) {
        FindProvisionalHigh(rangeStart, i);
        FindHigh(m_provisionalHighAt, i);
        if (m_found) {
            return;
        }
    }
}

void ZigZagHigh::Append(int size) {
    m_h.Fill(size);
    if (m_h.InitializeSuccess()) {
        m_size += size;
    }
}

void ZigZagHigh::FindProvisionalHigh(int rangeStart, int rangeEnd) {
    m_provisionalHigh = m_h.ValueAt(rangeStart);
    m_provisionalHighAt = rangeStart;
    for (int i = rangeStart + 1; i <= rangeEnd; i++) {
        if (m_provisionalHigh < m_h.ValueAt(i)) {
            m_provisionalHigh = m_h.ValueAt(i);
            m_provisionalHighAt = i;
        }
    }
}

void ZigZagHigh::FindHigh(int rangeStart, int rangeEnd) {
    for (int i = rangeStart; i <= rangeEnd; i++) {
        double h = m_h.ValueAt(i);
        double v = ((m_provisionalHigh - h) * 100) / m_provisionalHigh;
        if (v > m_deviation) {
            m_high = m_provisionalHigh;
            m_highAt = m_provisionalHighAt;
            m_found = true;
            return;
        }
    }
}

#endif
