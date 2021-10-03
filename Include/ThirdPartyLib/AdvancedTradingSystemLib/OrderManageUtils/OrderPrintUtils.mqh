#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"

class OrderPrintUtils : public OrderManageUtils {
    public:
        OrderPrintUtils():OrderManageUtils() {}
        ~OrderPrintUtils() {}
    public:
        // 打印函数
        static void PrintAllOrdersInTrade();
        static void PrintAllOrdersInTrade(string comm);
        static void PrintAllOrdersInTrade(int magic_number);
};

// 打印函数
void OrderPrintUtils::PrintAllOrdersInTrade() {
    Print("----------------------PrintAllOrdersInTradeStart----------------------------------");
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
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
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && (OrderComment() == comm)) {
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
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderMagicNumber() == magic_number) {
            OrderPrint();
        }
    }
    Print("----------------------PrintAllOrdersInTradeEnd----------------------------------");
}