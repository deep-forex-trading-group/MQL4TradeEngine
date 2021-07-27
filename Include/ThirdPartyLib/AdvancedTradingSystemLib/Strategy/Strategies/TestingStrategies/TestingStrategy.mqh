#include "../../StrategyBase/all.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class TestingStrategy : public Strategy {
    public:
        TestingStrategy(string strategy_name)
                        : strategy_name_(strategy_name) {};
        ~TestingStrategy() {};

// Member Variables and Functions
    public:
        int ExecuteStrategy() const;
        int ExecuteStrategy(StrategyParams& params) const;
        int ExecuteStrategy(ConfigFile* config_file) const;
        void PrintStrategyInfo() const;

    private:
        string strategy_name_;
};

int TestingStrategy::ExecuteStrategy() const {
    PrintFormat("Execute TestingStrategy {%s} successed!", this.strategy_name_);
    return SUCCEEDED;
}

int TestingStrategy::ExecuteStrategy(StrategyParams& params) const {
    PrintFormat("Execute TestingStrategy {%s} with StrategyParams successed!", this.strategy_name_);
    PrintFormat("The StrategyParms for Strategy {%s} is following.", this.strategy_name_);
    params.printAllParams();
    return SUCCEEDED;
}

int TestingStrategy::ExecuteStrategy(ConfigFile* config_file) const {
    PrintFormat("Execute TestingStrategy {%s} with ConfigFile successed!", this.strategy_name_);
    config_file.PrintAllConfigItems();
    return SUCCEEDED;
}

void TestingStrategy::PrintStrategyInfo() const {
    PrintFormat("This is strategy -> {%s}", this.strategy_name_);
}