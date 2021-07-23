#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyContext.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/all.mqh>
#include "AIRobotConfig.mqh"

struct RefreshButtonsStatesParams {
    int magic_number;
    bool is_testing_ok;
    AIRobotConfig* ai_robot_config;
};

struct RefreshButtonsStatesRet {
    bool is_testing_ok;
};

class AIRobotUI {
    public:
        AIRobotUI() {
            this.button_section_set_pos = CORNER_RIGHT_LOWER;
        }
        ~AIRobotUI() {
            delete &ui_utils;
            delete &ou_get;
            delete &ou_close;
            delete &ou_send;
            delete &ou_print;
        }
    private:
        UIUtils ui_utils;
        OrderGetUtils ou_get;
        OrderCloseUtils ou_close;
        OrderSendUtils ou_send;
        OrderPrintUtils ou_print;
        AIRobotConfig ai_robot_config;
        ENUM_BASE_CORNER button_section_set_pos;

    public:
        void InitGraphItems();
        RefreshButtonsStatesRet RefreshButtonsStates(RefreshButtonsStatesParams& params);

// Some test cases for the functions in project.
    private:
        void testRefreshConfig();
        void testExecuteStrategy();
        void testOrderGroupCenter();
};

void AIRobotUI::InitGraphItems() {

    int button_x=120;
    int button_y=25;
    int button_inter_x=50;
    int button_inter_y=25;

    // Y从下往上，x从右往左
    ui_utils.button("平多按钮","平多","平多",button_x+button_inter_x*1,button_y+button_inter_y*4,
                    45,20,button_section_set_pos,clrFireBrick,clrBlack);
    ui_utils.button("平空按钮","平空","平空",button_x+button_inter_x*1,button_y+button_inter_y*3,
                    45,20,button_section_set_pos,clrMediumVioletRed,clrBlack);
    ui_utils.button("平盈利多按钮","平盈利多","平盈利多",button_x+button_inter_x*0,button_y+button_inter_y*4,
                    60,20,button_section_set_pos,clrMediumSeaGreen,clrBlack);
    ui_utils.button("平盈利空按钮","平盈利空","平盈利空",button_x+button_inter_x*0,button_y+button_inter_y*3,
                    60,20,button_section_set_pos,clrChocolate,clrBlack);
    ui_utils.button("全平按钮","全平","全平",button_x+button_inter_x*1,button_y+button_inter_y*2,
                    45,20,button_section_set_pos,clrDarkViolet,clrBlack);
    ui_utils.button("EA开关按钮","开启EA","关闭EA",button_x+button_inter_x*0,button_y+button_inter_y*2,
                    60,20,button_section_set_pos,clrBlue,clrRed);
    ui_utils.button("测试按钮","测试","测试",button_x+button_inter_x*1,button_y+button_inter_y*0,
                    60,20,button_section_set_pos,clrDarkViolet,clrBlack);
}

RefreshButtonsStatesRet AIRobotUI::RefreshButtonsStates(RefreshButtonsStatesParams& params) {
    ui_utils.CheckButtonState("平多按钮","平多","平多",clrFireBrick,clrBlack);
    ui_utils.CheckButtonState("平空按钮","平空","平空",clrMediumVioletRed,clrBlack);
    ui_utils.CheckButtonState("平盈利多按钮","平盈利多","平盈利多",clrMediumSeaGreen,clrBlack);
    ui_utils.CheckButtonState("平盈利空按钮","平盈利空","平盈利空",clrChocolate,clrBlack);
    ui_utils.CheckButtonState("全平按钮","全平","全平",clrDarkViolet,clrBlack);
    ui_utils.CheckButtonState("EA开关按钮","开启EA","关闭EA",clrBlue,clrRed);
    ui_utils.CheckButtonState("测试按钮","关闭测试","开启测试",clrDarkViolet,clrBlack);

    int magic_number = params.magic_number;
    bool ui_is_testing_ok = params.is_testing_ok;

    // ObjectGetInteger(0,"[button_name]",OBJPROP_STATE)==1 表示button为按下状态
    // ObjectSetInteger(0,"[button_name]",OBJPROP_STATE,0) 表示将button设置为弹起状态
    if(ui_utils.IsButtonPressed("平多按钮")) {
        ou_close.CloseAllBuyOrders(magic_number);
        ui_utils.UnPressButton("平多按钮");
    }

    if(ui_utils.IsButtonPressed("平空按钮")) {
        ou_close.CloseAllSellOrders(magic_number);
        ui_utils.UnPressButton("平空按钮");
    }

    if(ui_utils.IsButtonPressed("平盈利多按钮")) {
        ou_close.CloseAllBuyProfitOrders(magic_number, 0.1);
        ui_utils.UnPressButton("平盈利多按钮");
    }

    if(ui_utils.IsButtonPressed("平盈利空按钮")) {
        ou_close.CloseAllSellProfitOrders(magic_number, 0.1);
        ui_utils.UnPressButton("平盈利空按钮");
    }

    if(ui_utils.IsButtonPressed("全平按钮")) {
        ou_close.CloseAllOrders(magic_number);
        ui_utils.UnPressButton("全平按钮");
    }

    if (ui_utils.IsButtonPressed("测试按钮")) {
        ui_is_testing_ok = true;
        this.testRefreshConfig();
//        this.testOrderGroupCenter();
        ui_utils.UnPressButton("测试按钮");
    } else {
        ui_is_testing_ok = false;
    }

    RefreshButtonsStatesRet rb_states_ret;
    rb_states_ret.is_testing_ok = ui_is_testing_ok;

    return rb_states_ret;
}

void AIRobotUI::testRefreshConfig() {
    this.ai_robot_config.refreshConfig();
    this.ai_robot_config.printConfig();
}

void AIRobotUI::testExecuteStrategy() {
    StrategyParams ts_params = new TestingStrategyParams();
    StrategyContext *st_ctx = new StrategyContext(new TestingStrategy());
    st_ctx.executeStrategy(ts_params);
}

void AIRobotUI::testOrderGroupCenter() {
    PrintFormat("---------- Testing for the group center %s ----------", "order_group_center");
    OrderGroupCenter* order_group_center = new OrderGroupCenter();
    order_group_center.setName("Central Center");
    order_group_center.printInfo();
    PrintFormat("--------------- Init og1 ----------------------");
    OrderGroup* og1 = new OrderGroup(order_group_center);
    order_group_center.printInfo();
    PrintFormat("--------------- Init og2 ----------------------");
    OrderGroup* og2 = new OrderGroup(order_group_center);
    order_group_center.printInfo();

    order_group_center.createMsg("Hello World");
    order_group_center.unRegister(og1);

    PrintFormat("---------------- After unRegistered %s -------------", "og1");
    order_group_center.createMsg("After unRegitstered og1");

    order_group_center.unRegister(og2);

    PrintFormat("---------------- After unRegistered %s -------------", "og2");
    order_group_center.createMsg("After unRegitstered og2");


    delete og1;
    delete og2;
    delete order_group_center;
}

