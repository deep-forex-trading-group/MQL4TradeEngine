
// ------------------------------------------------------------------------------------------------
#include <stdlib.mqh>
#include <stderror.mqh> 
#property copyright   "EUR Cross Hedge v3.1"
#property link        "https://www.eahub.cn/thread-996-1-1.html"
#property description "[EAHub]EUR Cross Hedge是双币对冲EA，MT4无法进行多币复盘，进挂模拟盘研究。适用周期M15,或者H1"
#property version   "3.1"


// ------------------------------------------------------------------------------------------------
// EXTERN VARS
// ------------------------------------------------------------------------------------------------
extern int magic = 0;
// Configuration
extern string EAName = "EUR Cross Hedge v3.1";
extern string CommonSettings = "---------------------------------------------";
extern string MainSymbol="EURUSD";
extern string FollowSymbol="EURCAD";
extern int user_slippage = 2; 
extern int grid_size = 10;
extern double profit_lock = 0.60;
extern int profit_mode = 1;
extern string MoneyManagementSettings = "---------------------------------------------";
// Money Management
extern double min_lots = 0.01;
extern double max_lots =0.02;
extern double min_lots_increment = 0.01;
extern double account_risk = 10;
extern int    MaxTrade=50;


extern string TimeFilter = "----------Time Filter----------";
extern string Session1Set = "-- Session 1: Start & End Hours --";
extern int Session1_StartHour = 9;					// First session start hour. Time is broker server time
extern int Session1_EndHour = 12;				   // First session end hour. Time is broker server time
extern string Session2Set = "--- Session 2: Start & End Hours ---";
extern int Session2_StartHour = 13;			   // Second session start hour. Time is broker server time
extern int Session2_EndHour = 16;				   // Second session end hour. Time is broker server time
extern string L_____ = "--- Monday Start Hour ---";
extern int Monday_StartHour = 9;						// Trading will not start on Monday before this time. Broker server time.
extern string L______ = "--- Friday Close Hour ---";
extern int Friday_EndHour = 16;					   // Trading will end on Friday at this time. Broker server time.


// ------------------------------------------------------------------------------------------------
// GLOBAL VARS
// ------------------------------------------------------------------------------------------------
string key = "EUR Cross Hedge v3.1";
// Ticket
int buy_tickets[50];
int sell_tickets[50];
// Lots
double buy_lots[50];
double sell_lots[50];
// Current Profit
double buy_profit[50];
double sell_profit[50];
// Open Price
double buy_price[50];
double sell_price[50];
// Indicator
// Number of orders
int buys = 0;
int sells = 0;
double total_buy_profit=0,total_sell_profit=0;
double total_buy_lots=0, total_sell_lots=0;
double buy_max_profit=0, buy_close_profit=0;
double sell_max_profit=0, sell_close_profit=0;
int slippage=0;
// OrderReliable
int retry_attempts = 10; 
double sleep_time = 4.0;
double sleep_maximum	= 25.0;  // in seconds
string OrderReliable_Fname = "OrderReliable fname unset";
static int _OR_err = 0;
string OrderReliableVersion = "V1_1_1"; 


int deinit()
{

 ObjectsDeleteAll();
 
 }

// ------------------------------------------------------------------------------------------------
// START
// ------------------------------------------------------------------------------------------------
int start()
{  
  double point = MarketInfo(MainSymbol, MODE_POINT);
  double dd=0;

  
  if (MarketInfo(MainSymbol,MODE_DIGITS)==4 || MarketInfo(MainSymbol,MODE_DIGITS)==2)
  {
    slippage = user_slippage;
  }
  else if (MarketInfo(MainSymbol,MODE_DIGITS)==5 || MarketInfo(MainSymbol,MODE_DIGITS)==3)
  {
    slippage = 10*user_slippage;
  }
  
  if(IsTradeAllowed() == false) 
  {
    Comment("请检查是否允许实时交易");
    return(0);  
  }
  
  // Updating current status
  InitVars();
  UpdateVars();
  SortByLots();
  ShowData();
  ShowLines();
  
  Robot();
  
  return(0);
}

// ------------------------------------------------------------------------------------------------
// INIT VARS
// ------------------------------------------------------------------------------------------------
void InitVars()
{
  // Reset number of buy/sell orders
  buys=0;
  sells=0;
  // Reset arrays
  for(int i=0; i<50; i++)
  {
    buy_tickets[i] = 0;
    buy_lots[i] = 0;
    buy_profit[i] = 0;
    buy_price[i] = 0;
    sell_tickets[i] = 0;
    sell_lots[i] = 0;
    sell_profit[i] = 0;
    sell_price[i] = 0;    
  }
}

// ------------------------------------------------------------------------------------------------
// BUY RESET AFTER CLOSE
// ------------------------------------------------------------------------------------------------
void BuyResetAfterClose()
{
   buy_max_profit=0;
   buy_close_profit=0;  
   ObjectDelete("line_buy");
   ObjectDelete("line_buy_ts");
}

// ------------------------------------------------------------------------------------------------
// SELL RESET AFTER CLOSE
// ------------------------------------------------------------------------------------------------
void SellResetAfterClose()
{
   sell_max_profit=0;
   sell_close_profit=0;   
   ObjectDelete("line_sell");
   ObjectDelete("line_sell_ts");
}

// ------------------------------------------------------------------------------------------------
// UPDATE VARS
// ------------------------------------------------------------------------------------------------
void UpdateVars()
{
  int aux_buys=0, aux_sells=0;
  double aux_total_buy_profit=0, aux_total_sell_profit=0;
  double aux_total_buy_lots=0, aux_total_sell_lots=0;
  
  // We are going to introduce data from opened orders in arrays  
  for(int i=0; i<OrdersTotal(); i++)
  {
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true)
    {
      if((OrderSymbol() == MainSymbol) && OrderMagicNumber() == magic && OrderType() == OP_BUY)
      {
        buy_tickets[aux_buys] = OrderTicket();
        buy_lots[aux_buys] = OrderLots();
        buy_profit[aux_buys] = OrderProfit()+OrderCommission()+OrderSwap();
        buy_price[aux_buys] = OrderOpenPrice();
        aux_total_buy_profit = aux_total_buy_profit + buy_profit[aux_buys];
        aux_total_buy_lots = aux_total_buy_lots + OrderLots();
        aux_buys++;
      }
      if((OrderSymbol() == MainSymbol) && OrderMagicNumber() == magic && OrderType() == OP_SELL)
      {
        sell_tickets[aux_sells] = OrderTicket();
        sell_lots[aux_sells] = OrderLots();
        sell_profit[aux_sells] = OrderProfit()+OrderCommission()+OrderSwap();
        sell_price[aux_sells] = OrderOpenPrice();
        aux_total_sell_profit = aux_total_sell_profit + sell_profit[aux_sells];
        aux_total_sell_lots = aux_total_sell_lots + OrderLots();
        aux_sells++;
      }
    }
  }
  
  // Update global vars
  buys = aux_buys;
  sells = aux_sells;
  total_buy_profit = aux_total_buy_profit;
  total_sell_profit = aux_total_sell_profit;
  total_buy_lots = aux_total_buy_lots;
  total_sell_lots = aux_total_sell_lots;
}

