#property library
#property copyright "Copyright 2022, YuhichYOC"

#include "..\MA\MovingAverage.mq5"
#include "Deviations.mq5"

class BolingerBand {
public:
    BolingerBand(void);
    ~BolingerBand(void);

    void Initialize(int size, int rangeStart, int rangeEnd, int sigma);
    bool InitializeSuccess(void);

    void ReverseAdd(double, int);
    void Calc(void);
    void CopyResult(double &maSeries[], double &plusSeries[], double &minusSeries[]);

private:
    int m_size;
    int m_rangeStart;
    int m_rangeEnd;
    int m_sigma;
    double m_maSeries[];
    double m_deviationSeries[];
    double m_plusSeries[];
    double m_minusSeries[];
    bool m_initializeSuccess;

    MovingAverage ma;
    Deviations d;

    bool CheckArguments(void);
};

void BolingerBand::BolingerBand() {}

void BolingerBand::~BolingerBand() {}

void BolingerBand::Initialize(int size, int rangeStart, int rangeEnd, int sigma) {
    m_size = size;
    m_rangeStart = rangeStart;
    m_rangeEnd = rangeEnd;
    m_sigma = sigma;
    if (!CheckArguments()
        || ArrayResize(m_maSeries, m_size, 0) == -1
        || ArrayResize(m_deviationSeries, m_size, 0) == -1
        || ArrayResize(m_plusSeries, m_size, 0) == -1
        || ArrayResize(m_minusSeries, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    ma.Initialize(m_size, m_rangeStart, m_rangeEnd);
    d.Initialize(m_size, m_rangeStart, m_rangeEnd);
    m_initializeSuccess = true;
}

bool BolingerBand::InitializeSuccess() {
    return m_initializeSuccess
        && ma.InitializeSuccess()
        && d.InitializeSuccess();
}

void BolingerBand::ReverseAdd(double v, int i) {
    ma.ReverseAdd(v, i);
    d.ReverseAdd(v, i);
}

void BolingerBand::Calc() {
    ma.Calc();
    d.Calc();
    ma.CopyResult(m_maSeries);
    d.CopyResult(m_deviationSeries);
    for (int i = 0; i < m_size; i++) {
        m_plusSeries[i] = m_maSeries[i] + m_deviationSeries[i] * m_sigma;
        m_minusSeries[i] = m_maSeries[i] - m_deviationSeries[i] * m_sigma;
    }
}

void BolingerBand::CopyResult(double &maSeries[], double &plusSeries[], double &minusSeries[]) {
    for (int i = 0; i < m_size; i++) {
        maSeries[i] = m_maSeries[i];
        plusSeries[i] = m_plusSeries[i];
        minusSeries[i] = m_minusSeries[i];
    }
}

bool BolingerBand::CheckArguments() {
    if (m_sigma < 1) {
        printf("BolingerBand::Initialize sigma must be larger than 1");
        return false;
    }
    return true;
}
