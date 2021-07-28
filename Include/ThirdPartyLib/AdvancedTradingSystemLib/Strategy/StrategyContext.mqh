#include "StrategyBase/all.mqh"

class StrategyContext {
    public:
        StrategyContext(Strategy *strategy = NULL) : strategy_(strategy) {};
        ~StrategyContext() {
            delete this.strategy_;
        };

    public:
        int SetStrategy(Strategy *strategy);
        int ExecuteStrategy() const;


// Member Variables and Functions
    private:
        Strategy *strategy_;
};

int StrategyContext::SetStrategy(Strategy *strategy) {
    delete this.strategy_;
    this.strategy_ = strategy;
    return SUCCEEDED;
}

int StrategyContext::ExecuteStrategy() const {
    this.strategy_.ExecuteStrategy();
    return SUCCEEDED;
}