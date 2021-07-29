#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ModuleTestManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>

#include "AIRobotUI.mqh"

void AIRobotUI::InitGraphItems() {
    this.button_x = 80;
    this.button_y = 25;
    this.button_inter_x = 75;
    this.button_inter_y = 30;
    this.button_length = 65;
    this.button_width = 20;
    this.btn1 = new Button("平多按钮","平多","平多",(button_x+button_inter_x*1),(button_y+button_inter_y*3),
                        button_length,button_width,button_section_set_pos,clrFireBrick,clrBlack);
    this.btn2 = new Button("平空按钮","平空","平空",button_x+button_inter_x*0,button_y+button_inter_y*3,
                    button_length,button_width,button_section_set_pos,clrMediumVioletRed,clrBlack);
    this.btn3 = new Button("平盈利多按钮","平盈利多","平盈利多",button_x+button_inter_x*1,button_y+button_inter_y*2,
                    button_length,button_width,button_section_set_pos,clrMediumSeaGreen,clrBlack);
    this.btn4 = new Button("平盈利空按钮","平盈利空","平盈利空",button_x+button_inter_x*0,button_y+button_inter_y*2,
                    button_length,button_width,button_section_set_pos,clrChocolate,clrBlack);
    this.btn5 = new Button("全平按钮","全平","全平",button_x+button_inter_x*1,button_y+button_inter_y*1,
                    button_length,button_width,button_section_set_pos,clrDarkViolet,clrBlack);
    this.btn6 = new Button("EA开关按钮","开启EA","关闭EA",button_x+button_inter_x*0,button_y+button_inter_y*1,
                    button_length,button_width,button_section_set_pos,clrBlue,clrRed);
    this.btn7 = new Button("测试按钮","关闭测试","开启测试",button_x+button_inter_x*1,button_y+button_inter_y*0,
                    button_length,button_width,button_section_set_pos,clrDarkViolet,clrBlack);
    this.btn8 = new Button("测试按钮2","测试2","测试2",button_x+button_inter_x*0,button_y+button_inter_y*0,
                    button_length,button_width,button_section_set_pos,clrDarkViolet,clrBlack);
}

void AIRobotUI::RefreshButtonsStates() {
    btn1.CheckButtonState();
    btn2.CheckButtonState();
    btn3.CheckButtonState();
    btn4.CheckButtonState();
    btn5.CheckButtonState();
    btn6.CheckButtonState();
    btn7.CheckButtonState();
    btn8.CheckButtonState();

    if(btn1.IsButtonPressed()) {
        btn1.UnPressButton();
    }

    if(btn2.IsButtonPressed()) {
        btn2.UnPressButton();
    }

    if(btn3.IsButtonPressed()) {
        btn3.UnPressButton();
    }

    if(btn4.IsButtonPressed()) {
        btn4.UnPressButton();
    }

    if(btn5.IsButtonPressed()) {
        btn5.UnPressButton();
    }

    if(btn6.IsButtonPressed()) {
        btn6.UnPressButton();
    }

    if (btn7.IsButtonPressed()) {
        mt_manager.StartTestOne();
        btn7.UnPressButton();
    }

    if (btn8.IsButtonPressed()) {
        mt_manager.StartTestTwo();
        btn8.UnPressButton();
    }
}