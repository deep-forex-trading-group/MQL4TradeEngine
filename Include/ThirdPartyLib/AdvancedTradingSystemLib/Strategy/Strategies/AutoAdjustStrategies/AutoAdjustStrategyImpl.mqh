#include "DataStructure.mqh"

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/AutoAdjustStrategies/DataStructure.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
int AutoAdjustStrategy::ExecuteStrategy() const {
    return SUCCEEDED;
}
int AutoAdjustStrategy::OnTickExecute() {
    if (!this.params_.IsParamsValid()) {
        return FAILED;
    }
    double lots = 0.05;
    int num_orders = this.auto_adjust_order_group_.GetTotalNumOfOrdersInTrades();
    OrderInMarket res[1];
    bool is_sig_exist = this.ou_get_.GetOrderInTrade(this.params_.sig_order_magic_number, res);
    if (is_sig_exist) {
        lots = NormalizeDouble(this.params_.pip_start_lots * MathPow(this.params_.lots_exponent, num_orders),
                               MarketInfoUtils::GetDigits());
    }
    double pip_step_add = NormalizeDouble(
                                this.params_.pip_step * MathPow(this.params_.pip_step_exponent, num_orders),0);

    int group_magic_number = this.auto_adjust_order_group_.GetGroupMagicNumber();
    HashSet<int>* magic_set = this.auto_adjust_order_group_.GetWholeOrderMagicSet();
    double cur_total_profit = AccountInfoUtils::GetCurrentTotalProfit(magic_set);
    double total_lots = AccountInfoUtils::GetCurrentTotalLots(magic_set);
//    double target_profit_money =
//                    NormalizeDouble(this.params_.pip_start_lots * num_orders * this.params_.target_profit_factor  * this.params_.lots_exponent, 2);
    PrintFormat("total_lots: %.4f, target_profit_factor: %.4f", total_lots, this.params_.target_profit_factor);
    double target_profit_money =
                    NormalizeDouble(total_lots * this.params_.target_profit_factor, 2);

    PrintFormat("cur_total_profit: %.4f, target_profit_money: %.4f", cur_total_profit, target_profit_money);
    if (target_profit_money + 0.01 <= cur_total_profit) {
        OrderCloseUtils::CloseAllOrders(magic_set);
        this.auto_adjust_order_group_.UpdateMagicNumber();
        UIUtils::Laber("盈利平仓",Red,0);
    }
    PrintFormat("lots: %.4f", lots);
    PrintFormat("pip_step_add: %.4f", pip_step_add);
    this.ou_send_.AddOneOrderByStepPipReverse(magic_set, group_magic_number, BUY_ORDER_SEND, pip_step_add, lots);
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
//    this.auto_adjust_order_group_.CreateBuyOrder(pip_start_lots_double);
    this.auto_adjust_order_group_.CreateSellOrder(pip_start_lots_double);
    return SUCCEEDED;
}
int AutoAdjustStrategy::SetAutoAdjustOrderGroup(AutoAdjustOrderGroup* auto_adjust_order_group) {
    if (IsPtrInvalid(auto_adjust_order_group)) {
        PrintFormat("The auto_adjust_order_group pointer passed in the AutoAdjustStrategy {%s} is invalid",
                     this.strategy_name_);
        return FAILED;
    }
    PrintFormat("Sets the AutoAdjustStrategy {%s} with auto_adjust_order_group {%s}",
                this.strategy_name_, auto_adjust_order_group.GetGroupName());
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