#property library
#property copyright "Copyright 2022, YuhichYOC"

#include "..\Price\Close.mq5"

class Deviations {
public:
    Deviations(void);
    ~Deviations(void);

    void Initialize(int size, int rangeStart, int rangeEnd);
    bool InitializeSuccess(void);

    void Calc(Close &close);
    void CopyResult(double &deviations[]);
    double ValueAt(int index);

private:
    int m_size;
    int m_rangeStart;
    int m_rangeEnd;
    double m_results[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
    double CalcDeviation(int rangeStart, int rangeEnd, Close &close);
};

void Deviations::Deviations() {}

void Deviations::~Deviations() {}

void Deviations::Initialize(int size, int rangeStart, int rangeEnd) {
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

bool Deviations::InitializeSuccess() {
    return m_initializeSuccess;
}

void Deviations::Calc(Close &close) {
    int startAt = m_rangeStart;
    for (int i = startAt; i < m_size; i++) {
        int rangeStart = i - m_rangeStart;
        int rangeEnd = i + m_rangeEnd;
        if (rangeEnd > m_size) {
            rangeEnd = m_size;
        }
        m_results[i] = CalcDeviation(rangeStart, rangeEnd, close);
    }
}

void Deviations::CopyResult(double &deviations[]) {
    for (int i = 0; i < m_size; i++) {
        deviations[i] = m_results[i];
    }
}

double Deviations::ValueAt(int index) {
    return m_results[index];
}

bool Deviations::CheckArguments() {
    if (m_size < m_rangeStart + m_rangeEnd) {
        printf("Deviations::Initialize Calculation size must be larger than the number of items from rangeStart to rangeEnd.");
        return false;
    }
    return true;
}

double Deviations::CalcDeviation(int rangeStart, int rangeEnd, Close &close) {
    double powerSum = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        powerSum += MathPow(close.ValueAt(i), 2);
    }
    double sumPower = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        sumPower += close.ValueAt(i);
    }
    sumPower = MathPow(sumPower, 2);
    int n = rangeEnd - rangeStart;
    return MathSqrt((n * powerSum - sumPower) / (n * (n - 1)));
}
