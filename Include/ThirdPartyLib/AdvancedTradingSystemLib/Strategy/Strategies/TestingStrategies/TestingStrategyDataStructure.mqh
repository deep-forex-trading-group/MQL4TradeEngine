#include "../../StrategyBase/StrategyDataStructure.mqh"

class TestingStrategyParams : public StrategyParams {
    public:
        TestingStrategyParams() {
            this.testing_input_code = -1;
        };
        ~TestingStrategyParams() {};

    public:
        void printAllParams();

    public:
        int testing_input_code;
};

void TestingStrategyParams::printAllParams() {
    PrintFormat("TestingStrategyParams[%s:%d]", "testing_input_code", this.testing_input_code);
};