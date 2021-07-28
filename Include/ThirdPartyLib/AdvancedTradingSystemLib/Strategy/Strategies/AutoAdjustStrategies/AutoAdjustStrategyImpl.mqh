#include "AutoAdjustStrategy.mqh"
#include "DataStructure.mqh"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/AutoAdjustStrategies/DataStructure.mqh>

int AutoAdjustStrategy::ExecuteStrategy() const {
    if (!this.CheckConfigFileValid()) {
        return FAILED;
    }
    string pip_start_lots = this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "pip_start_lots");
    double pip_start_lots_double = StringToDouble(pip_start_lots);
    OrderSendUtils ou_send_ad();
    ou_send_ad.CreateBuyOrder(this.strategy_params_.magic_number_cur_order, pip_start_lots_double);
    return SUCCEEDED;
}
void AutoAdjustStrategy::PrintStrategyInfo() const {
    PrintFormat("Current Strategy is a AutoAdjustStrategy, the name is %s", this.strategy_name_);
    if (this.CheckConfigFileValid()) {
        this.config_file_.PrintAllConfigItems();;
    }
}