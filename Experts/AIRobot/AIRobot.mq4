#property  copyright "AIRobot Basic Template"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "AIRobot for consistently profits"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/SystemConfigUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/AutoAdjustStrategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/EAUtils/all.mqh>
#include "AIRobotUI.mqh"
#include "AIRobotUIImpl.mqh"
#include "DataStructure.mqh"

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets
extern SYSTEM_MODE system_mode = PRODUCTION_MODE;
extern bool allow_real_acct = false;

AIRobotUI ai_robot_ui;
ConfigFile* system_mode_config;
AutoAdjustStrategy* at_strategy;
CommentContent* comment_content_ea;
UIRetData ui_ret_data();

bool is_at_strategy_valid = false;

int OnInit() {

    if (!allow_real_acct && !EAUtils::IsEARunOnDemoAccount()) {
        PrintFormat("EA is not allowed for real acct, please set the [allow_real_acct].");
        return INIT_FAILED;
    }

// Initializes Config File for system_mode
    system_mode_config = new ConfigFile("system_mode_config.txt");
// Initializes comment_content_ea
    comment_content_ea = ai_robot_ui.GetCommentContent();
    comment_content_ea.SetTitleToFieldStringTerm("IsRunNorm", "YES");

// Initialized at_strategy
    at_strategy = new AutoAdjustStrategy("at_strategy");
    if (!at_strategy.IsInitSuccess()) {
        PrintFormat("Init AutoAdjustStrategy(at_strategy) Failed");
        return INIT_FAILED;
    }
    is_at_strategy_valid = true;

    if (!system_mode_config.CheckConfigFileValid()) {
        PrintFormat("System Config File is invalid, makes sure the path as %s" ,
                     "Config/system_mode_config.txt");
        return INIT_FAILED;
    }
// Code snippets to change the system_mode by config file
    SYSTEM_MODE sys_mode_out[1];
    sys_mode_out[0] = system_mode;
    SystemConfigUtil::SwitchSystemMode(system_mode_config, sys_mode_out);
    system_mode = sys_mode_out[0];

TESTING_CODE_ST(system_mode)
        Print("Testing Mode Running.");
TESTING_CODE_END(system_mode)
    return INIT_SUCCEEDED;
}

void OnTick() {
    ai_robot_ui.OnTickRefreshUI(&ui_ret_data);
    if (!is_at_strategy_valid) {
        return;
    }
    at_strategy.OnTickSetUIAutoInfo(ui_ret_data.ui_auto_info);
    if (at_strategy.OnTickExecute(comment_content_ea) == FAILED) {
        comment_content_ea.SetTitleToFieldStringTerm("IsRunNorm", "ATS_NOT");
        is_at_strategy_valid = false;
    }
}

void OnDeinit(const int reason) {
    Print("Deinitialize the AIRobot EA.");
    ShowDeinitReason(reason);
    SafeDeletePtr(&ai_robot_ui);
    SafeDeletePtr(system_mode_config);
    SafeDeletePtr(at_strategy);
}