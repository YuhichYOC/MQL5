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

#include "..\..\..\Libraries\BolingerBand\BolingerBand.mq5"

class BolingerBand21H1Plot {
public:
    BolingerBand21H1Plot(void);
    ~BolingerBand21H1Plot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void ReverseAdd(double, int);
    void Calc(void);
    void CopyResult(double &plotMASeries[], double &plotPlusSeries[], double &plotMinusSeries[]);

private:
    BolingerBand b;
};

void BolingerBand21H1Plot::BolingerBand21H1Plot() {}

void BolingerBand21H1Plot::~BolingerBand21H1Plot() {}

void BolingerBand21H1Plot::Initialize(int size) {
    b.Initialize(size, 20, 1, 2);
}

bool BolingerBand21H1Plot::InitializeSuccess() {
    return b.InitializeSuccess();
}

void BolingerBand21H1Plot::ReverseAdd(double value, int i) {
    b.ReverseAdd(value, i);
}

void BolingerBand21H1Plot::Calc() {
    b.Calc();
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
        for (int i = 0; i < rates_total; i++) {
            p.ReverseAdd(iClose(_Symbol, PERIOD_H1, i), i);
        }
        p.Calc();
        p.CopyResult(PlotMASeries, PlotPlusSeries, PlotMinusSeries);
    }
    else {
        printf("OnCalculate canceled");
    }

    return rates_total;
}
