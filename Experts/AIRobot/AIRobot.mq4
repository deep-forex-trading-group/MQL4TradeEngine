#property  copyright "AIRobot Basic Template"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "AIRobot for consistently profits"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include "AIRobotUI.mqh"
#include "AIRobotUIImpl.mqh"

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets

AIRobotUI ai_robot_ui;
ConfigFile* system_mode_config;
SYSTEM_MODE system_mode = PRODUCTION_MODE;

bool is_testing_ok = False;

int OnInit() {
    system_mode_config = new ConfigFile("system_mode_config.txt");
    if (!system_mode_config.CheckConfigFileValid()) {
        PrintFormat("System Config File is invalid, makes sure the path as %s" ,
                     "Config/system_mode_config.txt");
        return INIT_FAILED;
    }
    SwitchSystemMode();
TESTING_CODE_ST(system_mode)
        Print("Testing Mode Start");
TESTING_CODE_END(system_mode)
    return INIT_SUCCEEDED;
}

void OnTick() {
    ai_robot_ui.RefreshButtonsStates();
}

void OnDeinit(const int reason) {
    Print("Deinitialize the AIRobot EA.");
    ShowDeinitReason(reason);
    delete &ai_robot_ui;
    delete system_mode_config;
}

void SwitchSystemMode() {
    if (!system_mode_config.CheckConfigFieldExistByTitleAndFieldName("system", "system_mode")) {
        PrintFormat("Config for setting Sytem Running Mode does not exist.");
    } else {
        PrintFormat("System Mode is setting to {%s}",
                    system_mode_config.GetConfigFieldByTitleAndFieldName("system", "system_mode"));
        string system_mode_input = system_mode_config.GetConfigFieldByTitleAndFieldName("system", "system_mode");
        if (system_mode_input == "TestMode") {
            system_mode = TEST_MODE;
        }
    }
}