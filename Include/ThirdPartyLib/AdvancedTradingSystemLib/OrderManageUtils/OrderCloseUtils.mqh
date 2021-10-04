#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>

class OrderCloseUtils : public OrderManageUtils {
    public:
        OrderCloseUtils():OrderManageUtils() {}
        ~OrderCloseUtils() {}
    public:
        // 平仓函数
        bool CloseAllOrders(int magic_number);
        static bool CloseAllOrders(HashSet<int>* magic_number);
        bool CloseAllBuyOrders();
        bool CloseAllBuyOrders(int magic_number);
        bool CloseAllBuyProfitOrders(int magic_number, double profit);
        bool CloseAllSellOrders();
        bool CloseAllSellOrders(int magic_number);
        bool CloseAllSellProfitOrders(int magic_number, double profit);
        static bool CloseOrderByOrderTicket(int order_ticket, int dir);
        bool CloseSingleOrderByProfit(double profit);
        bool CloseSingleOrderByLoss(double loss);
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
bool OrderCloseUtils::CloseAllOrders(HashSet<int>* magic_number_set) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && magic_number_set.contains(OrderMagicNumber())) {
              RefreshRates();
              CloseOrderByOrderTicket(OrderTicket(), 0);
        }
    }
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
           CloseOrderByOrderTicket(OrderTicket(), 0);
     }
  }
  return is_success;
}
bool OrderCloseUtils::CloseAllBuyOrders(int magic_number) {
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
bool OrderCloseUtils::CloseAllBuyProfitOrders(int magic_number, double profit) {
       int total_orders_num = OrdersTotal();
       bool is_success = false;
       for (int i = total_orders_num - 1; i >= 0; i--) {
          RefreshRates();
          if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
                          && OrderType() == OP_BUY && OrderMagicNumber() == magic_number
                          && (OrderProfit() + OrderSwap() + OrderCommission()) >= profit) {
                RefreshRates();
                CloseOrderByOrderTicket(OrderTicket(), 0);
          }
       }
       return is_success;
}
bool OrderCloseUtils::CloseAllSellOrders() {
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
bool OrderCloseUtils::CloseAllSellOrders(int magic_number) {
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
bool OrderCloseUtils::CloseAllSellProfitOrders(int magic_number, double profit) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL && OrderMagicNumber() == magic_number
            && (OrderProfit() + OrderSwap() + OrderCommission()) >= profit) {
            RefreshRates();
            CloseOrderByOrderTicket(OrderTicket(), 1);
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
        //Print("CloseOrderByOrderTicket Select Order ", order_ticket, " error, Repeat Operations!");
        cnt--;
    }

    if (!is_success) Print("After Trying 100 times, Can not Selecting Order: ", order_ticket);

    is_success = false;
    cnt = 100;
    while (!is_success && cnt >= 0) {
        // (dir == 0 ? NormalizeDouble(Bid, Digits):NormalizeDouble(Ask, Digits))
        is_success = OrderClose(order_ticket,OrderLots(),OrderClosePrice(),
                                int(2*spread),clrFireBrick);
        //Print("CloseOrderByOrderTicket Close Order ", order_ticket, " error, Repeat Operations!");
        cnt--;
    }

    if (!is_success) {
        Print("Error: ", GetLastError());
        Print("After Trying 100 times, Can not Closing Order: ", order_ticket);
    }
    return is_success;
}
bool OrderCloseUtils::CloseSingleOrderByProfit(double profit) {
    int total_orders_num = OrdersTotal();
    bool is_success = false;
    for (int i = total_orders_num - 1; i >= 0; i--) {
        RefreshRates();
        // Print("----------------------- profit", profit, "----------------------");
        // OrderPrint();
        // Print("----------------------- profit", profit, "----------------------");
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && (OrderProfit() + OrderSwap() + OrderCommission()) >= profit) {
            RefreshRates();
            if (OrderType() == OP_BUY) CloseOrderByOrderTicket(OrderTicket(), 0);
            if (OrderType() == OP_SELL) CloseOrderByOrderTicket(OrderTicket(), 1);
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