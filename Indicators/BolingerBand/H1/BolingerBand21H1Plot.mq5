#property copyright "Copyright 2022, YuhichYOC"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots 3

//--- plot Short
#property indicator_label1 "21H1"
#property indicator_type1 DRAW_LINE
#property indicator_color1 clrCoral
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1

#property indicator_label2 "21H1Plus"
#property indicator_type2 DRAW_LINE
#property indicator_color2 clrCoral
#property indicator_style2 STYLE_SOLID
#property indicator_width2 1

#property indicator_label3 "21H1Minus"
#property indicator_type3 DRAW_LINE
#property indicator_color3 clrCoral
#property indicator_style3 STYLE_SOLID
#property indicator_width3 1

//--- indicator buffers
double PlotMASeries[];
double PlotPlusSeries[];
double PlotMinusSeries[];

#ifndef IG_BOLINGER_BAND
#define IG_BOLINGER_BAND
#include "..\..\..\Libraries\BolingerBand\BolingerBand.mq5"
#endif

#ifndef D_BOLINGER_BAND_21H1_PLOT_H
#define D_BOLINGER_BAND_21H1_PLOT_H

class BolingerBand21H1Plot {
public:
    BolingerBand21H1Plot(void);
    ~BolingerBand21H1Plot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void Calc(void);
    void Calc(int appendSize);
    void Refresh(
        int size,
        double &plotMASeries[],
        double &plotPlusSeries[],
        double &plotMinusSeries[]
    );
    void CopyResult(
        double &plotMASeries[],
        double &plotPlusSeries[],
        double &plotMinusSeries[]
    );

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    BolingerBand m_b;
};

#endif

#ifndef D_BOLINGER_BAND_21H1_PLOT_B
#define D_BOLINGER_BAND_21H1_PLOT_B

void BolingerBand21H1Plot::BolingerBand21H1Plot() {}

void BolingerBand21H1Plot::~BolingerBand21H1Plot() {}

void BolingerBand21H1Plot::Initialize(int size) {
    m_symbol = _Symbol;
    m_period = _Period;
    m_size = size;
    m_b.Initialize(m_symbol, m_period, m_size, 20, 1, 2);
}

bool BolingerBand21H1Plot::InitializeSuccess() {
    return m_b.InitializeSuccess();
}

void BolingerBand21H1Plot::Calc() {
    m_b.Calc();
}

void BolingerBand21H1Plot::Calc(int appendSize) {
    m_b.Calc(appendSize);
    m_size += appendSize;
}

void BolingerBand21H1Plot::Refresh(
    int size,
    double &plotMASeries[],
    double &plotPlusSeries[],
    double &plotMinusSeries[]
) {
    if (size == 0) {
        m_b.Refresh();
        plotMASeries[m_size - 1] = m_b.ValueAt(m_size - 1);
        plotPlusSeries[m_size - 1] = m_b.HighAt(m_size - 1);
        plotMinusSeries[m_size - 1] = m_b.LowAt(m_size - 1);
        return;
    }

    for (int i = m_size - size; i < m_size; i++) {
        plotMASeries[i] = m_b.ValueAt(i);
        plotPlusSeries[i] = m_b.HighAt(i);
        plotMinusSeries[i] = m_b.LowAt(i);
    }
}

void BolingerBand21H1Plot::CopyResult(
    double &plotMASeries[],
    double &plotPlusSeries[],
    double &plotMinusSeries[]
) {
    for (int i = 0; i < m_size; i++) {
        plotMASeries[i] = m_b.ValueAt(i);
        plotPlusSeries[i] = m_b.HighAt(i);
        plotMinusSeries[i] = m_b.LowAt(i);
    }
}

#endif

BolingerBand21H1Plot p;

int OnInit() {
    SetIndexBuffer(0, PlotMASeries, INDICATOR_DATA);
    SetIndexBuffer(1, PlotPlusSeries, INDICATOR_DATA);
    SetIndexBuffer(2, PlotMinusSeries, INDICATOR_DATA);
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
        p.CopyResult(
            PlotMASeries,
            PlotPlusSeries,
            PlotMinusSeries
        );
        return rates_total;
    }

    int appendSize = rates_total - prev_calculated;
    if (appendSize > 0) {
        p.Calc(appendSize);
    }
    if (!p.InitializeSuccess()) {
        return rates_total;
    }
    p.Refresh(
        appendSize,
        PlotMASeries,
        PlotPlusSeries,
        PlotMinusSeries
    );
    return rates_total;
}
