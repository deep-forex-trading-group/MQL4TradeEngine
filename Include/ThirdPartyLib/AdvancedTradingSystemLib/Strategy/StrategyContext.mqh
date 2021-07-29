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
        int OnTickExecuteStrategy();
        int OnActionExecuteStrategy();


// Member Variables and Functions
    private:
        Strategy* strategy_;
};

int StrategyContext::SetStrategy(Strategy *strategy) {
    this.strategy_ = strategy;
    return SUCCEEDED;
}

int StrategyContext::OnTickExecuteStrategy() {
    if(IsPtrInvalid(this.strategy_)) {
        PrintFormat("The strategy_ pointer in StrategyContext is invalid");
        return FAILED;
    }
    this.strategy_.OnTickExecute();
    return SUCCEEDED;
}

int StrategyContext::OnActionExecuteStrategy() {
    if(IsPtrInvalid(this.strategy_)) {
        PrintFormat("The strategy_ pointer in StrategyContext is invalid");
        return FAILED;
    }
    this.strategy_.OnActionExecute();
    return SUCCEEDED;
}