// ------------------------------------------------------------------------------------------------
// SORT BY LOTS
// ------------------------------------------------------------------------------------------------
void SortByLots()
{ 
  int aux_tickets;
  double aux_lots, aux_profit, aux_price;
  
  // We are going to sort orders by volume
  // m[0] smallest volume m[size-1] largest volume
  
  // BUY ORDERS
  for(int i=0; i<buys-1; i++)
  {
    for(int j=i+1; j<buys; j++)
    {
      if (buy_lots[i]>0 && buy_lots[j]>0)
      {
        // at least 2 orders
        if (buy_lots[j]<buy_lots[i])
        {
          // sorting
          // ...lots...
          aux_lots=buy_lots[i];
          buy_lots[i]=buy_lots[j];
          buy_lots[j]=aux_lots;
          // ...tickets...
          aux_tickets=buy_tickets[i];
          buy_tickets[i]=buy_tickets[j];
          buy_tickets[j]=aux_tickets;
          // ...profits...
          aux_profit=buy_profit[i];
          buy_profit[i]=buy_profit[j];
          buy_profit[j]=aux_profit;
          // ...and open price
          aux_price=buy_price[i];
          buy_price[i]=buy_price[j];
          buy_price[j]=aux_price;
        }
      }
    }
  }
  
  // SELL ORDERS
  for(i=0; i<sells-1; i++)
  {
    for(j=i+1; j<sells; j++)
    {
      if (sell_lots[i]>0 && sell_lots[j]>0)
      {
        // at least 2 orders
        if (sell_lots[j]<sell_lots[i])
        {
          // sorting...
          // ...lots...
          aux_lots=sell_lots[i];
          sell_lots[i]=sell_lots[j];
          sell_lots[j]=aux_lots;
          // ...tickets...
          aux_tickets=sell_tickets[i];
          sell_tickets[i]=sell_tickets[j];
          sell_tickets[j]=aux_tickets;
          // ...profits...
          aux_profit=sell_profit[i];
          sell_profit[i]=sell_profit[j];
          sell_profit[j]=aux_profit;
          // ...and open price
          aux_price=sell_price[i];
          sell_price[i]=sell_price[j];
          sell_price[j]=aux_price;
        }
      }
    }
  }
}

// ------------------------------------------------------------------------------------------------
// SHOW LINES
// ------------------------------------------------------------------------------------------------
void ShowLines()
{
  double aux_tp_buy=0, aux_tp_sell=0;
  int factor=1;
  double buy_tar=0, sell_tar=0;
  double buy_a=0, sell_a=0;
  double buy_b=0, sell_b=0;
  double buy_pip=0, sell_pip=0;
  double buy_v[50], sell_v[50];
  double point = MarketInfo(MainSymbol, MODE_POINT);
  int i;
  
  if (slippage>user_slippage) point=point*10;
  
  if (buys>=1)
  { 
    if (profit_mode==1) aux_tp_buy = CalculateTP(buy_lots[0]);
    if (profit_mode==2) aux_tp_buy = (CalculateTP(total_buy_lots)/buys);
  }  
  
  if (sells>=1)
  {
    if (profit_mode==1) aux_tp_sell = CalculateTP(sell_lots[0]);
    if (profit_mode==2) aux_tp_sell = (CalculateTP(total_sell_lots)/sells);
  }
  
  if (buys>=1)
  {
    buy_pip = CalculatePipValue(buy_lots[0]);    
    for (i=0;i<50;i++) buy_v[i] = 0;  
    
    for (i=buys;i>=0;i--)
    {
      buy_v[i] = MathRound(buy_lots[i]/buy_lots[0]);
    }
  
    for (i=buys;i>=0;i--)
    {
      buy_a = buy_a + buy_v[i];
      buy_b = buy_b + buy_price[i]*buy_v[i];
      
    }  
  
    buy_tar = aux_tp_buy/(buy_pip/point);
    buy_tar = buy_tar + buy_b;
    buy_tar = buy_tar/buy_a;
  
    HorizontalLine(buy_tar,"line_buy",DodgerBlue,STYLE_SOLID,2);
    
    if (buy_close_profit>0)
    {
      buy_tar = buy_close_profit/(buy_pip/point);
      buy_tar = buy_tar + buy_b;
      buy_tar = buy_tar/buy_a;
      HorizontalLine(buy_tar,"line_buy_ts",DodgerBlue,STYLE_DASH,1);
    }
  }
  
  if (sells>=1)
  {
    sell_pip = CalculatePipValue(sell_lots[0]);    
    for (i=0;i<50;i++) sell_v[i] = 0;  
    
    for (i=sells;i>=0;i--)
    {
      sell_v[i] = MathRound(sell_lots[i]/sell_lots[0]);
    }
  
    for (i=sells;i>=0;i--)
    {
      sell_a = sell_a + sell_v[i];
      sell_b = sell_b + sell_price[i]*sell_v[i];
      
    } 
  
    sell_tar = -1*(aux_tp_sell/(sell_pip/point));
    sell_tar = sell_tar + sell_b;
    sell_tar = sell_tar/sell_a;
  
    HorizontalLine(sell_tar,"line_sell",Tomato,STYLE_SOLID,2);
    
    if (sell_close_profit>0)
    {
      sell_tar = -1*(sell_close_profit/(sell_pip/point));
      sell_tar = sell_tar + sell_b;
      sell_tar = sell_tar/sell_a;
      HorizontalLine(sell_tar,"line_sell_ts",Tomato,STYLE_DASH,1);
    }
  }

}

// ------------------------------------------------------------------------------------------------
// SHOW DATA
// ------------------------------------------------------------------------------------------------
void ShowData()
{
  string txt;
  double aux_tp_buy=0, aux_tp_sell=0;
  
  if (buys>=1)
  { 
    if (profit_mode==1) aux_tp_buy = CalculateTP(buy_lots[0]);
    if (profit_mode==2) aux_tp_buy = (CalculateTP(total_buy_lots)/buys);
  }  
  
  if (sells>=1)
  {
    if (profit_mode==1) aux_tp_sell = CalculateTP(sell_lots[0]);
    if (profit_mode==2) aux_tp_sell = (CalculateTP(total_sell_lots)/sells);
  }
        
  txt = "\nEUR Cross Hedge v3.1 is running." +
        "\n" +
        "\nSETTINGS: " + 
        "\nGrid size: " + grid_size +
        "\nProfit locked: " + DoubleToStr(100*profit_lock,2) + "%" +
        "\nMinimum lots: " + DoubleToStr(min_lots,2) +
        "\nAccount risk: " + DoubleToStr(account_risk,0) + "%" +
       
        
        "\n" +
        "\nBUY ORDERS" +
        "\nNumber of orders: " + buys +
        "\nTotal lots: " + DoubleToStr(total_buy_lots,2) +         
        "\nCurrent profit: " + DoubleToStr(total_buy_profit,2) + 
        "\nProfit goal: $" + DoubleToStr(aux_tp_buy,2) + 
        "\nMaximum profit reached: $" + DoubleToStr(buy_max_profit,2) + 
        "\nProfit locked: $" + DoubleToStr(buy_close_profit,2) + 
        
        "\n" +
        "\nSELL ORDERS" +
        "\nNumber of orders: " + sells +
        "\nTotal lots: " + DoubleToStr(total_sell_lots,2) +   
        "\nCurrent profit: " + DoubleToStr(total_sell_profit,2) +       
        "\nProfit goal: $" + DoubleToStr(aux_tp_sell,2) + 
        "\nMaximum profit reached: $" + DoubleToStr(sell_max_profit,2) + 
        "\nProfit locked: $" + DoubleToStr(sell_close_profit,2);
  
  Comment(txt);
}


// ------------------------------------------------------------------------------------------------
// WRITE
// ------------------------------------------------------------------------------------------------
void Write(string name, string s, int x, int y, string font, int size, color c)
{
  if (ObjectFind(name)!=-1)
  {
    ObjectSetText(name,s,size,font,c);
  }
  else
  {
    ObjectCreate(name,OBJ_LABEL,0,0,0);
    ObjectSetText(name,s,size,font,c);
    ObjectSet(name,OBJPROP_XDISTANCE, x);
    ObjectSet(name,OBJPROP_YDISTANCE, y);
  }
}

