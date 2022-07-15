#property library
#property copyright "Copyright 2022, YuhichYOC"

class MarketInfo {
public:
    MarketInfo(void);
    ~MarketInfo(void);

    double Ask(string symbol);
    double Bid(string symbol);
    long StopLevel(string symbol);
    double Point(string symbol);
    double BuyTPMinimum(string symbol);
    double BuySLMaximum(string symbol);
    double SellTPMaximum(string symbol);
    double SellSLMinimum(string symbol);
};

void MarketInfo::MarketInfo() {}

void MarketInfo::~MarketInfo() {}

double MarketInfo::Ask(string symbol) {
    return SymbolInfoDouble(symbol, SYMBOL_ASK);
}

double MarketInfo::Bid(string symbol) {
    return SymbolInfoDouble(symbol, SYMBOL_BID);
}

long MarketInfo::StopLevel(string symbol) {
    return SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
}

double MarketInfo::Point(string symbol) {
    return SymbolInfoDouble(symbol, SYMBOL_POINT);
}

double MarketInfo::BuyTPMinimum(string symbol) {
    return Bid(symbol) + (StopLevel(symbol) * Point(symbol));
}

double MarketInfo::BuySLMaximum(string symbol) {
    return Bid(symbol) - (StopLevel(symbol) * Point(symbol));
}

double MarketInfo::SellTPMaximum(string symbol) {
    return Ask(symbol) - (StopLevel(symbol) * Point(symbol));
}

double MarketInfo::SellSLMinimum(string symbol) {
    return Ask(symbol) + (StopLevel(symbol) * Point(symbol));
}
