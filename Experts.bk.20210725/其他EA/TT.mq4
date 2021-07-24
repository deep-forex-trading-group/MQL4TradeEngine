//+------------------------------------------------------------------+
//|                                                           TT.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+

int magicnumber1=1000;
int magicnumber2=2000;
int magicnumber3=3000;
int magicnumber4=4000;
int profitjudge(string sym,int magicnumber,int peri)
{
   int i;
   datetime time=0;
   int k=0;
   double profit=0;
   for(i=OrdersHistoryTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
      {
         if(OrderSymbol()==sym &&  OrderMagicNumber()==magicnumber1 && 
(OrderType()==OP_BUY || OrderType()==OP_SELL))
         {
            time=OrderCloseTime();
            break;
         }
      }
   }

   if(time==0)
   {
      return(0);
   }
   while(iTime(sym,peri,k)>=time)
   {
      k++;
   }
   for(i=OrdersHistoryTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
      {
         if(OrderSymbol()==sym && OrderCloseTime()>=iTime(sym,peri,k) && 
			(OrderType()==OP_BUY || OrderType()==OP_SELL) &&
           (OrderMagicNumber()==magicnumber1 || 
OrderMagicNumber()==magicnumber2 ||  
OrderMagicNumber()==magicnumber3 ||  
OrderMagicNumber()==magicnumber4))
         {
            profit=profit+OrderProfit();
         }
         if(OrderCloseTime()<iTime(sym,peri,k))
         {
            break;
         }
      }
   }
   if(profit>0)
   {
      return(1);
   }
   else
   {
      return(0);
   }
}

double kuisun=0.01;
double calculatelot(string sym,int peri)
{
      double lot;
      double vlu=SymbolInfoDouble(sym,SYMBOL_TRADE_CONTRACT_SIZE);
      double ATr=iATR(sym,peri,20,1);
      int i=0;
      int judge=0;
      double zxshou=MarketInfo(sym,MODE_MINLOT);
      double factor=1;
      string symbol[20];
      string symstr_fthf="";
      string symstr_bkhf="";
      string ss;
symbol[0]="EUR";symbol[1]="GBP";symbol[2]="AUD";symbol[3]="CHF";
symbol[4]="JPY";symbol[5]="NZD";symbol[6]="CAD";symbol[7]="CNH";
symbol[8]="USD";
      for(i=0;i<=8;i++)
      {
         judge=StringFind(sym,symbol[i],0);
         if(judge>=0)
         {
            symstr_fthf=StringSubstr(sym,0,3);
            symstr_bkhf=StringSubstr(sym,3,3);
            break;
         }
      }
      if(symstr_fthf == "USD")
      {
         factor=iClose(sym,peri,1);
      }
      else if(symstr_bkhf == "USD" || symstr_bkhf=="")
      {
         factor=1;
      }
      else
      {
         ss="USD"+symstr_fthf;
         if(iClose(ss, peri,1)!=0)
         {
            factor=iClose(sym, peri,1)/iClose(ss, peri,1);
         }
         else
         {
            ss=symstr_fthf+"USD";
            factor=iClose(ss, peri,1)*iClose(sym, peri,1);
         }
      }
      lot=10000*kuisun/(vlu*ATr)*factor;
      return(lot);
}

int swit20_BUY=0;
int swit55_BUY=0;
int swit20_SELL=0;
int swit55_SELL=0;
void openlogic(string sym,int peri)
{
   double price_buy1=iHigh(sym,peri,iHighest(sym,peri,MODE_HIGH,20,1));
   double price_sell1=iLow(sym,peri,iLowest(sym,peri,MODE_LOW,20,1));
   double price_buy2=iHigh(sym,peri,iHighest(sym,peri,MODE_HIGH,55,1));
   double price_sell2=iLow(sym,peri,iLowest(sym,peri,MODE_LOW,55,1));
   double lot=calculatelot(sym,peri);
   double ATr=iATR(sym,peri,20,1);
   int order_buy=calculateorder(sym,OP_BUY,magicnumber1);
   int order_buystop=calculateorder(sym,OP_BUYSTOP,magicnumber1);
   int order_sell=calculateorder(sym,OP_SELL,magicnumber1);
   int order_sellstop=calculateorder(sym,OP_SELLSTOP,magicnumber1);
   if(profitjudge(sym,magicnumber1,peri)==1 && order_buy==0)
   {
      swit20_BUY=0;
   }
   if(profitjudge(sym,magicnumber1,peri)==1 && order_sell==0)
   {
      swit20_SELL=0;
   }
   if(order_buy==0 && order_buystop==0 && 
	profitjudge(sym,magicnumber1,peri)==0 && 
	iMA(sym,peri,130,0,1,PRICE_CLOSE,1)>iMA(sym,peri,509,0,1,PRICE_CLOSE,1))
   {
      pendingorder(sym,"BUYSTOP",price_buy1,lot,price_buy1-2*ATr,0,
magicnumber1,"Turtle");
      swit20_BUY=1;
      swit55_BUY=0;
   }
   else if(order_buy==0 && order_buystop==0 && swit20_BUY==0 && 
	iMA(sym,peri,130,0,1,PRICE_CLOSE,1)>iMA(sym,peri,509,0,1,PRICE_CLOSE,1))
   {
      pendingorder(sym,"BUYSTOP",price_buy2,lot,price_buy2-2*ATr,0,
magicnumber1,"Turtle");
      swit55_BUY=1;
   }
   if(order_sell==0 && order_sellstop==0 && 
	profitjudge(sym,magicnumber1,peri)==0 && 
	iMA(sym,peri,130,0,1,PRICE_CLOSE,1)<iMA(sym,peri,509,0,1,PRICE_CLOSE,1))
   {
      pendingorder(sym,"SELLSTOP",price_sell1,lot,price_sell1+2*ATr,0,
magicnumber1,"Turtle");
      swit20_SELL=1;
      swit55_SELL=0;
   }
   else if(order_sell==0 && order_sellstop==0 && swit20_SELL==0 && 
	iMA(sym,peri,130,0,1,PRICE_CLOSE,1)<iMA(sym,peri,509,0,1,PRICE_CLOSE,1))
   {
pendingorder(sym,"SELLSTOP",price_sell2,lot,price_sell2+2*ATr,0,
magicnumber1,"Turtle");
swit55_SELL=1;
   }
}

