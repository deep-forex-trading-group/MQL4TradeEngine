#include "OrderInMarket.mqh"

class OrderManageUtils {

private:
   double Spread;
   // Magic Numbers
   int MagicNumberBuy;   
   int MagicNumberSell;

public:

    OrderManageUtils() {
        Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
        // Magic Numbers
        MagicNumberBuy        = 123456789;
        MagicNumberSell       = 987654321;
    }

    ~OrderManageUtils() {}

    // 订单信息函数
    int GetNumOfAllOrders();

    // 订单信息函数
    int GetNumOfAllOrders(int magic_number);
    int GetNumOfBuyOrders();
    int GetNumOfSellOrders();
    int GetNumOfLossOrders();
    bool GetBuyOrdersReverse(OrderInMarket& res[], int total_get_cnt);
    bool GetBuyProfitOrdersReverse(OrderInMarket& res[], int total_get_cnt);
    bool GetBuyLossOrdersReverse(OrderInMarket& res[], int total_get_cnt);
    bool GetSellOrdersReverse(OrderInMarket& res[], int total_get_cnt);
    bool GetSellProfitOrdersReverse(OrderInMarket& res[], int total_get_cnt);
    bool GetSellLossOrdersReverse(OrderInMarket& res[], int total_get_cnt);
    bool GetHighestOpenPriceOrder(OrderInMarket& res[]);
    bool GetHighestBuyOpenPriceOrder(OrderInMarket& res[], int magic_number);
    bool GetHighestSellOpenPriceOrder(OrderInMarket& res[], int magic_number);
    bool GetLowestOpenPriceOrder(OrderInMarket& res[]);
    bool GetLowestSellOpenPriceOrder(OrderInMarket& res[], int magic_number);
    bool GetLowestBuyOpenPriceOrder(OrderInMarket& res[], int magic_number);
    void PrintOrderInMarketArray(OrderInMarket& in[]);

    // 平仓函数
    bool CloseAllOrders(int magic_number);
    bool CloseAllBuyOrders();
    bool CloseAllBuyOrders(int magic_number);
    bool CloseAllBuyProfitOrders(int magic_number, double profit);
    bool CloseAllSellOrders();
    bool CloseAllSellOrders(int magic_number);
    bool CloseAllSellProfitOrders(int magic_number, double profit);
    bool CloseOrderByOrderTicket(int order_ticket, int dir);
    bool CloseSingleOrderByProfit(double profit);
    bool CloseSingleOrderByLoss(double loss);

    // 下单函数
    bool AddOneOrderByStepPip(int direction, double StepPip, double Lot);
    int CreateBuyOrder(double Lots, int TP, int SL);
    int CreateSellOrder(double Lots, int TP, int SL);
    int SendMarketOrder(int Type, double Lots, int TP, int SL,
                        int Magic, string Cmnt, double OpenPrice = 0, string mSymbol = "");

    // 打印函数
    void PrintAllOrders();

    // ---------------------------- 逻辑辅助函数区域 ----------------------------
    double IIFd(bool condition, double ifTrue, double ifFalse);
};

// 订单信息函数
int OrderManageUtils::GetNumOfAllOrders() {
  int total_num = OrdersTotal();
  int res_total_num = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
        res_total_num++;
     }
  }
  return res_total_num;
}

