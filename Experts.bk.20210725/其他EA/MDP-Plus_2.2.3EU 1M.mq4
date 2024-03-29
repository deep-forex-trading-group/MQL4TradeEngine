
#property copyright "YANG"
#property version   "1.00"
#property copyright "EA"
#property strict

extern bool   k_g_1 =false;     
extern int    fx_yc =100;       //Abnormal fluctuation
extern double lots  =0.02;      //lots
extern float  zhi_s =1;         //stop($)
extern int    zhi_y =15;        //Take profit
extern int   xiao_b =6;         //1 hour profit multiple
extern int   jie_j  =10;        //Long position profit multiple
extern int    dian_c=2;         //Spread
extern int    magic =88888888;  

int    wei_z =2,
       wei_s =100;     
       
double dian_z=0.01,    
       lots_s;         

int    f_z=0;          
        
int    take;     
datetime time;   
bool   fx_jj =false;      
//+------------------------------------------------------------------+
//                                 |
//+------------------------------------------------------------------+
int OnInit()
  {
      datetime tom=0;
      int AA_1=OrdersTotal();
      if(Point < 0.001)
     {
           dian_z=0.00001;
           wei_z=5;
           wei_s=100000;
     }
     else if(Point == 0.001)
     {
           dian_z=0.001;
           wei_z=3;
           wei_s=1000;
     }
     
     EventSetTimer(1);
     for(int AA=0; AA<AA_1; AA++)
     {
         if(!OrderSelect(AA, SELECT_BY_POS, MODE_TRADES))  break;
         if(OrderSymbol() != Symbol())  continue;
         if(OrderMagicNumber() != magic) continue;
         
         if(OrderOpenTime() > tom)  
         {
             take=OrderTicket();
             tom=OrderOpenTime();
             continue;
         }
         
     }
//---
   return(INIT_SUCCEEDED);
}
 
void OnDeinit(const int reason)
{
    
    EventKillTimer();
}

