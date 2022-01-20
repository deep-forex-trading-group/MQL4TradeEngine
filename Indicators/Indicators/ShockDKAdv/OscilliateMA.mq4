//+------------------------------------------------------------------+
//|                                      CustomIndicator.template.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <MovingAverages.mqh>

// Default show the indicator in chart window using indicator_chart_window
// Show the indicator in a separate window
//#property indicator_separate_window
#property indicator_chart_window

// --- indicator settings
#property indicator_buffers 5
#property indicator_color1 clrRed
#property indicator_color2 clrRed
#property indicator_color3 clrYellow
#property indicator_color4 clrGreen
#property indicator_color5 clrGreen

// --- input parameters
extern int FastPeriod = 10;
extern int SlowPeriod = 15;
extern int MovingRangePeriod = 9;

int FastSecPeriod = 90;

// --- indicator buffers
double ExtTopBuffer[];
double ExtMiddleRedBuffer[];
double ExtMiddleYellowBuffer[];
double ExtMiddleGreenBuffer[];
double ExtBottomBuffer[];

// --- helping buffers
double ExtLWHighBuffer[];
double ExtLWLowBuffer[];
double ExtMAHDBuffer[];
double ExtMALDBuffer[];
double ExtHighBuffer[];
double ExtLowBuffer[];

