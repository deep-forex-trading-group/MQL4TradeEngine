#property  copyright "TrendingRobot"
#property description "TrendingRobot for consistently profits"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/SystemConfigUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/TrendingStrategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/EAUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/MarketInfoUtils.mqh>
#include "DataStructure.mqh"

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets
extern SYSTEM_MODE system_mode = PRODUCTION_MODE;
extern bool allow_real_acct = true;

ConfigFile* system_mode_config;
TrendingStrategy* trending_strategy;

bool is_trending_strategy_valid = false;

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

// Initialized trending_strategy
    trending_strategy = new TrendingStrategy("trending_strategy");
    if (!trending_strategy.IsInitSuccess()) {
        PrintFormat("Init TrendingStrategy(trending_strategy) Failed");
        return INIT_FAILED;
    }
    is_trending_strategy_valid = true;

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
    trending_strategy.OnTickExecute();
    if (!is_trending_strategy_valid) {
        return;
    }
    if (trending_strategy.BeforeTickExecute() == FAILED) {
        is_trending_strategy_valid = false;
    }
    if (trending_strategy.OnTickExecute() == FAILED) {
        is_trending_strategy_valid = false;
    }
    if (trending_strategy.AfterTickExecute() == FAILED) {
        is_trending_strategy_valid = false;
    }
}
void OnDeinit(const int reason) {
    Print("Deinitialize the TrendingRobot EA.");
    ShowDeinitReason(reason);
    SafeDeletePtr(system_mode_config);
    SafeDeletePtr(trending_strategy);
}