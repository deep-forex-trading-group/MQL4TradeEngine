#property  copyright "RoboFibo v.7"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "来EAHub下载更多EA。"
  enum ENUM_Trading_Mode      {PendingLimitOrderFollowTrend = 0,PendingLimitOrderReversalTrend = 1,PendingStopOrderFollowTrend = 2,PendingStopOrderReversalTrend = 3  };
  enum ENUM_Candlestick_Mode      {ToAvoidNews = 0,ToTriggerOrder = 1  };


//------------------
extern bool ShowComment=true;
extern  ENUM_Trading_Mode  TradingMode=3  ;   
extern bool UseMM=false ;   
extern double Risk=0.1  ;   
extern double FixedLots=0.01  ;   
extern double LotsExponent=1.1  ;   
extern bool UseTakeProfit=false ;   
extern int   TakeProfit=200  ;   
extern bool UseStopLoss=false ;   
extern int   StopLoss=200  ;   
extern bool AutoTargetMoney=true  ;   
extern double TargetMoneyFactor=20  ;   
extern double TargetMoney=0  ;   
extern bool AutoStopLossMoney=false ;   
extern double StoplossFactor=0  ;   
extern double StoplossMoney=0  ;   
extern bool UseTrailing=false ;   
extern int   TrailingStop=20  ;   
extern int   TrailingStart=0  ;   
extern  ENUM_Candlestick_Mode  CandlestickMode=0  ;   
extern int   CandlestickHighLow=500  ;   
extern int   MaxOrderBuy=50  ;   
extern int   MaxOrderSell=50  ;   
extern int   PendingDistance=20  ;   
extern int   Pipstep=10  ;   
extern double PipstepExponent=1  ;   
extern double MaxSpreadPlusCommission=50  ;   
extern bool HighToLow=true  ;   
extern double HighFibo=76.4  ;   
extern double LowFibo=23.6  ;   
extern int   StartBar=1  ;   
extern int   BarsBack=20  ;   
extern bool ShowFibo=true  ;   
extern int   Slippage=3  ;   
extern int   MagicNumber=1  ;   
extern string TradeComment="[EAHub]RoboFibo v.7"  ;  
extern bool TradeMonday=true  ;   
extern bool TradeTuesday=true  ;   
extern bool TradeWednesday=true  ;   
extern bool TradeThursday=true  ;   
extern bool TradeFriday=true  ;   
extern int   StartHour=0  ;   
extern int   StartMinute=0  ;   
extern int   EndHour=23  ;   
extern int   EndMinute=59  ;   
  double    总_do_1 = 10000.0;
  double    总_do_2 = 0.236;
  double    总_do_3 = 0.382;
  double    总_do_4 = 0.5;
  double    总_do_5 = 0.618;
  double    总_do_6 = 0.764;
  double    总_do_7 = 0.0;
  double    总_do_8 = 1.0;
  uint      总_ui_9 = Blue;
  uint      总_ui_10 = DarkGray;
  double    总_do11ko[];
  double    总_do12ko[];
  double    总_do13ko[];
  double    总_do14ko[];
  double    总_do15ko[];
  double    总_do16ko[];
  double    总_do17ko[];
  double    总_do18ko[];
  double    总_do_19 = 0.0;
  double    总_do_20 = 0.0;
  bool      总_bo_21 = false;
  bool      总_bo_22 = false;
  int       总_in_23 = 0;
  int       总_in_24 = 0;
  int       总_in_25 = 0;
  int       总_in_26 = 0;
  int       总_in_27 = 0;
  int       总_in_28 = 0;
  double    总_do29si30[30];
  int       总_in_30 = 0;
  double    总_do_31 = 0.0;
  int       总_in_32 = 0;
  double    总_do_33 = 0.0;
  double    总_do_34 = 0.0;
  double    总_do_35 = 0.0;
  double    总_do_36 = 0.0;
  double    总_do_37 = 0.0;
  double    总_do_38 = 0.0;
  double    总_do_39 = 0.0;
  double    总_do_40 = 0.0;
  double    总_do_41 = 0.0;
  double    总_do_42 = 0.0;
  double    总_do_43 = 0.0;
  bool      总_bo_44 = false;
  double    总_do_45 = 0.0;
  int       总_in_46 = 0;
  double    总_do_47 = 0.0;
  bool      总_bo_48 = true;
  double    总_do_49 = 240.0;
  double    总_do_50 = 0.0;
  int       总_in_51 = 0;
  double    总_do_52 = 0.0;
  double    总_do_53 = 0.0;
  double    总_do_54 = 0.0;
  double    总_do_55 = 0.0;
  double    总_do_56 = 0.0;
  double    总_do_57 = 0.0;
  double    总_do_58 = 0.0;
  double    总_do_59 = 0.0;

#import   "stdlib.ex4"
string ErrorDescription( int 木_0);
#import     

 int init()
 {
  int       子_in_1;
  double    子_do_2;
//----- -----

 ArrayInitialize(总_do29si30,0.0); 
 总_in_30 = MarketInfo(NULL,12) ;
 总_do_31 = MarketInfo(NULL,11) ;
 Print("Digits: " + string(总_in_30) + " Point: " + DoubleToString(MarketInfo(NULL,11),总_in_30)); 
 子_do_2 = MarketInfo(Symbol(),24) ;
 总_in_32 = MathLog(子_do_2) / (-2.302585092994) ;
 总_do_33 = MathMax(FixedLots,MarketInfo(Symbol(),23)) ;
 总_do_34 = MathMin(总_do_1,MarketInfo(Symbol(),25)) ;
 总_do_35 = Risk / 100.0 ;
 总_do_36 = NormalizeDouble(MaxSpreadPlusCommission * 总_do_31,总_in_30 + 1) ;
 总_do_37 = NormalizeDouble(PendingDistance * 总_do_31,总_in_30) ;
 总_do_43 = NormalizeDouble(总_do_31 * CandlestickHighLow,总_in_30) ;
 总_bo_44 = false ;
 总_do_45 = NormalizeDouble(总_do_47 * 总_do_31,总_in_30 + 1) ;
 if ( !(IsTesting()) )
  {
  if ( 总_bo_48 )
   {
   子_in_1 = Period() ;
   switch(Period())
    {
    case 1 :
     总_do_49 = 5.0 ;
        break;
    case 5 :
     总_do_49 = 15.0 ;
        break;
    case 15 :
     总_do_49 = 30.0 ;
        break;
    case 30 :
     总_do_49 = 60.0 ;
        break;
    case 60 :
     总_do_49 = 240.0 ;
        break;
    case 240 :
     总_do_49 = 1440.0 ;
        break;
    case 1440 :
     总_do_49 = 10080.0 ;
        break;
    case 10080 :
     总_do_49 = 43200.0 ;
        break;
    case 43200 :
     总_do_49 = 43200.0 ;
   }}
  总_do_50 = 0.0001 ;
  }
 DeleteAllObjects ( ); 
 SetIndexBuffer(0,总_do11ko); 
 SetIndexBuffer(1,总_do12ko); 
 SetIndexBuffer(2,总_do13ko); 
 SetIndexBuffer(3,总_do14ko); 
 SetIndexBuffer(4,总_do15ko); 
 SetIndexBuffer(5,总_do16ko); 
 SetIndexBuffer(6,总_do17ko); 
 SetIndexBuffer(7,总_do18ko); 
 SetIndexLabel(0,"Fibo_" + DoubleToString(总_do_7,4)); 
 SetIndexLabel(1,"Fibo_" + DoubleToString(总_do_2,4)); 
 SetIndexLabel(2,"Fibo_" + DoubleToString(总_do_3,4)); 
 SetIndexLabel(3,"Fibo_" + DoubleToString(总_do_4,4)); 
 SetIndexLabel(4,"Fibo_" + DoubleToString(总_do_5,4)); 
 SetIndexLabel(5,"Fibo_" + DoubleToString(总_do_6,4)); 
 SetIndexLabel(7,"Fibo_" + DoubleToString(总_do_8,4)); 
 return(0); 
 }
