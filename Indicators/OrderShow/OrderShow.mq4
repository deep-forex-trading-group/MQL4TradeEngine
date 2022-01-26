//+------------------------------------------------------------------+
//|                                                    OrderShow.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <ThirdPartyLib/AdvancedTradingSystemLib/FileIOUtils/DataFrame/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

// Default show the indicator in chart window using indicator_chart_window
// Show the indicator in a separate window
#property indicator_separate_window

// --- indicator settings
#property indicator_buffers 2
#property indicator_color1 clrRed
#property indicator_color2 clrYellow

// --- indicator_buffers
double ExtEquityBuffer[];
double ExtBalanceBuffer[];

// Minimum and Maximum of the indicator window
//
//#property indicator_minimum 1
//#property indicator_maximum 10

DataFrame* df;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
    string path = "records/whmg_eb.csv";
    df = new DataFrame(path, ",", 0);
//    df.PrintDataFrame();

    // Init
    IndicatorBuffers(2);

    // Drawing Settins
    SetIndexStyle(0, DRAW_LINE);
    SetIndexBuffer(0, ExtEquityBuffer);
    SetIndexStyle(1, DRAW_LINE);
    SetIndexBuffer(1, ExtBalanceBuffer);

    IndicatorShortName("OrderShow");

    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[],
                const double &open[], const double &high[], const double &low[], const double &close[],
                const long &tick_volume[], const long &volume[], const int &spread[]) {
    int limit = rates_total - prev_calculated;
//    PrintFormat("NEWLOOP");
    HashMap<string, LineContent*>* df_content_map = df.GetDFIndexMap();
    for (int i = limit - 1; i >=0; i--) {
        LineContent* cur_line_content = df_content_map[TimeToStr(time[i])];
        if (IsPtrInvalid(cur_line_content)) {
            continue;
        }
        double equity = StringToDouble(cur_line_content.get(2));
        double balance = StringToDouble(cur_line_content.get(3));
        ExtEquityBuffer[i] = equity;
        ExtBalanceBuffer[i] = balance;
//        PrintFormat("dt: %s, equity: %s, balance: %s",
//                    TimeToString(time[i]), DoubleToStr(equity), DoubleToStr(balance));
    }
    // Returns value of inidicator caculated in current iteration for next call
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

void OnDeinit(const int reason) {
    Print("Deinitialize the OrderShow Indicator");
    ShowDeinitReason(reason);
    SafeDeletePtr(df);
}