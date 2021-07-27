#include "StrategyBase/all.mqh"

class StrategyContext {
    public:
        StrategyContext(Strategy *strategy = NULL) : strategy_(strategy) {};
        ~StrategyContext() {
            delete this.strategy_;
        };

    public:
        int set_strategy(Strategy *strategy);
        int executeStrategy(StrategyParams& strategyParams) const;
        int executeStrategy(ConfigFile* config_file) const;


// Member Variables and Functions
    private:
        Strategy *strategy_;
};

int StrategyContext::set_strategy(Strategy *strategy) {
    delete this.strategy_;
    this.strategy_ = strategy;
    return SUCCEEDED;
}

int StrategyContext::executeStrategy(StrategyParams& strategyParams) const {
    this.strategy_.executeStrategy(strategyParams);
    return SUCCEEDED;
}

int StrategyContext::executeStrategy(ConfigFile* config_file) const {
    this.strategy_.executeStrategy(config_file);
    return SUCCEEDED;
}