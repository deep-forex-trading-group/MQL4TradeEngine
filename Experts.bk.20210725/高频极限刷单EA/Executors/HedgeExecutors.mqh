#include <ThirdPartyLib/Trade/Order.mqh>
#include <ThirdPartyLib/Trade/OrderPool.mqh>
#include <ThirdPartyLib/Trade/OrderManager.mqh>
#include <ThirdPartyLib/Collection/List.mqh>
#include <ThirdPartyLib/Collection/LinkedList.mqh>
#include <ThirdPartyLib/Utils/File.mqh>

#include "../Conf/Configuration.mqh"

#ifndef TestModeHedgeExecutors
   #define TestModeHedgeExecutors
#endif

class HedgeExecutor {
   public:
      HedgeExecutor(Configuration& conf_from_base) {
         this.conf = conf_from_base;
         getHaList(this.ha_list);
      };
      ~HedgeExecutor() {};
   private:
      Configuration conf;
      LinkedList<HedgeAttribute*> ha_list;
   public:
      int execute() const {
         return 1; 
      }

      bool hedgeOrders(const LinkedList<HedgeAttribute*> &ha_list) const {
         TradingPool trading_pool;
         LinkedList<LinkedList<Order*>*> list;
         LinkedList<Order*> rs_list;

         // for(OrderPoolIter __it__(trading_pool); !__it__.end(); __it__.next()) {
         //    Print("exe 2");
         //    Order o;
         //    if (o.Comment()==conf.ORDER_COMMENT) {
         //       // rs_list.push(new Order());
         //    }
         // }
         // foreachorder(trading_pool) {
            
         // }
         // list.push(&rs_list);

         // for(Iter<LinkedList<Order*>*> it_list(list); !it_list.end(); it_list.next()) {
         //    LinkedList<Order*> current_list = it_list.current();
         //    for (Iter<Order*> it_order(current_list); !it_order.end(); it_order.next()) {
         //       Order* order2print = it_order.current();
         //       Print(order2print.toString());
         //    }
         // }

         return true;
      }

      bool getHaList(const LinkedList<HedgeAttribute*> &ha_list) {
         this.ha_list.push(new HedgeAttribute(0.01,-1));
         this.ha_list.push(new HedgeAttribute(0.02,20));
         this.ha_list.push(new HedgeAttribute(0.04,20));
         this.ha_list.push(new HedgeAttribute(0.08,30));
         this.ha_list.push(new HedgeAttribute(0.16,30));
         return true;
      }
};
