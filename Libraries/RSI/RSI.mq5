#property library
#property copyright "Copyright 2022, YuhichYOC"

#include "..\Price\Close.mq5"

class RSI {
public:
    RSI(void);
    ~RSI(void);

    void Initialize(int size, int rangeStart, int rangeEnd);
    bool InitializeSuccess(void);
    int GetSize(void);

    void Calc(Close &close);
    void CopyResult(double &rsis[]);
    double ValueAt(int index);

private:
    int m_size;
    int m_rangeStart;
    int m_rangeEnd;
    double m_results[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
    double SumPlus(int rangeStart, int rangeEnd, Close &close);
    double SumMinus(int rangeStart, int rangeEnd, Close &close);
};

void RSI::RSI() {}

void RSI::~RSI() {}

void RSI::Initialize(int size, int rangeStart, int rangeEnd) {
    m_size = size;
    m_rangeStart = rangeStart;
    m_rangeEnd = rangeEnd;
    if (!CheckArguments()
        || ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_initializeSuccess = true;
}

bool RSI::InitializeSuccess() {
    return m_initializeSuccess;
}

int RSI::GetSize() {
    return m_size;
}

void RSI::Calc(Close &close) {
    int startAt = m_rangeStart;
    for (int i = startAt; i < m_size; i++) {
        int rangeStart = i - m_rangeStart;
        int rangeEnd = i + m_rangeEnd;
        if (rangeEnd > m_size) {
            rangeEnd = m_size;
        }
        double plus = SumPlus(rangeStart, rangeEnd, close);
        double minus = SumMinus(rangeStart, rangeEnd, close);
        m_results[i] = (plus / (plus + minus)) * 100;
    }
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

double RSI::SumPlus(int rangeStart, int rangeEnd, Close &close) {
    double plus = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        if (i == 0) {
            continue;
        }
        double diff = close.ValueAt(i) - close.ValueAt(i - 1);
        if (diff > 0) {
            plus += diff;
        }
    }
    return plus;
}

double RSI::SumMinus(int rangeStart, int rangeEnd, Close &close) {
    double minus = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        if (i == 0) {
            continue;
        }
        double diff = close.ValueAt(i - 1) - close.ValueAt(i);
        if (diff > 0) {
            minus += diff;
        }
    }
    return minus;
}
