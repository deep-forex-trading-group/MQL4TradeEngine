#include "OrderInMarket.mqh"

// Base Class For Order Management
class OrderManageUtils {
    public:

        OrderManageUtils() {
            Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
            // Magic Numbers
            MagicNumberBuy        = 123456789;
            MagicNumberSell       = 987654321;
        }

        virtual ~OrderManageUtils() {}

// Member Variables and Functions
    protected:
        double Spread;
        // Magic Numbers
        int MagicNumberBuy;
        int MagicNumberSell;
};