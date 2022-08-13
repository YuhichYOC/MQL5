#property library
#property copyright "Copyright 2022, YuhichYOC"

#ifndef D_CLOSE_H
#define D_CLOSE_H

class Close {
public:
    Close(void);
    ~Close(void);

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

#ifndef D_CLOSE_B
#define D_CLOSE_B

void Close::Close() {}

void Close::~Close() {}

void Close::Initialize(string symbol, ENUM_TIMEFRAMES period, int size) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    if (ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_initializeSuccess = true;
}

bool Close::InitializeSuccess() {
    return m_initializeSuccess;
}

int Close::GetSize() {
    return m_size;
}

void Close::Fill() {
    for (int i = 0; i < m_size; i++) {
        m_results[(m_size - 1) - i] = iClose(m_symbol, m_period, i);
    }
}

void Close::Fill(int appendSize) {
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

void Close::Refresh() {
    m_results[m_size - 1] = iClose(m_symbol, m_period, 0);
}

void Close::CopyResult(double &results[]) {
    for (int i = 0; i < m_size; i++) {
        results[i] = m_results[i];
    }
}

double Close::ValueAt(int index) {
    return m_results[index];
}

#endif
