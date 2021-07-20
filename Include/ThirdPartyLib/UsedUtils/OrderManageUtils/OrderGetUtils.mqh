#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"

class OrderGetUtils : OrderManageUtils {
    public:
        OrderGetUtils():OrderManageUtils() {}
        ~OrderGetUtils() {}
    public:
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
};

// 订单信息函数
int OrderGetUtils::GetNumOfAllOrders() {
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
int OrderGetUtils::GetNumOfAllOrders(int magic_number) {
 int total_num = OrdersTotal();
 int res_total_num = 0;
 for (int i = total_num - 1; i >= 0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
       res_total_num++;
    }
 }
 return res_total_num;
}
int OrderGetUtils::GetNumOfBuyOrders() {
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
int OrderGetUtils::GetNumOfSellOrders() {
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
int OrderGetUtils::GetNumOfLossOrders() {
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
bool OrderGetUtils::GetBuyOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
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
bool OrderGetUtils::GetBuyProfitOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
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
bool OrderGetUtils::GetBuyLossOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
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
bool OrderGetUtils::GetSellOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
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
bool OrderGetUtils::GetSellProfitOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
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
bool OrderGetUtils::GetSellLossOrdersReverse(OrderInMarket& res[], int total_get_cnt) {
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
bool OrderGetUtils::GetHighestOpenPriceOrder(OrderInMarket& res[]) {
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
bool OrderGetUtils::GetHighestBuyOpenPriceOrder(OrderInMarket& res[], int magic_number) {
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
bool OrderGetUtils::GetHighestSellOpenPriceOrder(OrderInMarket& res[], int magic_number) {
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
bool OrderGetUtils::GetLowestOpenPriceOrder(OrderInMarket& res[]) {
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
bool OrderGetUtils::GetLowestSellOpenPriceOrder(OrderInMarket& res[], int magic_number) {
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
bool OrderGetUtils::GetLowestBuyOpenPriceOrder(OrderInMarket& res[], int magic_number) {
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
void OrderGetUtils::PrintOrderInMarketArray(OrderInMarket& in[]) {
    for (int i = 0; i < ArraySize(in); i++) {
        in[i].PrintOrderInMarket();
    }
}
