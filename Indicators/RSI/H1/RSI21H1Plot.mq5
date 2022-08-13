#property copyright "Copyright 2022, YuhichYOC"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 1
#property indicator_plots 1

//--- plot Short
#property indicator_label1 "21H1"
#property indicator_type1 DRAW_LINE
#property indicator_color1 clrCoral
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1

//--- indicator buffers
double PlotRSISeries[];

#ifndef IG_RSI
#define IG_RSI
#include "..\..\..\Libraries\RSI\RSI.mq5"
#endif

#ifndef D_RSI_21H1_PLOT_H
#define D_RSI_21H1_PLOT_H

class RSI21H1Plot {
public:
    RSI21H1Plot(void);
    ~RSI21H1Plot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void Calc(void);
    void Calc(int appendSize);
    void Refresh(int size, double &plotRSISeries[]);
    void CopyResult(double &plotRSISeries[]);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    RSI m_rsi;
};

#endif

#ifndef D_RSI_21H1_PLOT_B
#define D_RSI_21H1_PLOT_B

void RSI21H1Plot::RSI21H1Plot() {}

void RSI21H1Plot::~RSI21H1Plot() {}

void RSI21H1Plot::Initialize(int size) {
    m_symbol = _Symbol;
    m_period = _Period;
    m_size = size;
    m_rsi.Initialize(m_symbol, m_period, m_size, 20, 1);
}

bool RSI21H1Plot::InitializeSuccess() {
    return m_rsi.InitializeSuccess();
}

void RSI21H1Plot::Calc() {
    m_rsi.Calc();
}

void RSI21H1Plot::Calc(int appendSize) {
    m_rsi.Calc(appendSize);
    m_size += appendSize;
}

void RSI21H1Plot::Refresh(int size, double &plotRSISeries[]) {
    if (size == 0) {
        m_rsi.Refresh();
        plotRSISeries[m_size - 1] = m_rsi.ValueAt(m_size - 1);
        return;
    }

    for (int i = m_size - size; i < m_size; i++) {
        plotRSISeries[i] = m_rsi.ValueAt(i);
    }
}

void RSI21H1Plot::CopyResult(double &plotRSISeries[]) {
    for (int i = 0; i < m_size; i++) {
        plotRSISeries[i] = m_rsi.ValueAt(i);
    }
}

#endif

RSI21H1Plot p;

int OnInit() {
    SetIndexBuffer(0, PlotRSISeries, INDICATOR_DATA);
    return INIT_SUCCEEDED;
}

int OnCalculate(
    const int rates_total,
    const int prev_calculated,
    const int begin,
    const double& price[]
) {
    if (prev_calculated == 0) {
        p.Initialize(rates_total);
        if (!p.InitializeSuccess()) {
            return rates_total;
        }
        p.Calc();
        p.CopyResult(PlotRSISeries);
        return rates_total;
    }

    int appendSize = rates_total - prev_calculated;
    if (appendSize > 0) {
        p.Calc(appendSize);
    }
    if (!p.InitializeSuccess()) {
        return rates_total;
    }
    p.Refresh(appendSize, PlotRSISeries);
    return rates_total;
}
