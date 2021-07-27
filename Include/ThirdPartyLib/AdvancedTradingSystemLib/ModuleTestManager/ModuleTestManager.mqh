#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyContext.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/ConfigDataStructure/all.mqh>

class ModuleTestManager {
    public:
        ModuleTestManager() {};
        ~ModuleTestManager() {};
// Some test cases for the functions in project.
    public:
        static void TestRefreshConfigFile();
        static void TestExecuteStrategy();
        static void TestOrderGroupCenter();
        static void TestCopyMap();
};