#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderGetUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderCloseUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderSendUtils.mqh>

// #ifndef TestModeOrderManage1
//    #define TestModeOrderManage1
// #endif

class HedgeUtils {
    public:
        double Spread;
        double add_order_profit_value;
        HedgeUtils(double aopv) {
            this.Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
            this.add_order_profit_value = aopv;
        }
        virtual ~HedgeUtils();

    protected:
        OrderGetUtils ou_get;
        OrderCloseUtils ou_close;
        OrderSendUtils ou_send;

    public:
        virtual bool HdegeOrders(bool is_add_new, int spread_beishu);
};

class HedgeUtilsBuy : public HedgeUtils {
    public:
        HedgeUtilsBuy(double aopv) : HedgeUtils(aopv) {}
        virtual ~HedgeUtilsBuy() {}

    public:
        virtual bool HdegeOrders(bool is_add_new, int spread_beishu);
};

bool HedgeUtilsBuy::HdegeOrders(bool is_add_new, int spread_beishu) {
    OrderInMarket order_in_market[1000];
    ou_get.GetBuyOrdersReverse(order_in_market, 2);
    if (ArraySize(order_in_market) >= 2) {
        #ifdef TestModeOrderManage
            Print(order_in_market[0].order_ticket, ",", order_in_market[1].order_ticket,
                    "," , (order_in_market[0].order_profit + order_in_market[1].order_profit),
                    ", ", add_order_profit_value);
        #endif

        if (order_in_market[0].order_profit + order_in_market[1].order_profit <= add_order_profit_value) {
            ou_close.CloseOrderByOrderTicket(order_in_market[0].order_ticket,0);
            ou_close.CloseOrderByOrderTicket(order_in_market[1].order_ticket,0);
            if (is_add_new) ou_send.CreateBuyOrder(order_in_market[0].order_lots,0,0);
            return true;
        }
    }
    return false;
};

class HedgeUtilsSell : public HedgeUtils {
    public:
       HedgeUtilsSell(double aopv) : HedgeUtils(aopv) {}
       virtual ~HedgeUtilsSell() {}

    public:
        virtual bool HdegeOrders(bool is_add_new, int spread_beishu);
};

bool HedgeUtilsSell::HdegeOrders(bool is_add_new, int spread_beishu) {
    OrderInMarket order_in_market[1000];
    ou_get.GetSellOrdersReverse(order_in_market, 2);
    if (ArraySize(order_in_market) >= 2) {
        #ifdef TestModeOrderManage
            Print(order_in_market[0].order_ticket, ",", order_in_market[1].order_ticket,
                  "," , (order_in_market[0].order_profit + order_in_market[1].order_profit),
                  ", ", add_order_profit_value);
        #endif
        if (order_in_market[0].order_profit + order_in_market[1].order_profit <= add_order_profit_value) {
            ou_close.CloseOrderByOrderTicket(order_in_market[0].order_ticket,1);
            ou_close.CloseOrderByOrderTicket(order_in_market[1].order_ticket,1);
            if (is_add_new) ou_send.CreateSellOrder(order_in_market[0].order_lots,0,0);
            return true;
        }
    }
    return false;
}