// ------------------------------------------------------------------------------------------------
// HORIZONTAL LINE
// ------------------------------------------------------------------------------------------------
void HorizontalLine(double value, string name, color c, int style, int thickness) 
{
  if(ObjectFind(name) == -1)
  {
    ObjectCreate(name, OBJ_HLINE, 0, Time[0], value);
    
    ObjectSet(name, OBJPROP_STYLE, style);             
    ObjectSet(name, OBJPROP_COLOR, c);
    ObjectSet(name,OBJPROP_WIDTH,thickness);
  }
  else
  {
    ObjectSet(name,OBJPROP_PRICE1,value);
    ObjectSet(name, OBJPROP_STYLE, style);             
    ObjectSet(name, OBJPROP_COLOR, c);
    ObjectSet(name,OBJPROP_WIDTH,thickness);
  }  
}

// ------------------------------------------------------------------------------------------------
// CALCULATE STARTING VOLUME
// ------------------------------------------------------------------------------------------------
double CalculateStartingVolume()
{ 
  double aux; 

  aux=min_lots;

  if (aux>MarketInfo(MainSymbol,MODE_MAXLOT))
    aux=MarketInfo(MainSymbol,MODE_MAXLOT);
      
  if (aux<MarketInfo(MainSymbol,MODE_MINLOT))
    aux=MarketInfo(MainSymbol,MODE_MINLOT);
  
  return(aux);
}

// ------------------------------------------------------------------------------------------------
// CALCULATE DECIMALS
// ------------------------------------------------------------------------------------------------
double CalculateDecimals(double volume)
{ 
  double aux; 
  int decimals;
  
  if (min_lots_increment>=1)
  {
    decimals=0;
  }  
  else
  {
    decimals=0;
    aux=volume;
    while (aux<1)
    {
      decimals = decimals + 1;
      aux = aux * 10;
    }
  }
  
  return(decimals);
}
// ------------------------------------------------------------------------------------------------
// MARTINGALE VOLUME
// ------------------------------------------------------------------------------------------------
double MartingaleVolume(double losses)
{ 
  double aux, grid_value, multiplier; 
  
  grid_value = CalculateTP(min_lots); // minimum grid value
  multiplier = MathFloor(MathAbs(losses/grid_value));
 
  aux = NormalizeDouble(multiplier*min_lots_increment,CalculateDecimals(min_lots_increment));
  
  if (aux < min_lots) aux = min_lots;
  
  if (aux > max_lots) aux = max_lots;
    
  if (aux>MarketInfo(MainSymbol,MODE_MAXLOT))
    aux=MarketInfo(MainSymbol,MODE_MAXLOT);
      
  if (aux<MarketInfo(MainSymbol,MODE_MINLOT))
    aux=MarketInfo(MainSymbol,MODE_MINLOT);
  
  return(aux);
}

// ------------------------------------------------------------------------------------------------
// CALCULATE PIP VALUE
// ------------------------------------------------------------------------------------------------
double CalculatePipValue(double volume)
{ 
   double aux_mm_value=0;
   
   double aux_mm_tick_value = MarketInfo(MainSymbol, MODE_TICKVALUE);
   double aux_mm_tick_size = MarketInfo(MainSymbol, MODE_TICKSIZE);
   int aux_mm_digits = MarketInfo(MainSymbol,MODE_DIGITS);   
   double aux_mm_veces_lots;
   
   if (volume!=0)
   {
     aux_mm_veces_lots = 1/volume;
      
     if (aux_mm_digits==5 || aux_mm_digits==3)
     {
       aux_mm_value=aux_mm_tick_value*10;
     }
     else if (aux_mm_digits==4 || aux_mm_digits==2)
     {
       aux_mm_value = aux_mm_tick_value;
     }
   
     aux_mm_value = aux_mm_value/aux_mm_veces_lots;
   }  
   
   return(aux_mm_value);
}

// ------------------------------------------------------------------------------------------------
// CALCULATE TAKE PROFIT
// ------------------------------------------------------------------------------------------------
double CalculateTP(double volume)
{ 
  int aux_take_profit;      
  
  aux_take_profit=grid_size*CalculatePipValue(volume);  

  return(aux_take_profit);
}

// ------------------------------------------------------------------------------------------------
// CALCULATE STOP LOSS
// ------------------------------------------------------------------------------------------------
double CalculateSL(double volume)
{ 
  int aux_stop_loss;      
  
  aux_stop_loss=-1*grid_size*CalculatePipValue(volume);
    
  return(aux_stop_loss);
}

