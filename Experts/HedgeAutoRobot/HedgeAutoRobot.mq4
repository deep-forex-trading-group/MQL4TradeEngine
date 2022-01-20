#property  copyright "HedgeAutoRobot"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "AIRobot for consistently profits"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/SystemConfigUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/HedgeAutoStrategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/TrendAutoStrategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/EAUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/MarketInfoUtils.mqh>
#include "DataStructure.mqh"

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets
extern SYSTEM_MODE system_mode = PRODUCTION_MODE;
extern bool allow_real_acct = true;

ConfigFile* system_mode_config;
HedgeAutoStrategy* ha_strategy;
TrendAutoStrategy* ta_strategy;

bool is_ha_strategy_valid = false;

int OnInit() {
    if (!allow_real_acct && !EAUtils::IsEARunOnDemoAccount()) {
        PrintFormat("EA is not allowed for real acct, please set the [allow_real_acct].");
        return INIT_FAILED;
    }

    if (!MarketInfoUtils::SetUp()) {
        PrintFormat("MarketInfoUtils::SetUp() failed!");
        return INIT_FAILED;
    }

// Initializes Config File for system_mode
    system_mode_config = new ConfigFile("system_mode_config.txt");

// Initialized at_strategy
    ha_strategy = new HedgeAutoStrategy("ha_strategy");
    if (!ha_strategy.IsInitSuccess()) {
        PrintFormat("Init HedgeAutoStrategy(ha_strategy) Failed");
        return INIT_FAILED;
    }
    is_ha_strategy_valid = true;

    if (!system_mode_config.CheckConfigFileValid()) {
        PrintFormat("System Config File is invalid, makes sure the path as %s" ,
                     "Config/system_mode_config.txt");
        return INIT_FAILED;
    }
// Code snippets to change the system_mode by config file
    SYSTEM_MODE sys_mode_out[1];
    sys_mode_out[0] = system_mode;
    SystemConfigUtil::SwitchSystemMode(system_mode_config, sys_mode_out);
    system_mode = sys_mode_out[0];

TESTING_CODE_ST(system_mode)
        Print("Testing Mode Running.");
TESTING_CODE_END(system_mode)
    return INIT_SUCCEEDED;
}

void OnTick() {
    ta_strategy.OnTickExecute();
    if (!is_ha_strategy_valid) {
        return;
    }
    if (ha_strategy.BeforeTickExecute() == FAILED) {
        is_ha_strategy_valid = false;
    }
    if (ha_strategy.OnTickExecute() == FAILED) {
        is_ha_strategy_valid = false;
    }
    if (ha_strategy.AfterTickExecute() == FAILED) {
        is_ha_strategy_valid = false;
    }
}

void OnDeinit(const int reason) {
    Print("Deinitialize the AIRobot EA.");
    ShowDeinitReason(reason);
    SafeDeletePtr(system_mode_config);
    SafeDeletePtr(ha_strategy);
}