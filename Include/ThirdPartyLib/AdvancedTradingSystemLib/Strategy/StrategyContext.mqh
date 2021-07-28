#include "StrategyBase/all.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
class StrategyContext {
    public:
        StrategyContext(Strategy *strategy = NULL) : strategy_(strategy) {};
        ~StrategyContext() {
            SaveDeletePtr(this.strategy_);
        };

    public:
        int SetStrategy(Strategy* strategy);
        int ExecuteStrategy() const;


// Member Variables and Functions
    private:
        Strategy *strategy_;
};

int StrategyContext::SetStrategy(Strategy *strategy) {
    this.strategy_ = strategy;
    return SUCCEEDED;
}

int StrategyContext::ExecuteStrategy() const {
    if(IsPtrInvalid(this.strategy_)) {
        PrintFormat("The strategy_ pointer in StrategyContext is invalid");
        return FAILED;
    }
    this.strategy_.ExecuteStrategy();
    return SUCCEEDED;
}