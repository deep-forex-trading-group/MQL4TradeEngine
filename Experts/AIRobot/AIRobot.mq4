#property  copyright "AIRobot Basic Template"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "AIRobot for consistently profits"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/SystemConfigUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/AutoAdjustStrategy/all.mqh>
#include "AIRobotUI.mqh"
#include "AIRobotUIImpl.mqh"

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets
extern SYSTEM_MODE system_mode = PRODUCTION_MODE;

AIRobotUI ai_robot_ui;
ConfigFile* system_mode_config;
AutoAdjustStrategy* at_strategy;
//StrategyContext* st_ctx;

int OnInit() {
    system_mode_config = new ConfigFile("system_mode_config.txt");
    at_strategy = new AutoAdjustStrategy("at_strategy");
    if (!at_strategy.IsInitSuccess()) {
        PrintFormat("Init AutoAdjustStrategy(at_strategy) Failed");
        return INIT_FAILED;
    }

//    st_ctx = new StrategyContext(at_strategy);
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
    CommentContent* cur_comment_content = ai_robot_ui.GetCommentContent();
    if (at_strategy.OnTickExecute(cur_comment_content) == FAILED) {
        PrintFormat("Execute [at_strategy] Failed! ");
        // TODO: to stop EA or do sth to handle the failed cases
    }
//    OrderPrintUtils::PrintAllOrders();
//    PrintFormat(MODE_HISTORY);
//    PrintFormat(MODE_TRADES);
    // 最后更新UI, 因为有时间差
    ai_robot_ui.RefreshUI();
}

void OnDeinit(const int reason) {
    Print("Deinitialize the AIRobot EA.");
    ShowDeinitReason(reason);
    SafeDeletePtr(&ai_robot_ui);
    SafeDeletePtr(system_mode_config);
    SafeDeletePtr(at_strategy);
//    SafeDeletePtr(st_ctx);
}