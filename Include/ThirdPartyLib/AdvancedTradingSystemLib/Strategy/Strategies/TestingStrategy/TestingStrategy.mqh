#include "../../StrategyBase/all.mqh"
#include "TestingStrategyDataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class TestingStrategy : public Strategy {
    public:
        TestingStrategy(string strategy_name) {
            this.strategy_name_ = strategy_name;
        };
        ~TestingStrategy() {};

// Member Variables and Functions
    public:
        int ExecuteStrategy() const;
        int BeforeTickExecute();
        int OnTickExecute();
        int AfterTickExecute();
        int OnActionExecute();
        void SetTestingStrategyParams(TestingStrategyParams* params);
        void PrintStrategyInfo() const;
    private:
        TestingStrategyParams* testing_strategy_params_;
};

int TestingStrategy::ExecuteStrategy() const {
    PrintFormat("Execute TestingStrategy {%s} successed!", this.strategy_name_);
    return SUCCEEDED;
}
int TestingStrategy::BeforeTickExecute() {
    return SUCCEEDED;
}
int TestingStrategy::OnTickExecute() {
    return SUCCEEDED;
}
int TestingStrategy::AfterTickExecute() {
    return SUCCEEDED;
}
int TestingStrategy::OnActionExecute() {
    return SUCCEEDED;
}
void TestingStrategy::SetTestingStrategyParams(TestingStrategyParams* params) {
    this.testing_strategy_params_ = params;
}
void TestingStrategy::PrintStrategyInfo() const {
    PrintFormat("This is strategy -> {%s}", this.strategy_name_);
}