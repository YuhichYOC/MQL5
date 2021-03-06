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

#include "..\..\..\Libraries\Price\Close.mq5"
#include "..\..\..\Libraries\BolingerBand\BolingerBand.mq5"

class BolingerBand21H1Plot {
public:
    BolingerBand21H1Plot(void);
    ~BolingerBand21H1Plot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void Calc(void);
    void CopyResult(double &plotMASeries[], double &plotPlusSeries[], double &plotMinusSeries[]);

private:
    Close close;
    MovingAverage ma;
    Deviations deviations;
    BolingerBand b;
};

void BolingerBand21H1Plot::BolingerBand21H1Plot() {}

void BolingerBand21H1Plot::~BolingerBand21H1Plot() {}

void BolingerBand21H1Plot::Initialize(int size) {
    close.Initialize(_Symbol, PERIOD_H1, size);
    ma.Initialize(size, 20, 1);
    deviations.Initialize(size, 20, 1);
    b.Initialize(size, 2);
}

bool BolingerBand21H1Plot::InitializeSuccess() {
    return close.InitializeSuccess()
        && ma.InitializeSuccess()
        && deviations.InitializeSuccess()
        && b.InitializeSuccess();
}

void BolingerBand21H1Plot::Calc() {
    close.Fill();
    ma.Calc(close);
    deviations.Calc(close);
    b.Calc(ma, deviations);
}

void BolingerBand21H1Plot::CopyResult(double &plotMASeries[], double &plotPlusSeries[], double &plotMinusSeries[]) {
    b.CopyResult(plotMASeries, plotPlusSeries, plotMinusSeries);
}

BolingerBand21H1Plot p;
int try;

int OnInit() {
    try = 10000;
    SetIndexBuffer(0, PlotMASeries, INDICATOR_DATA);
    SetIndexBuffer(1, PlotPlusSeries, INDICATOR_DATA);
    SetIndexBuffer(2, PlotMinusSeries, INDICATOR_DATA);
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
        p.CopyResult(PlotMASeries, PlotPlusSeries, PlotMinusSeries);
    }
    else {
        printf("OnCalculate canceled");
    }

    return rates_total;
}
