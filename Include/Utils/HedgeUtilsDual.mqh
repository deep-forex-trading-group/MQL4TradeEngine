#include "OrderManageUtils.mqh"

// #ifndef TestModeOrderManage1
//    #define TestModeOrderManage1
// #endif

struct HedgeUtilsDualParams
{
   bool is_add_new;
   double profit_lower;
   double profit_upper;
   HedgeUtilsDualParams() {
      is_add_new = false;
      profit_lower = 1;
      profit_upper = 2;
   }
};

interface HedgeUtilsDual {
   bool HdegeOrders(HedgeUtilsDualParams &params);
};

class HedgeUtilsDualBuy : public HedgeUtilsDual
{
public:
   double Spread;
   OrderManageUtils ou;

public:
   HedgeUtilsDualBuy() {
      Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
      ou = new OrderManageUtils();
   }
   
   ~HedgeUtilsDualBuy() {
      delete &ou;
   }

public:
   bool HdegeOrders(HedgeUtilsDualParams &params) {
      OrderInMarket buy_profit_orders[1000];
      ou.GetBuyProfitOrdersReverse(buy_profit_orders,-1);
      OrderInMarket buy_loss_orders[1000];
      ou.GetBuyLossOrdersReverse(buy_loss_orders,-1);

      // Print("----------------Start Print Hedge ", ArraySize(buy_loss_orders),", ", ArraySize(buy_profit_orders), "-------------------------");
      for (int i = 0; i < ArraySize(buy_profit_orders); i++) {
         for (int j = 0; j < ArraySize(buy_loss_orders); j++) {
            double current_gain_profit = buy_profit_orders[i].order_profit;
            double current_loss_profit = buy_loss_orders[j].order_profit;
            if (current_gain_profit + current_loss_profit >= params.profit_lower
                && current_gain_profit + current_loss_profit <= params.profit_upper) {
               ou.CloseOrderByOrderTicket(buy_profit_orders[i].order_ticket,0);
               ou.CloseOrderByOrderTicket(buy_loss_orders[j].order_ticket,0);
               if (params.is_add_new) ou.CreateBuyOrder(buy_profit_orders[i].order_lots,0,0);
               return true;
            }
         }
      }
      // Print("----------------End Print Hedge -------------------------");

      return false;
   }

   bool HdegeOrdersOrigin(HedgeUtilsDualParams &params) {
      OrderInMarket buy_profit_orders[1000];
      ou.GetSellProfitOrdersReverse(buy_profit_orders,-1);
      OrderInMarket buy_loss_orders[1000];
      ou.GetSellLossOrdersReverse(buy_loss_orders,-1);

      for (int i = 0; i < ArraySize(buy_profit_orders); i++) {
         for (int j = 0; j < ArraySize(buy_loss_orders); j++) {
            double current_gain_profit = buy_profit_orders[i].order_profit;
            double current_loss_profit = buy_loss_orders[j].order_profit;
            // buy_profit_orders[i].PrintOrderInMarket();
            // buy_loss_orders[j].PrintOrderInMarket();
            if (current_gain_profit + current_loss_profit >= params.profit_lower
               && current_gain_profit + current_loss_profit <= params.profit_upper) {
               ou.CloseOrderByOrderTicket(buy_profit_orders[i].order_ticket,0);
               ou.CloseOrderByOrderTicket(buy_loss_orders[j].order_ticket,0);
               if (params.is_add_new) ou.CreateBuyOrder(buy_profit_orders[i].order_lots,0,0);
               return true;
            }
         }
      }

      return false;
   }

};

class HedgeUtilsDualSell : public HedgeUtilsDual
{
public:
   double Spread;
   OrderManageUtils ou;

public:
   HedgeUtilsDualSell() {
      Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
      ou = new OrderManageUtils();
   }
   
   ~HedgeUtilsDualSell() {
      delete &ou;
   }
   
public:
   bool HdegeOrders(HedgeUtilsDualParams &params) {
      OrderInMarket sell_profit_orders[1000];
      ou.GetSellProfitOrdersReverse(sell_profit_orders,-1);
      OrderInMarket sell_loss_orders[1000];
      ou.GetSellLossOrdersReverse(sell_loss_orders,-1);

      // Print("----------------Start Print Hedge ", ArraySize(buy_loss_orders), "-------------------------");
      for (int i = 0; i < ArraySize(sell_profit_orders); i++) {
         for (int j = 0; j < ArraySize(sell_loss_orders); j++) {
            double current_gain_profit = sell_profit_orders[i].order_profit;
            double current_loss_profit = sell_loss_orders[j].order_profit;
            if (current_gain_profit + current_loss_profit >= params.profit_lower
                && current_gain_profit + current_loss_profit <= params.profit_upper) {
               ou.CloseOrderByOrderTicket(sell_profit_orders[i].order_ticket,0);
               ou.CloseOrderByOrderTicket(sell_loss_orders[j].order_ticket,0);
               if (params.is_add_new) ou.CreateSellOrder(sell_profit_orders[i].order_lots,0,0);
               return true;
            }
         }
      }
      // Print("----------------End Print Hedge -------------------------");

      return false;
   }

   bool HdegeOrdersOrigin(HedgeUtilsDualParams &params) {
      OrderInMarket order_in_market[1000];
      ou.GetSellOrdersReverse(order_in_market, 2);
      if (ArraySize(order_in_market) >= 2) {
         #ifdef TestModeOrderManage
            Print(order_in_market[0].order_ticket, ",", order_in_market[1].order_ticket, "," , (order_in_market[0].order_profit + order_in_market[1].order_profit), 
                  ", ", add_order_profit_value);
         #endif
         double current_profit = order_in_market[0].order_profit + order_in_market[1].order_profit;
         if (current_profit <= params.profit_upper && current_profit >= params.profit_lower) {
            ou.CloseOrderByOrderTicket(order_in_market[0].order_ticket,1);
            ou.CloseOrderByOrderTicket(order_in_market[1].order_ticket,1);
            if (params.is_add_new) ou.CreateSellOrder(order_in_market[0].order_lots,0,0);
            return true;
         }
      }
      return false;
   }
};