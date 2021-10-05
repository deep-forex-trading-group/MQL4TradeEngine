#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>

class OrderSendUtils : public OrderManageUtils {
    public:
        OrderSendUtils():OrderManageUtils() {}
        ~OrderSendUtils() {}
    public:
        // 下单函数
        bool AddOneOrderByStepPipReverse(int magic_number, int direction, double step_pip, double Lot);
        bool AddOneOrderByStepPipReverse(HashSet<int>* magic_number_set, int magic_number_new_order,
                                  int direction, double step_pip, double Lot);
        int CreateBuyOrder(int magic_number, double Lots, int TP, int SL);
        int CreateBuyOrder(int magic_number, double Lots);
        int CreateBuyOrder(int magic_number, double Lots, string comment);
        int CreateBuyOrder(int magic_number, double Lots, int TP, int SL, string comment);
        int CreateSellOrder(int magic_number, double Lots, int TP, int SL);
        int CreateSellOrder(int magic_number, double Lots);
        int CreateSellOrder(int magic_number, double Lots, string comment);
        int CreateSellOrder(int magic_number, double Lots, int TP, int SL, string comment);
        int SendMarketOrder(int Type, double Lots, int TP, int SL,
                            int Magic, string Cmnt, double OpenPrice = 0, string mSymbol = "");
    private:
        // ---------------------------- 逻辑辅助函数区域 ----------------------------
        double OrderSendUtils::IIFd(bool condition, double ifTrue, double ifFalse);
};

// 下单函数
bool OrderSendUtils::AddOneOrderByStepPipReverse(int magic_number, int direction,
                                                 double step_pip, double Lot) {
    OrderInMarket order_in_market[1000];

    if (direction == SELL_ORDER_SEND) {
         int total_orders_num = OrdersTotal();

         double highest_price = -1;
         int higest_ticket = -1;
         for (int i = total_orders_num - 1; i >= 0; i--) {
            RefreshRates();
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
                RefreshRates();
                if (highest_price == -1 || OrderOpenPrice() >= highest_price) {
                    highest_price = OrderOpenPrice();
                    higest_ticket = OrderTicket();
                }
            }
         }

        if (highest_price != -1
            && NormalizeDouble(Bid, Digits) - highest_price >= step_pip*MarketInfoUtils::GetPoints()) {
            return CreateSellOrder(magic_number,Lot,0,0) >= 0;
        }
    }

    if (direction == BUY_ORDER_SEND) {
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
                && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
                RefreshRates();
                if (lowest_price == -1 || OrderOpenPrice() <= lowest_price) {
                    lowest_price = OrderOpenPrice();
                    lowest_ticket = OrderTicket();
                }
            }
         }
         if (lowest_price != -1
             && lowest_price - NormalizeDouble(Ask, Digits) >= step_pip * MarketInfoUtils::GetPoints()) {
            return CreateBuyOrder(magic_number,Lot,0,0) >= 0;
         }
    }

    return false;
}
bool OrderSendUtils::AddOneOrderByStepPipReverse(HashSet<int>* magic_number_set, int magic_number_new_order,
                          int direction, double step_pip, double Lot) {
    OrderInMarket order_in_market[1000];
    if (IsPtrInvalid(magic_number_set)) {
        PrintFormat("magic_number_set is invalid in AddOneOrderByStepPipReverse. ");
        return false;
    }

    if (direction == SELL_ORDER_SEND) {
         int total_orders_num = OrdersTotal();

         double highest_price = -1;
         int higest_ticket = -1;
         for (int i = total_orders_num - 1; i >= 0; i--) {
            RefreshRates();
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                && OrderType() == OP_SELL && magic_number_set.contains(OrderMagicNumber())) {
                RefreshRates();
                if (highest_price == -1 || OrderOpenPrice() >= highest_price) {
                    highest_price = OrderOpenPrice();
                    higest_ticket = OrderTicket();
                }
            }
         }

        if (higest_ticket != -1
            && NormalizeDouble(Bid, Digits) - highest_price >= step_pip * MarketInfoUtils::GetPoints()) {
            return CreateSellOrder(magic_number_new_order,Lot,0,0) >= 0;
        }
    }

    if (direction == BUY_ORDER_SEND) {
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
                && OrderType() == OP_BUY && magic_number_set.contains(OrderMagicNumber())) {
            RefreshRates();
                if (lowest_price == -1 || OrderOpenPrice() <= lowest_price) {
                    lowest_price = OrderOpenPrice();
                    lowest_ticket = OrderTicket();
                }
            }
         }
         if (lowest_ticket != -1
             && lowest_price - NormalizeDouble(Ask, Digits) >= step_pip*MarketInfoUtils::GetPoints()) {
            return CreateBuyOrder(magic_number_new_order,Lot,0,0) >= 0;
         }
    }

    return false;
}
int OrderSendUtils::CreateBuyOrder(int magic_number, double Lots, int TP, int SL) {
    return SendMarketOrder(OP_BUY, Lots, TP, SL, magic_number, "Buy Order");
}
int OrderSendUtils::CreateBuyOrder(int magic_number, double Lots) {
    return SendMarketOrder(OP_BUY, Lots, 0, 0, magic_number, "Buy Order");
}
int OrderSendUtils::CreateBuyOrder(int magic_number, double Lots, string comment) {
    return SendMarketOrder(OP_BUY, Lots, 0, 0, magic_number, comment);
}
int OrderSendUtils::CreateBuyOrder(int magic_number, double Lots, int TP, int SL, string comment) {
    return SendMarketOrder(OP_BUY, Lots, TP, SL, magic_number, comment);
}
int OrderSendUtils::CreateSellOrder(int magic_number, double Lots, int TP, int SL) {
    return SendMarketOrder(OP_SELL, Lots, TP, SL, magic_number, "Sell Order");
}