double ExtFirstOrderHigh[];
double ExtSecOrderHigh[];
double ExtFirstOrderLow[];
double ExtSecOrderLow[];

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
    IndicatorBuffers(15);

    // Drawing Settins
    SetIndexStyle(0, DRAW_LINE);
    SetIndexBuffer(0, ExtTopBuffer);
    SetIndexStyle(1, DRAW_LINE);
    SetIndexBuffer(1, ExtMiddleRedBuffer);
    SetIndexStyle(2, DRAW_LINE);
    SetIndexBuffer(2, ExtMiddleYellowBuffer);
    SetIndexStyle(3, DRAW_LINE);
    SetIndexBuffer(3, ExtMiddleGreenBuffer);
    SetIndexStyle(4, DRAW_LINE);
    SetIndexBuffer(4, ExtBottomBuffer);

    SetIndexBuffer(5, ExtLWHighBuffer);
    SetIndexBuffer(6, ExtLWLowBuffer);
    SetIndexBuffer(7, ExtMAHDBuffer);
    SetIndexBuffer(8, ExtMALDBuffer);
    SetIndexBuffer(9, ExtHighBuffer);
    SetIndexBuffer(10, ExtLowBuffer);

    SetIndexBuffer(11, ExtFirstOrderHigh);
    SetIndexBuffer(12, ExtSecOrderHigh);
    SetIndexBuffer(13, ExtFirstOrderLow);
    SetIndexBuffer(14, ExtSecOrderLow);

    IndicatorShortName("OscilliateMA("+IntegerToString(FastPeriod)+","
                                      +IntegerToString(SlowPeriod)+")");
    if (FastPeriod <= 1 || SlowPeriod <= 1
        || FastPeriod > SlowPeriod) {
        Print("Wrong Input Parameters");
        return (INIT_FAILED);
    } else {
        is_input_params_valid = true;
    }

    return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[],
                const double &open[], const double &high[], const double &low[], const double &close[],
                const long &tick_volume[], const long &volume[], const int &spread[]) {


    int i, limit;
//    if (rates_total <= (SlowPeriod + 90) || !is_input_params_valid) {
//        return 0;
//    }
    if (rates_total <= SlowPeriod || !is_input_params_valid) {
        return 0;
    }
    limit = rates_total - prev_calculated;

    int high_weighted_sum = (FastPeriod + 1) * FastPeriod / 2; int low_weighted_sum = high_weighted_sum;
    LinearWeightedMAOnBuffer(rates_total, prev_calculated, 0, FastPeriod, high, ExtLWHighBuffer, high_weighted_sum);
    LinearWeightedMAOnBuffer(rates_total, prev_calculated, 0, FastPeriod, low, ExtLWLowBuffer, low_weighted_sum);
    SimpleMAOnBuffer(rates_total, prev_calculated, 0, FastPeriod, high, ExtHighBuffer);
    SimpleMAOnBuffer(rates_total, prev_calculated, 0, FastPeriod, low, ExtLowBuffer);

    ExponentialMAOnBuffer(rates_total, prev_calculated, 0, SlowPeriod, ExtHighBuffer, ExtFirstOrderHigh);
    ExponentialMAOnBuffer(rates_total, prev_calculated, 0, SlowPeriod, ExtFirstOrderHigh, ExtSecOrderHigh);
    ExponentialMAOnBuffer(rates_total, prev_calculated, 0, SlowPeriod, ExtLowBuffer, ExtFirstOrderLow);
    ExponentialMAOnBuffer(rates_total, prev_calculated, 0, SlowPeriod, ExtFirstOrderLow, ExtSecOrderLow);

//    H1=(XAverage(XAverage(H,25),25)-XAverage(XAverage(L,25),25))*1+XAverage(XAverage(H,25),25);

//    L1=XAverage(XAverage(L,25),25)-(XAverage(XAverage(H,25),25)-XAverage(XAverage(L,25),25));

    ExponentialMAOnBuffer(rates_total, prev_calculated, 0, FastSecPeriod, ExtLWHighBuffer, ExtMAHDBuffer);
    ExponentialMAOnBuffer(rates_total, prev_calculated, 0, FastSecPeriod, ExtLWLowBuffer, ExtMALDBuffer);


    // --- main loop
    for (i = 0; i < limit - 1; i++) {
        ExtTopBuffer[i] = high[iHighest(NULL, 0, MODE_HIGH, MovingRangePeriod, i+1)];
        ExtBottomBuffer[i] = low[iLowest(NULL, 0, MODE_LOW, MovingRangePeriod, i+1)];
    }
    double buy_sig[1]; ArrayResize(buy_sig, rates_total);
    double sell_sig[1]; ArrayResize(sell_sig, rates_total);

    for (i = 0; i < limit - 1; i++) {
        double CD = ExtMAHDBuffer[i+1] - ExtMALDBuffer[i+1];
        double MHCD = ExtMAHDBuffer[i+1] + 2*CD;
        double MLCD = ExtMALDBuffer[i+1] - 2*CD;
//      DD = H1>=MHCD AND L1>=MLCD;
//    	KK = L1<=MLCD AND H1<=MHCD;
//    	ZD = L1>=MLCD AND H1<=MHCD;
        double H1 = (ExtSecOrderHigh[i] - ExtSecOrderLow[i]) + ExtSecOrderHigh[i];
        double L1 = ExtSecOrderLow[i] - (ExtSecOrderHigh[i] - ExtSecOrderLow[i]);
        // 多头状态，红色
        if (H1>=MHCD && L1>=MLCD) {
            ExtMiddleRedBuffer[i] = (MHCD + MLCD) * 0.5;
        }
        // 空头状态，绿色
        if (L1<=MLCD && H1<=MHCD) {
            ExtMiddleGreenBuffer[i] = (MHCD + MLCD) * 0.5;
        }
        // 震荡状态，黄色
        if (L1>=MLCD && H1<=MHCD) {
            ExtMiddleYellowBuffer[i] = (MHCD + MLCD) * 0.5;
        }
//        ExtTopBuffer[i] = high[iHighest(NULL, 0, MODE_HIGH, MovingRangePeriod, i)];
//        ExtBottomBuffer[i] = low[iLowest(NULL, 0, MODE_LOW, MovingRangePeriod, i)];

        // 多头，空头，破轨入场
//    	If (DD[1]==True and H>=HH[1] and MarketPosition<>1) {
//    			buy(Lots,Max(HH[1],open));
//    	}
//    	If (KK[1]==True and L<=LL[1] and MarketPosition<>-1) {
//    			SellShort(Lots,Min(LL[1],open));
//    	}
        // 震荡状态多空建仓逻辑
//    	cond1=HH[1]>(MLCD[1]+MHCD[1])*0.5 and H[1]==HH[1] and ZD[1] and H[1]<MHCD[1] and L<=L[1];
//    	cond2=LL[1]<(MLCD[1]+MHCD[1])*0.5 and L[1]==LL[1] and ZD[1] and L[1]>MLCD[1] and H>=H[1];
//    	if (cond1 and MarketPosition<>-1) {
//    			SellShort(Lots,Min(L[1],open));
//    			HighAfterEntry=High;
//    	}
//    	if (cond2 and MarketPosition<>1) {
//    			buy(Lots,Max(H[1],open));
//    			LowAfterEntry=Low;
//    	}
    	bool DD = H1>=MHCD && L1>=MLCD;
    	bool KK = L1<=MLCD && H1<=MHCD;
    	bool ZD = L1>=MLCD && H1<=MHCD;
    	// 马丁为主，套多了反向重仓追趋势，吊灯损
    	// 突破入场
//    	if (DD && high[i+1] >= ExtTopBuffer[i]) {
//            buy_sig[i] = 1;
//    	}
//    	if (KK && low[i+1] <= ExtBottomBuffer[i]) {
//            sell_sig[i] = 1;
//    	}

//    	if (high[i+1] >= ExtTopBuffer[i]) {
//            buy_sig[i] = 1;
//    	}
//    	if (low[i+1] <= ExtBottomBuffer[i]) {
//            sell_sig[i] = 1;
//    	}
        // 外汇一次一单太难，就马丁，若逆势加仓重了以后，反向顺势单加起来拿到吊灯为止
    	// 魔改回调入场
    	if (DD && high[i+1] >= ExtBottomBuffer[i]) {
            buy_sig[i] = 1;
    	}
    	if (KK && low[i+1] <= ExtTopBuffer[i]) {
            sell_sig[i] = 1;
    	}
//    	if (ZD) {
//    	    bool ZD_DD = high[i+1]>(MHCD+MLCD)*0.5 && high[i+1]>=ExtTopBuffer[i] && high[i+1]<MHCD && low[i]<=low[i+1];
//    	    bool ZD_KK = low[i+1]<(MHCD+MLCD)*0.5 && low[i+1]<=ExtBottomBuffer[i] && low[i+1]>MLCD && high[i]>=high[i+1];
//    	    if (ZD_DD) buy_sig[i] = 1;
//    	    if (ZD_KK) sell_sig[i] = 1;
//    	}
//        ExtTopBuffer[i] = L1;
//        ExtBottomBuffer[i] = MLCD;
    }
    for (i = limit - 1; i >= 0; i--) {
        if (buy_sig[i] == 1) {
            DrawArrowUp(time[i], close[i]);
            i -= 4;
        }
    }
    for (i = limit - 1; i >= 0; i--) {
        if (sell_sig[i] == 1) {
            DrawArrowDown(time[i], close[i]);
            i -= 4;
        }
    }
    // Returns value of prev_calculated for next call
    return(rates_total);
}