// ------------------------------------------------------------------------------------------------
// ROBOT
// ------------------------------------------------------------------------------------------------
void Robot()
{
  int  i;
  bool cerrada,cerrada1;  
  bool ticket,ticket1;
  
  double ima_192 = iMA(NULL, PERIOD_M15, 5, 0, MODE_SMA, PRICE_CLOSE, 0);
  double ima_200 = iMA(NULL, PERIOD_M15, 13, 0, MODE_SMA, PRICE_CLOSE, 0);
  double ima_208 = iMA(NULL, PERIOD_M15, 21, 0, MODE_SMA, PRICE_CLOSE, 0);
  double ima_216 = iMA(NULL, PERIOD_M15, 60, 0, MODE_SMA, PRICE_CLOSE, 0);
  double ima_224 = iMA(NULL, PERIOD_M15, 200, 0, MODE_SMA, PRICE_CLOSE, 0);
  
  double KDJ_1=iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 0);
  double KDJ_2=iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 0);
  
  // *************************
  // ACCOUNT RISK CONTROL
  // *************************
  if (((100-account_risk)/100)*AccountBalance()>AccountEquity())
  {
    // Closing buy orders
    for (i=buys-1; i>=0; i--) 
    {
      cerrada=OrderCloseReliable(buy_tickets[i],buy_lots[i],MarketInfo(MainSymbol,MODE_BID),slippage,Blue);
      if(cerrada>0)
      {  cerrada1=OrderCloseReliable(sell_tickets[i],sell_lots[i],MarketInfo(MainSymbol,MODE_ASK),slippage,Red);
      }
    }
    // Closing sell orders
    for (i=sells-1; i>=0; i--) 
    {
      cerrada=OrderCloseReliable(sell_tickets[i],sell_lots[i],MarketInfo(MainSymbol,MODE_ASK),slippage,Red);
      if(cerrada>0)
      {      
      cerrada1=OrderCloseReliable(buy_tickets[i],buy_lots[i],MarketInfo(FollowSymbol,MODE_BID),slippage,Blue);
      }
    }
    BuyResetAfterClose();
    SellResetAfterClose();
  }  
  
  // **************************************************
  // BUYS==0
  // **************************************************
  if (buys==0&&buys<=MaxTrade&&(TradeTime ()))
  {
    if (ima_192 > ima_200 && ima_200 > ima_208 && ima_208 > ima_216 && ima_216 > ima_224 && ima_192 - ima_208 > 0.004&&KDJ_1-KDJ_2>2) 
    {
      ticket = OrderSendReliable(MainSymbol,OP_BUY,CalculateStartingVolume(),MarketInfo(MainSymbol,MODE_ASK),slippage,0,0,key,magic,0,Blue);
      
      if(ticket>0)
      {
       ticket1 = OrderSendReliable(FollowSymbol,OP_SELL,CalculateStartingVolume(),MarketInfo(FollowSymbol,MODE_BID),slippage,0,0,key,magic,0,Red);
       }
       
      Sleep(3000); 
      }     
  }  
  

  // **************************************************
  // BUYS>=1
  // **************************************************  
  if (buys>=1&&buys<=MaxTrade&&(TradeTime ()))
  {
    // CASE 1 >>> We reach Stop Loss (grid size)    
    if (total_buy_profit < CalculateSL(total_buy_lots))
    {
      if (ima_192 > ima_200 && ima_200 > ima_208 && ima_208 > ima_216 && ima_216 > ima_224 && ima_192 - ima_208 > 0.004&&KDJ_1-KDJ_2>2) 
      {
        ticket = OrderSendReliable(MainSymbol,OP_BUY,MartingaleVolume(total_buy_profit),MarketInfo(MainSymbol,MODE_ASK),slippage,0,0,key,magic,0,Blue); 
        if(ticket>0)
        {
        ticket1 = OrderSendReliable(FollowSymbol,OP_SELL,MartingaleVolume(total_buy_profit),MarketInfo(FollowSymbol,MODE_BID),slippage,0,0,key,magic,0,Red); 
        }
        
        Sleep(3000);
      }
    } 
    }
    
    // CASE 2.1 >>> We reach Take Profit so we activate profit lock
    if (buy_max_profit==0 && profit_mode==1 && total_buy_profit > CalculateTP(buy_lots[0]))
    {
      buy_max_profit = total_buy_profit;
      buy_close_profit = profit_lock*buy_max_profit;
    }
    if (buy_max_profit==0 && profit_mode==2 && total_buy_profit > (CalculateTP(total_buy_lots)/buys))
    {
      buy_max_profit = total_buy_profit;
      buy_close_profit = profit_lock*buy_max_profit;
    }
    
    // CASE 2.2 >>> Profit locked is updated in real time
    if (buy_max_profit>0)
    {
      if (total_buy_profit>buy_max_profit)
      {      
        buy_max_profit = total_buy_profit;
        buy_close_profit = profit_lock*total_buy_profit; 
      }
    }   
    
    // CASE 2.3 >>> If profit falls below profit locked we close all orders
    if (buy_max_profit>0 && buy_close_profit>0 && buy_max_profit>buy_close_profit && total_buy_profit<buy_close_profit) 
    {
      // Cerramos las ordenes
      for (i=buys-1; i>=0; i--) 
      {
        cerrada=OrderCloseReliable(buy_tickets[i],buy_lots[i],MarketInfo(MainSymbol,MODE_BID),slippage,Blue);
        
       if( cerrada>0)
       {
        cerrada1=OrderCloseReliable(sell_tickets[i],sell_lots[i],MarketInfo(MainSymbol,MODE_ASK),slippage,Red);
        }
      }
      // At this point all orders are closed. Global vars will be updated thanks to UpdateVars() on next start() execution
      BuyResetAfterClose();
    }      
   // if (buys>1)
  
  // **************************************************
  // SELLS==0
  // **************************************************
  if (sells==0&&sells<=MaxTrade&&(TradeTime ()))
  {
    if (ima_192 < ima_200 && ima_200 < ima_208 && ima_208 < ima_216 && ima_216 < ima_224 && ima_208 - ima_192 > 0.004&&KDJ_2-KDJ_1>2) 
    {  ticket = OrderSendReliable(MainSymbol,OP_SELL,CalculateStartingVolume(),MarketInfo(MainSymbol,MODE_BID),slippage,0,0,key,magic,0,Red);  
     
     if(ticket>0)
     {
      ticket1 = OrderSendReliable(FollowSymbol,OP_BUY,CalculateStartingVolume(),MarketInfo(FollowSymbol,MODE_ASK),slippage,0,0,key,magic,0,Blue);  
     }
      Sleep(3000); 
  }  
  }
  
  // **************************************************
  // SELLS>=1
  // **************************************************  
  if (sells>=1&&sells<=MaxTrade&&(TradeTime ()))
  {
    // CASE 1 >>> We reach Stop Loss (grid size)   
    if (total_sell_profit < CalculateSL(total_sell_lots))
    {
      if (ima_192 < ima_200 && ima_200 < ima_208 && ima_208 < ima_216 && ima_216 < ima_224 && ima_208 - ima_192 > 0.004&&KDJ_2-KDJ_1>2)
      {
        ticket = OrderSendReliable(MainSymbol,OP_SELL,MartingaleVolume(total_sell_profit),MarketInfo(MainSymbol,MODE_BID),slippage,0,0,key,magic,0,Red); 
        if(ticket>0)
     {
        ticket = OrderSendReliable(FollowSymbol,OP_BUY,MartingaleVolume(total_sell_profit),MarketInfo(FollowSymbol,MODE_ASK),slippage,0,0,key,magic,0,Blue); 

     }
       
       
        Sleep(3000);
      }
    } 
    }
    
    // CASE 2.1 >>> We reach Take Profit so we activate profit lock
    if (sell_max_profit==0 && profit_mode==1 && total_sell_profit > CalculateTP(sell_lots[0]))
    {
      sell_max_profit = total_sell_profit;
      sell_close_profit = profit_lock*sell_max_profit;
    }
    if (sell_max_profit==0 && profit_mode==2 && total_sell_profit > (CalculateTP(total_sell_lots)/sells))
    {
      sell_max_profit = total_sell_profit;
      sell_close_profit = profit_lock*sell_max_profit;
    }
    
    // CASE 2.2 >>> Profit locked is updated in real time
    if (sell_max_profit>0)
    {
      if (total_sell_profit>sell_max_profit)
      {      
        sell_max_profit = total_sell_profit;
        sell_close_profit = profit_lock*sell_max_profit;
      }
    }   
    
    // CASE 2.3 >>> If profit falls below profit locked we close all orders
    if (sell_max_profit>0 && sell_close_profit>0 && sell_max_profit>sell_close_profit && total_sell_profit<sell_close_profit) 
    {
      for (i=sells-1; i>=0; i--) 
      {
        cerrada=OrderCloseReliable(sell_tickets[i],sell_lots[i],MarketInfo(MainSymbol,MODE_ASK),slippage,Red);
        if(cerrada>0)
        {
        cerrada1=OrderCloseReliable(buy_tickets[i],buy_lots[i],MarketInfo(FollowSymbol,MODE_BID),slippage,Blue);
        }
      }
      // At this point all orders are closed. Global vars will be updated thanks to UpdateVars() on next start() execution
      SellResetAfterClose();  
    }   
       
  } // if (sells>1)  
  
  
    



