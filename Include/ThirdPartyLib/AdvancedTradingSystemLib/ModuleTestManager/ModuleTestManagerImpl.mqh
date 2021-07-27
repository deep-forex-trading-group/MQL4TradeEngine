#include "ModuleTestManager.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyContext.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/ConfigDataStructure/all.mqh>

void ModuleTestManager::TestRefreshConfigFile() {
//    this.ai_robot_config.refreshConfig();
    ConfigFile* config_file = new ConfigFile("config", "config.txt");
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
    delete config_file;
}

void ModuleTestManager::TestExecuteStrategy() {
    StrategyParams* ts_params = new TestingStrategyParams();
    TestingStrategy* ts_1 = new TestingStrategy("ts_1");
    TestingStrategy* ts_2 = new TestingStrategy("ts_2");
    TestingStrategy* ts_3 = new TestingStrategy("ts_3");

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

    PrintFormat("------------ testing TestingStrategy for ts_3 with no params ------------------");
    st_ctx.SetStrategy(ts_3);
    st_ctx.ExecuteStrategy();

    delete config_file_testing_2;
    delete config_file_testing;
    delete ts_params;
    delete ts_1;
    delete ts_2;
    delete st_ctx;
}

void ModuleTestManager::TestOrderGroupCenter() {
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

void ModuleTestManager::TestCopyMap() {
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