void DrawArrowUp(datetime time, double price) {
    string object_name="up_arr_"+string(time);

    //--- first find object by name
    if(ObjectFind(object_name)>=0) {
       ObjectDelete(object_name);
    }
    if(ObjectFind(object_name)<0) {
        if(ObjectCreate(object_name,OBJ_ARROW,0,time,price)) {
            ObjectSet(object_name,OBJPROP_ARROWCODE,SYMBOL_ARROWUP);
            ObjectSet(object_name,OBJPROP_COLOR,clrRed);
            ObjectSet(object_name,OBJPROP_PRICE1,price);
            ObjectSet(object_name,OBJPROP_TIME1,time);
        }
    }
}

void DrawArrowDown(datetime time, double price) {
    string object_name="down_arr_"+string(time);
    //--- first find object by name
    if(ObjectFind(object_name)>=0) {
       ObjectDelete(object_name);
    }
    if(ObjectFind(object_name)<0) {
        if(ObjectCreate(object_name,OBJ_ARROW,0,time,price)) {
            ObjectSet(object_name,OBJPROP_ARROWCODE,SYMBOL_ARROWDOWN);
            ObjectSet(object_name,OBJPROP_COLOR,clrBlue);
            ObjectSet(object_name,OBJPROP_PRICE1,price);
            ObjectSet(object_name,OBJPROP_TIME1,time);
        }
    }
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
