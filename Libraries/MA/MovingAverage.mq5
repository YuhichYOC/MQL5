#property library
#property copyright "Copyright 2022, YuhichYOC"

#include "..\Price\Close.mq5"

class MovingAverage {
public:
    MovingAverage(void);
    ~MovingAverage(void);

    void Initialize(int size, int rangeStart, int rangeEnd);
    bool InitializeSuccess(void);
    int GetSize(void);

    void Calc(Close &close);
    void CopyResult(double &mas[]);
    double ValueAt(int index);

private:
    int m_size;
    int m_rangeStart;
    int m_rangeEnd;
    double m_results[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
    double SumCloses(int rangeStart, int rangeEnd, Close &close);
};

void MovingAverage::MovingAverage() {}

void MovingAverage::~MovingAverage() {}

void MovingAverage::Initialize(int size, int rangeStart, int rangeEnd) {
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

bool MovingAverage::InitializeSuccess() {
    return m_initializeSuccess;
}

int MovingAverage::GetSize() {
    return m_size;
}

void MovingAverage::Calc(Close &close) {
    int startAt = m_rangeStart;
    for (int i = startAt; i < m_size; i++) {
        int rangeStart = i - m_rangeStart;
        int rangeEnd = i + m_rangeEnd;
        if (rangeEnd > m_size) {
            rangeEnd = m_size;
        }
        int denominator = rangeEnd - rangeStart;
        double numerator = SumCloses(rangeStart, rangeEnd, close);
        m_results[i] = numerator / denominator;
    }
}

void MovingAverage::CopyResult(double &mas[]) {
    for (int i = 0; i < m_size; i++) {
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

double MovingAverage::SumCloses(int rangeStart, int rangeEnd, Close &close) {
    double sum = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        sum += close.ValueAt(i);
    }
    return sum;
}
