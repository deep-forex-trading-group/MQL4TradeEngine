#property copyright " 淘宝店：阿尔法量化交易研究室"
#property copyright " QQ：2352332611"
#property copyright " 手机：17620012282"
#property link      "https://alphago.taobao.com/?spm=2013.1.1000126.3.2c114bc81h30ji"
//----
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 DeepSkyBlue
#property indicator_color4 Tomato
#property indicator_color5 Orange
#property indicator_color6 DodgerBlue

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 0
#property indicator_width6 0

//---- input parameters
extern int       PerATR =40;
extern double    kATR   =2.0;

extern bool      Alert_Box =false;
extern bool      Send_Mail =false;

extern bool     useNewTrendSig   =true;
extern int      BuySellLevelDrawMode  =1;//0-none; 1-lines,2-arrows
extern int      FloorCeilLevelDrawMode=1;//0-none; 1-lines,2-arrows

extern int TimeFrame       = 0;
extern string  note_TimeFrames_        = "M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN|0-currentTF";
extern string  NRTRDrawLineMode        = "0-none; 1-lines,2-arrows";
string IndicatorFileName;
int y;

//---- buffers
double SellBuffer[];
double BuyBuffer[];
double Ceil[];
double Floor[];
double Trend[];
int sm_Bars;
double SellBufferSig[];
double BuyBufferSig[];
bool TrUpAlerted =false,TrDnAlerted =false;  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(7);
 

   if (BuySellLevelDrawMode==0)BuySellLevelDrawMode=DRAW_NONE;
   if (BuySellLevelDrawMode==1)BuySellLevelDrawMode=DRAW_LINE;   
   if (BuySellLevelDrawMode==2)BuySellLevelDrawMode=DRAW_ARROW;  
 
   if (FloorCeilLevelDrawMode==0)FloorCeilLevelDrawMode=DRAW_NONE;
   if (FloorCeilLevelDrawMode==1)FloorCeilLevelDrawMode=DRAW_LINE;   
   if (FloorCeilLevelDrawMode==2)FloorCeilLevelDrawMode=DRAW_ARROW;   

   SetIndexStyle(0,BuySellLevelDrawMode);
   SetIndexStyle(1,BuySellLevelDrawMode);

   SetIndexStyle(2,FloorCeilLevelDrawMode);
   SetIndexStyle(3,FloorCeilLevelDrawMode);
   
   
   
   SetIndexArrow(0,167);  //251
   SetIndexBuffer(0,SellBuffer);
   SetIndexEmptyValue(0,0.0);
   //
   SetIndexArrow(1,167);  //251
   SetIndexBuffer(1,BuyBuffer);
   SetIndexEmptyValue(1,0.0);
   
   
   
   SetIndexArrow(2,158);//159
   SetIndexBuffer(2,Ceil);
   SetIndexEmptyValue(2,0.0);
   //
   SetIndexArrow(3,158);//159
   SetIndexBuffer(3,Floor);
   SetIndexEmptyValue(3,0.0);




   if (useNewTrendSig)
      {
      SetIndexStyle(4,DRAW_ARROW);
      SetIndexStyle(5,DRAW_ARROW);
      }
      else
      {
      SetIndexStyle(4,DRAW_NONE);
      SetIndexStyle(5,DRAW_NONE);
      }



   SetIndexArrow(4,176);  // 250 177 251
   SetIndexBuffer(4,SellBufferSig);
   SetIndexEmptyValue(4,0.0);
 
   SetIndexArrow(5,176);  //250 177 251
   SetIndexBuffer(5,BuyBufferSig);
   SetIndexEmptyValue(5,0.0);


   //
   SetIndexBuffer(6,Trend);
   SetIndexEmptyValue(6,0);


           switch(TimeFrame)
   {
      case 1: string TimeFrameStr = "M1" ;  break;
      case 5     :   TimeFrameStr = "M5" ;  break;
      case 15    :   TimeFrameStr = "M15";  break;
      case 30    :   TimeFrameStr = "M30";  break;
      case 60    :   TimeFrameStr = "H1" ;  break;
      case 240   :   TimeFrameStr = "H4" ;  break;
      case 1440  :   TimeFrameStr = "D1" ;  break;
      case 10080 :   TimeFrameStr = "W1" ;  break;
      case 43200 :   TimeFrameStr = "MN1";  break;
      default :      TimeFrameStr = "TF0";
   }

   TimeFrame         = MathMax(TimeFrame,Period());
   IndicatorFileName = WindowExpertName();

   string short_name;
   short_name="NRTR_R("+PerATR+ ", "+DoubleToStr(kATR,2)+") "+TimeFrameStr ;
   IndicatorShortName(short_name);


   SetIndexLabel(0,"DnTrendRes "+short_name);
   SetIndexLabel(1,"UpTrendSup "+short_name);
   SetIndexLabel(2,"UpTrendCeil "+short_name);
   SetIndexLabel(3,"DnTrendFloor "+short_name);
   SetIndexLabel(4,"DnTrendSig "+short_name);
   SetIndexLabel(5,"UpTrendSig "+short_name);


