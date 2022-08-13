#property copyright "Copyright 2022, YuhichYOC"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots 1

//--- plot Short
#property indicator_label1 "ZigZag"
#property indicator_type1 DRAW_SECTION
#property indicator_color1 clrCoral
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1

//--- indicator buffers
double PlotZZSeries[];

input double Deviation = 1.0;

#ifndef IG_ZIGZAG
#define IG_ZIGZAG
#include "..\..\Libraries\ZigZag\ZigZag.mq5"
#endif

#ifndef D_ZIGZAG_PLOT_H
#define D_ZIGZAG_PLOT_H

class ZigZagPlot {
public:
    ZigZagPlot(void);
    ~ZigZagPlot(void);

    void Initialize(
        string symbol,
        ENUM_TIMEFRAMES period,
        int size,
        double deviation
    );
    bool InitializeSuccess(void);

    void Scan(void);
    void Scan(int appendSize);
    void CopyResult(double &zz[]);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;

    ZigZag zz;
};

#endif

#ifndef D_ZIGZAG_PLOT_B
#define D_ZIGZAG_PLOT_B

void ZigZagPlot::ZigZagPlot() {}

void ZigZagPlot::~ZigZagPlot() {}

void ZigZagPlot::Initialize(
    string symbol,
    ENUM_TIMEFRAMES period,
    int size,
    double deviation
) {
    m_symbol = symbol;
    m_period = period;
    m_size = size;
    zz.Initialize(m_symbol, m_period, m_size, deviation);
}

bool ZigZagPlot::InitializeSuccess() {
    return zz.InitializeSuccess();
}

void ZigZagPlot::Scan() {
    zz.Scan();
}

void ZigZagPlot::Scan(int appendSize) {
    zz.Scan(appendSize);
    m_size += appendSize;
}

void ZigZagPlot::CopyResult(double &plotZZSeries[]) {
    for (int i = 0; i < m_size; i++) {
        plotZZSeries[i] = zz.ValueAt(i);
    }
}

#endif

ZigZagPlot p;

int OnInit() {
    SetIndexBuffer(0, PlotZZSeries, INDICATOR_DATA);
    PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0);
    return INIT_SUCCEEDED;
}

int OnCalculate(
    const int rates_total,
    const int prev_calculated,
    const int begin,
    const double& price[]
) {
    if (prev_calculated == 0) {
        p.Initialize(
            _Symbol,
            _Period,
            rates_total,
            Deviation
        );
        if (!p.InitializeSuccess()) {
            return rates_total;
        }
        p.Scan();
        ArrayInitialize(PlotZZSeries, 0);
        p.CopyResult(PlotZZSeries);
        return rates_total;
    }

    int appendSize = rates_total - prev_calculated;
    if (appendSize == 0) {
        return rates_total;
    }
    p.Scan(appendSize);
    if (!p.InitializeSuccess()) {
        return rates_total;
    }
    ArrayInitialize(PlotZZSeries, 0);
    p.CopyResult(PlotZZSeries);
    return rates_total;
}
