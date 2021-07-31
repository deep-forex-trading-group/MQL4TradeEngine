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
    this.btn1.CheckButtonState();
    this.btn2.CheckButtonState();
    this.btn3.CheckButtonState();
    this.btn4.CheckButtonState();
    this.btn5.CheckButtonState();
    this.btn6.CheckButtonState();
    this.btn7.CheckButtonState();
    this.btn8.CheckButtonState();

    if(this.btn1.IsButtonPressed()) {
        this.btn1.UnPressButton();
    }

    if(this.btn2.IsButtonPressed()) {
        this.btn2.UnPressButton();
    }

    if(this.btn3.IsButtonPressed()) {
        this.btn3.UnPressButton();
    }

    if(this.btn4.IsButtonPressed()) {
        this.btn4.UnPressButton();
    }

    if(this.btn5.IsButtonPressed()) {
        this.btn5.UnPressButton();
    }

    if(this.btn6.IsButtonPressed()) {
        this.btn6.UnPressButton();
    }

    if (this.btn7.IsButtonPressed()) {
        PrintFormat("act btn7 st");
        mt_manager.StartTestOne();
        this.btn7.UnPressButton();
        PrintFormat("act btn7 end");
    }

    if (this.btn8.IsButtonPressed()) {
        mt_manager.StartTestTwo();
        this.btn8.UnPressButton();
    }
}