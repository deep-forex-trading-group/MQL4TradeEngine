//+------------------------------------------------------------------+
//|                                                       Thirds.mq4 |
//|                                                      Magnumfreak |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "微信：wh14980272"
#property link      "智善金融"

#property indicator_chart_window
int count =1;

input int BarCount = 200;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      ObjectCreate("topline",1,0,TimeCurrent(),High[120]);
      ObjectSet("topline",OBJPROP_COLOR,Magenta);
      ObjectSet("topline",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("topline",OBJPROP_WIDTH,2);     
  
      ObjectCreate("halfbottomline",1,0,TimeCurrent(),Low[120]);
      ObjectSet("halfbottomline",OBJPROP_COLOR,Magenta);
      ObjectSet("halfbottomline",OBJPROP_STYLE,STYLE_DASH);
      ObjectSet("halfbottomline",OBJPROP_WIDTH,1);     
  
      ObjectCreate("halftopline",1,0,TimeCurrent(),High[120]);
      ObjectSet("halftopline",OBJPROP_COLOR,Magenta);
      ObjectSet("halftopline",OBJPROP_STYLE,STYLE_DASH);
      ObjectSet("halftopline",OBJPROP_WIDTH,1);     
  
      ObjectCreate("bottomline",1,0,TimeCurrent(),Low[120]);
      ObjectSet("bottomline",OBJPROP_COLOR,Magenta);
      ObjectSet("bottomline",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("bottomline",OBJPROP_WIDTH,2);     
  
      ObjectCreate("onesixth",1,0,TimeCurrent(),High[120]);
      ObjectSet("onesixth",OBJPROP_COLOR,Gold);
      ObjectSet("onesixth",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("onesixth",OBJPROP_WIDTH,2);     
  
      ObjectCreate("twosixth",1,0,TimeCurrent(),High[120]);
      ObjectSet("twosixth",OBJPROP_COLOR,Green);
      ObjectSet("twosixth",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("twosixth",OBJPROP_WIDTH,2);    

      ObjectCreate("threesixth",1,0,TimeCurrent(),High[120]);
      ObjectSet("threesixth",OBJPROP_COLOR,White);
      ObjectSet("threesixth",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("threesixth",OBJPROP_WIDTH,2);
      
      ObjectCreate("foursixth",1,0,TimeCurrent(),Low[120]);
      ObjectSet("foursixth",OBJPROP_COLOR,Green);
      ObjectSet("foursixth",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("foursixth",OBJPROP_WIDTH,2);
      
      ObjectCreate("fivesixth",1,0,TimeCurrent(),Low[120]);
      ObjectSet("fivesixth",OBJPROP_COLOR,Gold);
      ObjectSet("fivesixth",OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet("fivesixth",OBJPROP_WIDTH,2);
      
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
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  
   
//----
//----
   // double value = WindowPriceMax(0)-WindowPriceMin(0);      //value top of the chart - value buttem
   double value = High[iHighest(NULL,0,MODE_HIGH,BarCount,1)] - Low[iLowest(NULL,0,MODE_LOW,BarCount,1)];      //value top of the chart - value bottom
   double sixth = value/6;
   double valueS = (value*(MathPow(10,Digits)));
   double sixthS = (sixth*(MathPow(10,Digits)));
   
   double seventh = value/7;
   //double valueS = (value*(MathPow(10,Digits)));
   double seventhS = (seventh*(MathPow(10,Digits)));
   
   if(ObjectFind("fivesixth")==-1)init();
   //Comment(ObjectFind("sixth"));
   ObjectMove("topline",0,TimeCurrent(),High[iHighest(NULL,0,MODE_HIGH,BarCount,1)]);
   ObjectMove("halftopline",0,TimeCurrent(),Low[iLowest(NULL,0,MODE_LOW,BarCount,1)]+sixth+sixth+sixth+sixth+sixth+(sixth/2));
   ObjectMove("halfbottomline",0,TimeCurrent(),Low[iLowest(NULL,0,MODE_LOW,BarCount,1)]+(sixth/2));
   ObjectMove("bottomline",0,TimeCurrent(),Low[iLowest(NULL,0,MODE_LOW,BarCount,1)]);
   ObjectMove("onesixth",0,TimeCurrent(),Low[iLowest(NULL,0,MODE_LOW,BarCount,1)]+sixth);
   ObjectMove("twosixth",0,TimeCurrent(),Low[iLowest(NULL,0,MODE_LOW,BarCount,1)]+sixth+sixth);
   ObjectMove("threesixth",0,TimeCurrent(),Low[iLowest(NULL,0,MODE_LOW,BarCount,1)]+sixth+sixth+sixth);
   ObjectMove("foursixth",0,TimeCurrent(),Low[iLowest(NULL,0,MODE_LOW,BarCount,1)]+sixth+sixth+sixth+sixth);
   ObjectMove("fivesixth",0,TimeCurrent(),Low[iLowest(NULL,0,MODE_LOW,BarCount,1)]+sixth+sixth+sixth+sixth+sixth);
   
   //Comment("Top to bottem = ", (valueS), " pips", "\n" ,"Distance between lines = ", (sixthS), " pips" , 
   //        "\n" ,"TAKE PROFIT DISTANCE = ", (seventhS), " pips");
      
//----
   return(0);
  }
//+------------------------------------------------------------------+