#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"

class OrderSendUtils : public OrderManageUtils {
    public:
        OrderSendUtils():OrderManageUtils() {}
        ~OrderSendUtils() {}
    public:
        // 下单函数
        bool AddOneOrderByStepPip(int direction, double StepPip, double Lot);
        int CreateBuyOrder(double Lots, int TP, int SL);
        int CreateSellOrder(double Lots, int TP, int SL);
        int SendMarketOrder(int Type, double Lots, int TP, int SL,
                            int Magic, string Cmnt, double OpenPrice = 0, string mSymbol = "");
    private:
        // ---------------------------- 逻辑辅助函数区域 ----------------------------
        double OrderSendUtils::IIFd(bool condition, double ifTrue, double ifFalse);
};

// 下单函数
bool OrderSendUtils::AddOneOrderByStepPip(int direction, double StepPip, double Lot) {
    OrderInMarket order_in_market[1000];

    if (direction == 0) {
         int total_orders_num = OrdersTotal();
         // if (total_orders_num == 0) {
         //    return CreateBuyOrder(Lot,0,0) >= 0;
         // }

         double highest_price = -1;
         int higest_ticket = -1;
         for (int i = total_orders_num - 1; i >= 0; i--) {
            RefreshRates();
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderType() == OP_BUY) {
                RefreshRates();
                if (highest_price == -1 || OrderOpenPrice() >= highest_price) {
                    highest_price = OrderOpenPrice();
                    higest_ticket = OrderTicket();
                }
            }
         }

        if (NormalizeDouble(Ask, Digits) - highest_price >= StepPip*Point) {
            return CreateBuyOrder(Lot,0,0) >= 0;
        }
    }

    if (direction == 1) {
         int dir_1_total_orders_num = OrdersTotal();
         double lowest_price = -1;
         int lowest_ticket = -1;
         // if (total_orders_num == 0) {
         //    return CreateSellOrder(Lot,0,0) >= 0;
         // }
         for (int dir_1_i = dir_1_total_orders_num - 1; dir_1_i >= 0; dir_1_i--) {
            RefreshRates();
            if (OrderSelect(dir_1_i, SELECT_BY_POS, MODE_TRADES)
                && OrderSymbol() == Symbol()
                && OrderType() == OP_SELL) {
            RefreshRates();
                if (lowest_price == -1 || OrderOpenPrice() <= lowest_price) {
                    lowest_price = OrderOpenPrice();
                    lowest_ticket = OrderTicket();
                }
            }
         }
         if (NormalizeDouble(Bid, Digits) -  lowest_price <= -StepPip*Point) {
            return CreateSellOrder(Lot,0,0) >= 0;
         }
    }

    return false;
}
int OrderSendUtils::CreateBuyOrder(double Lots, int TP, int SL) {
    return SendMarketOrder(OP_BUY, Lots, 0, 0, MagicNumberBuy, "Buy Order");
}
int OrderSendUtils::CreateSellOrder(double Lots, int TP, int SL) {
    return SendMarketOrder(OP_SELL, Lots, 0, 0, MagicNumberSell, "Sell Order");
}
int OrderSendUtils::SendMarketOrder(int Type, double Lots, int TP, int SL,
                                    int Magic, string Cmnt,
                                    double OpenPrice = 0, string mSymbol = "") {
  double Price, Take, Stop;
  int Ticket = -1;
  int Color, Err;
  int ErrorCount = 0;
  while(!IsStopped())
  {
     if(ErrorCount > 5) return(0);
     if(!IsConnected())
     {
        ErrorCount = ErrorCount + 1;
        Print("No connection with server!");
        Sleep(1000);
     }
     if(IsTradeContextBusy())
     {
        Sleep(3000);
        continue;
     }
     switch(Type)
     {
        case OP_BUY:
        if(mSymbol == "")
           Price = NormalizeDouble(Ask, Digits);
        else
           Price = NormalizeDouble(MarketInfo(mSymbol, MODE_ASK), Digits);
        Take = IIFd(TP == 0, 0, NormalizeDouble( Price + TP * Point, Digits));
        Stop = IIFd(SL == 0, 0, NormalizeDouble( Price - SL * Point, Digits));
        Color = Blue;
        break;
        case OP_SELL:
        if(mSymbol == "")
           Price = NormalizeDouble( Bid, Digits);
        else
           Price = NormalizeDouble(MarketInfo(mSymbol, MODE_BID), Digits);
        Price = NormalizeDouble( Bid, Digits);
        Take = IIFd(TP == 0, 0, NormalizeDouble( Price - TP * Point, Digits));
        Stop = IIFd(SL == 0, 0, NormalizeDouble( Price + SL * Point, Digits));
        Color = Red;
        break;
        default:
        return(-1);
     }
     if(IsTradeAllowed())
     {
        if(mSymbol == "")
        Ticket = OrderSend(Symbol(), Type, Lots, Price, int(2*Spread), 0, 0, Cmnt, Magic, 0, Color); // amended code
        else
        Ticket = OrderSend(mSymbol, Type, Lots, Price, int(2*Spread), Stop, Take, Cmnt, Magic, 0, Color);

        if(Ticket < 0)
        {
        Err = GetLastError();
        if (Err == 4   || /* SERVER_BUSY */
              Err == 129 || /* INVALID_PRICE */
              Err == 135 || /* PRICE_CHANGED */
              Err == 137 || /* BROKER_BUSY */
              Err == 138 || /* REQUOTE */
              Err == 146 || /* TRADE_CONTEXT_BUSY */
              Err == 136 )  /* OFF_QUOTES */
        {
           Sleep(3000);
           continue;
        }
        else
        {
           break;
        }
        }
        break;
     }
     else
     {
        break;
     }
  }

  return(Ticket);
}

// ---------------------------- 逻辑辅助函数区域 ----------------------------
double OrderSendUtils::IIFd(bool condition, double ifTrue, double ifFalse) {
    if (condition) return(ifTrue); else return(ifFalse);
}