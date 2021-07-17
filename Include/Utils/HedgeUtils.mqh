#include "OrderManageUtils.mqh"

// #ifndef TestModeOrderManage1
//    #define TestModeOrderManage1
// #endif

interface HedgeUtils {
   bool HdegeOrders(bool is_add_new, int spread_beishu);
};

class HedgeUtilsBuy : public HedgeUtils
{
public:
   double Spread;
   OrderManageUtils ou;
   double add_order_profit_value;

public:
   HedgeUtilsBuy(double aopv) {
      Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
      ou = new OrderManageUtils();
      this.add_order_profit_value = aopv;
   }
   
   ~HedgeUtilsBuy() {
      delete &ou;
   }

public:
   bool HdegeOrders(bool is_add_new, int spread_beishu) {
      OrderInMarket order_in_market[1000];
      ou.GetBuyOrdersReverse(order_in_market, 2);
      if (ArraySize(order_in_market) >= 2) {
         #ifdef TestModeOrderManage
            Print(order_in_market[0].order_ticket, ",", order_in_market[1].order_ticket, "," , (order_in_market[0].order_profit + order_in_market[1].order_profit), 
               ", ", add_order_profit_value);
         #endif

         if (order_in_market[0].order_profit + order_in_market[1].order_profit <= add_order_profit_value) {
            ou.CloseOrderByOrderTicket(order_in_market[0].order_ticket,0);
            ou.CloseOrderByOrderTicket(order_in_market[1].order_ticket,0);
            if (is_add_new) ou.CreateBuyOrder(order_in_market[0].order_lots,0,0);
            return true;
         }
      }
      return false;
   }

};

class HedgeUtilsSell : public HedgeUtils
{
public:
   double Spread;
   OrderManageUtils ou;
   double add_order_profit_value;

public:
   HedgeUtilsSell(double aopv) {
      Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),Digits)*Point;
      ou = new OrderManageUtils();
      this.add_order_profit_value = aopv;
   }
   
   ~HedgeUtilsSell() {
      delete &ou;
   }
   
public:
   bool HdegeOrders(bool is_add_new, int spread_beishu) {
      OrderInMarket order_in_market[1000];
      ou.GetSellOrdersReverse(order_in_market, 2);
      if (ArraySize(order_in_market) >= 2) {
         #ifdef TestModeOrderManage
            Print(order_in_market[0].order_ticket, ",", order_in_market[1].order_ticket, "," , (order_in_market[0].order_profit + order_in_market[1].order_profit), 
                  ", ", add_order_profit_value);
         #endif
         if (order_in_market[0].order_profit + order_in_market[1].order_profit <= add_order_profit_value) {
            ou.CloseOrderByOrderTicket(order_in_market[0].order_ticket,1);
            ou.CloseOrderByOrderTicket(order_in_market[1].order_ticket,1);
            if (is_add_new) ou.CreateSellOrder(order_in_market[0].order_lots,0,0);
            return true;
         }
      }
      return false;
   }
};