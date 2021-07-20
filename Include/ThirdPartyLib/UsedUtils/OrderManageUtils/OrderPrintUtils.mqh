#include "OrderManageUtils.mqh"
#include "OrderInMarket.mqh"

class OrderPrintUtils : public OrderManageUtils {
    public:
        OrderPrintUtils():OrderManageUtils() {}
        virtual ~OrderPrintUtils() {}
    public:
        // 打印函数
        void PrintAllOrders();
};

// 打印函数
void OrderPrintUtils::PrintAllOrders() {
    Print("----------------------PrintAllOrdersStart----------------------------------");
    int total_num = OrdersTotal();
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            OrderPrint();
        }
    }
    Print("----------------------PrintAllOrdersEnd----------------------------------");
}