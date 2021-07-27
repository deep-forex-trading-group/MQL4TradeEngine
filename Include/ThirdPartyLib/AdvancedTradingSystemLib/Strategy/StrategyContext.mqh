#include "StrategyBase/all.mqh"

class StrategyContext {
    public:
        StrategyContext(Strategy *strategy = NULL) : strategy_(strategy) {};
        ~StrategyContext() {
            delete this.strategy_;
        };

    public:
        int SetStrategy(Strategy *strategy);
        int ExecuteStrategy(StrategyParams* strategyParams) const;
        int ExecuteStrategy(ConfigFile* config_file) const;


// Member Variables and Functions
    private:
        Strategy *strategy_;
};

int StrategyContext::SetStrategy(Strategy *strategy) {
    delete this.strategy_;
    this.strategy_ = strategy;
    return SUCCEEDED;
}

int StrategyContext::ExecuteStrategy(StrategyParams* strategyParams) const {
    this.strategy_.ExecuteStrategy(strategyParams);
    return SUCCEEDED;
}

int StrategyContext::ExecuteStrategy(ConfigFile* config_file) const {
    this.strategy_.ExecuteStrategy(config_file);
    return SUCCEEDED;
}