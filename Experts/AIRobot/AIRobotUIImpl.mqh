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
    this.btn_close_buy = new Button("平多按钮","平多","平多",(button_x+button_inter_x*1),(button_y+button_inter_y*3),
                        button_length,button_width,button_section_set_pos,clrFireBrick,clrBlack);
    this.btn_close_sell = new Button("平空按钮","平空","平空",button_x+button_inter_x*0,button_y+button_inter_y*3,
                    button_length,button_width,button_section_set_pos,clrMediumVioletRed,clrBlack);
    this.btn_close_profit_buy = new Button("平盈利多按钮","平盈利多","平盈利多",button_x+button_inter_x*1,button_y+button_inter_y*2,
                    button_length,button_width,button_section_set_pos,clrMediumSeaGreen,clrBlack);
    this.btn_close_profit_sell = new Button("平盈利空按钮","平盈利空","平盈利空",button_x+button_inter_x*0,button_y+button_inter_y*2,
                    button_length,button_width,button_section_set_pos,clrChocolate,clrBlack);
    this.btn_close_all = new Button("全平按钮","全平","全平",button_x+button_inter_x*1,button_y+button_inter_y*1,
                    button_length,button_width,button_section_set_pos,clrDarkViolet,clrBlack);
    this.ea_openclose = new Button("EA开关按钮","开启EA","关闭EA",button_x+button_inter_x*0,button_y+button_inter_y*1,
                    button_length,button_width,button_section_set_pos,clrBlue,clrRed);
    this.ea_test = new Button("测试按钮","关闭测试","开启测试",button_x+button_inter_x*1,button_y+button_inter_y*0,
                    button_length,button_width,button_section_set_pos,clrDarkViolet,clrBlack);
    this.ea_test_sec = new Button("测试按钮2","测试2","测试2",button_x+button_inter_x*0,button_y+button_inter_y*0,
                    button_length,button_width,button_section_set_pos,clrDarkViolet,clrBlack);
}

void AIRobotUI::RefreshButtonsStates() {
    this.btn_close_buy.CheckButtonState();
    this.btn_close_sell.CheckButtonState();
    this.btn_close_profit_buy.CheckButtonState();
    this.btn_close_profit_sell.CheckButtonState();
    this.btn_close_all.CheckButtonState();
    this.ea_openclose.CheckButtonState();
    this.ea_test.CheckButtonState();
    this.ea_test_sec.CheckButtonState();

    if(this.btn_close_buy.IsButtonPressed()) {
        this.btn_close_buy.UnPressButton();
    }

    if(this.btn_close_sell.IsButtonPressed()) {
        this.btn_close_sell.UnPressButton();
    }

    if(this.btn_close_profit_buy.IsButtonPressed()) {
        this.btn_close_profit_buy.UnPressButton();
    }

    if(this.btn_close_profit_sell.IsButtonPressed()) {
        this.btn_close_profit_sell.UnPressButton();
    }

    if(this.btn_close_all.IsButtonPressed()) {
        this.btn_close_all.UnPressButton();
    }

    if(this.ea_openclose.IsButtonPressed()) {
        this.ea_openclose.UnPressButton();
    }

    if (this.ea_test.IsButtonPressed()) {
        mt_manager.StartTestOne();
        this.ea_test.UnPressButton();
    }

    if (this.ea_test_sec.IsButtonPressed()) {
        mt_manager.StartTestTwo();
        this.ea_test_sec.UnPressButton();
    }
}