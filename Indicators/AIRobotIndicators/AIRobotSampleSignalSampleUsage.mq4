//+------------------------------------------------------------------+
//|                               AIRobotSampleSignalSampleUsage.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// Indicator Settings
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  DodgerBlue

// Input Params
input int InpAtrPeriod=14; // ATR Period

// Buffers
double ExtATRBuffer[];
double ExtTRBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
// Indicator buffers mapping
    string short_name;
    // 1 additional buffer used for counting.
    IndicatorBuffers(2);
    IndicatorDigits(Digits);
    // Indicator line
    SetIndexStyle(0,DRAW_LINE);
    SetIndexBuffer(0,ExtATRBuffer);
    SetIndexBuffer(1,ExtTRBuffer);
    // Name for DataWindow and indicator subwindow label
    short_name="ATR("+IntegerToString(InpAtrPeriod)+")";
    IndicatorShortName(short_name);
    SetIndexLabel(0,short_name);
    // Checks for input parameter
    if(InpAtrPeriod<=0) {
        Print("Wrong input parameter ATR Period=",InpAtrPeriod);
        return(INIT_FAILED);
    }
    //---
    SetIndexDrawBegin(0,InpAtrPeriod);

    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[],
                const double &open[], const double &high[], const double &low[], const double &close[],
                const long &tick_volume[], const long &volume[], const int &spread[]) {
    int i,limit;
    // Checks for bars count and input parameter
    if(rates_total<=InpAtrPeriod || InpAtrPeriod<=0) { return(0); }

    // Counting from 0 to rates_total
    ArraySetAsSeries(ExtATRBuffer,false);
    ArraySetAsSeries(ExtTRBuffer,false);
    ArraySetAsSeries(open,false);
    ArraySetAsSeries(high,false);
    ArraySetAsSeries(low,false);
    ArraySetAsSeries(close,false);

    // Preliminary calculations
    if(prev_calculated==0) {
        ExtTRBuffer[0]=0.0;
        ExtATRBuffer[0]=0.0;
        // Filling out the array of True Range values for each period
        for(i=1; i<rates_total; i++) {
            ExtTRBuffer[i]=MathMax(high[i],close[i-1])-MathMin(low[i],close[i-1]);
        }

        // First AtrPeriod values of the indicator are not calculated
        double firstValue=0.0;
        for(i=1; i<=InpAtrPeriod; i++) {
            ExtATRBuffer[i] = 0.0;
            firstValue += ExtTRBuffer[i];
        }

        // Calculating the first value of the indicator
        firstValue /= InpAtrPeriod;
        ExtATRBuffer[InpAtrPeriod] = firstValue;
        limit = InpAtrPeriod+1;
    } else {
        limit=prev_calculated-1;
    }

    // The main loop of calculations
    for(i=limit; i<rates_total; i++) {
        ExtTRBuffer[i]=MathMax(high[i],close[i-1])-MathMin(low[i],close[i-1]);
        ExtATRBuffer[i]=ExtATRBuffer[i-1]+(ExtTRBuffer[i]-ExtTRBuffer[i-InpAtrPeriod])/InpAtrPeriod;
    }
    // Returns value of prev_calculated for next call
    return(rates_total);
}
//+------------------------------------------------------------------+