//=============================================================================
//							 OrderSendReliable()
//
//	This is intended to be a drop-in replacement for OrderSend() which, 
//	one hopes, is more resistant to various forms of errors prevalent 
//	with MetaTrader.
//			  
//	RETURN VALUE: 
//
//	Ticket number or -1 under some error conditions.  Check
// final error returned by Metatrader with OrderReliableLastErr().
// This will reset the value from GetLastError(), so in that sense it cannot
// be a total drop-in replacement due to Metatrader flaw. 
//
//	FEATURES:
//
//		 * Re-trying under some error conditions, sleeping a random 
//		   time defined by an exponential probability distribution.
//
//		 * Automatic normalization of Digits
//
//		 * Automatically makes sure that stop levels are more than
//		   the minimum stop distance, as given by the server. If they
//		   are too close, they are adjusted.
//
//		 * Automatically converts stop orders to market orders 
//		   when the stop orders are rejected by the server for 
//		   being to close to market.  NOTE: This intentionally
//       applies only to OP_BUYSTOP and OP_SELLSTOP, 
//       OP_BUYLIMIT and OP_SELLLIMIT are not converted to market
//       orders and so for prices which are too close to current
//       this function is likely to loop a few times and return
//       with the "invalid stops" error message. 
//       Note, the commentary in previous versions erroneously said
//       that limit orders would be converted.  Note also
//       that entering a BUYSTOP or SELLSTOP new order is distinct
//       from setting a stoploss on an outstanding order; use
//       OrderModifyReliable() for that. 
//
//		 * Displays various error messages on the log for debugging.
//
//
//	Matt Kennel, 2006-05-28 and following
//
//=============================================================================
int OrderSendReliable(string symbol, int cmd, double volume, double price,
					  int slippage, double stoploss, double takeprofit,
					  string comment, int magic, datetime expiration = 0, 
					  color arrow_color = CLR_NONE) 
{

	// ------------------------------------------------
	// Check basic conditions see if trade is possible. 
	// ------------------------------------------------
	OrderReliable_Fname = "OrderSendReliable";
	OrderReliablePrint(" attempted " + OrderReliable_CommandString(cmd) + " " + volume + 
						" lots @" + price + " sl:" + stoploss + " tp:" + takeprofit); 
						
	//if (!IsConnected()) 
	//{
	//	OrderReliablePrint("error: IsConnected() == false");
	//	_OR_err = ERR_NO_CONNECTION; 
	//	return(-1);
	//}
	
	if (IsStopped()) 
	{
		OrderReliablePrint("error: IsStopped() == true");
		_OR_err = ERR_COMMON_ERROR; 
		return(-1);
	}
	
	int cnt = 0;
	while(!IsTradeAllowed() && cnt < retry_attempts) 
	{
		OrderReliable_SleepRandomTime(sleep_time, sleep_maximum); 
		cnt++;
	}
	
	if (!IsTradeAllowed()) 
	{
		OrderReliablePrint("error: no operation possible because IsTradeAllowed()==false, even after retries.");
		_OR_err = ERR_TRADE_CONTEXT_BUSY; 

		return(-1);  
	}

	// Normalize all price / stoploss / takeprofit to the proper # of digits.
	int digits = MarketInfo(symbol, MODE_DIGITS);
	if (digits > 0) 
	{
		price = NormalizeDouble(price, digits);
		stoploss = NormalizeDouble(stoploss, digits);
		takeprofit = NormalizeDouble(takeprofit, digits); 
	}
	
	if (stoploss != 0) 
		OrderReliable_EnsureValidStop(symbol, price, stoploss); 

	int err = GetLastError(); // clear the global variable.  
	err = 0; 
	_OR_err = 0; 
	bool exit_loop = false;
	bool limit_to_market = false; 
	
	// limit/stop order. 
	int ticket=-1;

	if ((cmd == OP_BUYSTOP) || (cmd == OP_SELLSTOP) || (cmd == OP_BUYLIMIT) || (cmd == OP_SELLLIMIT)) 
	{
		cnt = 0;
		while (!exit_loop) 
		{
			if (IsTradeAllowed()) 
			{
				ticket = OrderSend(symbol, cmd, volume, price, slippage, stoploss, 
									takeprofit, "EAHub"+comment, magic, expiration, arrow_color);
				err = GetLastError();
				_OR_err = err; 
			} 
			else 
			{
				cnt++;
			} 
			
			switch (err) 
			{
				case ERR_NO_ERROR:
					exit_loop = true;
					break;
				
				// retryable errors
				case ERR_SERVER_BUSY:
				case ERR_NO_CONNECTION:
				case ERR_INVALID_PRICE:
				case ERR_OFF_QUOTES:
				case ERR_BROKER_BUSY:
				case ERR_TRADE_CONTEXT_BUSY: 
					cnt++; 
					break;
					
				case ERR_PRICE_CHANGED:
				case ERR_REQUOTE:
					RefreshRates();
					continue;	// we can apparently retry immediately according to MT docs.
					
				case ERR_INVALID_STOPS:
					double servers_min_stop = MarketInfo(symbol, MODE_STOPLEVEL) * MarketInfo(symbol, MODE_POINT); 
					if (cmd == OP_BUYSTOP) 
					{
						// If we are too close to put in a limit/stop order so go to market.
						if (MathAbs(MarketInfo(symbol,MODE_ASK) - price) <= servers_min_stop)	
							limit_to_market = true; 
							
					} 
					else if (cmd == OP_SELLSTOP) 
					{
						// If we are too close to put in a limit/stop order so go to market.
						if (MathAbs(MarketInfo(symbol,MODE_BID) - price) <= servers_min_stop)
							limit_to_market = true; 
					}
					exit_loop = true; 
					break; 
					
				default:
					// an apparently serious error.
					exit_loop = true;
					break; 
					
			}  // end switch 

			if (cnt > retry_attempts) 
				exit_loop = true; 
			 	
			if (exit_loop) 
			{
				if (err != ERR_NO_ERROR) 
				{
					OrderReliablePrint("non-retryable error: " + OrderReliableErrTxt(err)); 
				}
				if (cnt > retry_attempts) 
				{
					OrderReliablePrint("retry attempts maxed at " + retry_attempts); 
				}
			}
			 
			if (!exit_loop) 
			{
				OrderReliablePrint("retryable error (" + cnt + "/" + retry_attempts + 
									"): " + OrderReliableErrTxt(err)); 
				OrderReliable_SleepRandomTime(sleep_time, sleep_maximum); 
				RefreshRates(); 
			}
		}
		 
		// We have now exited from loop. 
		if (err == ERR_NO_ERROR) 
		{
			OrderReliablePrint("apparently successful OP_BUYSTOP or OP_SELLSTOP order placed, details follow.");
			OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES); 
			OrderPrint(); 
			return(ticket); // SUCCESS! 
		} 
		if (!limit_to_market) 
		{
			OrderReliablePrint("failed to execute stop or limit order after " + cnt + " retries");
			OrderReliablePrint("failed trade: " + OrderReliable_CommandString(cmd) + " " + symbol + 
								"@" + price + " tp@" + takeprofit + " sl@" + stoploss); 
			OrderReliablePrint("last error: " + OrderReliableErrTxt(err)); 
			return(-1); 
		}
	}  // end	  
  
	if (limit_to_market) 
	{
		OrderReliablePrint("going from limit order to market order because market is too close.");
		if ((cmd == OP_BUYSTOP) || (cmd == OP_BUYLIMIT)) 
		{
			cmd = OP_BUY;
			price = MarketInfo(symbol,MODE_ASK);
		} 
		else if ((cmd == OP_SELLSTOP) || (cmd == OP_SELLLIMIT)) 
		{
			cmd = OP_SELL;
			price = MarketInfo(symbol,MODE_BID);
		}	
	}
	
	// we now have a market order.
	err = GetLastError(); // so we clear the global variable.  
	err = 0; 
	_OR_err = 0; 
	ticket = -1;

	if ((cmd == OP_BUY) || (cmd == OP_SELL)) 
	{
		cnt = 0;
		while (!exit_loop) 
		{
			if (IsTradeAllowed()) 
			{
				ticket = OrderSend(symbol, cmd, volume, price, slippage, 
									stoploss, takeprofit, "EAHub"+comment, magic, 
									expiration, arrow_color);
				err = GetLastError();
				_OR_err = err; 
			} 
			else 
			{
				cnt++;
			} 
			switch (err) 
			{
				case ERR_NO_ERROR:
					exit_loop = true;
					break;
					
				case ERR_SERVER_BUSY:
				case ERR_NO_CONNECTION:
				case ERR_INVALID_PRICE:
				case ERR_OFF_QUOTES:
				case ERR_BROKER_BUSY:
				case ERR_TRADE_CONTEXT_BUSY: 
					cnt++; // a retryable error
					break;
					
				case ERR_PRICE_CHANGED:
				case ERR_REQUOTE:
					RefreshRates();
					continue; // we can apparently retry immediately according to MT docs.
					
				default:
					// an apparently serious, unretryable error.
					exit_loop = true;
					break; 
					
			}  // end switch 

			if (cnt > retry_attempts) 
			 	exit_loop = true; 
			 	
			if (!exit_loop) 
			{
				OrderReliablePrint("retryable error (" + cnt + "/" + 
									retry_attempts + "): " + OrderReliableErrTxt(err)); 
				OrderReliable_SleepRandomTime(sleep_time,sleep_maximum); 
				RefreshRates(); 
			}
			
			if (exit_loop) 
			{
				if (err != ERR_NO_ERROR) 
				{
					OrderReliablePrint("non-retryable error: " + OrderReliableErrTxt(err)); 
				}
				if (cnt > retry_attempts) 
				{
					OrderReliablePrint("retry attempts maxed at " + retry_attempts); 
				}
			}
		}
		
		// we have now exited from loop. 
		if (err == ERR_NO_ERROR) 
		{
			OrderReliablePrint("apparently successful OP_BUY or OP_SELL order placed, details follow.");
			OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES); 
			OrderPrint(); 
			return(ticket); // SUCCESS! 
		} 
		OrderReliablePrint("failed to execute OP_BUY/OP_SELL, after " + cnt + " retries");
		OrderReliablePrint("failed trade: " + OrderReliable_CommandString(cmd) + " " + symbol + 
							"@" + price + " tp@" + takeprofit + " sl@" + stoploss); 
		OrderReliablePrint("last error: " + OrderReliableErrTxt(err)); 
		return(-1); 
	}
