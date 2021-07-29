#include "DataStructure.mqh"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/AutoAdjustStrategies/DataStructure.mqh>

int AutoAdjustStrategy::ExecuteStrategy() const {
    return SUCCEEDED;
}
int AutoAdjustStrategy::OnTickExecute() {
    PrintFormat("AutoAdjustStrategy {%s} executed OnTickExecute", this.strategy_name_);
    return SUCCEEDED;
}
int AutoAdjustStrategy::OnActionExecute() {
    PrintFormat("AutoAdjustStrategy {%s} executed OnActionExecute", this.strategy_name_);
    if (!this.CheckConfigFileValid()) {
        return FAILED;
    }
    string pip_start_lots = this.config_file_.GetConfigFieldByTitleAndFieldName(
                                                        "Adjust", "pip_start_lots");
    double pip_start_lots_double = StringToDouble(pip_start_lots);
    OrderSendUtils ou_send_ad();
    // TODO:to replace the magic number -1 with order_group management.
    ou_send_ad.CreateBuyOrder(-1, pip_start_lots_double);
    return SUCCEEDED;
}
int AutoAdjustStrategy::SetAutoAdjustOrderGroup(AutoAdjustOrderGroup* auto_adjust_order_group) {
    this.auto_adjust_order_group_ = auto_adjust_order_group;
    return SUCCEEDED;
}
void AutoAdjustStrategy::PrintStrategyInfo() const {
    PrintFormat("Current Strategy is a AutoAdjustStrategy, the name is %s, ",
                this.strategy_name_);
    if (this.CheckConfigFileValid()) {
        this.config_file_.PrintAllConfigItems();;
    }
}