//init <<==
//---------- ----------  ---------- ----------
 int start()
 {
  bool      子_bo_1;
  string    子_st_2;
  datetime  子_da_3;
  double    子_do_4;
  double    子_do_5;
  double    子_do_6;
  double    子_do_7;
  int       子_in_8;
  string    子_st_9;
  int       子_in_10;
  double    子_do_11;
  double    子_do_12;
  int       子_in_13;
  int       子_in_14;
  bool      子_bo_15;
  double    子_do_16;
  double    子_do_17;
  double    子_do_18;
  double    子_do_19;
  double    子_do_20;
  double    子_do_21;
  double    子_do_22;
  double    子_do_23;
  double    子_do_24;
  double    子_do_25;
  double    子_do_26;
  double    子_do_27;
  int       子_in_28;
  int       子_in_29;
  double    子_do_30;
  double    子_do_31;
  int       子_in_32;
  int       子_in_33;
  double    子_do_34;
  double    子_do_35;
  double    子_do_36;
  double    子_do_37;
  double    子_do_38;
  double    子_do_39;
  double    子_do_40;
  double    子_do_41;
  double    子_do_42;
  int       子_in_43;
  double    子_do_44;
  double    子_do_45;
  int       子_in_46;
  double    子_do_47;
  double    子_do_48;
  double    子_do_49;
  double    子_do_50;
  double    子_do_51;
  double    子_do_52;
  int       子_in_53;
  string    子_st_54;
//----- -----




 子_bo_1 = IsDemo() ;
 if ( !(子_bo_1) )
  {
  //Alert("You can not use the program with a real account!"); 
  //return(0); 
  }
 子_st_2 = "2016.8.25" ;
 子_da_3 = StringToTime(子_st_2) ;
 if ( TimeCurrent() >= 子_da_3 )
  {
  //Alert("The trial version has been expired!"); 
 //return(0); 
  }
 if ( ShowFibo == 1 )
  {
  CalcFibo(); 
  }
 子_do_4 = NormalizeDouble(Pipstep * MathPow(PipstepExponent,CountTradesSell ( )),0) ;
 子_do_5 = NormalizeDouble(Pipstep * MathPow(PipstepExponent,CountTradesBuy ( )),0) ;
 子_do_6 = FindLastSellPrice_Hilo ( ) ;
 子_do_7 = FindLastBuyPrice_Hilo ( ) ;
 子_in_8 = 0 ;
 子_in_10 = 0 ;
 子_do_11 = 0.0 ;
 子_do_12 = 0.0 ;
 子_in_13 = 0 ;
 子_in_14 = 0 ;
 子_bo_15 = false ;
 子_do_16 = 0.0 ;
 子_do_17 = 0.0 ;
 子_do_18 = 0.0 ;
 子_do_19 = 0.0 ;
 子_do_20 = 0.0 ;
 子_do_21 = 0.0 ;
 子_do_22 = 0.0 ;
 子_do_23 = 0.0 ;
 子_do_24 = iHigh(NULL,0,0) ;
 子_do_25 = iLow(NULL,0,0) ;
 子_do_26 = iHigh(NULL,0,1) ;
 子_do_27 = iLow(NULL,0,1) ;
 子_in_28 = 0 ;
 子_in_29 = 0 ;
 子_do_30 = 0.0 ;
 子_do_31 = 0.0 ;
 子_in_32 = iLowest(NULL,0,MODE_LOW,BarsBack,StartBar) ;
 子_in_33 = iHighest(NULL,0,MODE_HIGH,BarsBack,StartBar) ;
 子_do_34 = 0.0 ;
 子_do_35 = 0.0 ;
 子_do_31 = High[子_in_33] ;
 子_do_30 = Low[子_in_32] ;
 总_do_52 = 子_do_31 - 子_do_30 ;
 子_do_36 = LowFibo / 100.0 * 总_do_52 + 子_do_30 ;
 子_do_37 = 总_do_52 * 0.236 + 子_do_30 ;
 子_do_38 = 总_do_52 * 0.382 + 子_do_30 ;
 子_do_39 = 总_do_52 * 0.5 + 子_do_30 ;
 子_do_40 = 总_do_52 * 0.618 + 子_do_30 ;
 子_do_41 = 总_do_52 * 0.764 + 子_do_30 ;
 子_do_42 = HighFibo / 100.0 * 总_do_52 + 子_do_30 ;
 if ( !(总_bo_44) )
  {
  for (子_in_43 = OrdersHistoryTotal() - 1 ; 子_in_43 >= 0 ; 子_in_43 = 子_in_43 - 1)
   {
   if ( !(OrderSelect(子_in_43,SELECT_BY_POS,MODE_HISTORY)) || !(OrderProfit()!=0.0) || !(OrderClosePrice()!=OrderOpenPrice()) || OrderSymbol() != Symbol() )   continue;
   总_bo_44 = true ;
   子_do_12=MathAbs(OrderProfit() / (OrderClosePrice() - OrderOpenPrice()));
   总_do_45 = ( -(OrderCommission())) / 子_do_12 ;
   break;
   
   }
   }
 子_do_17 = NormalizeDouble(AccountBalance() * AccountLeverage() * 总_do_35 / MarketInfo(Symbol(),15),总_in_32) ;
 if ( !(UseMM) )
  {
  子_do_17 = FixedLots ;
  }
 总_do_57 = 子_do_17 * TargetMoneyFactor * CountTradesSell ( ) * LotsExponent ;
 if ( !(AutoTargetMoney) )
  {
  总_do_57 = TargetMoney ;
  }
 总_do_56 = 子_do_17 * TargetMoneyFactor * CountTradesBuy ( ) * LotsExponent ;
 if ( !(AutoTargetMoney) )
  {
  总_do_56 = TargetMoney ;
  }
 总_do_59 = 子_do_17 * StoplossFactor * CountTradesSell ( ) * LotsExponent ;
 if ( !(AutoStopLossMoney) )
  {
  总_do_59 = StoplossMoney ;
  }
 总_do_58 = 子_do_17 * StoplossFactor * CountTradesBuy ( ) * LotsExponent ;
 if ( !(AutoStopLossMoney) )
  {
  总_do_58 = StoplossMoney ;
  }
 子_do_44 = Ask - Bid ;
 ArrayCopy(总_do29si30,总_do29si30,0,1,29); 
 总_do29si30[29] = 子_do_44;
 if ( 总_in_46 <  30 )
  {
  总_in_46=总_in_46 + 1;
  }
 子_do_45 = 0.0 ;
 子_in_43 = 29 ;
 for (子_in_46 = 0 ; 子_in_46 < 总_in_46 ; 子_in_46 = 子_in_46 + 1)
  {
  子_do_45 = 子_do_45 + 总_do29si30[子_in_43] ;
  子_in_43 = 子_in_43 - 1;
  }
 子_do_47 = 子_do_45 / 总_in_46 ;
 子_do_48 = NormalizeDouble(Ask + 总_do_45,总_in_30) ;
 子_do_49 = NormalizeDouble(Bid - 总_do_45,总_in_30) ;
 子_do_50 = NormalizeDouble(子_do_47 + 总_do_45,总_in_30 + 1) ;
 子_do_51 = 子_do_24 - 子_do_25 ;
 子_do_52 = 子_do_26 - 子_do_27 ;
 if ( Bid - 子_do_6>=子_do_4 * Point() )
  {
  总_in_25 = MaxOrderSell ;
  }
 else
  {
  总_in_25 = 1 ;
  }
 if ( 子_do_7 - Ask>=子_do_5 * Point() )
  {
  总_in_26 = MaxOrderBuy ;
  }
 else
  {
  总_in_26 = 1 ;
  }
 if ( CandlestickMode != 0 )
  {
  if ( CandlestickMode == 1 && 子_do_51>总_do_43 )
   {
   if ( Bid>子_do_42 )
    {
    子_in_13 = -1 ;
    }
   else
    {
    if ( Bid<子_do_36 )
     {
     子_in_13 = 1 ;
  }}}}
 else
  {
  if ( 子_do_51<=总_do_43 && 子_do_52<=总_do_43 )
   {
   if ( Bid>子_do_42 )
    {
    子_in_13 = -1 ;
    }
   else
    {
    if ( Bid<子_do_36 )
     {
     子_in_13 = 1 ;
  }}}}
 子_in_53 = 0 ;
 for (子_in_43 = 0 ; 子_in_43 < OrdersTotal() ; 子_in_43 = 子_in_43 + 1)
  {
  if ( !(OrderSelect(子_in_43,SELECT_BY_POS,MODE_TRADES)) || OrderMagicNumber() != MagicNumber )   continue;
  子_in_14 = OrderType() ;
  if ( 子_in_14 == 0 || 子_in_14 == 1 || OrderSymbol() != Symbol() )   continue;
  子_in_53 = 子_in_53 + 1;
  switch(子_in_14)
   {
   case 4 :
    子_do_16 = NormalizeDouble(OrderOpenPrice(),总_in_30) ;
    子_do_11 = NormalizeDouble(Ask + 总_do_37,总_in_30) ;
    if ( !(子_do_11<子_do_16) )   break;
    子_do_20 = NormalizeDouble(子_do_11 - StopLoss * Point(),总_in_30) ;
    子_do_21 = NormalizeDouble(TakeProfit * Point() + 子_do_11,总_in_30) ;
    子_do_23 = 子_do_20 ;
    if ( !(UseStopLoss) )
     {
     子_do_23 = 0.0 ;
     }
    子_do_22 = 子_do_21 ;
    if ( !(UseTakeProfit) )
     {
     子_do_22 = 0.0 ;
     }
    if ( OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() )
     {
     子_bo_15 = OrderModify(OrderTicket(),子_do_11,子_do_23,子_do_22,0,Blue) ;
     }
    if ( 子_bo_15 )   break;
    子_in_8 = GetLastError() ;
    子_st_9 = ErrorDescription(子_in_8) ;
    Print("BUYSTOP Modify Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
       break;
   case 5 :
    子_do_16 = NormalizeDouble(OrderOpenPrice(),总_in_30) ;
    子_do_11 = NormalizeDouble(Bid - 总_do_37,总_in_30) ;
    if ( !(子_do_11>子_do_16) )   break;
    子_do_20 = NormalizeDouble(StopLoss * Point() + 子_do_11,总_in_30) ;
    子_do_21 = NormalizeDouble(子_do_11 - TakeProfit * Point(),总_in_30) ;
    子_do_23 = 子_do_20 ;
    if ( !(UseStopLoss) )
     {
     子_do_23 = 0.0 ;
     }
    子_do_22 = 子_do_21 ;
    if ( !(UseTakeProfit) )
     {
     子_do_22 = 0.0 ;
     }
    if ( OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() )
     {
     子_bo_15 = OrderModify(OrderTicket(),子_do_11,子_do_23,子_do_22,0,Red) ;
     }
    if ( 子_bo_15 )   break;
    子_in_8 = GetLastError() ;
    子_st_9 = ErrorDescription(子_in_8) ;
    Print("SELLSTOP Modify Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
       break;
   case 3 :
    子_do_16 = NormalizeDouble(OrderOpenPrice(),总_in_30) ;
    子_do_11 = NormalizeDouble(Bid + 总_do_37,总_in_30) ;
    if ( !(子_do_11<子_do_16) )   break;
    子_do_20 = NormalizeDouble(StopLoss * Point() + 子_do_11,总_in_30) ;
    子_do_21 = NormalizeDouble(子_do_11 - TakeProfit * Point(),总_in_30) ;
    子_do_23 = 子_do_20 ;
    if ( !(UseStopLoss) )
     {
     子_do_23 = 0.0 ;
     }
    子_do_22 = 子_do_21 ;
    if ( !(UseTakeProfit) )
     {
     子_do_22 = 0.0 ;
     }
    if ( OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() )
     {
     子_bo_15 = OrderModify(OrderTicket(),子_do_11,子_do_23,子_do_22,0,Red) ;
     }
    if ( 子_bo_15 )   break;
    子_in_8 = GetLastError() ;
    子_st_9 = ErrorDescription(子_in_8) ;
    Print("BUYLIMIT Modify Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
       break;
   case 2 :
    子_do_16 = NormalizeDouble(OrderOpenPrice(),总_in_30) ;
    子_do_11 = NormalizeDouble(Ask - 总_do_37,总_in_30) ;
    if ( !(子_do_11>子_do_16) )   break;
    子_do_20 = NormalizeDouble(子_do_11 - StopLoss * Point(),总_in_30) ;
    子_do_21 = NormalizeDouble(TakeProfit * Point() + 子_do_11,总_in_30) ;
    子_do_23 = 子_do_20 ;
    if ( !(UseStopLoss) )
     {
     子_do_23 = 0.0 ;
     }
    子_do_22 = 子_do_21 ;
    if ( !(UseTakeProfit) )
     {
     子_do_22 = 0.0 ;
     }
    if ( OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() )
     {
     子_bo_15 = OrderModify(OrderTicket(),子_do_11,子_do_23,子_do_22,0,Blue) ;
     }
    if ( 子_bo_15 )   break;
    子_in_8 = GetLastError() ;
    子_st_9 = ErrorDescription(子_in_8) ;
    Print("SELLLIMIT Modify Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
   }
  }
 if ( CountTradesBuy ( ) == 0 )
  {
  总_bo_21 = false ;
  }
 if ( CountTradesSell ( ) == 0 )
  {
  总_bo_22 = false ;
  }
 TotalProfitbuy ( ); 
 TotalProfitsell ( ); 
 if(ShowComment)
 ChartComment(); 
 if ( ( ( 总_do_56>0.0 && 总_do_19>=总_do_56 ) || ( -(总_do_58)<0.0 && 总_do_19<= -(总_do_58)) ) )
  {
  总_bo_21 = true ;
  }
 if ( 总_bo_21 )
  {
  OpenOrdClose ( ); 
  }
 if ( ( ( 总_do_57>0.0 && 总_do_20>=总_do_57 ) || ( -(总_do_59)<0.0 && 总_do_20<= -(总_do_59)) ) )
  {
  总_bo_22 = true ;
  }
 if ( 总_bo_22 )
  {
  OpenOrdClose2 ( ); 
  }
 if ( UseTrailing )
  {
  MoveTrailingStop(); 
  }
 if ( !(TradeMonday) && DayOfWeek() == 1 )
  {
  return(0); 
  }
 if ( !(TradeTuesday) && DayOfWeek() == 2 )
  {
  return(0); 
  }
 if ( !(TradeWednesday) && DayOfWeek() == 3 )
  {
  return(0); 
  }
 if ( !(TradeThursday) && DayOfWeek() == 4 )
  {
  return(0); 
  }
 if ( !(TradeFriday) && DayOfWeek() == 5 )
  {
  return(0); 
  }
 switch(TradingMode)
  {
  case 0 :
   if ( Bid<子_do_36 && CountTradesSell ( ) >= 总_in_25 )
    {
    return(0); 
    }
   if ( !(Bid>子_do_42) || CountTradesBuy ( ) < 总_in_26 )   break;
   return(0); 
  case 2 :
   if ( Bid<子_do_36 && CountTradesSell ( ) >= 总_in_25 )
    {
    return(0); 
    }
   if ( !(Bid>子_do_42) || CountTradesBuy ( ) < 总_in_26 )   break;
   return(0); 
  case 1 :
   if ( Bid>子_do_42 && CountTradesSell ( ) >= 总_in_25 )
    {
    return(0); 
    }
   if ( !(Bid<子_do_36) || CountTradesBuy ( ) < 总_in_26 )   break;
   return(0); 
  case 3 :
   if ( Bid>子_do_42 && CountTradesSell ( ) >= 总_in_25 )
    {
    return(0); 
    }
   if ( !(Bid<子_do_36) || CountTradesBuy ( ) < 总_in_26 )   break;
   return(0); 
  }
 switch(TradingMode)
  {
  case 0 :
   if ( 子_in_53 != 0 || 子_in_13 == 0 || !(子_do_50<=总_do_36) || !(f0_4 ( )) )   break;
   子_do_17 = AccountBalance() * AccountLeverage() * 总_do_35 / MarketInfo(Symbol(),15) ;
   if ( !(UseMM) )
    {
    子_do_17 = FixedLots ;
    }
   子_do_18 = NormalizeDouble(子_do_17 * MathPow(LotsExponent,CountTradesBuy ( )),总_in_30) ;
   子_do_18 = MathMax(总_do_33,子_do_18) ;
   子_do_18 = MathMin(总_do_34,子_do_18) ;
   子_do_19 = NormalizeDouble(子_do_17 * MathPow(LotsExponent,CountTradesSell ( )),总_in_30) ;
   子_do_19 = MathMax(总_do_33,子_do_19) ;
   子_do_19 = MathMin(总_do_34,子_do_19) ;
   if ( 子_in_13 <  0 )
    {
    子_do_11 = NormalizeDouble(Ask - 总_do_37,总_in_30) ;
    子_do_20 = NormalizeDouble(子_do_11 - StopLoss * Point(),总_in_30) ;
    子_do_21 = NormalizeDouble(TakeProfit * Point() + 子_do_11,总_in_30) ;
    子_do_23 = 子_do_20 ;
    if ( !(UseStopLoss) )
     {
     子_do_23 = 0.0 ;
     }
    子_do_22 = 子_do_21 ;
    if ( !(UseTakeProfit) )
     {
     子_do_22 = 0.0 ;
     }
    子_in_10 = OrderSend(Symbol(),OP_BUYLIMIT,子_do_18,子_do_11,Slippage,子_do_23,子_do_22,TradeComment,MagicNumber,0,Blue) ;
    if ( 子_in_10 > 0 )   break;
    子_in_8 = GetLastError() ;
    子_st_9 = ErrorDescription(子_in_8) ;
    Print("BUYLIMIT Send Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " LT: " + DoubleToString(子_do_18,总_in_30) + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
       break;
   }
  子_do_11 = NormalizeDouble(Bid + 总_do_37,总_in_30) ;
  子_do_20 = NormalizeDouble(StopLoss * Point() + 子_do_11,总_in_30) ;
  子_do_21 = NormalizeDouble(子_do_11 - TakeProfit * Point(),总_in_30) ;
  子_do_23 = 子_do_20 ;
  if ( !(UseStopLoss) )
   {
   子_do_23 = 0.0 ;
   }
  子_do_22 = 子_do_21 ;
  if ( !(UseTakeProfit) )
   {
   子_do_22 = 0.0 ;
   }
  子_in_10 = OrderSend(Symbol(),OP_SELLLIMIT,子_do_19,子_do_11,Slippage,子_do_23,子_do_22,TradeComment,MagicNumber,0,Red) ;
  if ( 子_in_10 > 0 )   break;
  子_in_8 = GetLastError() ;
  子_st_9 = ErrorDescription(子_in_8) ;
  Print("SELLLIMIT Send Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " LT: " + DoubleToString(子_do_19,总_in_30) + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
     break;
  case 1 :
   if ( 子_in_53 != 0 || 子_in_13 == 0 || !(子_do_50<=总_do_36) || !(f0_4 ( )) )   break;
   子_do_17 = AccountBalance() * AccountLeverage() * 总_do_35 / MarketInfo(Symbol(),15) ;
   if ( !(UseMM) )
    {
    子_do_17 = FixedLots ;
    }
   子_do_18 = NormalizeDouble(子_do_17 * MathPow(LotsExponent,CountTradesBuy ( )),总_in_30) ;
   子_do_18 = MathMax(总_do_33,子_do_18) ;
   子_do_18 = MathMin(总_do_34,子_do_18) ;
   子_do_19 = NormalizeDouble(子_do_17 * MathPow(LotsExponent,CountTradesSell ( )),总_in_30) ;
   子_do_19 = MathMax(总_do_33,子_do_19) ;
   子_do_19 = MathMin(总_do_34,子_do_19) ;
   if ( 子_in_13 <  0 )
    {
    子_do_11 = NormalizeDouble(Bid + 总_do_37,总_in_30) ;
    子_do_20 = NormalizeDouble(StopLoss * Point() + 子_do_11,总_in_30) ;
    子_do_21 = NormalizeDouble(子_do_11 - TakeProfit * Point(),总_in_30) ;
    子_do_23 = 子_do_20 ;
    if ( !(UseStopLoss) )
     {
     子_do_23 = 0.0 ;
     }
    子_do_22 = 子_do_21 ;
    if ( !(UseTakeProfit) )
     {
     子_do_22 = 0.0 ;
     }
    子_in_10 = OrderSend(Symbol(),OP_SELLLIMIT,子_do_19,子_do_11,Slippage,子_do_23,子_do_22,TradeComment,MagicNumber,0,Red) ;
    if ( 子_in_10 > 0 )   break;
    子_in_8 = GetLastError() ;
    子_st_9 = ErrorDescription(子_in_8) ;
    Print("SELLLIMIT Send Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " LT: " + DoubleToString(子_do_19,总_in_30) + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
       break;
   }
  子_do_11 = NormalizeDouble(Ask - 总_do_37,总_in_30) ;
  子_do_20 = NormalizeDouble(子_do_11 - StopLoss * Point(),总_in_30) ;
  子_do_21 = NormalizeDouble(TakeProfit * Point() + 子_do_11,总_in_30) ;
  子_do_23 = 子_do_20 ;
  if ( !(UseStopLoss) )
   {
   子_do_23 = 0.0 ;
   }
  子_do_22 = 子_do_21 ;
  if ( !(UseTakeProfit) )
   {
   子_do_22 = 0.0 ;
   }
  子_in_10 = OrderSend(Symbol(),OP_BUYLIMIT,子_do_18,子_do_11,Slippage,子_do_23,子_do_22,TradeComment,MagicNumber,0,Blue) ;
  if ( 子_in_10 > 0 )   break;
  子_in_8 = GetLastError() ;
  子_st_9 = ErrorDescription(子_in_8) ;
  Print("BUYLIMIT Send Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " LT: " + DoubleToString(子_do_18,总_in_30) + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
     break;
  case 2 :
   if ( 子_in_53 != 0 || 子_in_13 == 0 || !(子_do_50<=总_do_36) || !(f0_4 ( )) )   break;
   子_do_17 = AccountBalance() * AccountLeverage() * 总_do_35 / MarketInfo(Symbol(),15) ;
   if ( !(UseMM) )
    {
    子_do_17 = FixedLots ;
    }
   子_do_18 = NormalizeDouble(子_do_17 * MathPow(LotsExponent,CountTradesBuy ( )),总_in_30) ;
   子_do_18 = MathMax(总_do_33,子_do_18) ;
   子_do_18 = MathMin(总_do_34,子_do_18) ;
   子_do_19 = NormalizeDouble(子_do_17 * MathPow(LotsExponent,CountTradesSell ( )),总_in_30) ;
   子_do_19 = MathMax(总_do_33,子_do_19) ;
   子_do_19 = MathMin(总_do_34,子_do_19) ;
   if ( 子_in_13 <  0 )
    {
    子_do_11 = NormalizeDouble(Ask + 总_do_37,总_in_30) ;
    子_do_20 = NormalizeDouble(子_do_11 - StopLoss * Point(),总_in_30) ;
    子_do_21 = NormalizeDouble(TakeProfit * Point() + 子_do_11,总_in_30) ;
    子_do_23 = 子_do_20 ;
    if ( !(UseStopLoss) )
     {
     子_do_23 = 0.0 ;
     }
    子_do_22 = 子_do_21 ;
    if ( !(UseTakeProfit) )
     {
     子_do_22 = 0.0 ;
     }
    子_in_10 = OrderSend(Symbol(),OP_BUYSTOP,子_do_18,子_do_11,Slippage,子_do_23,子_do_22,TradeComment,MagicNumber,0,Blue) ;
    if ( 子_in_10 > 0 )   break;
    子_in_8 = GetLastError() ;
    子_st_9 = ErrorDescription(子_in_8) ;
    Print("BUYSTOP Send Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " LT: " + DoubleToString(子_do_18,总_in_30) + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
       break;
   }
  子_do_11 = NormalizeDouble(Bid - 总_do_37,总_in_30) ;
  子_do_20 = NormalizeDouble(StopLoss * Point() + 子_do_11,总_in_30) ;
  子_do_21 = NormalizeDouble(子_do_11 - TakeProfit * Point(),总_in_30) ;
  子_do_23 = 子_do_20 ;
  if ( !(UseStopLoss) )
   {
   子_do_23 = 0.0 ;
   }
  子_do_22 = 子_do_21 ;
  if ( !(UseTakeProfit) )
   {
   子_do_22 = 0.0 ;
   }

  子_in_10 = OrderSend(Symbol(),OP_SELLSTOP,子_do_19,子_do_11,Slippage,子_do_23,子_do_22,TradeComment,MagicNumber,0,Red) ;
  if ( 子_in_10 > 0 )   break;
  子_in_8 = GetLastError() ;
  子_st_9 = ErrorDescription(子_in_8) ;
  
  Print("1 SELLSTOP Send Error Code: " + ", debug volume: " + 子_do_19 + ", Message: " + 子_st_9 + " LT: " + DoubleToString(子_do_19,总_in_30) + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
     break;
  case 3 :
   if ( 子_in_53 != 0 || 子_in_13 == 0 || !(子_do_50<=总_do_36) || !(f0_4 ( )) )   break;
   子_do_17 = AccountBalance() * AccountLeverage() * 总_do_35 / MarketInfo(Symbol(),15) ;
   if ( !(UseMM) )
    {
    子_do_17 = FixedLots ;
    }
   子_do_18 = NormalizeDouble(子_do_17 * MathPow(LotsExponent,CountTradesBuy ( )),总_in_30) ;
   子_do_18 = MathMax(总_do_33,子_do_18) ;
   子_do_18 = MathMin(总_do_34,子_do_18) ;
   子_do_19 = NormalizeDouble(子_do_17 * MathPow(LotsExponent,CountTradesSell ( )),总_in_30) ;
   子_do_19 = MathMax(总_do_33,子_do_19) ;
   子_do_19 = MathMin(总_do_34,子_do_19) ;
   if ( 子_in_13 <  0 )
    {
    子_do_11 = NormalizeDouble(Bid - 总_do_37,总_in_30) ;
    子_do_20 = NormalizeDouble(StopLoss * Point() + 子_do_11,总_in_30) ;
    子_do_21 = NormalizeDouble(子_do_11 - TakeProfit * Point(),总_in_30) ;
    子_do_23 = 子_do_20 ;
    if ( !(UseStopLoss) )
     {
     子_do_23 = 0.0 ;
     }
    子_do_22 = 子_do_21 ;
    if ( !(UseTakeProfit) )
     {
     子_do_22 = 0.0 ;
     }
    子_in_10 = OrderSend(Symbol(),OP_SELLSTOP,子_do_19,子_do_11,Slippage,子_do_23,子_do_22,TradeComment,MagicNumber,0,Red) ;

    if ( 子_in_10 > 0 )   break;
    子_in_8 = GetLastError() ;
    子_st_9 = ErrorDescription(子_in_8) ;
    Print("2 SELLSTOP Send Error Code: " + string(子_in_8) + ", debug volume: " + 子_do_19 + ", Message: " + 子_st_9 + " LT: " + DoubleToString(子_do_19,总_in_30) + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
       break;
   }
  子_do_11 = NormalizeDouble(Ask + 总_do_37,总_in_30) ;
  子_do_20 = NormalizeDouble(子_do_11 - StopLoss * Point(),总_in_30) ;
  子_do_21 = NormalizeDouble(TakeProfit * Point() + 子_do_11,总_in_30) ;
  子_do_23 = 子_do_20 ;
  if ( !(UseStopLoss) )
   {
   子_do_23 = 0.0 ;
   }
  子_do_22 = 子_do_21 ;
  if ( !(UseTakeProfit) )
   {
   子_do_22 = 0.0 ;
   }
  子_in_10 = OrderSend(Symbol(),OP_BUYSTOP,子_do_18,子_do_11,Slippage,子_do_23,子_do_22,TradeComment,MagicNumber,0,Blue) ;
  if ( 子_in_10 > 0 )   break;
  子_in_8 = GetLastError() ;
  子_st_9 = ErrorDescription(子_in_8) ;
  Print("BUYSTOP Send Error Code: " + string(子_in_8) + " Message: " + 子_st_9 + " LT: " + DoubleToString(子_do_18,总_in_30) + " OP: " + DoubleToString(子_do_11,总_in_30) + " SL: " + DoubleToString(子_do_23,总_in_30) + " TP: " + DoubleToString(子_do_22,总_in_30) + " Bid: " + DoubleToString(Bid,总_in_30) + " Ask: " + DoubleToString(Ask,总_in_30)); 
 }
子_st_54 = "AvgSpread:" + DoubleToString(子_do_47,总_in_30) + "  Commission rate:" + DoubleToString(总_do_45,总_in_30 + 1) + "  Real avg. spread:" + DoubleToString(子_do_50,总_in_30 + 1) ;
if ( 子_do_50>总_do_36 )
 {
 子_st_54 = 子_st_54 + "\n" + "The EA can not run with this spread ( " + DoubleToString(子_do_50,总_in_30 + 1) + " > " + DoubleToString(总_do_36,总_in_30 + 1) + " )" ;
 }
return(0); 
}
//start <<==
//---------- ----------  ---------- ----------
 int deinit()
 {
 Comment(""); 
 DeleteAllObjects ( ); 
 return(0); 
 }
//deinit <<==
//---------- ----------  ---------- ----------
 int f0_4()
 {
 if ( ( ( Hour() > StartHour && Hour() < EndHour ) || ( Hour() == StartHour && Minute() >= StartMinute ) || (Hour() == EndHour && Minute() <  EndMinute) ) )
  {
  return(1); 
  }
 return(0); 
 }
//f0_4 <<==
//---------- ----------  ---------- ----------
 void MoveTrailingStop()
 {
  int       子_in_1;
//----- -----

 for (子_in_1 = 0 ; 子_in_1 < OrdersTotal() ; 子_in_1 = 子_in_1 + 1)
  {
  if ( !(OrderSelect(子_in_1,SELECT_BY_POS,MODE_TRADES)) || OrderType() > 1 || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber )   continue;
  
  if ( OrderType() == 0 )
   {
   if ( TrailingStop <= 0 || !(NormalizeDouble(Ask - TrailingStart * Point(),Digits())>NormalizeDouble(TrailingStop * Point() + OrderOpenPrice(),Digits())) )   continue;
   
   if ( ( !(NormalizeDouble(OrderStopLoss(),Digits())<NormalizeDouble(Bid - TrailingStop * Point(),Digits())) && !(OrderStopLoss()==0.0) ) || !(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid - TrailingStop * Point(),Digits()),OrderTakeProfit(),0,Blue)) || GetLastError() != 0 )   continue;
   Print(Symbol() + ": Trailing Buy OrderModify ok "); 
    continue;
   }
  if ( TrailingStop <= 0 || !(NormalizeDouble(TrailingStart * Point() + Bid,Digits())<NormalizeDouble(OrderOpenPrice() - TrailingStop * Point(),Digits())) )   continue;
  
  if ( ( !(NormalizeDouble(OrderStopLoss(),Digits())>NormalizeDouble(TrailingStop * Point() + Ask,Digits())) && !(OrderStopLoss()==0.0) ) || !(OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TrailingStop * Point() + Ask,Digits()),OrderTakeProfit(),0,Red)) || GetLastError() != 0 )   continue;
  Print(Symbol() + ": Trailing Sell OrderModify ok "); 
  }
 }
//MoveTrailingStop <<==
//---------- ----------  ---------- ----------
 int ScanOpenTrades()
 {
  int       子_in_1;
  int       子_in_2;
  int       子_in_3;
//----- -----

 子_in_1 = OrdersTotal() ;
 子_in_2 = 0 ;
 for (子_in_3 = 0 ; 子_in_3 <= 子_in_1 - 1 ; 子_in_3 = 子_in_3 + 1)
  {
  if ( !(OrderSelect(子_in_3,SELECT_BY_POS,MODE_TRADES)) || OrderType() > 1 )   continue;
  
  if ( 总_in_23 > 0 && OrderMagicNumber() == 总_in_23 )
   {
   子_in_2 = 子_in_2 + 1;
   }
  if ( 总_in_23 != 0 )   continue;
  子_in_2 = 子_in_2 + 1;
  }
 return(子_in_2); 
 }
//ScanOpenTrades <<==
//---------- ----------  ---------- ----------
 int ScanOpenTradessymbol()
 {
  int       子_in_1;
  int       子_in_2;
  int       子_in_3;
//----- -----

 子_in_1 = OrdersTotal() ;
 子_in_2 = 0 ;
 for (子_in_3 = 0 ; 子_in_3 <= 子_in_1 - 1 ; 子_in_3 = 子_in_3 + 1)
  {
  if ( !(OrderSelect(子_in_3,SELECT_BY_POS,MODE_TRADES)) || OrderType() > 1 )   continue;
  
  if ( OrderSymbol() == Symbol() && 总_in_23 > 0 && OrderMagicNumber() == 总_in_23 )
   {
   子_in_2 = 子_in_2 + 1;
   }
  if ( OrderSymbol() != Symbol() || 总_in_23 != 0 )   continue;
  子_in_2 = 子_in_2 + 1;
  }
 return(子_in_2); 
 }
//ScanOpenTradessymbol <<==
//---------- ----------  ---------- ----------
 void OpenOrdClose()
 {
  int       子_in_1;
  int       子_in_2;
  int       子_in_3;
  bool      子_bo_4;
  bool      子_bo_5;
//----- -----

 子_bo_5 = false ;
 子_in_1 = OrdersTotal() ;
for (子_in_2 = 0 ; 子_in_2 < 子_in_1 ; 子_in_2 = 子_in_2 + 1)
 {
  if ( !(OrderSelect(子_in_2,SELECT_BY_POS,MODE_TRADES)) )   continue;
  子_in_3 = OrderType() ;
  子_bo_4 = false ;
  子_bo_5 = false ;
  if ( OrderSymbol() == Symbol() && MagicNumber > 0 && OrderMagicNumber() == MagicNumber )
   {
   子_bo_5 = true ;
   }
  else
   {
   if ( OrderSymbol() == Symbol() && MagicNumber == 0 )
    {
    子_bo_5 = true ;
   }}
  if ( !(子_bo_5) )   continue;
  switch(子_in_3)
   {
   case 0 :
    子_bo_4 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),9),Slippage,Blue) ;
    break;
   case 2 :
    if ( !(OrderDelete(OrderTicket(),0xFFFFFFFF)) )   break;
   case 4 :
    if ( !(OrderDelete(OrderTicket(),0xFFFFFFFF)) )   break;
    default :
     if ( 子_bo_4 )   break;
     Print(" OrderClose failed with error #",GetLastError()); 
     Sleep(3000); 
  }
 }
}
//OpenOrdClose <<==
//---------- ----------  ---------- ----------
 void OpenOrdClose2()
 {
  int       子_in_1;
  int       子_in_2;
  int       子_in_3;
  bool      子_bo_4;
  bool      子_bo_5;
//----- -----

 子_bo_5 = false ;
 子_in_1 = OrdersTotal() ;
for (子_in_2 = 0 ; 子_in_2 < 子_in_1 ; 子_in_2 = 子_in_2 + 1)
 {
  if ( !(OrderSelect(子_in_2,SELECT_BY_POS,MODE_TRADES)) )   continue;
  子_in_3 = OrderType() ;
  子_bo_4 = false ;
  子_bo_5 = false ;
  if ( OrderSymbol() == Symbol() && MagicNumber > 0 && OrderMagicNumber() == MagicNumber )
   {
   子_bo_5 = true ;
   }
  else
   {
   if ( OrderSymbol() == Symbol() && MagicNumber == 0 )
    {
    子_bo_5 = true ;
   }}
  if ( !(子_bo_5) )   continue;
  switch(子_in_3)
   {
   case 1 :
    子_bo_4 = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),Slippage,Red) ;
   break;
   case 3 :
    if ( !(OrderDelete(OrderTicket(),0xFFFFFFFF)) )   break;
   case 5 :
    if ( !(OrderDelete(OrderTicket(),0xFFFFFFFF)) )   break;
    default :
     if ( 子_bo_4 )   break;
     Print(" OrderClose failed with error #",GetLastError()); 
     Sleep(3000); 
  }
 }
}
//OpenOrdClose2 <<==
//---------- ----------  ---------- ----------
 void TotalProfitbuy()
 {
  int       子_in_1;
  int       子_in_2;
  int       子_in_3;
  bool      子_bo_4;
//----- -----

 子_in_1 = OrdersTotal() ;
 总_do_19 = 0.0 ;
 for (子_in_2 = 0 ; 子_in_2 < 子_in_1 ; 子_in_2 = 子_in_2 + 1)
  {
  if ( !(OrderSelect(子_in_2,SELECT_BY_POS,MODE_TRADES)) )   continue;
  子_in_3 = OrderType() ;
  子_bo_4 = false ;
  if ( OrderSymbol() == Symbol() && MagicNumber > 0 && OrderMagicNumber() == MagicNumber )
   {
   子_bo_4 = true ;
   }
  else
   {
   if ( OrderSymbol() == Symbol() && MagicNumber == 0 )
    {
    子_bo_4 = true ;
   }}
  if ( !(子_bo_4) || 子_in_3 != 0 )   continue;
  总_do_19 = OrderProfit() + OrderCommission() + OrderSwap() + 总_do_19 ;
  }
 }
//TotalProfitbuy <<==
//---------- ----------  ---------- ----------
 void TotalProfitsell()
 {
  int       子_in_1;
  int       子_in_2;
  int       子_in_3;
  bool      子_bo_4;
//----- -----

 子_in_1 = OrdersTotal() ;
 总_do_20 = 0.0 ;
 for (子_in_2 = 0 ; 子_in_2 < 子_in_1 ; 子_in_2 = 子_in_2 + 1)
  {
  if ( !(OrderSelect(子_in_2,SELECT_BY_POS,MODE_TRADES)) )   continue;
  子_in_3 = OrderType() ;
  子_bo_4 = false ;
  if ( OrderSymbol() == Symbol() && MagicNumber > 0 && OrderMagicNumber() == MagicNumber )
   {
   子_bo_4 = true ;
   }
  else
   {
   if ( OrderSymbol() == Symbol() && MagicNumber == 0 )
    {
    子_bo_4 = true ;
   }}
  if ( !(子_bo_4) || 子_in_3 != 1 )   continue;
  总_do_20 = OrderProfit() + OrderCommission() + OrderSwap() + 总_do_20 ;
  }
 }
//TotalProfitsell <<==
//---------- ----------  ---------- ----------
 void ChartComment()
 {
  string    子_st_1;
  string    子_st_2;
  string    子_st_3;
//----- -----

 子_st_1 = "" ;
 子_st_2 = "----------------------------------------\n" ;
 子_st_3 = "\n" ;
 子_st_1 = "----------------------------------------\n" ;
 子_st_1 = "----------------------------------------\nName = " + AccountName() + "\n" ;
 子_st_1 = 子_st_1 + "Broker" + " " + "=" + " " + AccountCompany() + "\n" ;
 子_st_1 = 子_st_1 + "Account Leverage" + " " + "=" + " " + "1:" + DoubleToString(AccountLeverage(),0) + "\n" ;
 子_st_1 = 子_st_1 + "Account Balance" + " " + "=" + " " + DoubleToString(AccountBalance(),2) + "\n" ;
 子_st_1 = 子_st_1 + "Account Equity" + " " + "=" + " " + DoubleToString(AccountEquity(),2) + "\n" ;
 子_st_1 = 子_st_1 + "Day Profit" + " " + "=" + " " + DoubleToString(AccountBalance() - startBalanceD1 ( ),2) + 子_st_3 ;
 子_st_1 = 子_st_1 + 子_st_2;
 子_st_1 = 子_st_1 + "Open ALL Positions = " + string(ScanOpenTrades ( )) + 子_st_3 ;
 子_st_1 = 子_st_1 + Symbol() + " ALL Order = " + string(ScanOpenTradessymbol ( )) + 子_st_3 ;
 子_st_1 = 子_st_1 + "Open Buy  = " + string(CountTradesBuy ( )) + 子_st_3 ;
 子_st_1 = 子_st_1 + "Open Sell = " + string(CountTradesSell ( )) + 子_st_3 ;
 子_st_1 = 子_st_1 + 子_st_2;
 子_st_1 = 子_st_1 + "Target Money Buy = " + DoubleToString(总_do_56,2) + 子_st_3 ;
 子_st_1 = 子_st_1 + "Stoploss Money Buy = " + DoubleToString( -(总_do_58),2) + 子_st_3 ;
 子_st_1 = 子_st_1 + 子_st_2;
 子_st_1 = 子_st_1 + "Target Money Sell = " + DoubleToString(总_do_57,2) + 子_st_3 ;
 子_st_1 = 子_st_1 + "Stoploss Money Sell = " + DoubleToString( -(总_do_59),2) + 子_st_3 ;
 子_st_1 = 子_st_1 + 子_st_2;
 子_st_1 = 子_st_1 + "Buy Profit(USD) = " + DoubleToString(总_do_19,2) + 子_st_3 ;
 子_st_1 = 子_st_1 + "Sell Profit(USD) = " + DoubleToString(总_do_20,2) + 子_st_3 ;
 子_st_1 = 子_st_1 + 子_st_2;
 Comment(子_st_1); 
 }
//ChartComment <<==
//---------- ----------  ---------- ----------
 void DeleteAllObjects()
 {
  int       子_in_1;
  string    子_st_2;
  int       子_in_3;
//----- -----

 子_in_3 = 0 ;
 子_in_1 = ObjectsTotal(-1) ;
 for (子_in_3 = ObjectsTotal(-1) - 1 ; 子_in_3 >= 0 ; 子_in_3 = 子_in_3 - 1)
  {
  if ( HighToLow )
   {
   子_st_2 = ObjectName(子_in_3) ;
   if ( StringFind(子_st_2,"v_u_hl",0) > -1 )
    {
    ObjectDelete(子_st_2); 
    }
   if ( StringFind(子_st_2,"v_l_hl",0) > -1 )
    {
    ObjectDelete(子_st_2); 
    }
   if ( StringFind(子_st_2,"Fibo_hl",0) > -1 )
    {
    ObjectDelete(子_st_2); 
    }
   if ( StringFind(子_st_2,"trend_hl",0) > -1 )
    {
    ObjectDelete(子_st_2); 
    }
   WindowRedraw(); 
    continue;
   }
  子_st_2 = ObjectName(子_in_3) ;
  if ( StringFind(子_st_2,"v_u_lh",0) > -1 )
   {
   ObjectDelete(子_st_2); 
   }
  if ( StringFind(子_st_2,"v_l_lh",0) > -1 )
   {
   ObjectDelete(子_st_2); 
   }
  if ( StringFind(子_st_2,"Fibo_lh",0) > -1 )
   {
   ObjectDelete(子_st_2); 
   }
  if ( StringFind(子_st_2,"trend_lh",0) > -1 )
   {
   ObjectDelete(子_st_2); 
   }
  WindowRedraw(); 
  }
 }
//DeleteAllObjects <<==
//---------- ----------  ---------- ----------
 void CalcFibo()
 {
  int       子_in_1;
  int       子_in_2;
  double    子_do_3;
  double    子_do_4;
  int       子_in_5;
  int       子_in_6;
  double    子_do_7;
  double    子_do_8;
  int       子_in_9;
//----- -----

 子_in_5 = iLowest(NULL,0,MODE_LOW,BarsBack,StartBar) ;
 子_in_6 = iHighest(NULL,0,MODE_HIGH,BarsBack,StartBar) ;
 子_do_7 = 0.0 ;
 子_do_8 = 0.0 ;
 子_do_4 = High[子_in_6] ;
 子_do_3 = Low[子_in_5] ;
 if ( HighToLow )
  {
  DrawVerticalLine ( "v_u_hl",子_in_6,总_ui_9); 
  DrawVerticalLine ( "v_l_hl",子_in_5,总_ui_9); 
  if ( ObjectFind("trend_hl") == -1 )
   {
   ObjectCreate("trend_hl",OBJ_TREND,0,Time[子_in_6],子_do_4,Time[子_in_5],子_do_3,0,0.0); 
   }
  ObjectSet("trend_hl",OBJPROP_TIME1,Time[子_in_6]); 
  ObjectSet("trend_hl",OBJPROP_TIME2,Time[子_in_5]); 
  ObjectSet("trend_hl",OBJPROP_PRICE1,子_do_4); 
  ObjectSet("trend_hl",OBJPROP_PRICE2,子_do_3); 
  ObjectSet("trend_hl",OBJPROP_STYLE,2.0); 
  ObjectSet("trend_hl",OBJPROP_RAY,0.0); 
  if ( ObjectFind("Fibo_hl") == -1 )
   {
   ObjectCreate("Fibo_hl",OBJ_FIBO,0,0,子_do_4,0,子_do_3,0,0.0); 
   }
  ObjectSet("Fibo_hl",OBJPROP_PRICE1,子_do_4); 
  ObjectSet("Fibo_hl",OBJPROP_PRICE2,子_do_3); 
  ObjectSet("Fibo_hl",OBJPROP_LEVELCOLOR,总_ui_10); 
  ObjectSet("Fibo_hl",OBJPROP_FIBOLEVELS,8.0); 
  ObjectSet("Fibo_hl",210,总_do_7); 
  ObjectSetFiboDescription("Fibo_hl",0,"SWING LOW (0.0) - %$"); 
  ObjectSet("Fibo_hl",211,总_do_2); 
  ObjectSetFiboDescription("Fibo_hl",1,"BREAKOUT AREA (23.6) -  %$"); 
  ObjectSet("Fibo_hl",212,总_do_3); 
  ObjectSetFiboDescription("Fibo_hl",2,"CRITICAL AREA (38.2) -  %$"); 
  ObjectSet("Fibo_hl",213,总_do_4); 
  ObjectSetFiboDescription("Fibo_hl",3,"CRITICAL AREA (50.0) -  %$"); 
  ObjectSet("Fibo_hl",214,总_do_5); 
  ObjectSetFiboDescription("Fibo_hl",4,"CRITICAL AREA (61.8) -  %$"); 
  ObjectSet("Fibo_hl",215,总_do_6); 
  ObjectSetFiboDescription("Fibo_hl",5,"BREAKOUT AREA (76.4) -  %$"); 
  ObjectSet("Fibo_hl",217,总_do_8); 
  ObjectSetFiboDescription("Fibo_hl",7,"SWING HIGH (100.0) - %$"); 
  ObjectSet("Fibo_hl",OBJPROP_RAY,1.0); 
  WindowRedraw(); 
  for (子_in_9 = 0 ; 子_in_9 < 100 ; 子_in_9 = 子_in_9 + 1)
   {
   总_do17ko[子_in_9] = NormalizeDouble((子_do_4 - 子_do_3) * 总_do_8 + 子_do_3,Digits());
   总_do16ko[子_in_9] = NormalizeDouble((子_do_4 - 子_do_3) * 总_do_6 + 子_do_3,Digits());
   总_do15ko[子_in_9] = NormalizeDouble((子_do_4 - 子_do_3) * 总_do_5 + 子_do_3,Digits());
   总_do14ko[子_in_9] = NormalizeDouble((子_do_4 - 子_do_3) * 总_do_4 + 子_do_3,Digits());
   总_do13ko[子_in_9] = NormalizeDouble((子_do_4 - 子_do_3) * 总_do_3 + 子_do_3,Digits());
   总_do12ko[子_in_9] = NormalizeDouble((子_do_4 - 子_do_3) * 总_do_2 + 子_do_3,Digits());
   总_do11ko[子_in_9] = NormalizeDouble((子_do_4 - 子_do_3) * 总_do_7 + 子_do_3,Digits());
   }
  return;
  }
 DrawVerticalLine ( "v_u_lh",子_in_6,总_ui_9); 
 DrawVerticalLine ( "v_l_lh",子_in_5,总_ui_9); 
 if ( ObjectFind("trend_hl") == -1 )
  {
  ObjectCreate("trend_lh",OBJ_TREND,0,Time[子_in_5],子_do_3,Time[子_in_6],子_do_4,0,0.0); 
  }
 ObjectSet("trend_lh",OBJPROP_TIME1,Time[子_in_5]); 
 ObjectSet("trend_lh",OBJPROP_TIME2,Time[子_in_6]); 
 ObjectSet("trend_lh",OBJPROP_PRICE1,子_do_3); 
 ObjectSet("trend_lh",OBJPROP_PRICE2,子_do_4); 
 ObjectSet("trend_lh",OBJPROP_STYLE,2.0); 
 ObjectSet("trend_lh",OBJPROP_RAY,0.0); 
 if ( ObjectFind("Fibo_lh") == -1 )
  {
  ObjectCreate("Fibo_lh",OBJ_FIBO,0,0,子_do_3,0,子_do_4,0,0.0); 
  }
 ObjectSet("Fibo_lh",OBJPROP_PRICE1,子_do_3); 
 ObjectSet("Fibo_lh",OBJPROP_PRICE2,子_do_4); 
 ObjectSet("Fibo_lh",OBJPROP_LEVELCOLOR,总_ui_10); 
 ObjectSet("Fibo_lh",OBJPROP_FIBOLEVELS,8.0); 
 ObjectSet("Fibo_lh",210,总_do_7); 
 ObjectSetFiboDescription("Fibo_lh",0,"SWING LOW (0.0) - %$"); 
 ObjectSet("Fibo_lh",211,总_do_2); 
 ObjectSetFiboDescription("Fibo_lh",1,"BREAKOUT AREA (23.6) -  %$"); 
 ObjectSet("Fibo_lh",212,总_do_3); 
 ObjectSetFiboDescription("Fibo_lh",2,"CRITICAL AREA (38.2) -  %$"); 
 ObjectSet("Fibo_lh",213,总_do_4); 
 ObjectSetFiboDescription("Fibo_lh",3,"CRITICAL AREA (50.0) -  %$"); 
 ObjectSet("Fibo_lh",214,总_do_5); 
 ObjectSetFiboDescription("Fibo_lh",4,"CRITICAL AREA (61.8) -  %$"); 
 ObjectSet("Fibo_lh",215,总_do_6); 
 ObjectSetFiboDescription("Fibo_lh",5,"BREAKOUT AREA (76.4) -  %$"); 
 ObjectSet("Fibo_lh",217,总_do_8); 
 ObjectSetFiboDescription("Fibo_lh",7,"SWING HIGH (100.0) - %$"); 
 ObjectSet("Fibo_lh",OBJPROP_RAY,1.0); 
 WindowRedraw(); 
 for (子_in_9 = 0 ; 子_in_9 < 100 ; 子_in_9 = 子_in_9 + 1)
  {
  总_do11ko[子_in_9] = NormalizeDouble(子_do_4,4);
  总_do12ko[子_in_9] = NormalizeDouble(子_do_4 - (子_do_4 - 子_do_3) * 总_do_2,Digits());
  总_do13ko[子_in_9] = NormalizeDouble(子_do_4 - (子_do_4 - 子_do_3) * 总_do_3,Digits());
  总_do14ko[子_in_9] = NormalizeDouble(子_do_4 - (子_do_4 - 子_do_3) * 总_do_4,Digits());
  总_do15ko[子_in_9] = NormalizeDouble(子_do_4 - (子_do_4 - 子_do_3) * 总_do_5,Digits());
  总_do16ko[子_in_9] = NormalizeDouble(子_do_4 - (子_do_4 - 子_do_3) * 总_do_6,Digits());
  总_do17ko[子_in_9] = NormalizeDouble(子_do_3,4);
  }
 }
//CalcFibo <<==
//---------- ----------  ---------- ----------
 void DrawVerticalLine( string 木_0,int 木_1,color 木_2)
 {
 if ( ObjectFind(木_0) == -1 )
  {
  ObjectCreate(木_0,OBJ_VLINE,0,Time[木_1],0.0,0,0.0,0,0.0); 
  ObjectSet(木_0,OBJPROP_COLOR,木_2); 
  ObjectSet(木_0,OBJPROP_STYLE,1.0); 
  ObjectSet(木_0,OBJPROP_WIDTH,1.0); 
  WindowRedraw(); 
  return;
  }
 ObjectDelete(木_0); 
 ObjectCreate(木_0,OBJ_VLINE,0,Time[木_1],0.0,0,0.0,0,0.0); 
 ObjectSet(木_0,OBJPROP_COLOR,木_2); 
 ObjectSet(木_0,OBJPROP_STYLE,1.0); 
 ObjectSet(木_0,OBJPROP_WIDTH,1.0); 
 WindowRedraw(); 
 }
//DrawVerticalLine <<==
//---------- ----------  ---------- ----------
 double FindLastBuyPrice_Hilo()
 {
  double    子_do_1;
  int       子_in_2;
  double    子_do_3;
  int       子_in_4;
//----- -----

 子_in_2 = 0 ;
 子_do_3 = 0.0 ;
 子_in_4 = 0 ;
 for (总_in_24=OrdersTotal() - 1 ; 总_in_24 >= 0 ; 总_in_24=总_in_24 - 1)
  {
  if ( !(OrderSelect(总_in_24,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderType() != 0 )   continue;
  子_in_2 = OrderTicket() ;
  if ( 子_in_2 <= 子_in_4 )   continue;
  子_do_1 = OrderOpenPrice() ;
  子_do_3 = 子_do_1 ;
  子_in_4 = 子_in_2 ;
  }
 return(子_do_1); 
 }
//FindLastBuyPrice_Hilo <<==
//---------- ----------  ---------- ----------
 double FindLastSellPrice_Hilo()
 {
  double    子_do_1;
  int       子_in_2;
  double    子_do_3;
  int       子_in_4;
//----- -----

 子_in_2 = 0 ;
 子_do_3 = 0.0 ;
 子_in_4 = 0 ;
 for (总_in_24=OrdersTotal() - 1 ; 总_in_24 >= 0 ; 总_in_24=总_in_24 - 1)
  {
  if ( !(OrderSelect(总_in_24,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderType() != 1 )   continue;
  子_in_2 = OrderTicket() ;
  if ( 子_in_2 <= 子_in_4 )   continue;
  子_do_1 = OrderOpenPrice() ;
  子_do_3 = 子_do_1 ;
  子_in_4 = 子_in_2 ;
  }
 return(子_do_1); 
 }
//FindLastSellPrice_Hilo <<==
//---------- ----------  ---------- ----------
 int CountTradesSell()
 {
  int       子_in_1;
  int       子_in_2;
//----- -----

 子_in_2 = 0 ;
 子_in_1 = 0 ;
 for (子_in_2 = OrdersTotal() - 1 ; 子_in_2 >= 0 ; 子_in_2 = 子_in_2 - 1)
  {
  if ( !(OrderSelect(子_in_2,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderType() != 1 )   continue;
  子_in_1 = 子_in_1 + 1;
  }
 return(子_in_1); 
 }
//CountTradesSell <<==
//---------- ----------  ---------- ----------
 int CountTradesBuy()
 {
  int       子_in_1;
  int       子_in_2;
//----- -----

 子_in_2 = 0 ;
 子_in_1 = 0 ;
 for (子_in_2 = OrdersTotal() - 1 ; 子_in_2 >= 0 ; 子_in_2 = 子_in_2 - 1)
  {
  if ( !(OrderSelect(子_in_2,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber || OrderType() != 0 )   continue;
  子_in_1 = 子_in_1 + 1;
  }
 return(子_in_1); 
 }
//CountTradesBuy <<==
//---------- ----------  ---------- ----------
 double startBalanceD1()
 {
  double    子_do_1;
  int       子_in_2;
  datetime  子_da_3;
  int       子_in_4;
  double    子_do_5;
//----- -----

 子_in_2 = OrdersHistoryTotal() ;
 子_da_3 = iTime(NULL,1440,0) ;
 for (子_in_4 = 子_in_2 ; 子_in_4 >= 0 ; 子_in_4 = 子_in_4 - 1)
  {
  if ( !(OrderSelect(子_in_4,SELECT_BY_POS,MODE_HISTORY)) || OrderCloseTime() < 子_da_3 )   continue;
  子_do_1 = OrderProfit() + OrderCommission() + OrderSwap() + 子_do_1 ;
  }
 子_do_5 = NormalizeDouble(AccountBalance() - 子_do_1,2) ;
 return(子_do_5); 
 }
//startBalanceD1 <<==
//---------- ----------  ---------- ----------
