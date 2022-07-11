#property library
#property copyright "Copyright 2022, YuhichYOC"

class MovingAverage {
public:
    MovingAverage(void);
    ~MovingAverage(void);

    void Initialize(int size, int rangeStart, int rangeEnd);
    bool InitializeSuccess(void);

    void ReverseAdd(double, int);
    void Calc(void);
    void CopyResult(double &mas[]);

private:
    int m_size;
    int m_rangeStart;
    int m_rangeEnd;
    double m_series[];
    double m_results[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
    double SumCloses(int, int);
};

void MovingAverage::MovingAverage() {}

void MovingAverage::~MovingAverage() {}

void MovingAverage::Initialize(int size, int rangeStart, int rangeEnd) {
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

bool MovingAverage::InitializeSuccess() {
    return m_initializeSuccess;
}

void MovingAverage::ReverseAdd(double v, int i) {
    m_series[(m_size - 1) - i] = v;
}

void MovingAverage::Calc() {
    int startAt = m_rangeStart;
    for (int i = startAt; i < m_size; i++) {
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

void MovingAverage::CopyResult(double &mas[]) {
    for (int i = 0; i < m_size; i++) {
        mas[i] = m_results[i];
    }
}

bool MovingAverage::CheckArguments() {
    if (m_size < m_rangeStart + m_rangeEnd) {
        printf("MovingAverage::Initialize Calculation size must be larger than the number of items from rangeStart to rangeEnd.");
        return false;
    }
    if (m_rangeStart < m_rangeEnd) {
        printf("MovingAverage::Initialize rangeEnd must be larger than rangeStart");
        return false;
    }
    return true;
}

double MovingAverage::SumCloses(int rangeStart, int rangeEnd) {
    double sum = 0;
    for (int i = rangeStart; i < rangeEnd; i++) {
        sum += m_series[i];
    }
    return sum;
}
