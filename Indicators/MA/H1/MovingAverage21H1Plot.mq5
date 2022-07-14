#property copyright "Copyright 2022, YuhichYOC"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots 1

//--- plot Short
#property indicator_label1 "21H1"
#property indicator_type1 DRAW_LINE
#property indicator_color1 clrCoral
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1

//--- indicator buffers
double PlotMASeries[];

#include "..\..\..\Libraries\Price\Close.mq5"
#include "..\..\..\Libraries\MA\MovingAverage.mq5"

class MovingAverage21H1Plot {
public:
    MovingAverage21H1Plot(void);
    ~MovingAverage21H1Plot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void Calc(void);
    void CopyResult(double &plotMASeries[]);

private:
    Close close;
    MovingAverage ma;
};

void MovingAverage21H1Plot::MovingAverage21H1Plot() {}

void MovingAverage21H1Plot::~MovingAverage21H1Plot() {}

void MovingAverage21H1Plot::Initialize(int size) {
    close.Initialize(_Symbol, PERIOD_H1, size);
    ma.Initialize(size, 20, 1);
}

bool MovingAverage21H1Plot::InitializeSuccess() {
    return close.InitializeSuccess()
        && ma.InitializeSuccess();
}

void MovingAverage21H1Plot::Calc() {
    close.Fill();
    ma.Calc(close);
}

void MovingAverage21H1Plot::CopyResult(double &plotMASeries[]) {
    ma.CopyResult(plotMASeries);
}

MovingAverage21H1Plot p;
int try;

int OnInit() {
    try = 10000;
    SetIndexBuffer(0, PlotMASeries, INDICATOR_DATA);
    return INIT_SUCCEEDED;
}

int OnCalculate(
    const int rates_total,
    const int prev_calculated,
    const int begin,
    const double& price[]) {

    if (try < 10000) {
        try += 1;
        return rates_total;
    }
    else {
        try = 0;
    }

    if (prev_calculated == 0) {
        p.Initialize(rates_total);
        if (!p.InitializeSuccess()) {
            return rates_total;
        }
        p.Calc();
        p.CopyResult(PlotMASeries);
    }
    else {
        printf("OnCalculate canceled");
    }

    return rates_total;
}
