#include "../../StrategyBase/all.mqh"
#include "DataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/AutoAdjustCenter/all.mqh>

class AutoAdjustStrategy : public Strategy {
    public:
        AutoAdjustStrategy(string strategy_name, AutoAdjustOrderGroup* auto_adjust_order_group)
                            : auto_adjust_order_group_(auto_adjust_order_group) {
            this.strategy_name_ = strategy_name;
        };
        ~AutoAdjustStrategy() {};

// Implements the abstract methods in base class Strategy
    public:
        int ExecuteStrategy() const;
        int OnTickExecute();
        int OnActionExecute();
        int SetAutoAdjustOrderGroup(AutoAdjustOrderGroup* auto_adjust_order_group);
        void PrintStrategyInfo() const;
    private:
        AutoAdjustOrderGroup* auto_adjust_order_group_;
};