// 订单信息函数
int OrderManageUtils::GetNumOfAllOrders(int magic_number) {
 int total_num = OrdersTotal();
 int res_total_num = 0;
 for (int i = total_num - 1; i >= 0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
       res_total_num++;
    }
 }
 return res_total_num;
}
int OrderManageUtils::GetNumOfBuyOrders() {
  int total_num = OrdersTotal();
  int total_buy = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
        && OrderType() == OP_BUY) {
        total_buy++;
     }
  }
  return total_buy;
}
int OrderManageUtils::GetNumOfSellOrders() {
  int total_num = OrdersTotal();
  int total_sell = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL) {
        total_sell++;
     }
  }
  return total_sell;
}
int OrderManageUtils::GetNumOfLossOrders() {
  int total_num = OrdersTotal();
  int total_loss_num = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderProfit() <= 0) {
        total_loss_num++;
     }
  }
  return total_loss_num;
}
bool OrderManageUtils::GetBuyOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY) {
        OrderInMarket oi();
        oi.order_lots = OrderLots();
        oi.order_open_price = OrderOpenPrice();
        oi.order_close_price = OrderClosePrice();
        oi.order_comment = OrderComment();
        oi.order_close_time = OrderCloseTime();
        oi.order_profit = OrderProfit();
        oi.order_type = OrderType();
        oi.order_ticket = OrderTicket();
        oi.order_position = i;
        res[res_i] = oi;
        res_i++;
        if (total_get_cnt >= 0 && res_i > total_get_cnt) {
           break;
        }
     }
  }
  ArrayResize(res, res_i);
  return true;
}
bool OrderManageUtils::GetBuyProfitOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY && OrderProfit() >= 0) {
        OrderInMarket oi();
        oi.order_lots = OrderLots();
        oi.order_open_price = OrderOpenPrice();
        oi.order_close_price = OrderClosePrice();
        oi.order_comment = OrderComment();
        oi.order_close_time = OrderCloseTime();
        oi.order_profit = OrderProfit();
        oi.order_type = OrderType();
        oi.order_ticket = OrderTicket();
        oi.order_position = i;
        res[res_i] = oi;
        res_i++;
        if (total_get_cnt >= 0 && res_i > total_get_cnt) {
           break;
        }
     }
  }
  ArrayResize(res, res_i);
  return true;
}
bool OrderManageUtils::GetBuyLossOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY && OrderProfit() < 0) {
        OrderInMarket oi();
        oi.order_lots = OrderLots();
        oi.order_open_price = OrderOpenPrice();
        oi.order_close_price = OrderClosePrice();
        oi.order_comment = OrderComment();
        oi.order_close_time = OrderCloseTime();
        oi.order_profit = OrderProfit();
        oi.order_type = OrderType();
        oi.order_ticket = OrderTicket();
        oi.order_position = i;
        res[res_i] = oi;
        res_i++;
        if (total_get_cnt >= 0 && res_i > total_get_cnt) {
           break;
        }
     }
  }
  ArrayResize(res, res_i);
  return true;
}
bool OrderManageUtils::GetSellOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL) {
        OrderInMarket oi();
        oi.order_lots = OrderLots();
        oi.order_open_price = OrderOpenPrice();
        oi.order_close_price = OrderClosePrice();
        oi.order_comment = OrderComment();
        oi.order_close_time = OrderCloseTime();
        oi.order_profit = OrderProfit();
        oi.order_type = OrderType();
        oi.order_ticket = OrderTicket();
        oi.order_position = i;
        res[res_i] = oi;
        res_i++;
        if (total_get_cnt >= 0 && res_i > total_get_cnt) {
           break;
        }
     }
  }
  ArrayResize(res, res_i);
  return true;
}
bool OrderManageUtils::GetSellProfitOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && OrderProfit() >= 0) {
        OrderInMarket oi();
        oi.order_lots = OrderLots();
        oi.order_open_price = OrderOpenPrice();
        oi.order_close_price = OrderClosePrice();
        oi.order_comment = OrderComment();
        oi.order_close_time = OrderCloseTime();
        oi.order_profit = OrderProfit();
        oi.order_type = OrderType();
        oi.order_ticket = OrderTicket();
        oi.order_position = i;
        res[res_i] = oi;
        res_i++;
        if (total_get_cnt >= 0 && res_i > total_get_cnt) {
           break;
        }
     }
  }
  ArrayResize(res, res_i);
  return true;
}
bool OrderManageUtils::GetSellLossOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && OrderProfit() < 0) {
        OrderInMarket oi();
        oi.order_lots = OrderLots();
        oi.order_open_price = OrderOpenPrice();
        oi.order_close_price = OrderClosePrice();
        oi.order_comment = OrderComment();
        oi.order_close_time = OrderCloseTime();
        oi.order_profit = OrderProfit();
        oi.order_type = OrderType();
        oi.order_ticket = OrderTicket();
        oi.order_position = i;
        res[res_i] = oi;
        res_i++;
        if (total_get_cnt >= 0 && res_i > total_get_cnt) {
           break;
        }
     }
  }
  ArrayResize(res, res_i);
  return true;
}
bool OrderManageUtils::GetHighestOpenPriceOrder(OrderInMarket& res[]) {
  int total_orders_num = OrdersTotal();
  double highest_price = -1;
  int higest_ticket = -1;
  OrderInMarket oi();
  for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
           RefreshRates();
           if (highest_price == -1 || OrderOpenPrice() >= highest_price) {
              highest_price = OrderOpenPrice();
              higest_ticket = OrderTicket();

              oi.order_lots = OrderLots();
              oi.order_open_price = OrderOpenPrice();
              oi.order_close_price = OrderClosePrice();
              oi.order_comment = OrderComment();
              oi.order_close_time = OrderCloseTime();
              oi.order_profit = OrderProfit();
              oi.order_type = OrderType();
              oi.order_ticket = OrderTicket();
              oi.order_position = i;
           }
     }
  }
  res[0] = oi;
  ArrayResize(res, 1);
  return true;
}
bool OrderManageUtils::GetHighestBuyOpenPriceOrder(OrderInMarket& res[], int magic_number) {
     int total_orders_num = OrdersTotal();
     double highest_price = -1;
     int higest_ticket = -1;
     OrderInMarket oi();
     for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
            && OrderSymbol() == Symbol() && OrderMagicNumber() == magic_number
            && OrderType() == OP_BUY) {
              RefreshRates();
              if (highest_price == -1 || OrderOpenPrice() >= highest_price) {
                 highest_price = OrderOpenPrice();
                 higest_ticket = OrderTicket();

                 oi.order_lots = OrderLots();
                 oi.order_open_price = OrderOpenPrice();
                 oi.order_close_price = OrderClosePrice();
                 oi.order_comment = OrderComment();
                 oi.order_close_time = OrderCloseTime();
                 oi.order_profit = OrderProfit();
                 oi.order_type = OrderType();
                 oi.order_ticket = OrderTicket();
                 oi.order_position = i;
              }
        }
     }
     res[0] = oi;
     ArrayResize(res, 1);
     return true;
}
bool OrderManageUtils::GetHighestSellOpenPriceOrder(OrderInMarket& res[], int magic_number) {
    int total_orders_num = OrdersTotal();
    double highest_price = -1;
    int higest_ticket = -1;
    OrderInMarket oi();
    for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
        RefreshRates();
        if (highest_price == -1 || OrderOpenPrice() >= highest_price) {
          highest_price = OrderOpenPrice();
          higest_ticket = OrderTicket();

          oi.order_lots = OrderLots();
          oi.order_open_price = OrderOpenPrice();
          oi.order_close_price = OrderClosePrice();
          oi.order_comment = OrderComment();
          oi.order_close_time = OrderCloseTime();
          oi.order_profit = OrderProfit();
          oi.order_type = OrderType();
          oi.order_ticket = OrderTicket();
          oi.order_position = i;
        }
     }
    }
    res[0] = oi;
    ArrayResize(res, 1);
    return true;
}
bool OrderManageUtils::GetLowestOpenPriceOrder(OrderInMarket& res[]) {
  int total_orders_num = OrdersTotal();
  double lowest_price = -1;
  int lowest_ticket = -1;
  OrderInMarket oi();
  for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
           RefreshRates();
           if (lowest_price == -1 || OrderOpenPrice() <= lowest_price) {
              lowest_price = OrderOpenPrice();
              lowest_ticket = OrderTicket();

              oi.order_lots = OrderLots();
              oi.order_open_price = OrderOpenPrice();
              oi.order_close_price = OrderClosePrice();
              oi.order_comment = OrderComment();
              oi.order_close_time = OrderCloseTime();
              oi.order_profit = OrderProfit();
              oi.order_type = OrderType();
              oi.order_ticket = OrderTicket();
              oi.order_position = i;
           }
     }
  }

  res[0] = oi;
  ArrayResize(res, 1);
  return true;
}
bool OrderManageUtils::GetLowestSellOpenPriceOrder(OrderInMarket& res[], int magic_number) {
     int total_orders_num = OrdersTotal();
     double lowest_price = -1;
     int lowest_ticket = -1;
     OrderInMarket oi();
     for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == magic_number && OrderType() == OP_SELL) {
              RefreshRates();
              if (lowest_price == -1 || OrderOpenPrice() <= lowest_price) {
                 lowest_price = OrderOpenPrice();
                 lowest_ticket = OrderTicket();

                 oi.order_lots = OrderLots();
                 oi.order_open_price = OrderOpenPrice();
                 oi.order_close_price = OrderClosePrice();
                 oi.order_comment = OrderComment();
                 oi.order_close_time = OrderCloseTime();
                 oi.order_profit = OrderProfit();
                 oi.order_type = OrderType();
                 oi.order_ticket = OrderTicket();
                 oi.order_position = i;
              }
        }
     }

     res[0] = oi;
     ArrayResize(res, 1);
     return true;
  }