return(0);}
	
//=============================================================================
int OrderSendReliableMKT(string symbol, int cmd, double volume, double price,
					  int slippage, double stoploss, double takeprofit,
					  string comment, int magic, datetime expiration = 0, 
					  color arrow_color = CLR_NONE) 
{

	// ------------------------------------------------
	// Check basic conditions see if trade is possible. 
	// ------------------------------------------------
	OrderReliable_Fname = "OrderSendReliableMKT";
	OrderReliablePrint(" attempted " + OrderReliable_CommandString(cmd) + " " + volume + 
						" lots @" + price + " sl:" + stoploss + " tp:" + takeprofit); 

   if ((cmd != OP_BUY) && (cmd != OP_SELL)) {
      OrderReliablePrint("Improper non market-order command passed.  Nothing done.");
      _OR_err = ERR_MALFUNCTIONAL_TRADE; 
      return(-1);
   }

	//if (!IsConnected()) 
	//{
	//	OrderReliablePrint("error: IsConnected() == false");
	//	_OR_err = ERR_NO_CONNECTION; 
	//	return(-1);
	//}
	
	if (IsStopped()) 
	{
		OrderReliablePrint("error: IsStopped() == true");
		_OR_err = ERR_COMMON_ERROR; 
		return(-1);
	}
	
	int cnt = 0;
	while(!IsTradeAllowed() && cnt < retry_attempts) 
	{
		OrderReliable_SleepRandomTime(sleep_time, sleep_maximum); 
		cnt++;
	}
	
	if (!IsTradeAllowed()) 
	{
		OrderReliablePrint("error: no operation possible because IsTradeAllowed()==false, even after retries.");
		_OR_err = ERR_TRADE_CONTEXT_BUSY; 

		return(-1);  
	}

	// Normalize all price / stoploss / takeprofit to the proper # of digits.
	int digits = MarketInfo(symbol, MODE_DIGITS);
	if (digits > 0) 
	{
		price = NormalizeDouble(price, digits);
		stoploss = NormalizeDouble(stoploss, digits);
		takeprofit = NormalizeDouble(takeprofit, digits); 
	}
	
	if (stoploss != 0) 
		OrderReliable_EnsureValidStop(symbol, price, stoploss); 

	int err = GetLastError(); // clear the global variable.  
	err = 0; 
	_OR_err = 0; 
	bool exit_loop = false;
	
	// limit/stop order. 
	int ticket=-1;

	// we now have a market order.
	err = GetLastError(); // so we clear the global variable.  
	err = 0; 
	_OR_err = 0; 
	ticket = -1;

	if ((cmd == OP_BUY) || (cmd == OP_SELL)) 
	{
		cnt = 0;
		while (!exit_loop) 
		{
			if (IsTradeAllowed()) 
			{
            double pnow = price;
            int slippagenow = slippage;
            if (cmd == OP_BUY) {
            	// modification by Paul Hampton-Smith to replace RefreshRates()
               pnow = NormalizeDouble(MarketInfo(symbol,MODE_ASK),MarketInfo(symbol,MODE_DIGITS)); // we are buying at Ask
               if (pnow > price) {
                  slippagenow = slippage - (pnow-price)/MarketInfo(symbol,MODE_POINT); 
               }
            } else if (cmd == OP_SELL) {
            	// modification by Paul Hampton-Smith to replace RefreshRates()
               pnow = NormalizeDouble(MarketInfo(symbol,MODE_BID),MarketInfo(symbol,MODE_DIGITS)); // we are buying at Ask
               if (pnow < price) {
                  // moved in an unfavorable direction
                  slippagenow = slippage - (price-pnow)/MarketInfo(symbol,MODE_POINT);
               }
            }
            if (slippagenow > slippage) slippagenow = slippage; 
            if (slippagenow >= 0) {
            
				   ticket = OrderSend(symbol, cmd, volume, pnow, slippagenow, 
									stoploss, takeprofit, "EAHub"+comment, magic, 
									expiration, arrow_color);
			   	err = GetLastError();
			   	_OR_err = err; 
			  } else {
			      // too far away, manually signal ERR_INVALID_PRICE, which
			      // will result in a sleep and a retry. 
			      err = ERR_INVALID_PRICE;
			      _OR_err = err; 
			  }
			} 
			else 
			{
				cnt++;
			} 
			switch (err) 
			{
				case ERR_NO_ERROR:
					exit_loop = true;
					break;
					
				case ERR_SERVER_BUSY:
				case ERR_NO_CONNECTION:
				case ERR_INVALID_PRICE:
				case ERR_OFF_QUOTES:
				case ERR_BROKER_BUSY:
				case ERR_TRADE_CONTEXT_BUSY: 
					cnt++; // a retryable error
					break;
					
				case ERR_PRICE_CHANGED:
				case ERR_REQUOTE:
					// Paul Hampton-Smith removed RefreshRates() here and used MarketInfo() above instead
					continue; // we can apparently retry immediately according to MT docs.
					
				default:
					// an apparently serious, unretryable error.
					exit_loop = true;
					break; 
					
			}  // end switch 

			if (cnt > retry_attempts) 
			 	exit_loop = true; 
			 	
			if (!exit_loop) 
			{
				OrderReliablePrint("retryable error (" + cnt + "/" + 
									retry_attempts + "): " + OrderReliableErrTxt(err)); 
				OrderReliable_SleepRandomTime(sleep_time,sleep_maximum); 
			}
			
			if (exit_loop) 
			{
				if (err != ERR_NO_ERROR) 
				{
					OrderReliablePrint("non-retryable error: " + OrderReliableErrTxt(err)); 
				}
				if (cnt > retry_attempts) 
				{
					OrderReliablePrint("retry attempts maxed at " + retry_attempts); 
				}
			}
		}
		
		// we have now exited from loop. 
		if (err == ERR_NO_ERROR) 
		{
			OrderReliablePrint("apparently successful OP_BUY or OP_SELL order placed, details follow.");
			OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES); 
			OrderPrint(); 
			return(ticket); // SUCCESS! 
		} 
		OrderReliablePrint("failed to execute OP_BUY/OP_SELL, after " + cnt + " retries");
		OrderReliablePrint("failed trade: " + OrderReliable_CommandString(cmd) + " " + symbol + 
							"@" + price + " tp@" + takeprofit + " sl@" + stoploss); 
		OrderReliablePrint("last error: " + OrderReliableErrTxt(err)); 
		return(-1); 
	}
}
		
	