//----
   return(0);
  }
//+------------------------------------------------------------------+
//| break  downtrend's   top                                         |
//+------------------------------------------------------------------+
bool BreakDown(int shift)
  {
   bool result=false;
   if (Close[shift]>SellBuffer[shift+1]) result=true;
   return(result);
  }
//+------------------------------------------------------------------+
//|  break  uptrend's   butt om                                      |
//+------------------------------------------------------------------+
bool BreakUp(int shift)
  {
   bool result=false;
   if (Close[shift]<BuyBuffer[shift+1]) result=true;
   return(result);
  }
//+------------------------------------------------------------------+
//| taking new min on downtrend                                      |
//+------------------------------------------------------------------+
bool BreakFloor(int shift)
  {
   bool result=false;
   if (High[shift]<Floor[shift+1]) result=true;
   return(result);
  }
//+------------------------------------------------------------------+
//| taking new max on uptrend                                        |
//+------------------------------------------------------------------+
bool BreakCeil(int shift)
  {
   bool result=false;
   if (Low[shift]>Ceil[shift+1]) result=true;
   return(result);
  }
//+------------------------------------------------------------------+
//| def prev trend                                                   |
//+------------------------------------------------------------------+
bool Uptrend(int shift)
  {
   //Print("Trend=",Trend[shift+1]);
   bool result=false;
   if (Trend[shift+1]==1) result=true;
   if (Trend[shift+1]==-1) result=false;
   if ((Trend[shift+1]!=1)&&(Trend[shift+1]!=-1)) Print("attension! trend is not defined, thats impossible. bar from the end",(Bars-shift));
   return(result);
  }
//+------------------------------------------------------------------+
//| volatility calc                                                  |
//+------------------------------------------------------------------+
double ATR(int iPer,int shift)
  {
   double result;
   //result=iMA(NULL,0,Per,0,MODE_SMA,PRICE_HIGH,shift+1)-iMA(NULL,0,Per,0,MODE_SMA,PRICE_LOW,shift+1);
   result=iATR(NULL,0,iPer,shift);
   //if (result>1.0) Alert("big atr=",result);
   //Print("ATR[",shift,"]=",result);
   return(result);
  }
//+------------------------------------------------------------------+
//| setting new ceil                                                 |
//+------------------------------------------------------------------+
void NewCeil(int shift)
  {
   Ceil[shift]=Close[shift];
   Floor[shift]=0.0;
  }
//+------------------------------------------------------------------+
//| new floor                                                         |
//+------------------------------------------------------------------+
void NewFloor(int shift)
  {
   Floor[shift]=Close[shift];
   Ceil[shift]=0.0;
  }
//+------------------------------------------------------------------+
//| set sup levl  uptrend                                            |
//+------------------------------------------------------------------+
void SetBuyBuffer(int shift)
  {
   BuyBuffer[shift]=Close[shift]-kATR*ATR(PerATR,shift);
   SellBuffer[shift]=0.0;
  }
//+------------------------------------------------------------------+
//| sup levl  downtrend                                              |
//+------------------------------------------------------------------+
void SetSellBuffer(int shift)
  {
   SellBuffer[shift]=Close[shift]+kATR*ATR(PerATR,shift);
   BuyBuffer[shift]=0.0;
  }
//+------------------------------------------------------------------+
//|trend reverce  and new levels set                                 |
//+------------------------------------------------------------------+
void NewTrend(int shift)
  {
   if (Trend[shift+1]==1)
     {
      Trend[shift]=-1;
      NewFloor(shift);
      SetSellBuffer(shift);
     }
   else    SellBufferSig[shift]=0.0;
   
   
   if (Trend[shift+1]==-1)

     {
      Trend[shift]=1;
      NewCeil(shift);
      SetBuyBuffer(shift); 
     }
  }
//+------------------------------------------------------------------+
//| trend continuation                                               |
//+------------------------------------------------------------------+
void CopyLastValues(int shift)
  {
   SellBuffer[shift]=SellBuffer[shift+1];
   BuyBuffer[shift]=BuyBuffer[shift+1];
   Ceil[shift]=Ceil[shift+1];
   Floor[shift]=Floor[shift+1];
   Trend[shift]=Trend[shift+1];
  }