bool OrderManageUtils::GetLowestBuyOpenPriceOrder(OrderInMarket& res[], int magic_number) {
        int total_orders_num = OrdersTotal();
        double lowest_price = -1;
        int lowest_ticket = -1;
        OrderInMarket oi();
        for (int i = total_orders_num - 1; i >= 0; i--) {
          RefreshRates();
          if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                && OrderMagicNumber() == magic_number && OrderType() == OP_BUY) {
                RefreshRates();
                if (lowest_price == -1 || OrderOpenPrice() <= lowest_price) {
                   lowest_price = OrderOpenPrice();
                   lowest_ticket = OrderTicket();

                   oi.order_lots = OrderLots();
                   oi.order_open_price = OrderOpenPrice();
                   oi.order_close_price = OrderClosePrice();
                   oi.order_comment = OrderComment();
                   oi.order_close_time = OrderCloseTime();
                   oi.order_profit = OrderProfit();
                   oi.order_type = OrderType();
                   oi.order_ticket = OrderTicket();
                   oi.order_position = i;
                }
          }
        }

        res[0] = oi;
        ArrayResize(res, 1);
        return true;
    }
void OrderManageUtils::PrintOrderInMarketArray(OrderInMarket& in[]) {
  for (int i = 0; i < ArraySize(in); i++) {
     in[i].PrintOrderInMarket();
  }
}

