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

#include "..\..\..\Libraries\MA\MovingAverage.mq5"

class MovingAverage90H1Plot {
public:
    MovingAverage90H1Plot(void);
    ~MovingAverage90H1Plot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void ReverseAdd(double, int);
    void Calc();
    void CopyResult(double &plotMASeries[]);

private:
    MovingAverage ma;
};

void MovingAverage90H1Plot::MovingAverage90H1Plot() {}

void MovingAverage90H1Plot::~MovingAverage90H1Plot() {}

void MovingAverage90H1Plot::Initialize(int size) {
    ma.Initialize(size, 89, 1);
}

bool MovingAverage90H1Plot::InitializeSuccess() {
    return ma.InitializeSuccess();
}

void MovingAverage90H1Plot::ReverseAdd(double value, int i) {
    ma.ReverseAdd(value, i);
}

void MovingAverage90H1Plot::Calc() {
    ma.Calc();
}

void MovingAverage90H1Plot::CopyResult(double &plotMASeries[]) {
    ma.CopyResult(plotMASeries);
}

MovingAverage90H1Plot p;
int try;

int OnInit() {
    try = 10000;
    SetIndexBuffer(0, PlotMASeries, INDICATOR_DATA);
    return(INIT_SUCCEEDED);
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
        for (int i = 0; i < rates_total; i++) {
            p.ReverseAdd(iClose(_Symbol, PERIOD_H1, i), i);
        }
        p.Calc();
        p.CopyResult(PlotMASeries);
    }
    else {
        printf("OnCalculate canceled");
    }

    return rates_total;
}
