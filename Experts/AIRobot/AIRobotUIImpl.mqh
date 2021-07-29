#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ModuleTestManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

void AIRobotUI::InitGraphItems() {

    int button_x=120;
    int button_y=25;
    int button_inter_x=75;
    int button_inter_y=25;

    // Y从下往上，x从右往左
    ui_utils.Button("平多按钮","平多","平多",button_x+button_inter_x*1,button_y+button_inter_y*4,
                    45,20,button_section_set_pos,clrFireBrick,clrBlack);
    ui_utils.Button("平空按钮","平空","平空",button_x+button_inter_x*1,button_y+button_inter_y*3,
                    45,20,button_section_set_pos,clrMediumVioletRed,clrBlack);
    ui_utils.Button("平盈利多按钮","平盈利多","平盈利多",button_x+button_inter_x*0,button_y+button_inter_y*4,
                    60,20,button_section_set_pos,clrMediumSeaGreen,clrBlack);
    ui_utils.Button("平盈利空按钮","平盈利空","平盈利空",button_x+button_inter_x*0,button_y+button_inter_y*3,
                    60,20,button_section_set_pos,clrChocolate,clrBlack);
    ui_utils.Button("全平按钮","全平","全平",button_x+button_inter_x*1,button_y+button_inter_y*2,
                    45,20,button_section_set_pos,clrDarkViolet,clrBlack);
    ui_utils.Button("EA开关按钮","开启EA","关闭EA",button_x+button_inter_x*0,button_y+button_inter_y*2,
                    60,20,button_section_set_pos,clrBlue,clrRed);
    ui_utils.Button("测试按钮","测试","测试",button_x+button_inter_x*1,button_y+button_inter_y*0,
                    60,20,button_section_set_pos,clrDarkViolet,clrBlack);
    ui_utils.Button("测试按钮2","测试2","测试2",button_x+button_inter_x*0,button_y+button_inter_y*0,
                    60,20,button_section_set_pos,clrDarkViolet,clrBlack);
}

void AIRobotUI::RefreshButtonsStates() {
    ui_utils.CheckButtonState("平多按钮","平多","平多",clrFireBrick,clrBlack);
    ui_utils.CheckButtonState("平空按钮","平空","平空",clrMediumVioletRed,clrBlack);
    ui_utils.CheckButtonState("平盈利多按钮","平盈利多","平盈利多",clrMediumSeaGreen,clrBlack);
    ui_utils.CheckButtonState("平盈利空按钮","平盈利空","平盈利空",clrChocolate,clrBlack);
    ui_utils.CheckButtonState("全平按钮","全平","全平",clrDarkViolet,clrBlack);
    ui_utils.CheckButtonState("EA开关按钮","开启EA","关闭EA",clrBlue,clrRed);
    ui_utils.CheckButtonState("测试按钮","关闭测试","开启测试",clrDarkViolet,clrBlack);

    if(ui_utils.IsButtonPressed("平多按钮")) {
        ou_close.CloseAllBuyOrders(DEFAULT_ORDER_MAGIC_NUMBER);
        ui_utils.UnPressButton("平多按钮");
    }

    if(ui_utils.IsButtonPressed("平空按钮")) {
        ou_close.CloseAllSellOrders(DEFAULT_ORDER_MAGIC_NUMBER);
        ui_utils.UnPressButton("平空按钮");
    }

    if(ui_utils.IsButtonPressed("平盈利多按钮")) {
        ou_close.CloseAllBuyProfitOrders(DEFAULT_ORDER_MAGIC_NUMBER, 0.1);
        ui_utils.UnPressButton("平盈利多按钮");
    }

    if(ui_utils.IsButtonPressed("平盈利空按钮")) {
        ou_close.CloseAllSellProfitOrders(DEFAULT_ORDER_MAGIC_NUMBER, 0.1);
        ui_utils.UnPressButton("平盈利空按钮");
    }

    if(ui_utils.IsButtonPressed("全平按钮")) {
        ou_close.CloseAllOrders(DEFAULT_ORDER_MAGIC_NUMBER);
        ui_utils.UnPressButton("全平按钮");
    }

    if (ui_utils.IsButtonPressed("测试按钮")) {
//        ModuleTestManager::TestRefreshConfigFile();
//        ModuleTestManager::TestOrderGroupCenter();
//        ModuleTestManager::TestCopyMap();
//        ModuleTestManager::TestExecuteStrategy();
//        ModuleTestManager::TestAutoAdjustStrategy();

        mt_manager.TestAutoAdjustStrategyOnTick();
        ui_utils.UnPressButton("测试按钮");
    }

    if (ui_utils.IsButtonPressed("测试按钮2")) {
        this.mt_manager.TestAutoAdjustStrategyOnAction();
        ui_utils.UnPressButton("测试按钮2");
    }
}