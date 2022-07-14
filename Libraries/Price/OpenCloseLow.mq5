#property library
#property copyright "Copyright 2022, YuhichYOC"

class OpenCloseLow {
public:
    OpenCloseLow(void);
    ~OpenCloseLow(void);

    void Initialize(string symbol, ENUM_TIMEFRAMES period, int size);
    bool InitializeSuccess(void);
    int GetSize(void);

    void Fill(void);
    void CopyResult(double &results[]);
    double ValueAt(int index);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    double m_results[];
    bool m_initializeSuccess;
};

void OpenCloseLow::OpenCloseLow() {}

void OpenCloseLow::~OpenCloseLow() {}

void OpenCloseLow::Initialize(string symbol, ENUM_TIMEFRAMES period, int size) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    if (ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_initializeSuccess = true;
}

bool OpenCloseLow::InitializeSuccess() {
    return m_initializeSuccess;
}

int OpenCloseLow::GetSize() {
    return m_size;
}

void OpenCloseLow::Fill() {
    for (int i = 0; i < m_size; i++) {
        double open = iOpen(m_symbol, m_period, i);
        double close = iClose(m_symbol, m_period, i);
        if (open <= close) {
            m_results[(m_size - 1) - i] = open;
        }
        else {
            m_results[(m_size - 1) - i] = close;
        }
    }
}

void OpenCloseLow::CopyResult(double &results[]) {
    for (int i = 0; i < m_size; i++) {
        results[i] = m_results[i];
    }
}

double OpenCloseLow::ValueAt(int index) {
    return m_results[index];
}