int OrderSendUtils::CreateSellOrder(int magic_number, double Lots) {
    return SendMarketOrder(OP_SELL, Lots, 0, 0, magic_number, "Sell Order");
}

int OrderSendUtils::CreateSellOrder(int magic_number, double Lots, string comment) {
    return SendMarketOrder(OP_SELL, Lots, 0, 0, magic_number, comment);
}
int OrderSendUtils::CreateSellOrder(int magic_number, double Lots, int TP, int SL, string comment) {
    return SendMarketOrder(OP_SELL, Lots, TP, SL, magic_number, comment);
}
int OrderSendUtils::SendMarketOrder(int Type, double Lots, int TP, int SL,
                                    int Magic, string Cmnt,
                                    double OpenPrice = 0, string mSymbol = "") {
  UpdatesSpread();
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
        Take = IIFd(TP == 0, 0, NormalizeDouble( Price + TP * MarketInfoUtils::GetPoints(), Digits));
        Stop = IIFd(SL == 0, 0, NormalizeDouble( Price - SL * MarketInfoUtils::GetPoints(), Digits));
        Color = Blue;
        break;
        case OP_SELL:
        if(mSymbol == "")
           Price = NormalizeDouble( Bid, Digits);
        else
           Price = NormalizeDouble(MarketInfo(mSymbol, MODE_BID), Digits);
        Price = NormalizeDouble( Bid, Digits);
        Take = IIFd(TP == 0, 0, NormalizeDouble( Price - TP * MarketInfoUtils::GetPoints(), Digits));
        Stop = IIFd(SL == 0, 0, NormalizeDouble( Price + SL * MarketInfoUtils::GetPoints(), Digits));
        Color = Red;
        break;
        default:
        return(-1);
     }
     if(IsTradeAllowed())
     {
        if(mSymbol == "")
            Ticket = OrderSend(Symbol(), Type, Lots, Price, int(2*this.Spread), 0, 0,
                                Cmnt, Magic, 0, Color); // amended code
        else
            Ticket = OrderSend(mSymbol, Type, Lots, Price, int(2*this.Spread), Stop, Take,
                                Cmnt, Magic, 0, Color);

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