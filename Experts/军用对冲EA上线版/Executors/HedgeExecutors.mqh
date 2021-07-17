#include <UsedUtils/OrderManageUtils.mqh>

#ifndef TestModeHedgeExecutors
   #define TestModeHedgeExecutors
#endif

interface HedegExecutor {

public:
   bool ExecuteHedgeProcess() {
      return false;
   }

};

class HedgeExecutorBuy : public HedegExecutor {
public:
   bool is_already_hedged;

public:
   OrderInMarket buy_order_in_market_arr[100];
   int total_buy_order_size;
public:
   HedgeExecutorBuy() {}

   ~HedgeExecutorBuy() {}

public:
   bool ExecuteHedgeProcess() {
      return false;
   }

};

class HedgeExecutorSell : public HedegExecutor {
public:
   bool is_already_hedged;

public:
   HedgeExecutorSell() {}

   ~HedgeExecutorSell() {}

public:
   bool ExecuteHedgeProcess() {
      return false;
   }

};

