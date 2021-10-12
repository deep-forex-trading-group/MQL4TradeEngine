#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>

class OrderCloseUtils : public OrderManageUtils {
    public:
        OrderCloseUtils():OrderManageUtils() {}
        ~OrderCloseUtils() {}
    public:
        // 平仓函数
        static bool CloseAllOrders(int magic_number);
        static bool CloseAllOrders(HashSet<int>* magic_number);
        static bool ClosePartOrders(HashSet<int>* magic_number_set, double prop_factor, int norm_lots_up_or_down);
        static bool CloseAllBuyOrders();
        static bool CloseAllBuyOrders(int magic_number);
        static bool CloseAllBuyOrders(HashSet<int>* magic_number_set);
        static bool CloseAllBuyProfitOrders(int magic_number, double profit);
        static bool CloseAllBuyProfitOrders(HashSet<int>* magic_number_set, double profit);
        static bool CloseAllSellOrders();
        static bool CloseAllSellOrders(int magic_number);
        static bool CloseAllSellOrders(HashSet<int>* magic_number_set);
        static bool CloseAllSellProfitOrders(int magic_number, double profit);
        static bool CloseAllSellProfitOrders(HashSet<int>* magic_number_set, double profit);
        static bool CloseOrderByOrderTicket(int order_ticket, int dir);
        static bool CloseOrderByOrderTicket(int order_ticket, int dir, double lots);
        static bool CloseSingleOrderByProfit(double profit);
        static bool CloseSingleOrderByLoss(double loss);
};

