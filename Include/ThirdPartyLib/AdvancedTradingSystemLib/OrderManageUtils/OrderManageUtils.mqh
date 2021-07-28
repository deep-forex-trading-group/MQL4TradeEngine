#include "OrderInMarket.mqh"

// Base Class For Order Management
class OrderManageUtils {
    public:

        OrderManageUtils() {
            Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
        }

        virtual ~OrderManageUtils() {}

// Member Variables and Functions
    protected:
        double Spread;
};