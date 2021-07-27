#include "StrategyDataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class Strategy {
    public:
        virtual ~Strategy() {};
// Abstract Methods to force sub-classes to implement them
        virtual int executeStrategy(StrategyParams& params) const = 0;
        virtual int executeStrategy(ConfigFile* config_file) const = 0;
};