bool OrderModifyReliable(int ticket, double price, double stoploss, 
						 double takeprofit, datetime expiration, 
						 color arrow_color = CLR_NONE) 
{
	OrderReliable_Fname = "OrderModifyReliable";

	OrderReliablePrint(" attempted modify of #" + ticket + " price:" + price + 
						" sl:" + stoploss + " tp:" + takeprofit); 

	//if (!IsConnected()) 
	//{
	//	OrderReliablePrint("error: IsConnected() == false");
	//	_OR_err = ERR_NO_CONNECTION; 
	//	return(false);
	//}
	
	if (IsStopped()) 
	{
		OrderReliablePrint("error: IsStopped() == true");
		return(false);
	}
	
	int cnt = 0;
	while(!IsTradeAllowed() && cnt < retry_attempts) 
	{
		OrderReliable_SleepRandomTime(sleep_time,sleep_maximum); 
		cnt++;
	}
	if (!IsTradeAllowed()) 
	{
		OrderReliablePrint("error: no operation possible because IsTradeAllowed()==false, even after retries.");
		_OR_err = ERR_TRADE_CONTEXT_BUSY; 
		return(false);  
	}


	
	if (false) {
		 // This section is 'nulled out', because
		 // it would have to involve an 'OrderSelect()' to obtain
		 // the symbol string, and that would change the global context of the
		 // existing OrderSelect, and hence would not be a drop-in replacement
		 // for OrderModify().
		 //
		 // See OrderModifyReliableSymbol() where the user passes in the Symbol 
		 // manually.
		 
		 OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);
		 string symbol = OrderSymbol();
		 int digits = MarketInfo(symbol,MODE_DIGITS);
		 if (digits > 0) {
			 price = NormalizeDouble(price,digits);
			 stoploss = NormalizeDouble(stoploss,digits);
			 takeprofit = NormalizeDouble(takeprofit,digits); 
		 }
		 if (stoploss != 0) OrderReliable_EnsureValidStop(symbol,price,stoploss); 
	}



	int err = GetLastError(); // so we clear the global variable.  
	err = 0; 
	_OR_err = 0; 
	bool exit_loop = false;
	cnt = 0;
	bool result = false;
	
	while (!exit_loop) 
	{
		if (IsTradeAllowed()) 
		{
			result = OrderModify(ticket, price, stoploss, 
								 takeprofit, expiration, arrow_color);
			err = GetLastError();
			_OR_err = err; 
		} 
		else 
			cnt++;

		if (result == true) 
			exit_loop = true;

		switch (err) 
		{
			case ERR_NO_ERROR:
				exit_loop = true;
				break;
				
			case ERR_NO_RESULT:
				// modification without changing a parameter. 
				// if you get this then you may want to change the code.
				exit_loop = true;
				break;
				
			case ERR_SERVER_BUSY:
			case ERR_NO_CONNECTION:
			case ERR_INVALID_PRICE:
			case ERR_OFF_QUOTES:
			case ERR_BROKER_BUSY:
			case ERR_TRADE_CONTEXT_BUSY: 
			case ERR_TRADE_TIMEOUT:		// for modify this is a retryable error, I hope. 
				cnt++; 	// a retryable error
				break;
				
			case ERR_PRICE_CHANGED:
			case ERR_REQUOTE:
				RefreshRates();
				continue; 	// we can apparently retry immediately according to MT docs.
				
			default:
				// an apparently serious, unretryable error.
				exit_loop = true;
				break; 
				
		}  // end switch 

		if (cnt > retry_attempts) 
			exit_loop = true; 
			
		if (!exit_loop) 
		{
			OrderReliablePrint("retryable error (" + cnt + "/" + retry_attempts + 
								"): "  +  OrderReliableErrTxt(err)); 
			OrderReliable_SleepRandomTime(sleep_time,sleep_maximum); 
			RefreshRates(); 
		}
		
		if (exit_loop) 
		{
			if ((err != ERR_NO_ERROR) && (err != ERR_NO_RESULT)) 
				OrderReliablePrint("non-retryable error: "  + OrderReliableErrTxt(err)); 

			if (cnt > retry_attempts) 
				OrderReliablePrint("retry attempts maxed at " + retry_attempts); 
		}
	}  
	
	// we have now exited from loop. 
	if ((result == true) || (err == ERR_NO_ERROR)) 
	{
		OrderReliablePrint("apparently successful modification order, updated trade details follow.");
		OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES); 
		OrderPrint(); 
		return(true); // SUCCESS! 
	} 
	
	if (err == ERR_NO_RESULT) 
	{
		OrderReliablePrint("Server reported modify order did not actually change parameters.");
		OrderReliablePrint("redundant modification: "  + ticket + " " + symbol + 
							"@" + price + " tp@" + takeprofit + " sl@" + stoploss); 
		OrderReliablePrint("Suggest modifying code logic to avoid."); 
		return(true);
	}
	
	OrderReliablePrint("failed to execute modify after " + cnt + " retries");
	OrderReliablePrint("failed modification: "  + ticket + " " + symbol + 
						"@" + price + " tp@" + takeprofit + " sl@" + stoploss); 
	OrderReliablePrint("last error: " + OrderReliableErrTxt(err)); 
	
	return(false);  
}
 
 
//=============================================================================
//
//						OrderModifyReliableSymbol()
//
//	This has the same calling sequence as OrderModify() except that the 
//	user must provide the symbol.
//
//	This function will then be able to ensure proper normalization and 
//	stop levels.
//
//=============================================================================
bool OrderModifyReliableSymbol(string symbol, int ticket, double price, 
							   double stoploss, double takeprofit, 
							   datetime expiration, color arrow_color = CLR_NONE) 
{
	int digits = MarketInfo(symbol, MODE_DIGITS);
	
	if (digits > 0) 
	{
		price = NormalizeDouble(price, digits);
		stoploss = NormalizeDouble(stoploss, digits);
		takeprofit = NormalizeDouble(takeprofit, digits); 
	}
	
	if (stoploss != 0) 
		OrderReliable_EnsureValidStop(symbol, price, stoploss); 
		
	return(OrderModifyReliable(ticket, price, stoploss, 
								takeprofit, expiration, arrow_color)); 
	
}
 
 

