#property copyright "共同探讨，互帮互助."
#property link      "http://940775881.qzone.qq.com"
#property version   "1.00"
#property description "制作人QQ：940775881"

extern string 喊单ID = "  ";
string srcfile= " "; 
extern string  跟单倍数设置="===============================";
extern string  follow设置=" 当Follow为1时倍数跟单，Follow为0时固定手数下单";                         
extern int follow = 1;
extern double 跟单倍数 = 1;
extern double 固定手数下单 = 0.01;

extern string 跟单货币后缀="";

int MagicN = 20091102;
int single_num;
 int stopp;
 double  Lots;
string gsa_144[50][8];

 
int OnInit()
{
    if(喊单ID == "  ")
       {
          Alert("没有填写跟单账号");
          return (0);
        }
    EventSetTimer(1);
   return(INIT_SUCCEEDED);
}

int deinit() 
{
   ObjectsDeleteAll();
   return (0);
}
void OnTimer()
{
   stopp++;
   int li_0;
   bool li_4;
   int li_8;
   string get_order;
   bool li_24;
   delObj();
  string singl_los = TimeToStr(TimeCurrent(), TIME_MINUTES|TIME_SECONDS);
   writetext("logo2",  "["+singl_los+"]"+"正在运行跟单", 250, 5, clrYellow, 10);
   singl_los = "喊单ID:"+喊单ID;
   writetext("Logo1", singl_los, 10, 100, clrYellow, 10);
   if(stopp<2) return ;     
if(stopp>=20)
   stopp=10;   
  while (true && !IsStopped())
  {
     Sleep(10);
  if (跟单信号() <= 0) return ;
   if (single_num > 0) 
   {
      for (int symbol_txt = 1; symbol_txt < single_num + 1; symbol_txt++) 
      {
        if (StrToInteger(gsa_144[symbol_txt][0]) <= 5) 
         {
           li_4 = TRUE;
            for (li_0 = 0; li_0 < OrdersTotal(); li_0++) 
            {
               if(OrderSelect(li_0, SELECT_BY_POS, MODE_TRADES)== false) continue;                    
                  if (OrderComment() == gsa_144[symbol_txt][7])  
                     {
                        li_4 = FALSE;
                     
                        break;
                     }
            }           
       if (li_4) 
            {
                 {
                    li_24 = 开单(gsa_144[symbol_txt][1]+跟单货币后缀, StrToDouble(gsa_144[symbol_txt][2]), StrToDouble(gsa_144[symbol_txt][4]), StrToDouble(gsa_144[symbol_txt][3]), StrToDouble(gsa_144[symbol_txt][5]), StrToInteger(gsa_144[symbol_txt][0]), gsa_144[symbol_txt][7]);
                   
                 }
            }
         }
      }
   }
  
   double stop1,profit1,op1;
   if (single_num > 0)
   {
      for (symbol_txt = 1; symbol_txt <= single_num; symbol_txt++) 
      {
         if (StrToInteger(gsa_144[symbol_txt][0]) <= 5) 
         {
            for (li_0 = OrdersTotal() - 1; li_0 >= 0; li_0--) 
            {
             if(OrderSelect(li_0, SELECT_BY_POS, MODE_TRADES)== false) continue;             
             if (OrderComment() == gsa_144[symbol_txt][7])
                  {                                         
                      op1=StrToDouble(gsa_144[symbol_txt][2]);
                      stop1=StrToDouble(gsa_144[symbol_txt][4]);
                      profit1=StrToDouble(gsa_144[symbol_txt][3]);
                      TradeModify(StringSubstr(OrderSymbol(),0,6), OrderTicket(), op1, stop1, profit1);                  
                   }
            }
         }
      }
   }

 if (single_num == 0)
      {
      li_0 = OrdersTotal();
      for(li_0 = 0; li_0 < OrdersTotal(); li_0++) 
      {
         if(OrderSelect(li_0, SELECT_BY_POS, MODE_TRADES)== false) continue;
         RefreshRates();
         if(OrderMagicNumber()==MagicN)
         {
         if (OrderType() == OP_SELL) li_8 = OrderClose(OrderTicket(), OrderLots(), MarketInfo(StringSubstr(OrderSymbol(),0,6), MODE_ASK), 300);
        else {
            if (OrderType() == OP_BUY) li_8 = OrderClose(OrderTicket(), OrderLots(), MarketInfo(StringSubstr(OrderSymbol(),0,6), MODE_BID), 300);
           else
               if (OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP) li_8 = OrderDelete(OrderTicket());
              }
         }
      }
   }

  if (single_num > 0)
   {
      for (li_0 = OrdersTotal() - 1; li_0 >= 0; li_0--) 
      {    
         if(OrderSelect(li_0, SELECT_BY_POS, MODE_TRADES)== false) continue;
         if (OrderType() <= 5 && (OrderMagicNumber()==MagicN))
         {
            li_4 = TRUE;
            for (symbol_txt = 1; symbol_txt <= single_num; symbol_txt++) 
            {
               if (OrderComment() == gsa_144[symbol_txt][7])
               {
                  li_4 = FALSE;
                  break;
               }
            }     
            if (li_4 != TRUE) continue;
            RefreshRates();
            if (OrderType() == OP_SELL && li_4 == TRUE) 
               li_8 = OrderClose(OrderTicket(), OrderLots(), MarketInfo(StringSubstr(OrderSymbol(),0,6), MODE_ASK), 300);
            if (OrderType() == OP_BUY && li_4 == TRUE) 
               li_8 = OrderClose(OrderTicket(), OrderLots(), MarketInfo(StringSubstr(OrderSymbol(),0,6), MODE_BID), 300);
         }
         if(OrderMagicNumber()==MagicN)
           {
           li_8 = OrderDelete(OrderTicket());
           }        
      }
   } 
  } 
}

