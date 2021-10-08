#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"

class OrderPrintUtils : public OrderManageUtils {
    public:
        OrderPrintUtils():OrderManageUtils() {}
        ~OrderPrintUtils() {}
    public:
        // 打印函数
        static void PrintAllOrders();
        static void PrintAllOrdersInTrade();
        static void PrintAllOrdersInTrade(string comm);
        static void PrintAllOrdersInTrade(int magic_number);
};
// Print Format:

// #ticket number; open time; trade operation; amount of lots; symbol;
// open price; Stop Loss; Take Profit; close time; close price;
// commission; swap; profit; comment; magic number; pending order expiration date.
// 打印函数
void OrderPrintUtils::PrintAllOrders() {
    Print("----------------------PrintAllOrdersStart----------------------------------");
    int total_num = OrdersTotal();
    int total_history_num = OrdersHistoryTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
            && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
            RefreshRates();
            OrderPrint();
        }
    }
    for (int i_his = total_history_num - 1; i_his >= 0; i_his--) {
        RefreshRates();
        if (OrderSelect(i_his, SELECT_BY_POS, MODE_HISTORY)
            && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
            RefreshRates();
            OrderPrint();
        }
    }
    Print("----------------------PrintAllOrdersEnd----------------------------------");
}
// 打印函数
void OrderPrintUtils::PrintAllOrdersInTrade() {
    Print("----------------------PrintAllOrdersInTradeStart----------------------------------");
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)
            && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
            RefreshRates();
            OrderPrint();
        }
    }
    Print("----------------------PrintAllOrdersInTradeEnd----------------------------------");
}
// 打印函数
void OrderPrintUtils::PrintAllOrdersInTrade(string comm) {
    Print("----------------------PrintAllOrdersInTradeStart----------------------------------");
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && (OrderComment() == comm)
            && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
            RefreshRates();
            OrderPrint();
        }
    }
    Print("----------------------PrintAllOrdersInTradeEnd----------------------------------");
}
// 打印函数
void OrderPrintUtils::PrintAllOrdersInTrade(int magic_number) {
    Print("----------------------PrintAllOrdersInTradeStart----------------------------------");
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        RefreshRates();
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderMagicNumber() == magic_number
            && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
            RefreshRates();
            OrderPrint();
        }
    }
    Print("----------------------PrintAllOrdersInTradeEnd----------------------------------");
}