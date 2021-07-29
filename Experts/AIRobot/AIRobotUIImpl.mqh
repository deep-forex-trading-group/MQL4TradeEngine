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
    this.btn7 = new Button("测试按钮","开启测试","关闭测试",button_x+button_inter_x*1,button_y+button_inter_y*0,
                    button_length,button_width,button_section_set_pos,clrDarkViolet,clrBlack);
    this.btn8 = new Button("测试按钮2","测试2","测试2",button_x+button_inter_x*0,button_y+button_inter_y*0,
                    button_length,button_width,button_section_set_pos,clrDarkViolet,clrBlack);
}

void AIRobotUI::RefreshButtonsStates() {
    btn1.CheckButtonState("平多按钮","平多","平多",clrFireBrick,clrBlack);
    btn2.CheckButtonState("平空按钮","平空","平空",clrMediumVioletRed,clrBlack);
    btn3.CheckButtonState("平盈利多按钮","平盈利多","平盈利多",clrMediumSeaGreen,clrBlack);
    btn4.CheckButtonState("平盈利空按钮","平盈利空","平盈利空",clrChocolate,clrBlack);
    btn5.CheckButtonState("全平按钮","全平","全平",clrDarkViolet,clrBlack);
    btn6.CheckButtonState("EA开关按钮","开启EA","关闭EA",clrBlue,clrRed);
    btn7.CheckButtonState("测试按钮","关闭测试","开启测试",clrDarkViolet,clrBlack);
    btn8.CheckButtonState("测试按钮2","关闭测试2","开启测试2",clrDarkViolet,clrBlack);

    if(btn1.IsButtonPressed("平多按钮")) {
        btn1.UnPressButton("平多按钮");
    }

    if(btn2.IsButtonPressed("平空按钮")) {
        btn2.UnPressButton("平空按钮");
    }

    if(btn3.IsButtonPressed("平盈利多按钮")) {
        btn3.UnPressButton("平盈利多按钮");
    }

    if(btn4.IsButtonPressed("平盈利空按钮")) {
        btn4.UnPressButton("平盈利空按钮");
    }

    if(btn5.IsButtonPressed("全平按钮")) {
        btn5.UnPressButton("全平按钮");
    }

    if(btn6.IsButtonPressed("EA开关按钮")) {
        btn6.UnPressButton("全平按钮");
    }

    if (btn7.IsButtonPressed("测试按钮")) {
        mt_manager.StartTestOne();
        btn7.UnPressButton("测试按钮");
    }

    if (btn8.IsButtonPressed("测试按钮2")) {
        mt_manager.StartTestTwo();
        btn8.UnPressButton("测试按钮2");
    }
}