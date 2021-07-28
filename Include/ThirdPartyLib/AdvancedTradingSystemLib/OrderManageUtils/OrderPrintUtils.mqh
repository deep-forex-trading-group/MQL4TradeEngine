#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"

class OrderPrintUtils : public OrderManageUtils {
    public:
        OrderPrintUtils():OrderManageUtils() {}
        ~OrderPrintUtils() {}
    public:
        // 打印函数
        void PrintAllOrders(int magic_number);
};

// 打印函数
void OrderPrintUtils::PrintAllOrders(int magic_number) {
    Print("----------------------PrintAllOrdersStart----------------------------------");
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderMagicNumber() == magic_number) {
            OrderPrint();
        }
    }
    Print("----------------------PrintAllOrdersEnd----------------------------------");
}