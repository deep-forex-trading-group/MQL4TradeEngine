#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"
#include "DataStructure.mqh"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>

class OrderGetUtils : OrderManageUtils {
    public:
        OrderGetUtils():OrderManageUtils() {}
        ~OrderGetUtils() {}
    public:
        // 订单信息函数
        static bool GetOrderInTrade(int magic_number, OrderInMarket& res[]);
        static bool GetOrderInTrade(HashSet<int>* magic_number_set, OrderInMarket& res[]);
        static MinMaxMagicNumber GetAllOrdersWithoutSymbolAndZeroMN();
        static bool GetAllOrders(OrderInMarket& res[]);
        static int GetNumOfAllOrdersInTrades(int magic_number);
        static int GetNumOfAllOrdersInTrades(HashSet<int>* magic_number_set);
        static int GetNumOfBuyOrders(int magic_number);
        static int GetNumOfSellOrders(int magic_number);
        static int GetNumOfLossOrders(int magic_number);
        static bool CheckOrder(string comm, long magic_number);
        static bool CheckOrder(string comm);
        static bool GetOrdersInHistoryWithMagicNumberSet(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetOrdersInTradesWithMagicNumberSet(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetOrdersInHistoryWithMagicNumber(int group_magic_number, OrderInMarket& res[]);
        static bool GetOrdersInTradesWithMagicNumber(int group_magic_number, OrderInMarket& res[]);
        static bool GetBuyOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        static bool GetBuyProfitOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        static bool GetBuyLossOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        static bool GetSellOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        static bool GetSellProfitOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        static bool GetSellLossOrdersReverse(int magic_number, OrderInMarket& res[], int total_get_cnt);
        static bool GetHighestOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        static bool GetHighestBuyOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        static bool GetHighestSellOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        static bool GetLowestOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        static bool GetLowestSellOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        static bool GetLowestBuyOpenPriceOrder(int magic_number, OrderInMarket& res[]);
        static bool GetHighestOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetHighestBuyOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetHighestSellOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetLowestOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetLowestSellOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
        static bool GetLowestBuyOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]);
};
bool OrderGetUtils::GetOrderInTrade(int magic_number, OrderInMarket& res[]) {
    ArrayResize(res, 1);
    int total_num = OrdersTotal();
    int res_total_num = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
             && OrderSymbol() == Symbol() && OrderMagicNumber() == magic_number) {
            RefreshRates();
            OrderInMarket oi();
            oi.GetOrderFromMarket(i);
            res[0] = oi;
            return true;
        }
    }
    return false;
}
bool OrderGetUtils::GetOrderInTrade(HashSet<int>* magic_number_set, OrderInMarket& res[]) {
    int total_num = OrdersTotal();
    ArrayResize(res, total_num+1);
    int res_total_num = 0;
    int res_i = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
            && OrderSymbol() == Symbol() && magic_number_set.contains(OrderMagicNumber())) {
            RefreshRates();
            OrderInMarket oi();
            oi.GetOrderFromMarket(i);
            res[res_i] = oi;
            res_i++;
        }
    }
    ArrayResize(res, res_i);
    return true;
}
MinMaxMagicNumber OrderGetUtils::GetAllOrdersWithoutSymbolAndZeroMN() {
    MinMaxMagicNumber res = {false, 0, 0};
    int total_num = OrdersTotal();
    int total_history_num = OrdersHistoryTotal();
    if (total_num + total_history_num == 0) {
        res.is_success = false;
        return res;
    }
    int res_i = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderMagicNumber() != 0) {
            RefreshRates();
            int cur_magic_number = OrderMagicNumber();
            PrintFormat("cur_magic_number=%d", cur_magic_number);
            if (res.max_magic_number == 0) {
                res.max_magic_number = cur_magic_number;
            } else {
                res.max_magic_number = MathMax(cur_magic_number, res.max_magic_number);
            }
            if (res.min_magic_number == 0) {
                res.min_magic_number = cur_magic_number;
            } else {
                res.min_magic_number = MathMin(cur_magic_number, res.min_magic_number);
            }
        }
    }

    for (int i = total_history_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderMagicNumber() != 0) {
            RefreshRates();
            int cur_magic_number = OrderMagicNumber();
            if (res.max_magic_number == 0) {
                res.max_magic_number = cur_magic_number;
            } else {
                res.max_magic_number = MathMax(cur_magic_number, res.max_magic_number);
            }
            if (res.min_magic_number == 0) {
                res.min_magic_number = cur_magic_number;
            } else {
                res.min_magic_number = MathMin(cur_magic_number, res.min_magic_number);
            }
        }
    }
    res.max_magic_number = res.max_magic_number != 0 ? res.max_magic_number : 1;
    res.min_magic_number = res.min_magic_number != 0 ? res.min_magic_number : -1;
    res.is_success = true;
    return res;
}
// 订单信息函数
bool OrderGetUtils::GetAllOrders(OrderInMarket& res[]) {
    int res_i = 0;
    int total_num = OrdersTotal();
    int total_history_num = OrdersHistoryTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            RefreshRates();
            OrderInMarket oi();
            oi.GetOrderFromMarket(i);
            res[res_i] = oi;
            res_i++;
        }
    }
    for (int i = total_history_num; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            RefreshRates();
            OrderInMarket oi();
            oi.GetOrderFromMarket(i);
            res[res_i] = oi;
            res_i++;
        }
    }
    ArrayResize(res, res_i);
    return true;
}
int OrderGetUtils::GetNumOfAllOrdersInTrades(int magic_number) {
    int total_num = OrdersTotal();
    int res_total_num = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
            && OrderSymbol() == Symbol() && OrderMagicNumber() == magic_number) {
            RefreshRates();
            res_total_num++;
        }
    }
    return res_total_num;
}
int OrderGetUtils::GetNumOfAllOrdersInTrades(HashSet<int>* magic_number_set) {
    int total_num = OrdersTotal();
    int res_total_num = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
            && OrderSymbol() == Symbol() && magic_number_set.contains(OrderMagicNumber())) {
                RefreshRates();
                res_total_num++;
        }
    }
    return res_total_num;
}
int OrderGetUtils::GetNumOfBuyOrders(int magic_number) {
    int total_num = OrdersTotal();
    int total_buy = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
            RefreshRates();
            total_buy++;
        }
    }
    return total_buy;
}
int OrderGetUtils::GetNumOfSellOrders(int magic_number) {
    int total_num = OrdersTotal();
    int total_sell = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
            RefreshRates();
            total_sell++;
        }
    }
    return total_sell;
}
int OrderGetUtils::GetNumOfLossOrders(int magic_number) {
    int total_num = OrdersTotal();
    int total_loss_num = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && (OrderProfit() + OrderCommission() + OrderSwap()) <= 0
            && OrderMagicNumber() == magic_number) {
            RefreshRates();
            total_loss_num++;
        }
    }
    return total_loss_num;
}
bool OrderGetUtils::CheckOrder(string comm, long magic_number) {
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && (OrderComment() == comm && OrderMagicNumber() == magic_number)) {
            RefreshRates();
            return true;
        }
    }
    return false;
}
bool OrderGetUtils::CheckOrder(string comm) {
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && (OrderComment() == comm)) {
            RefreshRates();
            return true;
        }
    }
    return false;
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
    int total_history_num = OrdersHistoryTotal();
    for (int i = total_history_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()
            && group_magic_number_set.contains(OrderMagicNumber())) {
            RefreshRates();
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
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && group_magic_number_set.contains(OrderMagicNumber())) {
            RefreshRates();
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
    int total_history_num = OrdersHistoryTotal();
    for (int i = total_history_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == group_magic_number) {
            RefreshRates();
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
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == group_magic_number) {
            RefreshRates();
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
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
        RefreshRates();
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
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY && (OrderProfit() + OrderCommission() + OrderSwap()) >= 0
         && OrderMagicNumber() == magic_number) {
        RefreshRates();
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
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY && (OrderProfit() + OrderCommission() + OrderSwap()) < 0
         && OrderMagicNumber() == magic_number) {
        RefreshRates();
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
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
        RefreshRates();
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
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && (OrderProfit() + OrderCommission() + OrderSwap()) >= 0
         && OrderMagicNumber() == magic_number) {
        RefreshRates();
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
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_SELL && (OrderProfit() + OrderCommission() + OrderSwap()) < 0
         && OrderMagicNumber() == magic_number) {
        RefreshRates();
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
            && OrderType() == OP_BUY) {
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
bool OrderGetUtils::GetHighestOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]) {
    if (IsPtrInvalid(group_magic_number_set)) {
        PrintFormat("group_magic_number_set pointer is invalid in GetHighestOpenPriceOrder");
        return false;
    }
    int total_orders_num = OrdersTotal();
    double highest_price = -1;
    int higest_ticket = -1;
    OrderInMarket oi();
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                        && group_magic_number_set.contains(OrderMagicNumber())) {
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
bool OrderGetUtils::GetHighestBuyOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]) {
    if (IsPtrInvalid(group_magic_number_set)) {
        PrintFormat("group_magic_number_set pointer is invalid in GetHighestBuyOpenPriceOrder");
        return false;
    }
    int total_orders_num = OrdersTotal();
    double highest_price = -1;
    int higest_ticket = -1;
    OrderInMarket oi();
    for (int i = total_orders_num - 1; i >= 0; i--) {
    RefreshRates();
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
        && OrderSymbol() == Symbol()
        && OrderType() == OP_BUY && group_magic_number_set.contains(OrderMagicNumber())) {
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
bool OrderGetUtils::GetHighestSellOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]) {
    if (IsPtrInvalid(group_magic_number_set)) {
        PrintFormat("group_magic_number_set pointer is invalid in GetHighestSellOpenPriceOrder");
        return false;
    }
    int total_orders_num = OrdersTotal();
    double highest_price = -1;
    int higest_ticket = -1;
    OrderInMarket oi();
    for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL && group_magic_number_set.contains(OrderMagicNumber())) {
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
bool OrderGetUtils::GetLowestOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]) {
    if (IsPtrInvalid(group_magic_number_set)) {
        PrintFormat("group_magic_number_set pointer is invalid in GetLowestOpenPriceOrder");
        return false;
    }

    int total_orders_num = OrdersTotal();
    double lowest_price = -1;
    int lowest_ticket = -1;
    OrderInMarket oi();
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                        && group_magic_number_set.contains(OrderMagicNumber())) {
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
bool OrderGetUtils::GetLowestSellOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]) {
    if (IsPtrInvalid(group_magic_number_set)) {
        PrintFormat("group_magic_number_set pointer is invalid in GetLowestSellOpenPriceOrder");
        return false;
    }

    int total_orders_num = OrdersTotal();
     double lowest_price = -1;
     int lowest_ticket = -1;
     OrderInMarket oi();
     for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && group_magic_number_set.contains(OrderMagicNumber()) && OrderType() == OP_SELL) {
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
bool OrderGetUtils::GetLowestBuyOpenPriceOrder(HashSet<int>* group_magic_number_set, OrderInMarket& res[]) {
    if (IsPtrInvalid(group_magic_number_set)) {
        PrintFormat("group_magic_number_set pointer is invalid in GetLowestBuyOpenPriceOrder");
        return false;
    }
    int total_orders_num = OrdersTotal();
    double lowest_price = -1;
    int lowest_ticket = -1;
    OrderInMarket oi();
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && group_magic_number_set.contains(OrderMagicNumber()) && OrderType() == OP_BUY) {
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