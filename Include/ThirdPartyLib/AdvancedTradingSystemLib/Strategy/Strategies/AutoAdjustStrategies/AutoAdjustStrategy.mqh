#include "../../StrategyBase/all.mqh"
#include "DataStructure.mqh"

class AutoAdjustStrategy : public Strategy {
    public:
        AutoAdjustStrategy(string strategy_name) {
            this.strategy_name_ = strategy_name;
        };
        ~AutoAdjustStrategy() {};

// Implements the abstract methods in base class Strategy
    public:
        int ExecuteStrategy() const;
        void PrintStrategyInfo() const;
        void SetStrategyParams(AutoAdjustStrategyParams* params) {
            this.strategy_params_ = params;
        }
    private:
        AutoAdjustStrategyParams* strategy_params_;
};