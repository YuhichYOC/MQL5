#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_DEVIATIONS_H
#define D_DEVIATIONS_H

#ifndef IG_P_CLOSE
#define IG_P_CLOSE
#include "..\Price\PClose.mq5"
#endif

class Deviations {
public:
    Deviations(void);
    ~Deviations(void);

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
    void CopyResult(double &deviations[]);
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
    double CalcDeviation(int, int);
};

#endif

#ifndef D_DEVIATIONS_B
#define D_DEVIATIONS_B

void Deviations::Deviations() {}

void Deviations::~Deviations() {}

void Deviations::Initialize(
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

bool Deviations::InitializeSuccess() {
    return m_initializeSuccess && m_c.InitializeSuccess();
}

int Deviations::GetSize() {
    return m_size;
}

void Deviations::Calc() {
    m_c.Fill();
    for (int i = m_rangeStart; i < m_size; i++) {
        int rangeStart = i - m_rangeStart;
        int rangeEnd = i + m_rangeEnd;
        if (rangeEnd > m_size) {
            rangeEnd = m_size;
        }
        m_results[i] = CalcDeviation(rangeStart, rangeEnd);
    }
}

void Deviations::Calc(int appendSize) {
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
        m_results[i] = CalcDeviation(rangeStart, rangeEnd);
    }
    m_size += appendSize;
    m_initializeSuccess = true;
}

void Deviations::Refresh() {
    m_c.Refresh();
    int rangeStart = m_size - m_rangeStart;
    int rangeEnd = m_size;
    m_results[m_size - 1] = CalcDeviation(rangeStart, rangeEnd);
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

double Deviations::CalcDeviation(int rangeStart, int rangeEnd) {
    double powerSum = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        powerSum += MathPow(m_c.ValueAt(i), 2);
    }
    double sumPower = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        sumPower += m_c.ValueAt(i);
    }
    sumPower = MathPow(sumPower, 2);
    int n = rangeEnd - rangeStart;
    return MathSqrt((n * powerSum - sumPower) / (n * (n - 1)));
}

#endif
