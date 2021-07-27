#include "AIRobotUI.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

void AIRobotUI::InitGraphItems() {

    int button_x=120;
    int button_y=25;
    int button_inter_x=50;
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
        this.TestRefreshConfigFile();
        this.TestOrderGroupCenter();
        this.TestCopyMap();
        this.TestExecuteStrategy();
        ui_utils.UnPressButton("测试按钮");
    } else {
        ui_is_testing_ok = false;
    }

    RefreshButtonsStatesRet rb_states_ret;
    rb_states_ret.is_testing_ok = ui_is_testing_ok;

    return rb_states_ret;
}

void AIRobotUI::TestRefreshConfigFile() {
//    this.ai_robot_config.refreshConfig();
    config_file.RefreshConfigFile();
    PrintFormat("---------- testing for config_file.GetConfigFieldByTitleAndFieldName() --------------");
    PrintFormat("config_file.GetConfigFieldByTitleAndFieldName(\"title_1\", \"pips_factor\") = %s",
                config_file.GetConfigFieldByTitleAndFieldName("title_1", "pips_factor"));
    PrintFormat("config_file.GetConfigFieldByTitleAndFieldName(\"2011\", \"act_factor\") = %s",
                config_file.GetConfigFieldByTitleAndFieldName("2011", "act_factor"));
    PrintFormat("config_file.GetConfigFieldByTitleAndFieldName(\"new title 2\", \"pips_factor\") = %s",
                config_file.GetConfigFieldByTitleAndFieldName("new title 2", "pips_factor"));
    PrintFormat("---------- testing for config_file.PrintAllConfigItems() --------------");
    config_file.PrintAllConfigItems();
}

void AIRobotUI::TestExecuteStrategy() {
    StrategyParams* ts_params = new TestingStrategyParams();
    TestingStrategy* ts_1 = new TestingStrategy("ts_1");
    TestingStrategy* ts_2 = new TestingStrategy("ts_2");

    StrategyContext *st_ctx = new StrategyContext(ts_1);
    PrintFormat("------------ testing TestingStrategy for ts_1 ------------------");

    st_ctx.ExecuteStrategy(ts_params);
    ConfigFile* config_file_testing = new ConfigFile("config.txt");
    st_ctx.ExecuteStrategy(config_file_testing);

    PrintFormat("------------ testing TestingStrategy for ts_2 ------------------");
    st_ctx.SetStrategy(ts_2);
    st_ctx.ExecuteStrategy(ts_params);
    ConfigFile* config_file_testing_2 = new ConfigFile("config.txt");
    st_ctx.ExecuteStrategy(config_file_testing_2);

    delete config_file_testing_2;
    delete config_file_testing;
    delete ts_params;
    delete ts_1;
    delete ts_2;
    delete st_ctx;
}

void AIRobotUI::TestOrderGroupCenter() {
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

void AIRobotUI::TestCopyMap() {
    CollectionCopyUtils<string, string>* collection_copy_utils = CollectionCopyUtils<string, string>::GetInstance();
    HashMap<string, string>* map_src = new HashMap<string, string>();
    map_src.set("k1", "12");
    map_src.set("k2", "16");
    HashMap<string, string>* map_dst = new HashMap<string, string>();
    foreachm(string, key, string, val, map_src) {
        PrintFormat("<%s, %s>", key, val);
    }
    collection_copy_utils.CopyMap(map_src, map_dst);
    foreachm(string, key, string, val, map_dst) {
        PrintFormat("<%s, %s>", key, val);
    }

    delete collection_copy_utils;
    delete map_src;
    delete map_dst;
}