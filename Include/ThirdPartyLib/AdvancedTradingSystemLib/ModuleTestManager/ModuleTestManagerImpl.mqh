#include "ModuleTestManager.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyContext.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/ConfigDataStructure/all.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/ModuleTestManager/all.mqh>

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
    SaveDeletePtr(config_file);
}

void ModuleTestManager::TestExecuteStrategy() {
    TestingStrategyParams* ts_params = new TestingStrategyParams();
    TestingStrategy* ts_1 = new TestingStrategy("ts_1");
    TestingStrategy* ts_2 = new TestingStrategy("ts_2");
    TestingStrategy* ts_3 = new TestingStrategy("ts_3");

    StrategyContext *st_ctx = new StrategyContext(ts_1);
    PrintFormat("------------ testing TestingStrategy for ts_1 ------------------");
   
    ts_1.SetTestingStrategyParams(ts_params);
    st_ctx.ExecuteStrategy();
    ConfigFile* config_file_testing = new ConfigFile("config.txt");
    st_ctx.ExecuteStrategy();

    PrintFormat("------------ testing TestingStrategy for ts_2 ------------------");
    
    ts_2.SetTestingStrategyParams(ts_params);
    st_ctx.SetStrategy(ts_2);
    st_ctx.ExecuteStrategy();
    ConfigFile* config_file_testing_2 = new ConfigFile("config.txt");
    st_ctx.ExecuteStrategy();

    PrintFormat("------------ testing TestingStrategy for ts_3 with no params ------------------");
    st_ctx.SetStrategy(ts_3);
    st_ctx.ExecuteStrategy();

    SaveDeletePtr(config_file_testing_2);
    SaveDeletePtr(config_file_testing);
    SaveDeletePtr(ts_params);
    SaveDeletePtr(ts_1);
    SaveDeletePtr(ts_2);
    SaveDeletePtr(st_ctx);
}

void ModuleTestManager::TestOrderGroupCenter() {
    PrintFormat("---------- Testing for the group center %s ----------", "order_group_center");
    OrderGroupCenter* order_group_center = new OrderGroupCenter("group_center_1");
    order_group_center.SetName("Central Center");
    order_group_center.PrintInfo();
    PrintFormat("--------------- Init og1 ----------------------");
    OrderGroup* og1 = new OrderGroup(order_group_center);
    order_group_center.PrintInfo();
    PrintFormat("--------------- Init og2 ----------------------");
    OrderGroup* og2 = new OrderGroup(order_group_center);
    order_group_center.PrintInfo();

    order_group_center.CreateMsg("Hello World");
    order_group_center.UnRegister(og1);

    PrintFormat("---------------- After unRegistered %s -------------", "og1");
    order_group_center.CreateMsg("After unRegitstered og1");

    order_group_center.UnRegister(og2);

    PrintFormat("---------------- After unRegistered %s -------------", "og2");
    order_group_center.CreateMsg("After unRegitstered og2");


    SaveDeletePtr(og1);
    SaveDeletePtr(og2);
    SaveDeletePtr(order_group_center);
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

    SaveDeletePtr(collection_copy_utils);
    SaveDeletePtr(map_src);
    SaveDeletePtr(map_dst);
}

void ModuleTestManager::TestAutoAdjustStrategyOnTick() {
    this.aa_group.OnTick();
}

void ModuleTestManager::TestAutoAdjustStrategyOnAction() {
    this.aa_group.OnAction();
}