int 跟单信号() 
{
   string ls_0;
   int li_8;
   int li_12 = -1;
   srcfile=喊单ID+".csv"; 
   li_12 = FileOpen(srcfile, FILE_CSV|FILE_COMMON|FILE_READ, ',');
   single_num = -1;
   if (li_12 >= 1) 
   {
      ls_0 = FileReadString(li_12);
      if (StringFind(ls_0, "#", 0) == -1) 
         {
            FileClose(li_12);
            return (-1);
         }
      li_8 = GetLastError();
      single_num = StrToInteger(StringSetChar(ls_0, StringLen(ls_0) - 1, 0));
      li_8 = GetLastError();
      if (li_8 != 0) 
         {
            FileClose(li_12);
            return (-1);
         }
      for (int li_16 = 1; li_16 <= single_num; li_16++) 
      {
         li_8 = GetLastError();
         gsa_144[li_16][0] = FileReadString(li_12);
         gsa_144[li_16][1] = FileReadString(li_12);
         gsa_144[li_16][2] = FileReadString(li_12);
         gsa_144[li_16][3] = FileReadString(li_12);
         gsa_144[li_16][4] = FileReadString(li_12);
         gsa_144[li_16][5] = FileReadString(li_12);
         gsa_144[li_16][6] = FileReadString(li_12);
         gsa_144[li_16][7] = FileReadString(li_12);
         li_8 = GetLastError();
         if (li_8 != 0) 
            {
               FileClose(li_12);
               return (-1);
            }
      }
   } 
   else 
   {
      FileClose(li_12);
      return (-1);
   }
   FileClose(li_12);
   return (1);
}


