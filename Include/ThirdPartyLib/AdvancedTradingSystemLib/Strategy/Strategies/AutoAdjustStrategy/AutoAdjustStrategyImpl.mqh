#include "AutoAdjustStrategy.mqh"

int AutoAdjustStrategy::ExecuteStrategy() const {
    return SUCCEEDED;
}
int AutoAdjustStrategy::OnTickExecute() {
    PrintFormat("Please use the api for Comment Content.");
    return FAILED;
}
int AutoAdjustStrategy::OnTickExecute(CommentContent* comment_content) {
    this.comment_content_ = comment_content;
    if (!this.params_.IsParamsValid()) {
        return FAILED;
    }
    this.OnTickShowBasicInfo();
    if (this.is_sig_buy_activated_) {
        this.auto_adjust_order_group_.CreateSigBuyOrder(this.params_.pip_start_lots);
        return SUCCEEDED;
    }
    if (this.is_sig_sell_activated_) {
        this.auto_adjust_order_group_.CreateSigSellOrder(this.params_.pip_start_lots);
        return SUCCEEDED;
    }
    double lots = 0.05;
    int num_orders = this.auto_adjust_order_group_.GetTotalNumOfOrdersInTrades();
    OrderInMarket res[1];
    bool is_sig_exist = OrderGetUtils::GetOrderInTrade(this.auto_adjust_order_group_.GetGroupSigMagicNumber(), res);
    int send_order_dir = INTEGER_MIN_INT;
    if (is_sig_exist) {
        lots = NormalizeDouble(this.params_.pip_start_lots * MathPow(this.params_.lots_exponent, num_orders),
                               MarketInfoUtils::GetDigits());
        send_order_dir = res[0].order_type == OP_BUY ? BUY_ORDER_SEND  : (
                                              res[0].order_type == OP_SELL ? SELL_ORDER_SEND  : send_order_dir);
    }
    double pip_step_add = NormalizeDouble(
                                this.params_.pip_step * MathPow(this.params_.pip_step_exponent, num_orders),0);

    double cur_total_profit = this.auto_adjust_order_group_.GetCurrentProfitInTrades();
    double total_lots = this.auto_adjust_order_group_.GetCurrentTotalLotsInTrades();
//    double target_profit_money =
//                    NormalizeDouble(this.params_.pip_start_lots * num_orders * this.params_.target_profit_factor  * this.params_.lots_exponent, 2);
    this.comment_content_.SetTitleToFieldDoubleTerm("total_lots", total_lots);
    this.comment_content_.SetTitleToFieldDoubleTerm("target_profit_factor", this.params_.target_profit_factor);

    double target_profit_money =
                    NormalizeDouble(total_lots * this.params_.target_profit_factor, 2);

    this.comment_content_.SetTitleToFieldDoubleTerm("cur_total_profit", cur_total_profit);
    this.comment_content_.SetTitleToFieldDoubleTerm("target_profit_money", target_profit_money);
    if (target_profit_money + 0.01 <= cur_total_profit) {
        this.auto_adjust_order_group_.CloseAllOrders();
        // Close all orders and the state of the group changes
        // So we just refresh the state, to update the magic number for the group
        this.auto_adjust_order_group_.UpdateMagicNumbersAll();
        UIUtils::Laber("盈利平仓",Red,0);
    }

    this.comment_content_.SetTitleToFieldDoubleTerm("pip_step_add", pip_step_add);
    this.auto_adjust_order_group_.AddOneOrderByStepPipReverse(send_order_dir, pip_step_add, lots);

    return SUCCEEDED;
}
void AutoAdjustStrategy::OnTickShowBasicInfo() {
    // Base Information to show.
    this.comment_content_.SetTitleToFieldDoubleTerm(
                                "cur_group_auto_mn", this.auto_adjust_order_group_.GetGroupAutoMagicNumber());
    this.comment_content_.SetTitleToFieldDoubleTerm(
                                "cur_group_sig_mn", this.auto_adjust_order_group_.GetGroupSigMagicNumber());
    this.comment_content_.SetTitleToFieldDoubleTerm(
                                "cur_group_manul_mn", this.auto_adjust_order_group_.GetGroupManualMagicNumber());
    this.comment_content_.SetTitleToFieldDoubleTerm(
                                "cur_group_id", this.auto_adjust_order_group_.GetGroupId());
}
int AutoAdjustStrategy::OnActionExecute() {
    PrintFormat("AutoAdjustStrategy {%s} executed OnActionExecute", this.strategy_name_);
    if (!this.CheckConfigFileValid()) {
        return FAILED;
    }
    string pip_start_lots = this.config_file_.GetConfigFieldByTitleAndFieldName(
                                                        "Adjust", "pip_start_lots");
    double pip_start_lots_double = StringToDouble(pip_start_lots);
//    this.auto_adjust_order_group_.CreateSigBuyOrder(pip_start_lots_double);
    this.auto_adjust_order_group_.CreateSigSellOrder(pip_start_lots_double);
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