#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_ZIGZAG_LOW_H
#define D_ZIGZAG_LOW_H

#ifndef IG_P_LOW
#define IG_P_LOW
#include "..\Price\PLow.mq5"
#endif

class ZigZagLow {
public:
    ZigZagLow(void);
    ~ZigZagLow(void);

    void Initialize(
        string symbol,
        ENUM_TIMEFRAMES period,
        int size,
        double deviation
    );
    bool InitializeSuccess(void);

    double Low(void);
    int LowAt(void);
    bool Found(void);
    void Find(void);
    void Find(int rangeStart);
    void Append(int);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    double m_deviation;

    PLow m_l;

    double m_provisionalLow;
    int m_provisionalLowAt;
    double m_low;
    int m_lowAt;
    bool m_found;

    void FindProvisionalLow(int, int);
    void FindLow(int, int);
};

#endif

#ifndef D_ZIGZAG_LOW_B
#define D_ZIGZAG_LOW_B

void ZigZagLow::ZigZagLow() {}

void ZigZagLow::~ZigZagLow() {}

void ZigZagLow::Initialize(
    string symbol,
    ENUM_TIMEFRAMES period,
    int size,
    double deviation
) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    m_deviation = deviation;
    m_l.Initialize(m_symbol, m_period, m_size);
}

bool ZigZagLow::InitializeSuccess() {
    return m_l.InitializeSuccess();
}

double ZigZagLow::Low() {
    return m_low;
}

int ZigZagLow::LowAt() {
    return m_lowAt;
}

bool ZigZagLow::Found() {
    return m_found;
}

void ZigZagLow::Find() {
    m_l.Fill();
    m_found = false;
    for (int i = 0; i < m_size; i++) {
        FindProvisionalLow(0, i);
        FindLow(m_provisionalLowAt, i);
        if (m_found) {
            return;
        }
    }
}

void ZigZagLow::Find(int rangeStart) {
    m_found = false;
    for (int i = rangeStart; i < m_size; i++) {
        FindProvisionalLow(rangeStart, i);
        FindLow(m_provisionalLowAt, i);
        if (m_found) {
            return;
        }
    }
}

void ZigZagLow::Append(int size) {
    m_l.Fill(size);
    if (m_l.InitializeSuccess()) {
        m_size += size;
    }
}

void ZigZagLow::FindProvisionalLow(int rangeStart, int rangeEnd) {
    m_provisionalLow = m_l.ValueAt(rangeStart);
    m_provisionalLowAt = rangeStart;
    for (int i = rangeStart + 1; i <= rangeEnd; i++) {
        if (m_provisionalLow > m_l.ValueAt(i)) {
            m_provisionalLow = m_l.ValueAt(i);
            m_provisionalLowAt = i;
        }
    }
}

void ZigZagLow::FindLow(int rangeStart, int rangeEnd) {
    for (int i = rangeStart; i <= rangeEnd; i++) {
        double l = m_l.ValueAt(i);
        double v = ((l - m_provisionalLow) * 100) / m_provisionalLow;
        if (v > m_deviation) {
            m_low = m_provisionalLow;
            m_lowAt = m_provisionalLowAt;
            m_found = true;
            return;
        }
    }
}

#endif
