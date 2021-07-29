#property  copyright "AIRobot Basic Template"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "AIRobot for consistently profits"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "AIRobotUI.mqh"
#include "AIRobotUIImpl.mqh"

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets
//#ifndef TestMode
//   #define TestMode
//#endif

AIRobotUI ai_robot_ui();

bool is_testing_ok = False;

int OnInit() {
    ai_robot_ui.InitGraphItems();
    return INIT_SUCCEEDED;
}

void OnTick() {
    ai_robot_ui.RefreshButtonsStates();
    #ifdef TestMode
        Print("config in main");
        ai_robot_config.printConfig();
    #endif
}

void OnDeinit(const int reason) {
    Print("Deinitialize the AIRobot EA.");
    ShowDeinitReason(reason);
    delete &ai_robot_ui;
}