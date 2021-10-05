#include "DataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/AutoAdjustCenter/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>

int AutoAdjustStrategy::ExecuteStrategy() const {
    return SUCCEEDED;
}
int AutoAdjustStrategy::OnTickExecute() {
    PrintFormat("Please use the api for Comment Content.");
    return FAILED;
}
int AutoAdjustStrategy::OnTickExecute(CommentContent* comment_content) {
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
    double cur_total_profit = AccountInfoUtils::GetCurrentTotalProfit(magic_set, MODE_TRADES);
    double total_lots = AccountInfoUtils::GetCurrentTotalLots(magic_set, MODE_TRADES);
//    double target_profit_money =
//                    NormalizeDouble(this.params_.pip_start_lots * num_orders * this.params_.target_profit_factor  * this.params_.lots_exponent, 2);
    comment_content.SetTitleToFieldDoubleTerm("total_lots", total_lots);
    comment_content.SetTitleToFieldDoubleTerm("target_profit_factor", this.params_.target_profit_factor);

    double target_profit_money =
                    NormalizeDouble(total_lots * this.params_.target_profit_factor, 2);

    comment_content.SetTitleToFieldDoubleTerm("cur_total_profit", cur_total_profit);
    comment_content.SetTitleToFieldDoubleTerm("target_profit_money", target_profit_money);
    if (target_profit_money + 0.01 <= cur_total_profit) {
        this.auto_adjust_order_group_.CloseAllOrders();
        // Close all orders and the state of the group changes
        // So we just refresh the state, to update the magic number for the group
        this.auto_adjust_order_group_.RefreshOrderGroupState();
        UIUtils::Laber("盈利平仓",Red,0);
    }
    comment_content.SetTitleToFieldDoubleTerm(
                                "cur_group_magic_number", this.auto_adjust_order_group_.GetGroupMagicNumber());
    comment_content.SetTitleToFieldDoubleTerm("pip_step_add", pip_step_add);
    this.auto_adjust_order_group_.AddOneOrderByStepPipReverse(BUY_ORDER_SEND, pip_step_add, lots);
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