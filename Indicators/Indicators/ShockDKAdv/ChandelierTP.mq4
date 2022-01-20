//+------------------------------------------------------------------+
//|                                      CustomIndicator.template.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>

// Default show the indicator in chart window using indicator_chart_window
// Show the indicator in a separate window
//#property indicator_separate_window
#property indicator_chart_window

// --- indicator settings
#property indicator_buffers 4
#property indicator_color1 clrBlue
#property indicator_color2 clrRed

// --- input parameters
extern int HighOrLow = 2; // 1 for high, 0 for low, 2 for both
extern int BarsCount = 20;
extern int TRS = 10; // 高低止损带上浮点数

// --- indicator buffers
double ExtHighBand[];
double ExtLowBand[];

// --- input parameter checking flag
bool is_input_params_valid = false;

// Minimum and Maximum of the indicator window
//
//#property indicator_minimum 1
//#property indicator_maximum 10

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
    // Init
    IndicatorBuffers(2);

    // Drawing Settings

    SetIndexBuffer(0, ExtHighBand);
    SetIndexBuffer(1, ExtLowBand);

    if (HighOrLow == 0) {
       SetIndexStyle(1, DRAW_NONE);
       SetIndexStyle(0, DRAW_LINE);
    }
    if (HighOrLow == 1) {
        SetIndexStyle(0, DRAW_NONE);
        SetIndexStyle(1, DRAW_LINE);
    }
    if (HighOrLow == 2) {
        SetIndexStyle(0, DRAW_LINE);
        SetIndexStyle(1, DRAW_LINE);
    }

    IndicatorShortName("Band BarsCount: " + IntegerToString(BarsCount)
                        + " for " + (HighOrLow == 1 ? "High" : "Low"));

    is_input_params_valid = true;

    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[],
                const double &open[], const double &high[], const double &low[], const double &close[],
                const long &tick_volume[], const long &volume[], const int &spread[]) {

    int i, limit;

    if (rates_total <= BarsCount || !is_input_params_valid) {
        return 0;
    }
    limit = rates_total - prev_calculated;


    for (i = 0; i < limit - 1; i++) {
        double liQKA = MathMax(1 - BarsCount*0.1, 0.3);
        double KliqPoint = high[iHighest(NULL,0,MODE_HIGH,BarsCount,i+1)]
                           + open[i]*TRS/10000*liQKA;
        double DliqPoint = low[iLowest(NULL,0,MODE_LOW,BarsCount,i+1)]
                           - open[i]*TRS/10000*liQKA;
        ExtHighBand[i] = KliqPoint;
        ExtLowBand[i] = DliqPoint;
    }

    // Returns value of prev_calculated for next call
    return(rates_total);
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {

}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam, const double &dparam, const string &sparam) {


}
