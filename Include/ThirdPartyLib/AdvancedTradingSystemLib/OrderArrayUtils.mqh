#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderInMarket.mqh>

class OrderArrayUtils {
    public:
        OrderArrayUtils() {};
        ~OrderArrayUtils() {};
    public:
        // 订单数组复制函数
        int ArrayCopyOrderInMarket(OrderInMarket& dst_array[], OrderInMarket& src_array[]);
};

// 订单数组复制函数
int OrderArrayUtils::ArrayCopyOrderInMarket(OrderInMarket& dst_array[], OrderInMarket& src_array[]) {
    int total_num = ArraySize(src_array);
    for (int i = 0; i < total_num; i++) {
        OrderInMarket oi_origin = src_array[i];
        OrderInMarket other[1];
        oi_origin.copyOrder(other);
        dst_array[i] = other[0];
    }

    ArrayResize(dst_array, total_num);

    return 0;
}
