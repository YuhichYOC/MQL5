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

#include "..\..\Libraries\ZigZag\ZigZag.mq5"

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
    void CopyResult(double &zz[]);

private:
    ZigZag zz;
};

void ZigZagPlot::ZigZagPlot() {}

void ZigZagPlot::~ZigZagPlot() {}

void ZigZagPlot::Initialize(
    string symbol,
    ENUM_TIMEFRAMES period,
    int size,
    double deviation
) {
    zz.Initialize(symbol, period, size, deviation);
}

bool ZigZagPlot::InitializeSuccess() {
    return zz.InitializeSuccess();
}

void ZigZagPlot::Scan() {
    zz.Scan();
}

void ZigZagPlot::CopyResult(double &plotZZSeries[]) {
    zz.CopyResult(plotZZSeries);
}

ZigZagPlot z;
int try;

int OnInit() {
    try = 10000;
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

    if (try < 10000) {
        try++;
        return rates_total;
    }
    else {
        try = 0;
    }

    if (prev_calculated == 0) {
        z.Initialize(
            _Symbol,
            _Period,
            rates_total,
            Deviation
        );
        if (!z.InitializeSuccess()) {
            return rates_total;
        }
        z.Scan();
        ArrayInitialize(PlotZZSeries, 0);
        z.CopyResult(PlotZZSeries);
    }
    else {
        printf("OnCalculate canceled");
    }

    return rates_total;
}
