#property copyright "Copyright 2022, YuhichYOC"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots 1

//--- plot Short
#property indicator_label1 "90H1"
#property indicator_type1 DRAW_LINE
#property indicator_color1 clrTeal
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1

//--- indicator buffers
double PlotMASeries[];

#ifndef IG_MOVING_AVERAGE
#define IG_MOVING_AVERAGE
#include "..\..\..\Libraries\MA\MovingAverage.mq5"
#endif

#ifndef D_MOVING_AVERAGE_90H1_PLOT_H
#define D_MOVING_AVERAGE_90H1_PLOT_H

class MovingAverage90H1Plot {
public:
    MovingAverage90H1Plot(void);
    ~MovingAverage90H1Plot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void Calc(void);
    void Calc(int appendSize);
    void Refresh(int size, double &plotMASeries[]);
    void CopyResult(double &plotMASeries[]);

private:
    string m_symbol;
    ENUM_TIMEFRAMES m_period;
    int m_size;
    MovingAverage m_m;
};

#endif

#ifndef D_MOVING_AVERAGE_90H1_PLOT_B
#define D_MOVING_AVERAGE_90H1_PLOT_B

void MovingAverage90H1Plot::MovingAverage90H1Plot() {}

void MovingAverage90H1Plot::~MovingAverage90H1Plot() {}

void MovingAverage90H1Plot::Initialize(int size) {
    m_symbol = _Symbol;
    m_period = _Period;
    m_size = size;
    m_m.Initialize(m_symbol, m_period, m_size, 89, 1);
}

bool MovingAverage90H1Plot::InitializeSuccess() {
    return m_m.InitializeSuccess();
}

void MovingAverage90H1Plot::Calc() {
    m_m.Calc();
}

void MovingAverage90H1Plot::Calc(int appendSize) {
    m_m.Calc(appendSize);
    m_size += appendSize;
}

void MovingAverage90H1Plot::Refresh(int size, double &plotMASeries[]) {
    if (size == 0) {
        m_m.Refresh();
        plotMASeries[m_size - 1] = m_m.ValueAt(m_size - 1);
        return;
    }

    for (int i = m_size - size; i < m_size; i++) {
        plotMASeries[i] = m_m.ValueAt(i);
    }
}

void MovingAverage90H1Plot::CopyResult(double &plotMASeries[]) {
    for (int i = 0; i < m_size; i++) {
        plotMASeries[i] = m_m.ValueAt(i);
    }
}

#endif

MovingAverage90H1Plot p;

int OnInit() {
    SetIndexBuffer(0, PlotMASeries, INDICATOR_DATA);
    return(INIT_SUCCEEDED);
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
        p.CopyResult(PlotMASeries);
        return rates_total;
    }

    int appendSize = rates_total - prev_calculated;
    if (appendSize > 0) {
        p.Calc(appendSize);
    }
    if (!p.InitializeSuccess()) {
        return rates_total;
    }
    p.Refresh(appendSize, PlotMASeries);
    return rates_total;
}
