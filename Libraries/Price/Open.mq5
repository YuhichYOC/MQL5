#property library
#property copyright "Copyright 2022, YuhichYOC"

class Open {
public:
    Open(void);
    ~Open(void);

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

void Open::Open() {}

void Open::~Open() {}

void Open::Initialize(string symbol, ENUM_TIMEFRAMES period, int size) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    if (ArrayResize(m_results, m_size, 0) == -1) {
        m_initializeSuccess = false;
        return;
    }
    m_initializeSuccess = true;
}

bool Open::InitializeSuccess() {
    return m_initializeSuccess;
}

int Open::GetSize() {
    return m_size;
}

void Open::Fill() {
    for (int i = 0; i < m_size; i++) {
        m_results[(m_size - 1) - i] = iOpen(m_symbol, m_period, i);
    }
}

void Open::CopyResult(double &results[]) {
    for (int i = 0; i < m_size; i++) {
        results[i] = m_results[i];
    }
}

double Open::ValueAt(int index) {
    return m_results[index];
}
