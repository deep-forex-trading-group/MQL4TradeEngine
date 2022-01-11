//+------------------------------------------------------------------+
//|                                                         火星.mq4 |
//|                                                           王子敏 |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "王子敏"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 White
#property indicator_color2 LawnGreen
#property indicator_color3 Magenta
#property indicator_color4 Blue
#property indicator_color5 Yellow
//--- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,ExtMapBuffer5);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| zuigao                        |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
for ( int i=0;i<15000;i++)
{

   ExtMapBuffer1[i]=High[iHighest(NULL,0,MODE_HIGH,150,i)];
   ExtMapBuffer2[i]=(High[iHighest(NULL,0,MODE_HIGH,150,i)] - Low[iLowest(NULL,0,MODE_LOW,150,i)])*0.75+Low[iLowest(NULL,0,MODE_LOW,150,i)] ;
   ExtMapBuffer3[i]=High[iHighest(NULL,0,MODE_HIGH,150,i)]/2 + Low[iLowest(NULL,0,MODE_LOW,150,i)]/2;
   ExtMapBuffer4[i]=(High[iHighest(NULL,0,MODE_HIGH,150,i)] - Low[iLowest(NULL,0,MODE_LOW,150,i)])*0.25+Low[iLowest(NULL,0,MODE_LOW,150,i)] ;
   ExtMapBuffer5[i]=Low[iLowest(NULL,0,MODE_LOW,150,i)];
   
}
   
 
   return(0);
  }
//+------------------------------------------------------------------+