int 开单(string as_0, double ad_8, double ad_16, double ad_24, double ad_32, int ai_40, string as_44)
{
    double Point_;
   if (MarketInfo(as_0, MODE_DIGITS) == 5 || MarketInfo(as_0, MODE_DIGITS) == 4)   Point_ = 0.0001;          
   if(MarketInfo(as_0, MODE_DIGITS)  == 3 || MarketInfo(as_0, MODE_DIGITS)  == 2) Point_ = 0.01;
   double ld_52;
   double ld_60;
   double ld_68;
   int li_76;
   
   if (follow == 0) Lots = 固定手数下单;
   else 
     {    
        Lots = NormalizeDouble(ad_32*跟单倍数, 2);   
          if(Lots<MarketInfo(as_0,MODE_MINLOT))
            {
               Lots=MarketInfo(as_0,MODE_MINLOT);
            }             
      }

      bool li_14=True;
               for (int li_10 = 0; li_10 < OrdersTotal(); li_10++) 
                  {
                     if(OrderSelect(li_10, SELECT_BY_POS, MODE_TRADES)== false) continue;    
                     if (OrderComment() ==as_44)
                        {
                          li_14 = FALSE;
                           break;}
                        }

   switch (ai_40)
   {
      case 0:
         RefreshRates();
          ld_60 = MarketInfo(as_0, MODE_ASK);
         ld_68 = Point_;
         if (MathAbs(ld_60 - ad_8) > 100 * ld_68) return (0);
         if(li_14==True)
            li_76 = OrderSend(as_0, OP_BUY, Lots, ld_60, 300, ad_16, ad_24,as_44, MagicN, 0);
         
         if (li_76 < 0) return (0);
         return (1);
         
      case 1:
         RefreshRates();   
         ld_52 = MarketInfo(as_0, MODE_BID);
         ld_68 =Point_;
         if (MathAbs(ld_52 - ad_8) > 100 * ld_68) return (0);
         if(li_14==True)
            li_76 = OrderSend(as_0, OP_SELL, Lots, ld_52, 300, ad_16, ad_24, as_44, MagicN, 0);
         if (li_76 < 0) return (0);
         return (1);
         
        case 2:
         RefreshRates();
         ld_68 =Point_;
         if(li_14==True)
            li_76 = OrderSend(as_0, OP_BUYLIMIT, Lots, ad_8, 300, ad_16, ad_24,as_44, MagicN, 0);
         if (li_76 < 0) return (0);
         return (1); 
         
        case 3:
         RefreshRates();  
         ld_68 =Point_;
         if(li_14==True)
            li_76 = OrderSend(as_0, OP_SELLLIMIT, Lots, ad_8,300, ad_16, ad_24, as_44, MagicN, 0);
         if (li_76 < 0) return (0);
         return (1);
          
      case 4:
         RefreshRates();  
         ld_68 =Point_;
         if(li_14==True)
            li_76 = OrderSend(as_0, OP_BUYSTOP, Lots, ad_8, 300, ad_16, ad_24, as_44, MagicN, 0);
         if (li_76 < 0) return (0);
         return (1); 
         
      case 5:
         RefreshRates(); 
         ld_68 =Point_;
         if(li_14==True)
            li_76 = OrderSend(as_0, OP_SELLSTOP, Lots, ad_8, 300, ad_16, ad_24, as_44, MagicN, 0);
         if (li_76 < 0) return (0);
         return (1); 
     
   }
   return (0);
}

bool TradeModify(string as_0, int ai_8, double ad_12, double ad_20, double ad_28)

{
   RefreshRates();
 
   double Point_;
   if (MarketInfo(as_0, MODE_DIGITS) == 5 || MarketInfo(StringSubstr(OrderSymbol(),0,6), MODE_DIGITS) == 4)
            Point_ = 0.0001;
   if(MarketInfo(as_0, MODE_DIGITS)  == 3|| MarketInfo(StringSubstr(OrderSymbol(),0,6), MODE_DIGITS) == 2) Point_ = 0.01;

   double ld_36 = MarketInfo(as_0, MODE_BID);
   double ld_44 = Point_;
   bool li_52 = OrderModify(ai_8, ad_12, ad_20, ad_28, 0);
   if (!li_52) return (FALSE);
   return (TRUE);
}

void writetext(string as_0, string as_8, int ai_16, int ai_20, color ai_24, int ai_28) 
{
   ObjectDelete(as_0);
   ObjectCreate(as_0, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(as_0, as_8, ai_28, "Arial", ai_24);
   ObjectSet(as_0, OBJPROP_CORNER, 0);
   ObjectSet(as_0, OBJPROP_XDISTANCE, ai_16);
   ObjectSet(as_0, OBJPROP_YDISTANCE, ai_20);
}

void delObj() 
{
   ObjectsDeleteAll(0, OBJ_LABEL);
}
