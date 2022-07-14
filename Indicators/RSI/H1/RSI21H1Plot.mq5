#property copyright "Copyright 2022, YuhichYOC"

#property indicator_separate_window
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

#include "..\..\..\Libraries\RSI\RSI.mq5"

class RSI21H1Plot {
public:
    RSI21H1Plot(void);
    ~RSI21H1Plot(void);

    void Initialize(int size);
    bool InitializeSuccess(void);

    void Calc(void);
    void CopyResult(double &plotRSISeries[]);

private:
    Close close;
    RSI rsi;
};

void RSI21H1Plot::RSI21H1Plot() {}

void RSI21H1Plot::~RSI21H1Plot() {}

void RSI21H1Plot::Initialize(int size) {
    close.Initialize(_Symbol, PERIOD_H1, size);
    rsi.Initialize(size, 20, 1);
}

bool RSI21H1Plot::InitializeSuccess() {
    return close.InitializeSuccess()
        && rsi.InitializeSuccess();
}

void RSI21H1Plot::Calc() {
    close.Fill();
    rsi.Calc(close);
}

void RSI21H1Plot::CopyResult(double &plotRSISeries[]) {
    rsi.CopyResult(plotRSISeries);
}

RSI21H1Plot p;
int try;

int OnInit() {
    try = 10000;
    SetIndexBuffer(0, PlotRSISeries, INDICATOR_DATA);
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
        p.CopyResult(PlotRSISeries);
    }
    else {
        printf("OnCalculate canceled");
    }

    return rates_total;
}
