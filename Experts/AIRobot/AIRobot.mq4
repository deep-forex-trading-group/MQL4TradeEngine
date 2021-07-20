#property  copyright "AIRobot Basic Template"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "AIRobot for consistently profits"

#include <ThirdPartyLib/UsedUtils/OrderInMarket.mqh>
#include <ThirdPartyLib/UsedUtils/OrderManageUtils.mqh>
#include <ThirdPartyLib/UsedUtils/HedgeUtilsDual.mqh>
#include <ThirdPartyLib/UsedUtils/AccountInfoUtils.mqh>
#include <ThirdPartyLib/UsedUtils/UIUtils.mqh>

#include <ThirdPartyLib/Collection/HashMap.mqh>

#include "AIRobotUI.mqh"
#include "AIRobotConfig.mqh"

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets
#ifndef TestMode
   #define TestMode
#endif

input string InpFileName="test_conf"; // file name
input string InpDirectoryName="ExpertsConf"; // directory name

extern int   magic_number_extern = 1;

OrderManageUtils ou();
AccountInfoUtils ai_utils();

AIRobotUI ai_robot_ui();
AIRobotConfig ai_robot_config();

bool is_testing_ok = False;

int OnInit() {
    AIRobotConfigParams ai_robot_config_params = ai_robot_config.getConfig();
    if(!ai_robot_config_params.is_config_exist) {
      Print("AIRobot Config does not exists!");
      return INIT_FAILED;
    }
    ai_robot_config.printConfig();
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
    refresh_button_states_params.ai_robot_config = &ai_robot_config;

    RefreshButtonsStatesRet rt = ai_robot_ui.RefreshButtonsStates(refresh_button_states_params);
    is_testing_ok = rt.is_testing_ok;
#ifdef TestMode
    Print("config in main");
    ai_robot_config.printConfig();
#endif
}

void OnDeinit(const int reason) {
//   ~ou();
//   ~ai_utils();
//   ~ui_utils();
//   ~read_config_utils();
}