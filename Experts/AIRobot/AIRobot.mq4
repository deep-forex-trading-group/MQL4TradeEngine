#property  copyright "AIRobot Basic Template"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "AIRobot for consistently profits"

#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/AccountInformationUtils/AccountInfoUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/UIUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/OrderGroupCenterBase/OrderGroup.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyContext.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/all.mqh>

#include "AIRobotUI.mqh"
#include "AIRobotUIImpl.mqh"

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets
//#ifndef TestMode
//   #define TestMode
//#endif

input string InpFileName="test_conf"; // file name
input string InpDirectoryName="ExpertsConf"; // directory name

extern int   magic_number_extern = 587456;

OrderGetUtils ou_get();
OrderCloseUtils ou_close();
OrderSendUtils ou_send();
OrderPrintUtils ou_print();
AccountInfoUtils* ai_utils;

AIRobotUI ai_robot_ui();

bool is_testing_ok = False;

int OnInit() {
    ai_utils = new AccountInfoUtils();
    ai_robot_ui.InitGraphItems();
    return INIT_SUCCEEDED;
}

void OnTick() {
    RefreshButtonStates();
}

void RefreshButtonStates() {

    RefreshButtonsStatesParams refresh_button_states_params;
    refresh_button_states_params.magic_number = magic_number_extern;
    refresh_button_states_params.is_testing_ok = is_testing_ok;

    RefreshButtonsStatesRet rt = ai_robot_ui.RefreshButtonsStates(refresh_button_states_params);
    is_testing_ok = rt.is_testing_ok;
    #ifdef TestMode
        Print("config in main");
        ai_robot_config.printConfig();
    #endif
}

void OnDeinit(const int reason) {
    Print("Deinitialize the AIRobot EA.");
    delete &ou_get;
    delete &ou_close;
    delete &ou_send;
    delete &ou_print;
    delete ai_utils;

    delete &ai_robot_ui;
}