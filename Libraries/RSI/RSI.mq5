#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_RSI_H
#define D_RSI_H

#ifndef IG_P_CLOSE
#define IG_P_CLOSE
#include "..\Price\PClose.mq5"
#endif

class RSI {
public:
    RSI(void);
    ~RSI(void);

    void Initialize(
        string symbol,
        ENUM_TIMEFRAMES period,
        int size,
        int rangeStart,
        int rangeEnd
    );
    bool InitializeSuccess(void);
    int GetSize(void);

    void Calc(void);
    void Calc(int appendSize);
    void Refresh(void);
    void CopyResult(double &rsis[]);
    double ValueAt(int index);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    int m_rangeStart;
    int m_rangeEnd;
    PClose m_c;
    double m_results[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
    double SumPlus(int, int);
    double SumMinus(int, int);
};

#endif

#ifndef D_RSI_B
#define D_RSI_B

void RSI::RSI() {}

void RSI::~RSI() {}

void RSI::Initialize(
    string symbol,
    ENUM_TIMEFRAMES period,
    int size,
    int rangeStart,
    int rangeEnd
) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    m_rangeStart = rangeStart;
    m_rangeEnd = rangeEnd;
    if (!CheckArguments()
        || ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_c.Initialize(m_symbol, m_period, m_size);
    m_initializeSuccess = true;
}

bool RSI::InitializeSuccess() {
    return m_initializeSuccess && m_c.InitializeSuccess();
}

int RSI::GetSize() {
    return m_size;
}

void RSI::Calc() {
    m_c.Fill();
    for (int i = m_rangeStart; i < m_size; i++) {
        int rangeStart = i - m_rangeStart;
        int rangeEnd = i + m_rangeEnd;
        if (rangeEnd > m_size) {
            rangeEnd = m_size;
        }
        double plus = SumPlus(rangeStart, rangeEnd);
        double minus = SumMinus(rangeStart, rangeEnd);
        m_results[i] = (plus / (plus + minus)) * 100;
    }
}

void RSI::Calc(int appendSize) {
    m_c.Fill(appendSize);
    if (!m_c.InitializeSuccess()) {
        m_initializeSuccess = false;
        return;
    }
    if (ArrayResize(m_results, m_size + appendSize, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    for (int i = m_size; i < m_size + appendSize; i++) {
        int rangeStart = i - m_rangeStart;
        int rangeEnd = i + m_rangeEnd;
        if (rangeEnd > m_size) {
            rangeEnd = m_size;
        }
        double plus = SumPlus(rangeStart, rangeEnd);
        double minus = SumMinus(rangeStart, rangeEnd);
        m_results[i] = (plus / (plus + minus)) * 100;
    }
    m_size += appendSize;
    m_initializeSuccess = true;
}

void RSI::Refresh() {
    m_c.Refresh();
    int rangeStart = m_size - m_rangeStart;
    int rangeEnd = m_size;
    double plus = SumPlus(rangeStart, rangeEnd);
    double minus = SumMinus(rangeStart, rangeEnd);
    m_results[m_size - 1] = (plus / (plus + minus)) * 100;
}

void RSI::CopyResult(double &rsis[]) {
    for (int i = 0; i < m_size; i++) {
        rsis[i] = m_results[i];
    }
}

double RSI::ValueAt(int index) {
    return m_results[index];
}

bool RSI::CheckArguments() {
    if (m_size < m_rangeStart + m_rangeEnd) {
        printf("RSI::Initialize Calculation size must be larger than the number of items from rangeStart to rangeEnd.");
        return false;
    }
    return true;
}

double RSI::SumPlus(int rangeStart, int rangeEnd) {
    double plus = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        if (i == 0) {
            continue;
        }
        double diff = m_c.ValueAt(i) - m_c.ValueAt(i - 1);
        if (diff > 0) {
            plus += diff;
        }
    }
    return plus;
}

double RSI::SumMinus(int rangeStart, int rangeEnd) {
    double minus = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        if (i == 0) {
            continue;
        }
        double diff = m_c.ValueAt(i - 1) - m_c.ValueAt(i);
        if (diff > 0) {
            minus += diff;
        }
    }
    return minus;
}

#endif
