#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyContext.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/ConfigDataStructure/all.mqh>

class ModuleTestManager {
    public:
        ModuleTestManager() {
            PrintFormat("Initiazlie ModuleTestManager. ");
            this.aa_order_group_center = new AutoAdjustOrderGroupCenter("agc");
            this.aa_group = new AutoAdjustOrderGroup("agr", this.aa_order_group_center);
            this.adjust_strategy = new AutoAdjustStrategy("ad_test");
            this.config_file_adjust = new ConfigFile("Config", "adjust_config.txt");
            this.adjust_strategy.SetConfigFile(this.config_file_adjust);
            this.st_test_ctx = new StrategyContext(this.adjust_strategy);
        };
        ~ModuleTestManager() {
            PrintFormat("Deinitiazlie ModuleTestManager. ");
            SafeDeletePtr(aa_order_group_center);
            SafeDeletePtr(adjust_strategy);
            SafeDeletePtr(aa_group);
            SafeDeletePtr(config_file_adjust);
            SafeDeletePtr(st_test_ctx);
        };
// Some test cases for the functions in project.
    public:
        void StartTestOne();
        void StartTestTwo();
        static void TestOpenSig();
        static void TestRefreshConfigFile();
        static void TestExecuteStrategy();
        static void TestOrderGroupCenter();
        static void TestCopyMap();
        void TestAutoAdjustStrategyOnTick();
        void TestAutoAdjustStrategyOnAction();
    private:
        AutoAdjustOrderGroupCenter* aa_order_group_center;
        AutoAdjustStrategy* adjust_strategy;
        AutoAdjustOrderGroup* aa_group;
        ConfigFile* config_file_adjust;
        StrategyContext* st_test_ctx;
};