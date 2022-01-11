/*
   Generated by EX4-TO-MQ4 decompiler V4.0.224.1 []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/
#property copyright "Copyright ?2006, Eli hayun"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

extern int maPeriod = 50;
extern int maMethod = 1;
extern int maPrice = 0;
extern int rsiPeriod = 40;
extern int rsiLevel = 50;
double blue_ma_values[];
double red_ma_values[];

int init() {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, blue_ma_values);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, red_ma_values);
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   double ma_value;
   double rsi_value;
   int indicator_count = IndicatorCounted();
   if (indicator_count < 0) return (-1);
   if (indicator_count > 0) indicator_count--;
   int bars_calc = Bars - indicator_count;
   for (int i = 0; i < bars_calc; i++) {
      ma_value = iMA(NULL, 0, maPeriod, 0, maMethod, maPrice, i);
      rsi_value = iRSI(NULL, 0, rsiPeriod, maPrice, i);
      if (rsi_value >= rsiLevel) blue_ma_values[i] = ma_value;
      else red_ma_values[i] = ma_value;
   }
   return (0);
}