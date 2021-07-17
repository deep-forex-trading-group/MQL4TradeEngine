//+------------------------------------------------------------------+
//|                        Guppy Mulitple Moving Average.mq4 |
//|                                  Code written by - Matt Trigwell |
//|                                                                  |
//+------------------------------------------------------------------+

// ***** For information on how to use this fantastic indicator *****
// http://www.369fx.com/
// http://www.market-analyst.com/kb/article.php/Guppy_Multiple_Moving_Average
// http://tradermike.net/2004/05/another_look_at_multiple_moving_averages

// ***** INSTRUCTIONS *****
// Add the indicator to your charts.
// This is the indicator


#property copyright "Code written by - Matt Trigwell"


#property indicator_chart_window
//#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Magenta
#property indicator_color2 Gold

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,EMPTY,1,indicator_color1);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE,EMPTY,1,indicator_color2);
   SetIndexBuffer(1,ExtMapBuffer2);
//----
   return(0);
  }

int deinit()
  {
   return(0);
  }

int start()
  {
   int i,j,limit,counted_bars=IndicatorCounted();
   
   
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   
   for(i=0; i<limit; i++){
      ExtMapBuffer1[i]=iMA(NULL,0,10,0,MODE_EMA,PRICE_OPEN,i);
      ExtMapBuffer2[i]=iMA(NULL,0,5,0,MODE_EMA,PRICE_CLOSE,i);
   }
   

   return(0);
  }
//+------------------------------------------------------------------+