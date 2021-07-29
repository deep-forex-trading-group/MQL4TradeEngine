#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyContext.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/ConfigDataStructure/all.mqh>

class ModuleTestManager {
    public:
        ModuleTestManager() {
            this.aa_order_group_center = new AutoAdjustOrderGroupCenter("agc");
            this.aa_group = new AutoAdjustOrderGroup("agr", this.aa_order_group_center);
            this.adjust_strategy = new AutoAdjustStrategy("ad_test", this.aa_group);
            this.config_file_adjust = new ConfigFile("Config", "adjust_config.txt");
            this.adjust_strategy.SetConfigFile(this.config_file_adjust);
            this.st_ctx = new StrategyContext(this.adjust_strategy);
        };
        ~ModuleTestManager() {
            SaveDeletePtr(aa_order_group_center);
            SaveDeletePtr(adjust_strategy);
            SaveDeletePtr(aa_group);
            SaveDeletePtr(config_file_adjust);
            SaveDeletePtr(st_ctx);
        };
// Some test cases for the functions in project.
    public:
        void StartTestOne();
        void StartTestTwo();
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
        StrategyContext* st_ctx;
};