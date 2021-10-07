#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ModuleTestManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>

#include "AIRobotUI.mqh"

void AIRobotUI::InitButtons() {
// button init params
    this.button_x = 80;
    this.button_y = 25;
    this.button_inter_x = 75;
    this.button_inter_y = 30;
    this.button_width = 65;
    this.button_height = 20;
    this.button_section_set_pos = CORNER_RIGHT_LOWER;

// Initialize the buttons and add them to the frame
    this.btn_ui_frame = new UIFrame("btn_frame", this.button_x, this.button_y,
                                 this.button_inter_x, this.button_inter_y,
                                 this.button_section_set_pos);
    this.btn_open_sig_test = new Button("信号测试按钮", this.button_width, this.button_height,
                                        "信测按下", clrFireBrick, "信测抬起", clrBlack);
    this.btn_ui_frame.AddUIComponent(2, 0, this.btn_open_sig_test);
    this.btn_is_show_comment = new Button("是否显示Comment按钮", this.button_width, this.button_height,
                                          "ShowComm", clrFireBrick, "HideComm", clrBlack);
    this.btn_ui_frame.AddUIComponent(1, 4, this.btn_is_show_comment);
    this.btn_close_buy = new Button("平多按钮", this.button_width, this.button_height,
                                     "ShowComm", clrFireBrick, "HideComm", clrBlack);
    this.btn_ui_frame.AddUIComponent(1, 3, this.btn_close_buy);
    this.btn_close_sell = new Button("平空按钮", this.button_width, this.button_height,
                                     "平空", clrMediumVioletRed, "平空", clrBlack);
    this.btn_ui_frame.AddUIComponent(0, 3, this.btn_close_sell);

    this.btn_close_profit_buy = new Button("平盈利多按钮", this.button_width, this.button_height,
                                           "平盈利多", clrMediumSeaGreen, "平盈利多", clrBlack);
    this.btn_ui_frame.AddUIComponent(1, 2, this.btn_close_profit_buy);
    this.btn_close_profit_sell = new Button("平盈利空按钮", this.button_width, this.button_height,
                                            "平盈利空", clrChocolate, "平盈利空", clrBlack);
    this.btn_ui_frame.AddUIComponent(0, 2, this.btn_close_profit_sell);
    this.btn_close_all = new Button("全平按钮", this.button_width, this.button_height,
                                    "全平",clrDarkViolet,"全平",clrBlack);
    this.btn_ui_frame.AddUIComponent(1, 1, this.btn_close_all);
    this.btn_ea_openclose = new Button("EA开关按钮", this.button_width, this.button_height,
                                    "开启EA", clrBlue, "关闭EA", clrRed);
    this.btn_ui_frame.AddUIComponent(0, 1, this.btn_ea_openclose);
    this.btn_ea_test = new Button("测试按钮", this.button_width, this.button_height,
                              "关闭测试", clrDarkViolet, "开启测试", clrBlack);
    this.btn_ui_frame.AddUIComponent(1, 0, this.btn_ea_test);
    this.btn_ea_test_sec = new Button("测试按钮2", this.button_width, this.button_height,
                                  "测试2", clrDarkViolet, "测试2", clrBlack);
    this.btn_ui_frame.AddUIComponent(0, 0, this.btn_ea_test_sec);
}

void AIRobotUI::RefreshButtonsStates() {
    if(this.btn_open_sig_test.IsButtonPressed()) {
        OrderSendUtils::CreateBuyOrder(-2000, 0.01, "ad_sig");
        this.btn_open_sig_test.UnPressButton();
    }

    if (this.btn_is_show_comment.IsButtonPressed()) {
        this.comment_content_.HideCommentContent();
//        this.btn_close_buy.UnPressButton();
    } else {
        this.comment_content_.ShowCommentContent();
    }

    if (this.btn_close_buy.IsButtonPressed()) {
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

    if(this.btn_ea_openclose.IsButtonPressed()) {
        this.btn_ea_openclose.UnPressButton();
    }

    if (this.btn_ea_test.IsButtonPressed()) {
//        mt_manager.StartTestOne();
        this.btn_ea_test.UnPressButton();
    }

    if (this.btn_ea_test_sec.IsButtonPressed()) {
//        mt_manager.StartTestTwo();
        this.btn_ea_test_sec.UnPressButton();
    }
}