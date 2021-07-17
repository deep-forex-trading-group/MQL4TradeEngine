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
double g_ibuf_96[];
double g_ibuf_100[];

int init() {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, g_ibuf_96);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, g_ibuf_100);
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   double l_ima_12;
   double l_irsi_20;
   int li_4 = IndicatorCounted();
   if (li_4 < 0) return (-1);
   if (li_4 > 0) li_4--;
   int li_0 = Bars - li_4;
   for (int li_8 = 0; li_8 < li_0; li_8++) {
      l_ima_12 = iMA(NULL, 0, maPeriod, 0, maMethod, maPrice, li_8);
      l_irsi_20 = iRSI(NULL, 0, rsiPeriod, maPrice, li_8);
      if (l_irsi_20 >= rsiLevel) g_ibuf_96[li_8] = l_ima_12;
      else g_ibuf_100[li_8] = l_ima_12;
   }
   return (0);
}
