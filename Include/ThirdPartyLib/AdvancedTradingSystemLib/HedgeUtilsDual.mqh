#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderManageUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderGetUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderCloseUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderSendUtils.mqh>

// #ifndef TestModeOrderManage1
//    #define TestModeOrderManage1
// #endif

struct HedgeUtilsDualParams {
    bool is_add_new;
    double profit_lower;
    double profit_upper;
    HedgeUtilsDualParams() {
        is_add_new = false;
        profit_lower = 1;
        profit_upper = 2;
    }
};

class HedgeUtilsDual {

    public:
        HedgeUtilsDual(double aopv) {
            this.Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
            this.add_order_profit_value = aopv;
        }
        virtual ~HedgeUtilsDual();

    protected:
        OrderGetUtils ou_get;
        OrderCloseUtils ou_close;
        OrderSendUtils ou_send;
        double Spread;
        double add_order_profit_value;

    public:
        virtual bool HdegeOrders(HedgeUtilsDualParams &params);
        virtual bool HdegeOrdersOrigin(HedgeUtilsDualParams &params);
};

class HedgeUtilsDualBuy : public HedgeUtilsDual {
    public:
        HedgeUtilsDualBuy(double aopv) : HedgeUtilsDual(aopv) {}
        virtual ~HedgeUtilsDualBuy() {}
    public:
        virtual bool HdegeOrders(HedgeUtilsDualParams &params);
        virtual bool HdegeOrdersOrigin(HedgeUtilsDualParams &params);
};

bool HedgeUtilsDualBuy::HdegeOrders(HedgeUtilsDualParams &params) {
    OrderInMarket buy_profit_orders[1000];
    ou_get.GetBuyProfitOrdersReverse(buy_profit_orders,-1);
    OrderInMarket buy_loss_orders[1000];
    ou_get.GetBuyLossOrdersReverse(buy_loss_orders,-1);

    // Print("----------------Start Print Hedge ", ArraySize(buy_loss_orders),", ", ArraySize(buy_profit_orders), "-------------------------");
    for (int i = 0; i < ArraySize(buy_profit_orders); i++) {
        for (int j = 0; j < ArraySize(buy_loss_orders); j++) {
            double current_gain_profit = buy_profit_orders[i].order_profit;
            double current_loss_profit = buy_loss_orders[j].order_profit;
            if (current_gain_profit + current_loss_profit >= params.profit_lower
            && current_gain_profit + current_loss_profit <= params.profit_upper) {
            ou_close.CloseOrderByOrderTicket(buy_profit_orders[i].order_ticket,0);
            ou_close.CloseOrderByOrderTicket(buy_loss_orders[j].order_ticket,0);
            if (params.is_add_new) ou_send.CreateBuyOrder(buy_profit_orders[i].order_lots,0,0);
                return true;
            }
        }
    }
    // Print("----------------End Print Hedge -------------------------");

    return false;
}

bool HedgeUtilsDualBuy::HdegeOrdersOrigin(HedgeUtilsDualParams &params) {
    OrderInMarket buy_profit_orders[1000];
    ou_get.GetSellProfitOrdersReverse(buy_profit_orders,-1);
    OrderInMarket buy_loss_orders[1000];
    ou_get.GetSellLossOrdersReverse(buy_loss_orders,-1);

    for (int i = 0; i < ArraySize(buy_profit_orders); i++) {
        for (int j = 0; j < ArraySize(buy_loss_orders); j++) {
            double current_gain_profit = buy_profit_orders[i].order_profit;
            double current_loss_profit = buy_loss_orders[j].order_profit;
            // buy_profit_orders[i].PrintOrderInMarket();
            // buy_loss_orders[j].PrintOrderInMarket();
            if (current_gain_profit + current_loss_profit >= params.profit_lower
                && current_gain_profit + current_loss_profit <= params.profit_upper) {
                ou_close.CloseOrderByOrderTicket(buy_profit_orders[i].order_ticket,0);
                ou_close.CloseOrderByOrderTicket(buy_loss_orders[j].order_ticket,0);
                if (params.is_add_new) ou_send.CreateBuyOrder(buy_profit_orders[i].order_lots,0,0);
                    return true;
            }
        }
    }

    return false;
}

class HedgeUtilsDualSell : public HedgeUtilsDual {
    public:
        HedgeUtilsDualSell(double aopv) : HedgeUtilsDual(aopv) {}
        virtual ~HedgeUtilsDualSell() {}
    public:
        virtual bool HdegeOrders(HedgeUtilsDualParams &params);
        virtual bool HdegeOrdersOrigin(HedgeUtilsDualParams &params);
};

bool HedgeUtilsDualSell::HdegeOrders(HedgeUtilsDualParams &params) {
    OrderInMarket sell_profit_orders[1000];
    ou_get.GetSellProfitOrdersReverse(sell_profit_orders,-1);
    OrderInMarket sell_loss_orders[1000];
    ou_get.GetSellLossOrdersReverse(sell_loss_orders,-1);

    // Print("----------------Start Print Hedge ", ArraySize(buy_loss_orders), "-------------------------");
    for (int i = 0; i < ArraySize(sell_profit_orders); i++) {
        for (int j = 0; j < ArraySize(sell_loss_orders); j++) {
            double current_gain_profit = sell_profit_orders[i].order_profit;
            double current_loss_profit = sell_loss_orders[j].order_profit;
            if (current_gain_profit + current_loss_profit >= params.profit_lower
                && current_gain_profit + current_loss_profit <= params.profit_upper) {
                ou_close.CloseOrderByOrderTicket(sell_profit_orders[i].order_ticket,0);
                ou_close.CloseOrderByOrderTicket(sell_loss_orders[j].order_ticket,0);
                if (params.is_add_new) ou_send.CreateSellOrder(sell_profit_orders[i].order_lots,0,0);
                return true;
            }
        }
    }
    // Print("----------------End Print Hedge -------------------------");

    return false;
}

bool HedgeUtilsDualSell::HdegeOrdersOrigin(HedgeUtilsDualParams &params) {
    OrderInMarket order_in_market[1000];
    ou_get.GetSellOrdersReverse(order_in_market, 2);
    if (ArraySize(order_in_market) >= 2) {
        #ifdef TestModeOrderManage
        Print(order_in_market[0].order_ticket, ",", order_in_market[1].order_ticket, "," , (order_in_market[0].order_profit + order_in_market[1].order_profit),
        ", ", add_order_profit_value);
        #endif
        double current_profit = order_in_market[0].order_profit + order_in_market[1].order_profit;
        if (current_profit <= params.profit_upper && current_profit >= params.profit_lower) {
            ou_close.CloseOrderByOrderTicket(order_in_market[0].order_ticket,1);
            ou_close.CloseOrderByOrderTicket(order_in_market[1].order_ticket,1);
            if (params.is_add_new) ou_send.CreateSellOrder(order_in_market[0].order_lots,0,0);
            return true;
        }
    }
    return false;
}