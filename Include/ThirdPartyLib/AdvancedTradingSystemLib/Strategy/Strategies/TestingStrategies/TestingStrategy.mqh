#include "../../StrategyBase/all.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class TestingStrategy : public Strategy {
    public:
        TestingStrategy() {};
        ~TestingStrategy() {};

// Member Variables and Functions
    public:
        int executeStrategy(StrategyParams& params) const;
        int executeStrategy(ConfigFile* config_file) const;
};

int TestingStrategy::executeStrategy(StrategyParams& params) const {
    Print("Execute testing strategy with StrategyParams successed!");
    return SUCCEEDED;
}

int TestingStrategy::executeStrategy(ConfigFile* config_file) const {
    Print("Execute testing strategy with ConfigFile successed!");
    config_file.PrintAllConfigItems();
    return SUCCEEDED;
}