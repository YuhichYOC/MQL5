#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_ZIGZAG_H
#define D_ZIGZAG_H

#ifndef IG_ZIGZAG_HIGH
#define IG_ZIGZAG_HIGH
#include "ZigZagHigh.mq5"
#endif

#ifndef IG_ZIGZAG_LOW
#define IG_ZIGZAG_LOW
#include "ZigZagLow.mq5"
#endif

enum ENUM_ZIGZAG_PEAK_TYPE_NEXT {
    HIGH,
    LOW,
    EITHER
};

class ZigZag {
public:
    ZigZag(void);
    ~ZigZag(void);

    void Initialize(
        string symbol,
        ENUM_TIMEFRAMES period,
        int size,
        double deviation
    );
    bool InitializeSuccess(void);
    int GetSize(void);

    void Scan(void);
    void Scan(int appendSize);
    void CopyResult(double &results[]);
    double ValueAt(int index);

    ENUM_ZIGZAG_PEAK_TYPE_NEXT LastTrend(void);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    double m_results[];
    bool m_initializeSuccess;

    ZigZagHigh m_zzh;
    ZigZagLow m_zzl;

    void Scan(ENUM_ZIGZAG_PEAK_TYPE_NEXT);
    void Update(ENUM_ZIGZAG_PEAK_TYPE_NEXT);
};

#endif

#ifndef D_ZIGZAG_B
#define D_ZIGZAG_B

void ZigZag::ZigZag() {}

void ZigZag::~ZigZag() {}

void ZigZag::Initialize(
    string symbol,
    ENUM_TIMEFRAMES period,
    int size,
    double deviation
) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    if (ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    for (int i = 0; i < m_size; i++) {
        m_results[i] = 0;
    }
    m_zzh.Initialize(symbol, period, size, deviation);
    m_zzl.Initialize(symbol, period, size, deviation);
    m_initializeSuccess = true;
}

bool ZigZag::InitializeSuccess() {
    return m_initializeSuccess
        && m_zzh.InitializeSuccess()
        && m_zzl.InitializeSuccess();
}

int ZigZag::GetSize() {
    return m_size;
}

void ZigZag::Scan() {
    Scan(EITHER);
    Update(EITHER);
    ENUM_ZIGZAG_PEAK_TYPE_NEXT n = m_zzh.HighAt() < m_zzl.LowAt() ? HIGH : LOW;

    bool highFound = m_zzh.Found();
    bool lowFound = m_zzl.Found();

    while (highFound && lowFound) {
        Scan(n);
        Update(n);
        n = n == HIGH ? LOW : HIGH;
        highFound = m_zzh.Found();
        lowFound = m_zzl.Found();
    }
}

void ZigZag::Scan(int appendSize) {
    if (ArrayResize(m_results, m_size + appendSize, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    for (int i = 0; i < m_size + appendSize; i++) {
        m_results[i] = 0;
    }
    m_zzh.Append(appendSize);
    m_zzl.Append(appendSize);
    if (!m_zzh.InitializeSuccess() || !m_zzl.InitializeSuccess()) {
        return;
    }

    m_size += appendSize;

    Scan(EITHER);
    Update(EITHER);
    ENUM_ZIGZAG_PEAK_TYPE_NEXT n = m_zzh.HighAt() < m_zzl.LowAt() ? HIGH : LOW;

    bool highFound = m_zzh.Found();
    bool lowFound = m_zzl.Found();

    while (highFound && lowFound) {
        Scan(n);
        Update(n);
        n = n == HIGH ? LOW : HIGH;
        highFound = m_zzh.Found();
        lowFound = m_zzl.Found();
    }
}

void ZigZag::CopyResult(double &results[]) {
    for (int i = 0; i < m_size; i++) {
        results[i] = m_results[i];
    }
}

double ZigZag::ValueAt(int index) {
    return m_results[index];
}

void ZigZag::Scan(ENUM_ZIGZAG_PEAK_TYPE_NEXT n) {
    if (n == HIGH) {
        m_zzh.Find(m_zzl.LowAt() + 1);
    }
    else if (n == LOW) {
        m_zzl.Find(m_zzh.HighAt() + 1);
    }
    else {
        m_zzh.Find();
        m_zzl.Find();
    }
}

void ZigZag::Update(ENUM_ZIGZAG_PEAK_TYPE_NEXT n) {
    if (n == HIGH) {
        m_results[m_zzh.HighAt()] = m_zzh.High();
    }
    else if (n == LOW) {
        m_results[m_zzl.LowAt()] = m_zzl.Low();
    }
    else {
        m_results[m_zzh.HighAt()] = m_zzh.High();
        m_results[m_zzl.LowAt()] = m_zzl.Low();
    }
}

#endif
