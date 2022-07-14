#property library
#property copyright "Copyright 2022, YuhichYOC"

#include "..\MA\MovingAverage.mq5"
#include "Deviations.mq5"

class BolingerBand {
public:
    BolingerBand(void);
    ~BolingerBand(void);

    void Initialize(int size, double sigma);
    bool InitializeSuccess(void);

    void Calc(MovingAverage &ma, Deviations &deviations);
    void CopyResult(double &maSeries[], double &plusSeries[], double &minusSeries[]);

private:
    int m_size;
    double m_sigma;
    double m_maSeries[];
    double m_plusSeries[];
    double m_minusSeries[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
};

void BolingerBand::BolingerBand() {}

void BolingerBand::~BolingerBand() {}

void BolingerBand::Initialize(int size, double sigma) {
    m_size = size;
    m_sigma = sigma;
    if (!CheckArguments()
        || ArrayResize(m_maSeries, m_size, 0) == -1
        || ArrayResize(m_plusSeries, m_size, 0) == -1
        || ArrayResize(m_minusSeries, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_initializeSuccess = true;
}

bool BolingerBand::InitializeSuccess() {
    return m_initializeSuccess;
}

void BolingerBand::Calc(MovingAverage &ma, Deviations &deviations) {
    ma.CopyResult(m_maSeries);
    for (int i = 0; i < m_size; i++) {
        m_plusSeries[i] = ma.ValueAt(i) + deviations.ValueAt(i) * m_sigma;
        m_minusSeries[i] = ma.ValueAt(i) - deviations.ValueAt(i) * m_sigma;
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
    if (m_sigma <= 0) {
        printf("BolingerBand::Initialize sigma must be larger than 0");
        return false;
    }
    return true;
}
