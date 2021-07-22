#include "../StrategyBase/all.mqh"

class TestingStrategy : public Strategy {
    public:
        TestingStrategy() {};
        ~TestingStrategy() {};

// Member Variables and Functions
    public:
        int executeStrategy(StrategyParams& params) const;
};

int TestingStrategy::executeStrategy(StrategyParams& params) const {
    Print("Execute testing strategy successed!");
    return SUCCEEDED;
}
