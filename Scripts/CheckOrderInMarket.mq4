//+------------------------------------------------------------------+
//|                                          CheckOrderInMarket.mq4 |
//|                   Copyright 2006-2015, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright   "2006-2015, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Period Converter to updated format of history base"
#property strict
#property show_inputs

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/MarketInfoUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/ArrayAdvancedUtils.mqh>

input int InpPeriodMultiplier=3; // Period multiplier factor
int       ExtHandle=-1;
void OnStart() {
    OrderInMarket res[100];
    OrderGetUtils::GetAllOrders(res);
    int total_num = ArraySize(res);
    for (int i = 0; i < total_num; i++) {
        OrderInMarket oi = res[i];
        oi.PrintOrderInMarket();
    }
}
void OnDeinit(const int reason) {
    Print("Deinitialize the CheckOrderInMarket Script.");
    ShowDeinitReason(reason);
}