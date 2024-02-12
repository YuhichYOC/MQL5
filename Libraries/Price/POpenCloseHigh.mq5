#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_P_OPEN_CLOSE_HIGH_H
#define D_P_OPEN_CLOSE_HIGH_H

class POpenCloseHigh {
public:
    POpenCloseHigh(void);
    ~POpenCloseHigh(void);

    void Initialize(string symbol, ENUM_TIMEFRAMES period, int size);
    bool InitializeSuccess(void);
    int GetSize(void);

    void Fill(void);
    void Fill(int appendSize);
    void Refresh(void);
    void CopyResult(double &results[]);
    double ValueAt(int index);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    double m_results[];
    bool m_initializeSuccess;
};

#endif

#ifndef D_P_OPEN_CLOSE_HIGH_B
#define D_P_OPEN_CLOSE_HIGH_B

void POpenCloseHigh::POpenCloseHigh() {}

void POpenCloseHigh::~POpenCloseHigh() {}

void POpenCloseHigh::Initialize(string symbol, ENUM_TIMEFRAMES period, int size) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    if (ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_initializeSuccess = true;
}

bool POpenCloseHigh::InitializeSuccess() {
    return m_initializeSuccess;
}

int POpenCloseHigh::GetSize() {
    return m_size;
}

void POpenCloseHigh::Fill() {
    for (int i = 0; i < m_size; i++) {
        double open = iOpen(m_symbol, m_period, i);
        double close = iClose(m_symbol, m_period, i);
        if (open >= close) {
            m_results[(m_size - 1) - i] = open;
        }
        else {
            m_results[(m_size - 1) - i] = close;
        }
    }
}

void POpenCloseHigh::Fill(int appendSize) {
    if (ArrayResize(m_results, m_size + appendSize, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    for (int i = 0; i < appendSize; i++) {
        double open = iOpen(m_symbol, m_period, i);
        double close = iClose(m_symbol, m_period, i);
        if (open >= close) {
            m_results[(m_size + appendSize - 1) - i] = open;
        }
        else {
            m_results[(m_size + appendSize - 1) - i] = close;
        }
    }
    m_size += appendSize;
    m_initializeSuccess = true;
}

void POpenCloseHigh::Refresh() {
    double open = iOpen(m_symbol, m_period, 0);
    double close = iClose(m_symbol, m_period, 0);
    if (open >= close) {
        m_results[m_size - 1] = open;
    }
    else {
        m_results[m_size - 1] = close;
    }
}

void POpenCloseHigh::CopyResult(double &results[]) {
    for (int i = 0; i < m_size; i++) {
        results[i] = m_results[i];
    }
}

double POpenCloseHigh::ValueAt(int index) {
    return m_results[index];
}

#endif