bool OrderCloseReliable(int ticket, double lots, double price, 
						int slippage, color arrow_color = CLR_NONE) 
{
	int nOrderType;
	string strSymbol;
	OrderReliable_Fname = "OrderCloseReliable";
	
	OrderReliablePrint(" attempted close of #" + ticket + " price:" + price + 
						" lots:" + lots + " slippage:" + slippage); 

// collect details of order so that we can use GetMarketInfo later if needed
	if (!OrderSelect(ticket,SELECT_BY_TICKET))
	{
		_OR_err = GetLastError();		
		OrderReliablePrint("error: " + ErrorDescription(_OR_err));
		return(false);
	}
	else
	{
		nOrderType = OrderType();
		strSymbol = OrderSymbol();
	}

	if (nOrderType != OP_BUY && nOrderType != OP_SELL)
	{
		_OR_err = ERR_INVALID_TICKET;
		OrderReliablePrint("error: trying to close ticket #" + ticket + ", which is " + OrderReliable_CommandString(nOrderType) + ", not OP_BUY or OP_SELL");
		return(false);
	}

	//if (!IsConnected()) 
	//{
	//	OrderReliablePrint("error: IsConnected() == false");
	//	_OR_err = ERR_NO_CONNECTION; 
	//	return(false);
	//}
	
	if (IsStopped()) 
	{
		OrderReliablePrint("error: IsStopped() == true");
		return(false);
	}

	
	int cnt = 0;


	int err = GetLastError(); // so we clear the global variable.  
	err = 0; 
	_OR_err = 0; 
	bool exit_loop = false;
	cnt = 0;
	bool result = false;
	
	while (!exit_loop) 
	{
		if (IsTradeAllowed()) 
		{
			result = OrderClose(ticket, lots, price, slippage, arrow_color);
			err = GetLastError();
			_OR_err = err; 
		} 
		else 
			cnt++;

		if (result == true) 
			exit_loop = true;

		switch (err) 
		{
			case ERR_NO_ERROR:
				exit_loop = true;
				break;
				
			case ERR_SERVER_BUSY:
			case ERR_NO_CONNECTION:
			case ERR_INVALID_PRICE:
			case ERR_OFF_QUOTES:
			case ERR_BROKER_BUSY:
			case ERR_TRADE_CONTEXT_BUSY: 
			case ERR_TRADE_TIMEOUT:		// for modify this is a retryable error, I hope. 
				cnt++; 	// a retryable error
				break;
				
			case ERR_PRICE_CHANGED:
			case ERR_REQUOTE:
				continue; 	// we can apparently retry immediately according to MT docs.
				
			default:
				// an apparently serious, unretryable error.
				exit_loop = true;
				break; 
				
		}  // end switch 

		if (cnt > retry_attempts) 
			exit_loop = true; 
			
		if (!exit_loop) 
		{
			OrderReliablePrint("retryable error (" + cnt + "/" + retry_attempts + 
								"): "  +  OrderReliableErrTxt(err)); 
			OrderReliable_SleepRandomTime(sleep_time,sleep_maximum); 
			// Added by Paul Hampton-Smith to ensure that price is updated for each retry
			if (nOrderType == OP_BUY)  price = NormalizeDouble(MarketInfo(strSymbol,MODE_BID),MarketInfo(strSymbol,MODE_DIGITS));
			if (nOrderType == OP_SELL) price = NormalizeDouble(MarketInfo(strSymbol,MODE_ASK),MarketInfo(strSymbol,MODE_DIGITS));
		}
		
		if (exit_loop) 
		{
			if ((err != ERR_NO_ERROR) && (err != ERR_NO_RESULT)) 
				OrderReliablePrint("non-retryable error: "  + OrderReliableErrTxt(err)); 

			if (cnt > retry_attempts) 
				OrderReliablePrint("retry attempts maxed at " + retry_attempts); 
		}
	}  
	
	// we have now exited from loop. 
	if ((result == true) || (err == ERR_NO_ERROR)) 
	{
		OrderReliablePrint("apparently successful close order, updated trade details follow.");
		OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES); 
		OrderPrint(); 
		return(true); // SUCCESS! 
	} 
	
	OrderReliablePrint("failed to execute close after " + cnt + " retries");
	OrderReliablePrint("failed close: Ticket #" + ticket + ", Price: " + 
						price + ", Slippage: " + slippage); 
	OrderReliablePrint("last error: " + OrderReliableErrTxt(err)); 
	
	return(false);  
}
 
 

//=============================================================================
//=============================================================================
//								Utility Functions
//=============================================================================
//=============================================================================



int OrderReliableLastErr() 
{
	return (_OR_err); 
}


string OrderReliableErrTxt(int err) 
{
	return ("" + err + ":" + ErrorDescription(err)); 
}


void OrderReliablePrint(string s) 
{
	// Print to log prepended with stuff;
	if (!(IsTesting() || IsOptimization())) Print(OrderReliable_Fname + " " + OrderReliableVersion + ":" + s);
}


string OrderReliable_CommandString(int cmd) 
{
	if (cmd == OP_BUY) 
		return("OP_BUY");

	if (cmd == OP_SELL) 
		return("OP_SELL");

	if (cmd == OP_BUYSTOP) 
		return("OP_BUYSTOP");

	if (cmd == OP_SELLSTOP) 
		return("OP_SELLSTOP");

	if (cmd == OP_BUYLIMIT) 
		return("OP_BUYLIMIT");

	if (cmd == OP_SELLLIMIT) 
		return("OP_SELLLIMIT");

	return("(CMD==" + cmd + ")"); 
}


//=============================================================================
//
//						 OrderReliable_EnsureValidStop()
//
// 	Adjust stop loss so that it is legal.
//
//	Matt Kennel 
//
//=============================================================================
void OrderReliable_EnsureValidStop(string symbol, double price, double& sl) 
{
	// Return if no S/L
	if (sl == 0) 
		return;
	
	double servers_min_stop = MarketInfo(symbol, MODE_STOPLEVEL) * MarketInfo(symbol, MODE_POINT); 
	
	if (MathAbs(price - sl) <= servers_min_stop) 
	{
		// we have to adjust the stop.
		if (price > sl)
			sl = price - servers_min_stop;	// we are long
			
		else if (price < sl)
			sl = price + servers_min_stop;	// we are short
			
		else
			OrderReliablePrint("EnsureValidStop: error, passed in price == sl, cannot adjust"); 
			
		sl = NormalizeDouble(sl, MarketInfo(symbol, MODE_DIGITS)); 
	}
}


//=============================================================================
//
//						 OrderReliable_SleepRandomTime()
//
//	This sleeps a random amount of time defined by an exponential 
//	probability distribution. The mean time, in Seconds is given 
//	in 'mean_time'.
//
//	This is the back-off strategy used by Ethernet.  This will 
//	quantize in tenths of seconds, so don't call this with a too 
//	small a number.  This returns immediately if we are backtesting
//	and does not sleep.
//
//	Matt Kennel mbkennelfx@gmail.com.
//
//=============================================================================
void OrderReliable_SleepRandomTime(double mean_time, double max_time) 
{
	if (IsTesting()) 
		return; 	// return immediately if backtesting.

	double tenths = MathCeil(mean_time / 0.1);
	if (tenths <= 0) 
		return; 
	 
	int maxtenths = MathRound(max_time/0.1); 
	double p = 1.0 - 1.0 / tenths; 
	  
	Sleep(100); 	// one tenth of a second PREVIOUS VERSIONS WERE STUPID HERE. 
	
	for(int i=0; i < maxtenths; i++)  
	{
		if (MathRand() > p*32768) 
			break; 
			
		// MathRand() returns in 0..32767
		Sleep(100); 
	}
}  



 bool TradeTime ()
{
	datetime local_currenttime;
	
	local_currenttime = TimeHour ( TimeCurrent() );	
	if ( DayOfWeek() == 1 && local_currenttime < Monday_StartHour )
		return ( FALSE );
   if ( DayOfWeek() == 5 && local_currenttime > Friday_EndHour ) 
		return ( FALSE );  
   if ( TradeSession ( local_currenttime, Session1_StartHour, Session1_EndHour ) || TradeSession ( local_currenttime, Session2_StartHour, Session2_EndHour ) )
		return ( TRUE );
   return ( FALSE );  
}

bool TradeSession ( double par_currenttime, int par_starthour, int par_endhour )
{
	if ( par_starthour == 0 )
		par_starthour = 24;
	if ( par_endhour == 0 )
		par_endhour = 24;
	if ( par_starthour < par_endhour )
		if ( ( par_currenttime < par_starthour ) || ( par_currenttime >= par_endhour ) )
			return ( FALSE );
	if ( par_starthour > par_endhour )
		if ( ( par_currenttime < par_starthour ) && ( par_currenttime >= par_endhour ) )
			return ( FALSE );			
	return ( TRUE );	
}	