//+------------------------------------------------------------------+
//|                                       |
//+------------------------------------------------------------------+
void OnTick()
{
    static double prof_lr;    
    static double prof_lr_1=0;
    static datetime time_1 =0;
    int    or_d=0;            
    double jj_ok=0;            
    bool   bo=false;          
    int    AA_1=OrdersTotal();
    
    double stop_lr=0;         
    datetime tme=0;
    int   xy=0;
 
    double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lots<min_volume)
     {
      Print("交易量小于允许的最小交易量，SYMBOL_VOLUME_MIN=%.2f");
      return;
     }   
    for(int A=0; A < AA_1; A++)
    {
        if(!OrderSelect(A, SELECT_BY_POS, MODE_TRADES))  break;
        if(OrderSymbol() != Symbol())  continue;
        if(OrderMagicNumber() != magic) continue;
        
        or_d++;  
        
        if(OrderProfit() < 0)  
               stop_lr +=OrderSwap()+OrderProfit()+OrderCommission();
               
          
        if(TimeCurrent()-14400 <= OrderOpenTime())  fx_jj=true;
     
        if(OrderType() == OP_BUY)
        { 
            if(OrderClosePrice() - OrderOpenPrice() > zhi_y*dian_z)  
            {
                jj_ok=OrderSwap()+OrderProfit()+OrderCommission();
                prof_lr += jj_ok;
                prof_lr_1 +=jj_ok;  
                
                if(OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), dian_c))
                { 
                   
                    
                    if(OrderTicket() != take)  continue;
                  
                      if(f_z==2 && Close[0] - Open[0] < fx_yc*dian_z && Close[0] - Open[0] > 0)
                      {
                           take=OrderSend(Symbol(), OP_SELL, lots_s, Ask, dian_c, 0, 0, "12", magic);
                             time=Time[0];
                             continue;
                      }
                      else if(f_z==1)
                      {
                         take=OrderSend(Symbol(), OP_BUY, lots_s, Bid, dian_c, 0, 0, "11", magic);
                          time=Time[0];
                          continue;
                      }
                      take=0;
                }
            }
         
            if(OrderTicket() != take)  continue;
            if(OrderOpenPrice()-OrderClosePrice() > zhi_y*dian_z)
            {
                
                if(f_z==2)
                {
                     take=OrderSend(Symbol(), OP_SELL, lots_s, Ask, dian_c, 0, 0, "10", magic);
                       time=Time[0];
                       continue;
                }
                else if(f_z==1)
                {
                   take=OrderSend(Symbol(), OP_BUY, lots_s, Bid, dian_c, 0, 0, "9", magic);
                    time=Time[0];
                    continue;
                }
            }
        }
        else if(OrderType() == OP_SELL)
        {
            if(OrderOpenPrice() - OrderClosePrice() > zhi_y*dian_z) 
            {
                jj_ok=OrderSwap()+OrderProfit()+OrderCommission();
                prof_lr += jj_ok;
                prof_lr_1 +=jj_ok; 
                if(OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), dian_c))
                { 
                  
                   
                   if(TimeHour(TimeCurrent())==0)  continue;
                    if(OrderTicket()!=take)  continue;
                   if(f_z==2 && Open[0] - Close[0] < fx_yc*dian_z && Open[0] - Close[0] > 0)
                   {
                        take=OrderSend(Symbol(), OP_BUY, lots_s, Bid, dian_c, 0, 0, "8", magic);
                          time=Time[0];
                          continue;
                   }
                   else if(f_z==1)
                   {
                      take=OrderSend(Symbol(), OP_SELL, lots_s, Ask, dian_c, 0, 0, "7", magic);
                         time=Time[0];
                         continue;
                   }
                   take=0;
                      
                }
            }
            if(OrderTicket()!= take)  continue;
            if(OrderClosePrice() - OrderOpenPrice() > zhi_y*dian_z)
            {
                
                if(f_z==2)
                {
                     take=OrderSend(Symbol(), OP_BUY, lots_s, Bid, dian_c, 0, 0, "6", magic);
                       time=Time[0];
                       continue;
                }
                else if(f_z==1)
                {
                   take=OrderSend(Symbol(), OP_SELL, lots_s, Ask, dian_c, 0, 0, "5", magic);
                      time=Time[0];
                      continue;
                }
            }
        }
    }
    
    if(or_d==0)
    {
        lots_s=lots;  
        time=0;
    }
    if(time_1==0 && prof_lr_1 > 0)
   {
       time_1=TimeCurrent()+900;
   }
     
      if(time != Time[0])
      {
           if(fx_jj)  jj_ok=or_ls();
           xy=0;
           for(int AA=0; AA<AA_1; AA++)
           {
               if(!OrderSelect(AA, SELECT_BY_POS, MODE_TRADES))  break;
               if(OrderSymbol() != Symbol())  continue;
               if(OrderMagicNumber() != magic) continue;
               
                
               if(xy >= 3)
               {
                  bo=OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), dian_c);
                  continue;
               }
               if(prof_lr + stop_lr >= zhi_s || prof_lr + stop_lr >= NormalizeDouble(zhi_s/2, 2))  
               {
                   bo=OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), dian_c);
                   take=0;
                   xy=3;
                   prof_lr=0;
                   continue;
               }
               if(prof_lr_1 + stop_lr >= zhi_s*xiao_b && time_1 < TimeCurrent())
               {
                   bo=OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), dian_c);
                   xy=4;
                   take=0;
                   time_1=TimeCurrent()+900;
                   prof_lr_1=0;
                   continue;
               }
               
               if(fx_jj)
               {
                   if(jj_ok <= 0)  continue;
                   if(jj_ok + stop_lr >= zhi_s*jie_j)  
                   {
                      bo=OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), dian_c);
                      xy=5;
                      continue;
                   }
                     
               }
               
           }
           
           xy=0;
         
          if(or_d > 0 && take > 0)  return;
          
           for(int xx=OrdersTotal()-1; xx>=0; xx--)
          {
              if(!OrderSelect(xx, SELECT_BY_POS, MODE_TRADES))  break;
              if(OrderSymbol() != Symbol())  continue;
              if(OrderMagicNumber() != magic) continue;
              
              if(OrderOpenTime() > tme && OrderType()==OP_BUY) 
              {
                  time=OrderOpenTime();
                  xy=1;
              }
              else if(OrderOpenTime() > tme && OrderType()==OP_SELL) 
              {
                  time=OrderOpenTime();
                  xy=2;
              }
          }
          
          if(xy==1)
          {
              take=OrderSend(Symbol(), OP_SELL, lots_s, Ask, dian_c, 0, 0, "4", magic);
              if(take > 0)
                time=Time[0];
          }
          else if(xy==2)
          {
              take=OrderSend(Symbol(), OP_BUY, lots_s, Bid, dian_c, 0, 0, "3", magic);
              if(take > 0)
                time=Time[0];
          }
          else
          {
              if(Open[1] > Close[1])
              {
                  take=OrderSend(Symbol(), OP_SELL, lots_s, Ask, dian_c, 0, 0, "2", magic);
                 if(take > 0)
                   time=Time[0]; 
              }
              else
              {
                  take=OrderSend(Symbol(), OP_BUY, lots_s, Bid, dian_c, 0, 0, "1", magic);
                 if(take > 0)
                   time=Time[0];
              }  
          }
          if(take<0) f_z=0;
      
      }  
    
}
void OnTimer()
{
      
      int seconds=0;// the left seconds of the current bar
      int h = 0; //Hour
      int m = 0; //Minute
      int s = 0; //Second  hh:mm:ss 
      int   xy=0;
      datetime timee=iTime(Symbol(),PERIOD_CURRENT,0),
               tme=0;
      //double   close = iClose(Symbol(),PERIOD_CURRENT,0);
      
      seconds=PeriodSeconds(PERIOD_CURRENT) -(int)(TimeCurrent()-timee);

      h = seconds/3600;
      m = (seconds - h*3600)/60;
      s = (seconds - h*3600 - m*60);
      
      if(m >= 3 && s>=0) f_z=1;
      else if(m < 3)  f_z=2;
       
}
double or_ls()
{
    static datetime tim=0;
    double   prof_lr4=0;   
    datetime tome;
    if(!k_g_1)  return(0);
    tome=TimeCurrent()-72000;
    for(int x=OrdersHistoryTotal()-1; x>=0; x--)
    {
        if(!OrderSelect(x, SELECT_BY_POS, MODE_HISTORY))
        {
            tim=TimeCurrent()+600;
            break;
        }
        if(OrderSymbol() != Symbol())  continue;
        if(OrderMagicNumber() != magic)  continue;
        if(OrderOpenTime() > tome)
        {
           prof_lr4 += OrderSwap()+OrderProfit()+OrderCommission();
        }
    }
    
    return(prof_lr4);
}