// 平仓函数
bool OrderCloseUtils::CloseAllOrders(int magic_number) {
  int total_orders_num = OrdersTotal();
  bool is_success = false;
     for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_BUY
            && (magic_number <= -1 || magic_number == OrderMagicNumber()) ) {
              RefreshRates();
              is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
        }
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                        && OrderType() == OP_SELL
                        && (magic_number <= -1 || magic_number == OrderMagicNumber())) {
              RefreshRates();
              is_success = CloseOrderByOrderTicket(OrderTicket(), 1);
        }
     }
  return is_success;
}
bool OrderCloseUtils::CloseAllOrders(HashSet<int>* magic_number_set) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && magic_number_set.contains(OrderMagicNumber())
            && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
              RefreshRates();
              is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
        }
    }
    return is_success;
}
bool OrderCloseUtils::ClosePartOrders(HashSet<int>* magic_number_set, double prop_factor, int norm_lots_up_or_down) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && magic_number_set.contains(OrderMagicNumber())
            && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
              RefreshRates();
              double lots = NormalizeDouble(OrderLots()*prop_factor, 2);
              lots = norm_lots_up_or_down == NORM_LOTS_UP ?
                                             MarketInfoUtils::NormalizeLotsUp(lots) :
                                             MarketInfoUtils::NormalizeLotsDown(lots);
              if (lots == 0) {
                continue;
              }
              if (lots == OrderLots()) {
                CloseOrderByOrderTicket(OrderTicket(), 0);
                continue;
              }
              is_success = CloseOrderByOrderTicket(OrderTicket(), 0, lots);
        }
    }
    // TODO: Replace Check, Checks all closing operation structure
    // TODO: Adds the testing check mode with all functions in OrderManager
    is_success = true;
    return is_success;
}
bool OrderCloseUtils::CloseAllBuyOrders() {
  int total_orders_num = OrdersTotal();
  bool is_success = false;
  for (int i = total_orders_num - 1; i >= 0; i--) {
     RefreshRates();
     if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
         && OrderType() == OP_BUY) {
           RefreshRates();
           is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
     }
  }
  return is_success;
}
bool OrderCloseUtils::CloseAllBuyOrders(int magic_number) {
    bool is_success = false;
     int total_orders_num = OrdersTotal();
     for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
              RefreshRates();
              is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
        }
     }
     return is_success;
}
bool OrderCloseUtils::CloseAllBuyOrders(HashSet<int>* magic_number_set) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_BUY && magic_number_set.contains(OrderMagicNumber())) {
              RefreshRates();
              is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
        }
    }
    return is_success;
}
bool OrderCloseUtils::CloseAllBuyProfitOrders(int magic_number, double profit) {
   int total_orders_num = OrdersTotal();
   bool is_success = false;
   for (int i = total_orders_num - 1; i >= 0; i--) {
      RefreshRates();
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
          && OrderType() == OP_BUY && OrderMagicNumber() == magic_number
          && (OrderProfit() + OrderSwap() + OrderCommission()) >= profit) {
            RefreshRates();
            is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
      }
   }
   return is_success;
}
bool OrderCloseUtils::CloseAllBuyProfitOrders(HashSet<int>* magic_number_set, double profit) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_BUY && magic_number_set.contains(OrderMagicNumber())
            && (OrderProfit() + OrderSwap() + OrderCommission()) >= profit) {
            RefreshRates();
            is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
        }
    }
    return is_success;
}
bool OrderCloseUtils::CloseAllSellOrders() {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL) {
            RefreshRates();
            is_success = CloseOrderByOrderTicket(OrderTicket(), 1);
        }
    }
    return is_success;
}
bool OrderCloseUtils::CloseAllSellOrders(int magic_number) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
            RefreshRates();
            is_success = CloseOrderByOrderTicket(OrderTicket(), 1);
        }
    }
    return is_success;
}
bool OrderCloseUtils::CloseAllSellOrders(HashSet<int>* magic_number_set) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL
            &&  magic_number_set.contains(OrderMagicNumber())) {
            RefreshRates();
            is_success = CloseOrderByOrderTicket(OrderTicket(), 1);
        }
    }
    return is_success;
}
bool OrderCloseUtils::CloseAllSellProfitOrders(int magic_number, double profit) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL && OrderMagicNumber() == magic_number
            && (OrderProfit() + OrderSwap() + OrderCommission()) >= profit) {
            RefreshRates();
            is_success = CloseOrderByOrderTicket(OrderTicket(), 1);
        }
    }
    return is_success;
}
bool OrderCloseUtils::CloseAllSellProfitOrders(HashSet<int>* magic_number_set, double profit) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL && magic_number_set.contains(OrderMagicNumber())
            && (OrderProfit() + OrderSwap() + OrderCommission()) >= profit) {
            RefreshRates();
            is_success = CloseOrderByOrderTicket(OrderTicket(), 1);
            PrintFormat("Activate close: %d", OrderTicket());
        }
    }
    return is_success;
}
bool OrderCloseUtils::CloseOrderByOrderTicket(int order_ticket, int dir) {
    double spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
    bool is_success = false;
    int cnt = 100;
    while (!is_success && cnt >= 0) {
        is_success = OrderSelect(order_ticket, SELECT_BY_TICKET, MODE_TRADES);
        RefreshRates();
        Print("CloseOrderByOrderTicket Select Order ", order_ticket, " error, Repeat Operations!");
        cnt--;
    }

    if (!is_success) Print("After Trying 100 times, Can not Selecting Order: ", order_ticket);

    is_success = false;
    cnt = 100;
    while (!is_success && cnt >= 0) {
        is_success = OrderClose(order_ticket,OrderLots(),OrderClosePrice(),
                                int(2*spread),clrFireBrick);
        Print("CloseOrderByOrderTicket Close Order ", order_ticket, " error, Repeat Operations!");
        cnt--;
    }

    if (!is_success) {
        Print("Error: ", GetLastError());
        Print("After Trying 100 times, Can not Closing Order: ", order_ticket);
    }
    return is_success;
}
bool OrderCloseUtils::CloseOrderByOrderTicket(int order_ticket, int dir, double lots) {
    double spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
    bool is_success = false;
    int cnt = 100;
    while (!is_success && cnt >= 0) {
        is_success = OrderSelect(order_ticket, SELECT_BY_TICKET, MODE_TRADES);
        RefreshRates();
        Print("CloseOrderByOrderTicket Select Order ", order_ticket, " error, Repeat Operations!");
        cnt--;
    }

    if (!is_success) Print("After Trying 100 times, Can not Selecting Order: ", order_ticket);

    is_success = false;
    cnt = 100;
    while (!is_success && cnt >= 0) {
        is_success = OrderClose(order_ticket,lots,OrderClosePrice(), int(2*spread), clrFireBrick);
        Print("CloseOrderByOrderTicket Close Order ", order_ticket, " error, Repeat Operations!");
        cnt--;
    }

    if (!is_success) {
        Print("Error: ", GetLastError());
        PrintFormat("After Trying 100 times, Can not Closing Order %d with lots <%.4f>",
                    order_ticket, lots);
    }
    return is_success;
}
bool OrderCloseUtils::CloseSingleOrderByProfit(double profit) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && (OrderProfit() + OrderSwap() + OrderCommission()) >= profit) {
            RefreshRates();
            if (OrderType() == OP_BUY) is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
            if (OrderType() == OP_SELL) is_success = CloseOrderByOrderTicket(OrderTicket(), 1);
        }
    }
    return is_success;
}
bool OrderCloseUtils::CloseSingleOrderByLoss(double loss) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
        && (OrderProfit() + OrderSwap() + OrderCommission()) <= -loss) {
            RefreshRates();
            if (OrderType() == OP_BUY) is_success = CloseOrderByOrderTicket(OrderTicket(), 0);
            if (OrderType() == OP_SELL) is_success = CloseOrderByOrderTicket(OrderTicket(), 1);
        }
    }
    return is_success;
}