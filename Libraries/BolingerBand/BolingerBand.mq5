#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_BOLINGER_BAND_H
#define D_BOLINGER_BAND_H

#ifndef IG_MOVING_AVERAGE
#define IG_MOVING_AVERAGE
#include "..\MA\MovingAverage.mq5"
#endif

#ifndef IG_DEVIATIONS
#define IG_DEVIATIONS
#include "Deviations.mq5"
#endif

class BolingerBand {
public:
    BolingerBand(void);
    ~BolingerBand(void);

    void Initialize(
        string symbol,
        ENUM_TIMEFRAMES period,
        int size,
        int rangeStart,
        int rangeEnd,
        double sigma
    );
    bool InitializeSuccess(void);
    int GetSize(void);

    void Calc(void);
    void Calc(int appendSize);
    void Refresh(void);
    void CopyResult(double &maSeries[], double &plusSeries[], double &minusSeries[]);
    double ValueAt(int index);
    double HighAt(int index);
    double LowAt(int index);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    double m_sigma;
    MovingAverage m_m;
    Deviations m_d;
    double m_maSeries[];
    double m_plusSeries[];
    double m_minusSeries[];
    bool m_initializeSuccess;

    bool CheckArguments(void);
};

#endif

#ifndef D_BOLINGER_BAND_B
#define D_BOLINGER_BAND_B

void BolingerBand::BolingerBand() {}

void BolingerBand::~BolingerBand() {}

void BolingerBand::Initialize(
    string symbol,
    ENUM_TIMEFRAMES period,
    int size,
    int rangeStart,
    int rangeEnd,
    double sigma
) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    m_sigma = sigma;
    if (!CheckArguments()
        || ArrayResize(m_maSeries, m_size, 0) == -1
        || ArrayResize(m_plusSeries, m_size, 0) == -1
        || ArrayResize(m_minusSeries, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_m.Initialize(m_symbol, m_period, m_size, rangeStart, rangeEnd);
    m_d.Initialize(m_symbol, m_period, m_size, rangeStart, rangeEnd);
    m_initializeSuccess = true;
}

bool BolingerBand::InitializeSuccess() {
    return m_initializeSuccess && m_m.InitializeSuccess() && m_d.InitializeSuccess();
}

int BolingerBand::GetSize() {
    return m_size;
}

void BolingerBand::Calc() {
    m_m.Calc();
    m_d.Calc();
    m_m.CopyResult(m_maSeries);
    for (int i = 0; i < m_size; i++) {
        double d = m_d.ValueAt(i);
        m_plusSeries[i] = m_maSeries[i] + m_d.ValueAt(i) * m_sigma;
        m_minusSeries[i] = m_maSeries[i] - m_d.ValueAt(i) * m_sigma;
    }
}

void BolingerBand::Calc(int appendSize) {
    m_m.Calc(appendSize);
    m_d.Calc(appendSize);
    if (ArrayResize(m_maSeries, m_size + appendSize, 0) == -1
        || ArrayResize(m_plusSeries, m_size + appendSize, 0) == -1
        || ArrayResize(m_minusSeries, m_size + appendSize, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_m.CopyResult(m_size, m_maSeries);
    for (int i = m_size; i < m_size + appendSize; i++) {
        double d = m_d.ValueAt(i);
        m_plusSeries[i] = m_maSeries[i] + m_d.ValueAt(i) * m_sigma;
        m_minusSeries[i] = m_maSeries[i] - m_d.ValueAt(i) * m_sigma;
    }
    m_size += appendSize;
    m_initializeSuccess = true;
}

void BolingerBand::Refresh() {
    m_m.Refresh();
    m_d.Refresh();
    m_maSeries[m_size - 1] = m_m.ValueAt(m_size - 1);
    m_plusSeries[m_size - 1] = m_maSeries[m_size - 1] + m_d.ValueAt(m_size - 1) * m_sigma;
    m_minusSeries[m_size - 1] = m_maSeries[m_size - 1] - m_d.ValueAt(m_size - 1) * m_sigma;
}

void BolingerBand::CopyResult(double &maSeries[], double &plusSeries[], double &minusSeries[]) {
    for (int i = 0; i < m_size; i++) {
        maSeries[i] = m_maSeries[i];
        plusSeries[i] = m_plusSeries[i];
        minusSeries[i] = m_minusSeries[i];
    }
}

double BolingerBand::ValueAt(int index) {
    return m_maSeries[index];
}

double BolingerBand::HighAt(int index) {
    return m_plusSeries[index];
}

double BolingerBand::LowAt(int index) {
    return m_minusSeries[index];
}

bool BolingerBand::CheckArguments() {
    if (m_sigma <= 0) {
        printf("BolingerBand::Initialize sigma must be larger than 0");
        return false;
    }
    return true;
}

#endif