//+------------------------------------------------------------------+
//| trend continuation                                               |
//+------------------------------------------------------------------+
void SendSMS(int shift)
  {
string Message;
string Signal;
Message ="NRTR Signal "+Symbol()+" TF"+TimeFrame+" on M" +Period()+"chart; Bid="+DoubleToStr(Bid,4);//+Bid;//NormalizeDouble(Bid,4);//+NormalizeDouble(Bid,Digits);//


  
   if (sm_Bars!=Bars)
       sm_Bars=Bars;
   if ((Trend[shift+1]*Trend[shift+2]==-1)&&(shift==0)&& Volume[0]>1) // trend changed
     {
      if (Trend[shift+1]==1)
       { 
      Signal = " NRTR turned UP";
       if (Send_Mail) SendMail (Message ,"" +Signal);
         if (Alert_Box &&!TrUpAlerted) Alert (Message+ Signal); 
         TrUpAlerted =true;TrDnAlerted =false;
         
        }
      else
        {
           Signal = " NRTR turned Down";

          if (Send_Mail) SendMail (Message ,"" +Signal);
     

 	     if (Alert_Box &&!TrDnAlerted) Alert (Message + Signal); 


   TrUpAlerted =false;TrDnAlerted =true;
        }
     }
   return;
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  
   int counted_bars=IndicatorCounted();
   int i,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=Bars-counted_bars;

   if (TimeFrame != Period())
   {
      datetime TimeArray[];
         limit = MathMax(limit,TimeFrame/Period());
         ArrayCopySeries(TimeArray ,MODE_TIME ,NULL,TimeFrame);


         for(i=0, y=0; i<limit; i++)
         {
            if(Time[i]<TimeArray[y]) y++;
           
            
   SellBuffer[i]= iCustom(NULL,TimeFrame,IndicatorFileName,PerATR,kATR,Alert_Box,
                  Send_Mail,useNewTrendSig,BuySellLevelDrawMode,FloorCeilLevelDrawMode,0,y);
   BuyBuffer[i] = iCustom(NULL,TimeFrame,IndicatorFileName,PerATR,kATR,Alert_Box,
                  Send_Mail,useNewTrendSig,BuySellLevelDrawMode,FloorCeilLevelDrawMode,1,y);

   Ceil[i]      = iCustom(NULL,TimeFrame,IndicatorFileName,PerATR,kATR,Alert_Box,
                  Send_Mail,useNewTrendSig,BuySellLevelDrawMode,FloorCeilLevelDrawMode,2,y);
   Floor[i]     = iCustom(NULL,TimeFrame,IndicatorFileName,PerATR,kATR,Alert_Box,
                  Send_Mail,useNewTrendSig,BuySellLevelDrawMode,FloorCeilLevelDrawMode,3,y);

   SellBufferSig[i]= iCustom(NULL,TimeFrame,IndicatorFileName,PerATR,kATR,Alert_Box,
                     Send_Mail,useNewTrendSig,BuySellLevelDrawMode,FloorCeilLevelDrawMode,4,y);
   BuyBufferSig[i] = iCustom(NULL,TimeFrame,IndicatorFileName,PerATR,kATR,Alert_Box,
                     Send_Mail,useNewTrendSig,BuySellLevelDrawMode,FloorCeilLevelDrawMode,5,y);
               
      }
   return(0);         
  }
   
  
   if (counted_bars>0) limit=Bars-counted_bars;
   if (counted_bars<0) return(0);
   if (counted_bars==0)
     {
      limit=Bars-PerATR-1;
      if (Close[limit+1]>Open[limit+1]) {Trend[limit+1]=1;Ceil[limit+1]=Close[limit+1];BuyBuffer[limit+1]=Close[limit+1]-kATR*ATR(PerATR,limit+1);}
      if (Close[limit+1]<Open[limit+1]) {Trend[limit+1]=-1;Floor[limit+1]=Close[limit+1];SellBuffer[limit+1]=Close[limit+1]+kATR*ATR(PerATR,limit+1);}
      if (Close[limit+1]==Open[limit+1]) {Trend[limit+1]=1;Ceil[limit+1]=Close[limit+1];BuyBuffer[limit+1]=Close[limit+1]-kATR*ATR(PerATR,limit+1);}
     }
//----
   for(int cnt=limit;cnt>=0;cnt--)
     {
            
      SendSMS(cnt);
      if (Uptrend(cnt))
        {
         //Print("UpTrend");
         if (BreakCeil(cnt))
           {
            NewCeil(cnt);
            SetBuyBuffer(cnt);
            Trend[cnt]=1;
            continue;
           }
         if (BreakUp(cnt))
           {
            NewTrend(cnt);

            continue;
           }
         CopyLastValues(cnt);
        }
      else
        {
         //Print("DownTrend");
         if (BreakFloor(cnt))
           {
            NewFloor(cnt);
            SetSellBuffer(cnt);
            Trend[cnt]=-1;

            continue;
           }
         if (BreakDown(cnt))
           {
            NewTrend(cnt);
     
            continue;
           }
         CopyLastValues(cnt);
        }
 
    }

// NewTrendSignal
     
   for( cnt=limit;cnt>=0;cnt--)
    {
         if(Trend[cnt+1]==-1 &&Trend[cnt]==1 )      
             { BuyBufferSig[cnt]=BuyBuffer[cnt];}
         else  BuyBufferSig[cnt]=0.0;
    }

   for( cnt=limit;cnt>=0;cnt--)
    {
         if(Trend[cnt+1]==1 && Trend[cnt]==-1 )
             { SellBufferSig[cnt]=SellBuffer[cnt];}
         else  SellBufferSig[cnt]=0.0;
    }
     
//----
   return(0);
  }
//+------------------------------------------------------------------+