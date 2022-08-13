#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_MOVING_AVERAGE_H
#define D_MOVING_AVERAGE_H

#ifndef IG_CLOSE
#define IG_CLOSE
#include "..\Price\Close.mq5"
#endif

class MovingAverage {
public:
    MovingAverage(void);
    ~MovingAverage(void);

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
    void CopyResult(double &mas[]);
    void CopyResult(int startAt, double &mas[]);
    double ValueAt(int index);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    int m_rangeStart;
    int m_rangeEnd;
    Close m_c;
    double m_results[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
    double SumCloses(int, int);
};

#endif

#ifndef D_MOVING_AVERAGE_B
#define D_MOVING_AVERAGE_B

void MovingAverage::MovingAverage() {}

void MovingAverage::~MovingAverage() {}

void MovingAverage::Initialize(
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

bool MovingAverage::InitializeSuccess() {
    return m_initializeSuccess && m_c.InitializeSuccess();
}

int MovingAverage::GetSize() {
    return m_size;
}

void MovingAverage::Calc() {
    m_c.Fill();
    for (int i = m_rangeStart; i < m_size; i++) {
        int rangeStart = i - m_rangeStart;
        int rangeEnd = i + m_rangeEnd;
        if (rangeEnd > m_size) {
            rangeEnd = m_size;
        }
        int denominator = rangeEnd - rangeStart;
        double numerator = SumCloses(rangeStart, rangeEnd);
        m_results[i] = numerator / denominator;
    }
}

void MovingAverage::Calc(int appendSize) {
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
        if (rangeEnd < m_size) {
            rangeEnd = m_size;
        }
        int denominator = rangeEnd - rangeStart;
        double numerator = SumCloses(rangeStart, rangeEnd);
        m_results[i] = numerator / denominator;
    }
    m_size += appendSize;
    m_initializeSuccess = true;
}

void MovingAverage::Refresh() {
    m_c.Refresh();
    int rangeStart = m_size - m_rangeStart;
    int rangeEnd = m_size;
    int denominator = m_rangeStart;
    double numerator = SumCloses(rangeStart, rangeEnd);
    m_results[m_size - 1] = numerator / denominator;
}

void MovingAverage::CopyResult(double &mas[]) {
    for (int i = 0; i < m_size; i++) {
        mas[i] = m_results[i];
    }
}

void MovingAverage::CopyResult(int startAt, double &mas[]) {
    for (int i = startAt; i < m_size; i++) {
        mas[i] = m_results[i];
    }
}

double MovingAverage::ValueAt(int index) {
    return m_results[index];
}

bool MovingAverage::CheckArguments() {
    if (m_size < m_rangeStart + m_rangeEnd) {
        printf("MovingAverage::Initialize Calculation size must be larger than the number of items from rangeStart to rangeEnd.");
        return false;
    }
    return true;
}

double MovingAverage::SumCloses(int rangeStart, int rangeEnd) {
    double sum = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        sum += m_c.ValueAt(i);
    }
    return sum;
}

#endif
