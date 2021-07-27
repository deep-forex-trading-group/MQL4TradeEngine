#include <ThirdPartyLib/MqlExtendLib/Collection/Copy.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyContext.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/ConfigDataStructure/all.mqh>

struct RefreshButtonsStatesParams {
    int magic_number;
    bool is_testing_ok;
};

struct RefreshButtonsStatesRet {
    bool is_testing_ok;
};

class AIRobotUI {
    public:
        AIRobotUI() {
            this.button_section_set_pos = CORNER_RIGHT_LOWER;
            this.config_file = new ConfigFile("config.txt");
        }
        ~AIRobotUI() {
            delete &ui_utils;
            delete &ou_get;
            delete &ou_close;
            delete &ou_send;
            delete &ou_print;
            delete config_file;
        }
    private:
        UIUtils ui_utils;
        OrderGetUtils ou_get;
        OrderCloseUtils ou_close;
        OrderSendUtils ou_send;
        OrderPrintUtils ou_print;
        ConfigFile* config_file;
        ENUM_BASE_CORNER button_section_set_pos;

    public:
        void InitGraphItems();
        RefreshButtonsStatesRet RefreshButtonsStates(RefreshButtonsStatesParams& params);

// Some test cases for the functions in project.
    private:
        void testRefreshConfigFile();
        void testExecuteStrategy();
        void testOrderGroupCenter();
        void testCopyMap();
};