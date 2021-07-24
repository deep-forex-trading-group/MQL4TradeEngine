#include <ThirdPartyLib/Trade/Order.mqh>
#include <ThirdPartyLib/Trade/OrderPool.mqh>
#include <ThirdPartyLib/Trade/OrderManager.mqh>

#include <ThirdPartyLib/Collection/List.mqh>
#include <ThirdPartyLib/Collection/LinkedList.mqh>

#include <ThirdPartyLib/Collection/Map.mqh>
#include <ThirdPartyLib/Collection/HashMap.mqh>

class HedgeAttribute {
   public:
      HedgeAttribute(double l, double d):lots(l),distance(d) {}
   public:
      double lots;
      double distance;
};


class Configuration {
   public:
      // Magic Numbers
      int MagicNumberBuy;   
      int MagicNumberSell;
      LinkedList<HedgeAttribute*> ha_list;

      // order comment
      string ORDER_COMMENT;

   private: 
      static Configuration* instance;
   public: 
      Configuration() {
         MagicNumberBuy = 123456789;
         MagicNumberSell = 987654321;
         ha_list = new LinkedList<HedgeAttribute*>;
         ORDER_COMMENT = "EURUSD#BUY#1234567890#1234567890#1234567890";
         
         ha_list.push(new HedgeAttribute(0.01,-1));
         ha_list.push(new HedgeAttribute(0.02,20));
         ha_list.push(new HedgeAttribute(0.04,20));
         ha_list.push(new HedgeAttribute(0.08,30));
         ha_list.push(new HedgeAttribute(0.16,30));
      };

      ~Configuration(){}
   // public: 
   //    static Configuration* getInstance() {
   //       if (instance == NULL) {
   //          instance = new Configuration();
   //       }
   //       return instance;
   //    }
};