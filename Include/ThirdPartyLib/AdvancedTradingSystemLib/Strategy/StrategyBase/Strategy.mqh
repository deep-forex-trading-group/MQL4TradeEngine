#include "StrategyDataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class Strategy {
    public:
        virtual ~Strategy() {};
// Abstract Methods to force sub-classes to implement them
        virtual int ExecuteStrategy() const = 0;
        virtual int ExecuteStrategy(StrategyParams& params) const = 0;
        virtual int ExecuteStrategy(ConfigFile* config_file) const = 0;
        virtual void PrintStrategyInfo() const = 0;
};