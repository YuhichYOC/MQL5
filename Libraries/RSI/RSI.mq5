#property library
#property copyright "Copyright 2022, YuhichYOC"

class RSI {
public:
    RSI(void);
    ~RSI(void);

    void Initialize(int size, int rangeStart, int rangeEnd);
    bool InitializeSuccess(void);

    void ReverseAdd(double, int);
    void Calc(void);
    void CopyResult(double &rsis[]);

private:
    int m_size;
    int m_rangeStart;
    int m_rangeEnd;
    double m_series[];
    double m_results[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
    double SumPlus(int, int);
    double SumMinus(int, int);
};

void RSI::RSI() {}

void RSI::~RSI() {}

void RSI::Initialize(int size, int rangeStart, int rangeEnd) {
    m_size = size;
    m_rangeStart = rangeStart;
    m_rangeEnd = rangeEnd;
    if (!CheckArguments()
        || ArrayResize(m_series, m_size, 0) == -1
        || ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_initializeSuccess = true;
}

bool RSI::InitializeSuccess() {
    return m_initializeSuccess;
}

void RSI::ReverseAdd(double v, int i) {
    m_series[(m_size - 1) - i] = v;
}

void RSI::Calc() {
    int startAt = m_rangeStart;
    for (int i = startAt; i < m_size; i++) {
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

void RSI::CopyResult(double &rsis[]) {
    for (int i = 0; i < m_size; i++) {
        rsis[i] = m_results[i];
    }
}

bool RSI::CheckArguments() {
    if (m_size < m_rangeStart + m_rangeEnd) {
        printf("RSI::Initialize Calculation size must be larger than the number of items from rangeStart to rangeEnd.");
        return false;
    }
    if (m_rangeStart < m_rangeEnd) {
        printf("RSI::Initialize rangeEnd must be larger than rangeStart");
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
        double diff = m_series[i] - m_series[i - 1];
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
        double diff = m_series[i - 1] - m_series[i];
        if (diff > 0) {
            minus += diff;
        }
    }
    return minus;
}
