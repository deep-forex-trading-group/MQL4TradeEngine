#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>

class OrderGetUtils : OrderManageUtils {
    public:
        OrderGetUtils():OrderManageUtils() {}
        ~OrderGetUtils() {}
    public:
        // 订单信息函数
        int GetNumOfAllOrders(int magic_number);
        int GetNumOfBuyOrders(int magic_number);
        int GetNumOfSellOrders(int magic_number);
        int GetNumOfLossOrders(int magic_number);
        static bool GetOrdersInHistoryWithMagicNumberSet(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetOrdersInTradesWithMagicNumberSet(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetOrdersInHistoryWithMagicNumber(int group_magic_number, OrderInMarket& res[]);
        static bool GetOrdersInTradesWithMagicNumber(int group_magic_number, OrderInMarket& res[]);
        bool GetBuyOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        bool GetBuyProfitOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        bool GetBuyLossOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        bool GetSellOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        bool GetSellProfitOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        bool GetSellLossOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        bool GetHighestOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        bool GetHighestBuyOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        bool GetHighestSellOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        bool GetLowestOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        bool GetLowestSellOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        bool GetLowestBuyOpenPriceOrder(int magic_number, OrderInMarket& res[]);
};

// 订单信息函数
int OrderGetUtils::GetNumOfAllOrders(int magic_number) {
 int total_num = OrdersTotal();
 int res_total_num = 0;
 for (int i = total_num - 1; i >= 0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) 
         && OrderSymbol() == Symbol() && OrderMagicNumber() == magic_number) {
       res_total_num++;
    }
 }
 return res_total_num;
}
int OrderGetUtils::GetNumOfBuyOrders(int magic_number) {
  int total_num = OrdersTotal();
  int total_buy = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
        && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
        total_buy++;
     }
  }
  return total_buy;
}
int OrderGetUtils::GetNumOfSellOrders(int magic_number) {
  int total_num = OrdersTotal();
  int total_sell = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
        total_sell++;
     }
  }
  return total_sell;
}
int OrderGetUtils::GetNumOfLossOrders(int magic_number) {
  int total_num = OrdersTotal();
  int total_loss_num = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && (OrderProfit() + OrderCommission() + OrderSwap()) <= 0
         && OrderMagicNumber() == magic_number) {
        total_loss_num++;
     }
  }
  return total_loss_num;
}
bool OrderGetUtils::GetOrdersInHistoryWithMagicNumberSet(HashSet<int>* group_magic_number_set, OrderInMarket& res[]) {
    // Gets the order in history pool
    if (ArraySize(res) <= 500) {
        ArrayResize(res, 500);
    }
    if (IsPtrInvalid(group_magic_number_set)) {
        PrintFormat("group_magic_number_set pointer is invalid in GetOrdersInHistoryWithMagicNumberSet");
        return false;
    }
    int res_i = 0;
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()
            && group_magic_number_set.contains(OrderMagicNumber())) {

            OrderInMarket oi();
            oi.GetOrderFromMarket(i);
            res[res_i] = oi;
            res_i++;
        }
    }
    ArrayResize(res, res_i);
    return true;
}
bool OrderGetUtils::GetOrdersInTradesWithMagicNumberSet(HashSet<int>* group_magic_number_set, OrderInMarket& res[]) {
    // Gets the order in history pool
    if (ArraySize(res) <= 500) {
        ArrayResize(res, 500);
    }
    if (IsPtrInvalid(group_magic_number_set)) {
        PrintFormat("group_magic_number_set pointer is invalid in GetOrdersInTradesWithMagicNumberSet");
        return false;
    }
    int res_i = 0;
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && group_magic_number_set.contains(OrderMagicNumber())) {

            OrderInMarket oi();
            oi.GetOrderFromMarket(i);
            res[res_i] = oi;
            res_i++;
        }
    }
    ArrayResize(res, res_i);
    return true;
}
bool OrderGetUtils::GetOrdersInHistoryWithMagicNumber(int group_magic_number, OrderInMarket& res[]) {
    // Gets the order in history pool
    ClearAndMakeSureArraySize(res);
    int res_i = 0;
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == group_magic_number) {

            OrderInMarket oi();
            oi.GetOrderFromMarket(i);
            res[res_i] = oi;
            res_i++;
        }
    }
    ArrayResize(res, res_i);
    return true;
}
bool OrderGetUtils::GetOrdersInTradesWithMagicNumber(int group_magic_number, OrderInMarket& res[]) {
    // Gets the order in history pool
    ClearAndMakeSureArraySize(res);
    int res_i = 0;
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == group_magic_number) {

            OrderInMarket oi();
            oi.GetOrderFromMarket(i);

            res[res_i] = oi;
            res_i++;
        }
    }
    ArrayResize(res, res_i);
    return true;
}
bool OrderGetUtils::GetBuyOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
        OrderInMarket oi();
        oi.GetOrderFromMarket(i);
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
bool OrderGetUtils::GetBuyProfitOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY && (OrderProfit() + OrderCommission() + OrderSwap()) >= 0
         && OrderMagicNumber() == magic_number) {
        OrderInMarket oi();
        oi.GetOrderFromMarket(i);
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
bool OrderGetUtils::GetBuyLossOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY && (OrderProfit() + OrderCommission() + OrderSwap()) < 0 && OrderMagicNumber() == magic_number) {
        OrderInMarket oi();
        oi.GetOrderFromMarket(i);
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
bool OrderGetUtils::GetSellOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
        OrderInMarket oi();
        oi.GetOrderFromMarket(i);
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
bool OrderGetUtils::GetSellProfitOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && (OrderProfit() + OrderCommission() + OrderSwap()) >= 0
         && OrderMagicNumber() == magic_number) {
        OrderInMarket oi();
        oi.GetOrderFromMarket(i);
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
bool OrderGetUtils::GetSellLossOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt) {
  int total_num = OrdersTotal();
  int res_i = 0;
  for (int i = total_num - 1; i >= 0; i--) {
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && (OrderProfit() + OrderCommission() + OrderSwap()) < 0
         && OrderMagicNumber() == magic_number) {
        OrderInMarket oi();
        oi.GetOrderFromMarket(i);
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
bool OrderGetUtils::GetHighestOpenPriceOrder(int magic_number, OrderInMarket& res[]) {
  int total_orders_num = OrdersTotal();
  double highest_price = -1;
  int higest_ticket = -1;
  OrderInMarket oi();
  for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() 
                     && OrderMagicNumber() == magic_number) {
           RefreshRates();
           if (highest_price == -1 || OrderOpenPrice() >= highest_price) {
              highest_price = OrderOpenPrice();
              higest_ticket = OrderTicket();

              oi.GetOrderFromMarket(i);
           }
     }
  }
  res[0] = oi;
  ArrayResize(res, 1);
  return true;
}
bool OrderGetUtils::GetHighestBuyOpenPriceOrder(int magic_number, OrderInMarket& res[]) {
     int total_orders_num = OrdersTotal();
     double highest_price = -1;
     int higest_ticket = -1;
     OrderInMarket oi();
     for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
            && OrderSymbol() == Symbol() && OrderMagicNumber() == magic_number
            && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
              RefreshRates();
              if (highest_price == -1 || OrderOpenPrice() >= highest_price) {
                 highest_price = OrderOpenPrice();
                 higest_ticket = OrderTicket();

                 oi.GetOrderFromMarket(i);
              }
        }
     }
     res[0] = oi;
     ArrayResize(res, 1);
     return true;
}
bool OrderGetUtils::GetHighestSellOpenPriceOrder(int magic_number, OrderInMarket& res[]) {
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

          oi.GetOrderFromMarket(i);
        }
     }
    }
    res[0] = oi;
    ArrayResize(res, 1);
    return true;
}
bool OrderGetUtils::GetLowestOpenPriceOrder(int magic_number, OrderInMarket& res[]) {
  int total_orders_num = OrdersTotal();
  double lowest_price = -1;
  int lowest_ticket = -1;
  OrderInMarket oi();
  for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                     && OrderMagicNumber() == magic_number) {
           RefreshRates();
           if (lowest_price == -1 || OrderOpenPrice() <= lowest_price) {
              lowest_price = OrderOpenPrice();
              lowest_ticket = OrderTicket();

              oi.GetOrderFromMarket(i);
           }
     }
  }

  res[0] = oi;
  ArrayResize(res, 1);
  return true;
}
bool OrderGetUtils::GetLowestSellOpenPriceOrder(int magic_number, OrderInMarket& res[]) {
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

                 oi.GetOrderFromMarket(i);
              }
        }
     }

     res[0] = oi;
     ArrayResize(res, 1);
     return true;
  }
bool OrderGetUtils::GetLowestBuyOpenPriceOrder(int magic_number, OrderInMarket& res[]) {
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

                oi.GetOrderFromMarket(i);
            }
        }
    }

    res[0] = oi;
    ArrayResize(res, 1);
    return true;
}