void orderdelet(string sym,int peri)
{
   int i;
   bool deletswitch_buy=true;
   bool deletswitch_sell=true;
   int check;
   for(i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber1 && 
			(OrderType()==OP_BUY || OrderType()==OP_BUYSTOP))
         {
            deletswitch_buy=false;
         }
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber1 && 
			(OrderType()==OP_SELL || OrderType()==OP_SELLSTOP))
         {
            deletswitch_sell=false;
         }
      }
   }
   if(deletswitch_buy==true)
   {
      swit20_BUY=0;
      swit55_BUY=0;
   }
   if(deletswitch_sell==true)
   {
      swit20_SELL=0;
      swit55_SELL=0;
   }
   if(Barjudge()==1)
   {
      for(i=OrdersTotal()-1;i>=0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS))
         {
            if(OrderSymbol()==sym && OrderType()==OP_BUYSTOP && 
				OrderMagicNumber()==magicnumber1)
            {
               check=OrderDelete(OrderTicket(),clrBlue);
               swit20_BUY=0;
               swit55_BUY=0;
            }
            if(OrderSymbol()==sym && OrderType()==OP_SELLSTOP && 
				OrderMagicNumber()==magicnumber1)
            {
               check=OrderDelete(OrderTicket(),clrRed);
               swit20_SELL=0;
               swit55_SELL=0;
            }
         }
      }
   }
}

void op_up(string sym,int peri)
{
   double ATr=iATR(sym,peri,20,1);
   bool buyupswit=false;
   bool sellupswit=false;
   bool swit2_buy=true;
   bool swit3_buy=true;
   bool swit4_buy=true;
   bool swit2_sell=true;
   bool swit3_sell=true;
   bool swit4_sell=true;
   double price_buy=0;
   double price_sell=0;
   double lot=calculatelot(sym,peri);
   int i;
   for(i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber1)
         {
            if(OrderType()==OP_BUY)
            {
               price_buy=OrderOpenPrice();
               buyupswit=true;
            }
            if(OrderType()==OP_SELL)
            {
               price_sell=OrderOpenPrice();
               sellupswit=true;
            }
         }
      }
   }
   for(i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber2 
			&& (OrderType()==OP_BUY || OrderType()==OP_BUYSTOP))
         {
            swit2_buy=false;
         }
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber3 
			&& (OrderType()==OP_BUY || OrderType()==OP_BUYSTOP))
         {
            swit3_buy=false;
         }
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber4 
			&& (OrderType()==OP_BUY || OrderType()==OP_BUYSTOP))
         {
            swit4_buy=false;
         }
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber2 
			&& (OrderType()==OP_SELL || OrderType()==OP_SELLSTOP))
         {
            swit2_sell=false;
         }
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber3 
			&& (OrderType()==OP_SELL || OrderType()==OP_SELLSTOP))
         {
            swit3_sell=false;
         }
         if(OrderSymbol()==sym && OrderMagicNumber()==magicnumber4 
			&& (OrderType()==OP_SELL || OrderType()==OP_SELLSTOP))
         {
            swit4_sell=false;
         }
      }
   }
   if(buyupswit==true)
   {
      if(MarketInfo(sym,MODE_ASK)>=price_buy+0.5*ATr && 
		swit2_buy==true)
      {
         orderopen(sym,"BUY",lot,price_buy-2*ATr,0,magicnumber2,"Turtle");
      }
      if(MarketInfo(sym,MODE_ASK)>=price_buy+1*ATr && swit3_buy==true)
      {
         orderopen(sym,"BUY",lot,price_buy-2*ATr,0,magicnumber3,"Turtle");
      }
      if(MarketInfo(sym,MODE_ASK)>=price_buy+1.5*ATr &&
 swit4_buy==true)
      {
         orderopen(sym,"BUY",lot,price_buy-2*ATr,0,magicnumber4,"Turtle");
      }
   }
   if(sellupswit==true)
   {
      if(MarketInfo(sym,MODE_BID)<=price_sell-0.5*ATr && swit2_sell==true)
      {
         orderopen(sym,"SELL",lot,price_sell+2*ATr,0,magicnumber2,"Turtle");
      }
      if(MarketInfo(sym,MODE_BID)<=price_sell-1*ATr && swit3_sell==true)
      {
         orderopen(sym,"SELL",lot,price_sell+2*ATr,0,magicnumber3,"Turtle");
      }
      if(MarketInfo(sym,MODE_BID)<=price_sell-1.5*ATr && swit4_sell==true)
      {
         orderopen(sym,"SELL",lot,price_sell+2*ATr,0,magicnumber4,"Turtle");
      }
   }
}

