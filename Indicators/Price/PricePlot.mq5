#property copyright "Copyright 2022, YuhichYOC"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots 4

//--- plot Short
#property indicator_label1 "PHigh"
#property indicator_type1 DRAW_LINE
#property indicator_color1 clrRed
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1

#property indicator_label2 "PLow"
#property indicator_type2 DRAW_LINE
#property indicator_color2 clrBlue
#property indicator_style2 STYLE_SOLID
#property indicator_width2 1

#property indicator_label3 "POpenCloseHigh"
#property indicator_type3 DRAW_LINE
#property indicator_color3 clrOrange
#property indicator_style3 STYLE_SOLID
#property indicator_width3 1

#property indicator_label4 "POpenCloseLow"
#property indicator_type4 DRAW_LINE
#property indicator_color4 clrSpringGreen
#property indicator_style4 STYLE_SOLID
#property indicator_width4 1

//--- indicator buffers
double PlotHighSeries[];
double PlotLowSeries[];
double PlotOpenCloseHighSeries[];
double PlotOpenCloseLowSeries[];

#ifndef IG_P_HIGH
#define IG_P_HIGH
#include "..\..\Libraries\Price\PHigh.mq5"
#endif

#ifndef IG_P_LOW
#define IG_P_LOW
#include "..\..\Libraries\Price\PLow.mq5"
#endif

#ifndef IG_P_OPEN_CLOSE_HIGH
#define IG_P_OPEN_CLOSE_HIGH
#include "..\..\Libraries\Price\POpenCloseHigh.mq5"
#endif

#ifndef IG_P_OPEN_CLOSE_LOW
#define IG_P_OPEN_CLOSE_LOW
#include "..\..\Libraries\Price\POpenCloseLow.mq5"
#endif

#ifndef D_PRICE_PLOT_H
#define D_PRICE_PLOT_H

class PricePlot {
public:
    PricePlot(void);
    ~PricePlot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void Fill(void);
    void Fill(int appendSize);
    void Refresh(
        int size,
        double &plotHighSeries[],
        double &plotLowSeries[],
        double &plotOpenCloseHighSeries[],
        double &plotOpenCloseLowSeries[]
    );
    void CopyResult(
        double &plotHighSeries[],
        double &plotLowSeries[],
        double &plotOpenCloseHighSeries[],
        double &plotOpenCloseLowSeries[]
    );

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    PHigh m_h;
    PLow m_l;
    POpenCloseHigh m_och;
    POpenCloseLow m_ocl;
};

#endif

#ifndef D_PRICE_PLOT_B
#define D_PRICE_PLOT_B

void PricePlot::PricePlot() {}

void PricePlot::~PricePlot() {}

void PricePlot::Initialize(int size) {
    m_symbol = _Symbol;
    m_period = _Period;
    m_size = size;
    m_h.Initialize(m_symbol, m_period, m_size);
    m_l.Initialize(m_symbol, m_period, m_size);
    m_och.Initialize(m_symbol, m_period, m_size);
    m_ocl.Initialize(m_symbol, m_period, m_size);
}

bool PricePlot::InitializeSuccess() {
    return m_h.InitializeSuccess()
        && m_l.InitializeSuccess()
        && m_och.InitializeSuccess()
        && m_ocl.InitializeSuccess();
}

void PricePlot::Fill() {
    m_h.Fill();
    m_l.Fill();
    m_och.Fill();
    m_ocl.Fill();
}

void PricePlot::Fill(int appendSize) {
    m_h.Fill(appendSize);
    m_l.Fill(appendSize);
    m_och.Fill(appendSize);
    m_ocl.Fill(appendSize);
    m_size += appendSize;
}

void PricePlot::Refresh(
    int size,
    double &plotHighSeries[],
    double &plotLowSeries[],
    double &plotOpenCloseHighSeries[],
    double &plotOpenCloseLowSeries[]
) {
    if (size == 0) {
        m_h.Refresh();
        m_l.Refresh();
        m_och.Refresh();
        m_ocl.Refresh();
        plotHighSeries[m_size - 1] = m_h.ValueAt(m_size - 1);
        plotLowSeries[m_size - 1] = m_l.ValueAt(m_size - 1);
        plotOpenCloseHighSeries[m_size - 1] = m_och.ValueAt(m_size - 1);
        plotOpenCloseLowSeries[m_size - 1] = m_ocl.ValueAt(m_size - 1);
        return;
    }

    for (int i = 0; i < size; i++) {
        plotHighSeries[i] = m_h.ValueAt(i);
        plotLowSeries[i] = m_l.ValueAt(i);
        plotOpenCloseHighSeries[i] = m_och.ValueAt(i);
        plotOpenCloseLowSeries[i] = m_ocl.ValueAt(i);
    }
}

void PricePlot::CopyResult(
    double &plotHighSeries[],
    double &plotLowSeries[],
    double &plotOpenCloseHighSeries[],
    double &plotOpenCloseLowSeries[]
) {
    for (int i = 0; i < m_size; i++) {
        plotHighSeries[i] = m_h.ValueAt(i);
        plotLowSeries[i] = m_l.ValueAt(i);
        plotOpenCloseHighSeries[i] = m_och.ValueAt(i);
        plotOpenCloseLowSeries[i] = m_ocl.ValueAt(i);
    }
}

#endif

PricePlot p;

int OnInit() {
    SetIndexBuffer(0, PlotHighSeries, INDICATOR_DATA);
    SetIndexBuffer(1, PlotLowSeries, INDICATOR_DATA);
    SetIndexBuffer(2, PlotOpenCloseHighSeries, INDICATOR_DATA);
    SetIndexBuffer(3, PlotOpenCloseLowSeries, INDICATOR_DATA);
    return INIT_SUCCEEDED;
}

int OnCalculate(
    const int rates_total,
    const int prev_calculated,
    const int begin,
    const double &price[]
) {
    if (prev_calculated == 0) {
        p.Initialize(rates_total);
        if (!p.InitializeSuccess()) {
            return rates_total;
        }
        p.Fill();
        p.CopyResult(
            PlotHighSeries,
            PlotLowSeries,
            PlotOpenCloseHighSeries,
            PlotOpenCloseLowSeries
        );
        return rates_total;
    }

    int appendSize = rates_total - prev_calculated;
    if (appendSize > 0) {
        p.Fill(appendSize);
    }
    if (!p.InitializeSuccess()) {
        return rates_total;
    }
    p.Refresh(
        appendSize,
        PlotHighSeries,
        PlotLowSeries,
        PlotOpenCloseHighSeries,
        PlotOpenCloseLowSeries
    );
    return rates_total;
}
