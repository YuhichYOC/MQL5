#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_P_CLOSE_H
#define D_P_CLOSE_H

class PClose {
public:
    PClose(void);
    ~PClose(void);

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

#ifndef D_P_CLOSE_B
#define D_P_CLOSE_B

void PClose::PClose() {}

void PClose::~PClose() {}

void PClose::Initialize(string symbol, ENUM_TIMEFRAMES period, int size) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    if (ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_initializeSuccess = true;
}

bool PClose::InitializeSuccess() {
    return m_initializeSuccess;
}

int PClose::GetSize() {
    return m_size;
}

void PClose::Fill() {
    for (int i = 0; i < m_size; i++) {
        m_results[(m_size - 1) - i] = iClose(m_symbol, m_period, i);
    }
}

void PClose::Fill(int appendSize) {
    if (ArrayResize(m_results, m_size + appendSize, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    for (int i = 0; i < appendSize; i++) {
        m_results[(m_size + appendSize - 1) - i] = iClose(m_symbol, m_period, i);
    }
    m_size += appendSize;
    m_initializeSuccess = true;
}

void PClose::Refresh() {
    m_results[m_size - 1] = iClose(m_symbol, m_period, 0);
}

void PClose::CopyResult(double &results[]) {
    for (int i = 0; i < m_size; i++) {
        results[i] = m_results[i];
    }
}

double PClose::ValueAt(int index) {
    return m_results[index];
}

#endif