// 平仓函数
bool OrderManageUtils::CloseAllOrders(int magic_number) {
  int total_orders_num = OrdersTotal();
  bool is_success = false;
     for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_BUY
            && (magic_number <= -1 || magic_number == OrderMagicNumber()) ) {
              RefreshRates();
              CloseOrderByOrderTicket(OrderTicket(), 0);
        }
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                        && OrderType() == OP_SELL
                        && (magic_number <= -1 || magic_number == OrderMagicNumber())) {
              RefreshRates();
              CloseOrderByOrderTicket(OrderTicket(), 1);
        }
     }
  return is_success;
}
bool OrderManageUtils::CloseAllBuyOrders() {
  int total_orders_num = OrdersTotal();
  bool is_success = false;
  for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                        && OrderType() == OP_BUY) {
           RefreshRates();
           CloseOrderByOrderTicket(OrderTicket(), 0);
     }
  }
  return is_success;
}
bool OrderManageUtils::CloseAllBuyOrders(int magic_number) {
     int total_orders_num = OrdersTotal();
     bool is_success = false;
     for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                        && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
              RefreshRates();
              CloseOrderByOrderTicket(OrderTicket(), 0);
        }
     }
     return is_success;
}
bool OrderManageUtils::CloseAllBuyProfitOrders(int magic_number, double profit) {
       int total_orders_num = OrdersTotal();
       bool is_success = false;
       for (int i = total_orders_num - 1; i >= 0; i--) {
          RefreshRates();
          if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                          && OrderType() == OP_BUY && OrderMagicNumber() == magic_number
                          && OrderProfit() >= profit) {
                RefreshRates();
                CloseOrderByOrderTicket(OrderTicket(), 0);
          }
       }
       return is_success;
}
bool OrderManageUtils::CloseAllSellOrders() {
  int total_orders_num = OrdersTotal();
  bool is_success = false;
  for (int i = total_orders_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                        && OrderType() == OP_SELL) {
        RefreshRates();
        CloseOrderByOrderTicket(OrderTicket(), 1);
     }
  }
  return is_success;
}
bool OrderManageUtils::CloseAllSellOrders(int magic_number) {
   int total_orders_num = OrdersTotal();
   bool is_success = false;
   for (int i = total_orders_num - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                          && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
         RefreshRates();
         CloseOrderByOrderTicket(OrderTicket(), 1);
      }
   }
   return is_success;
}
bool OrderManageUtils::CloseAllSellProfitOrders(int magic_number, double profit) {
   int total_orders_num = OrdersTotal();
   bool is_success = false;
   for (int i = total_orders_num - 1; i >= 0; i--) {
     //  Print(OrderTicket() + " magic_number: " + magic_number + ", " + OrderMagicNumber());
     //  Print(OrderTicket() + " OrderProfit(): " + OrderProfit() + ", " + profit);
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                      && OrderType() == OP_SELL && OrderMagicNumber() == magic_number
                      && OrderProfit() >= profit) {
         RefreshRates();
         CloseOrderByOrderTicket(OrderTicket(), 1);
         PrintFormat("Activate close: %d", OrderTicket());
      }
   }
   return is_success;
}
bool OrderManageUtils::CloseOrderByOrderTicket(int order_ticket, int dir) {
  bool is_success = false;
  int cnt = 100;
  while (!is_success && cnt >= 0) {
     is_success = OrderSelect(order_ticket, SELECT_BY_TICKET, MODE_TRADES);
     //Print("CloseOrderByOrderTicket Select Order ", order_ticket, " error, Repeat Operations!");
     cnt--;
  }

  if (!is_success) Print("After Trying 100 times, Can not Selecting Order: ", order_ticket);

  is_success = false;
  cnt = 100;
  while (!is_success && cnt >= 0) {
     // (dir == 0 ? NormalizeDouble(Bid, Digits):NormalizeDouble(Ask, Digits))
     is_success = OrderClose(order_ticket,OrderLots(),OrderClosePrice(),int(2*Spread),clrFireBrick);
     //Print("CloseOrderByOrderTicket Close Order ", order_ticket, " error, Repeat Operations!");
     cnt--;
  }

  if (!is_success) {
     Print("Error: ", GetLastError());
     Print("After Trying 100 times, Can not Closing Order: ", order_ticket);
  }
  return is_success;
}
bool OrderManageUtils::CloseSingleOrderByProfit(double profit) {
  int total_orders_num = OrdersTotal();
  bool is_success = false;
  for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     // Print("----------------------- profit", profit, "----------------------");
     // OrderPrint();
     // Print("----------------------- profit", profit, "----------------------");
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderProfit() >= profit) {
           RefreshRates();
           if (OrderType() == OP_BUY) CloseOrderByOrderTicket(OrderTicket(), 0);
           if (OrderType() == OP_SELL) CloseOrderByOrderTicket(OrderTicket(), 1);
     }
  }
  return is_success;
}
bool OrderManageUtils::CloseSingleOrderByLoss(double loss) {
  int total_orders_num = OrdersTotal();
  bool is_success = false;
  for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderProfit() <= -loss) {
           // Print("----------------------- loss: ", loss, "----------------------");
           // OrderPrint();
           // Print("----------------------- loss: ", loss, "----------------------");
           RefreshRates();
           if (OrderType() == OP_BUY) CloseOrderByOrderTicket(OrderTicket(), 0);
           if (OrderType() == OP_SELL) CloseOrderByOrderTicket(OrderTicket(), 1);
     }
  }
  return is_success;
}

// 下单函数
bool OrderManageUtils::AddOneOrderByStepPip(int direction, double StepPip, double Lot) {
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
int OrderManageUtils::CreateBuyOrder(double Lots, int TP, int SL) {
  return SendMarketOrder(OP_BUY, Lots, 0, 0, MagicNumberBuy, "Buy Order");
}
int OrderManageUtils::CreateSellOrder(double Lots, int TP, int SL) {
  return SendMarketOrder(OP_SELL, Lots, 0, 0, MagicNumberSell, "Sell Order");
}
int OrderManageUtils::SendMarketOrder(int Type, double Lots, int TP, int SL, int Magic, string Cmnt, double OpenPrice = 0, string mSymbol = "")
{
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

// 打印函数
void OrderManageUtils::PrintAllOrders() {
  Print("----------------------PrintAllOrdersStart----------------------------------");
  int total_num = OrdersTotal();
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
        OrderPrint();
     }
  }
  Print("----------------------PrintAllOrdersEnd----------------------------------");
}

// ---------------------------- 逻辑辅助函数区域 ----------------------------
double OrderManageUtils::IIFd(bool condition, double ifTrue, double ifFalse)
{
  if (condition) return(ifTrue); else return(ifFalse);
}