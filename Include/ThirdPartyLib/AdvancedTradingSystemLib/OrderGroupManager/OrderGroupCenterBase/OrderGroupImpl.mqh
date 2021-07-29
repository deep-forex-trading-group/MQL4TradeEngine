#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderInMarket.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderArrayUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderGetUtils.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include "OrderGroupCenter.mqh"
#include "OrderGroup.mqh"

// Observer register functionaliy
void OrderGroup::Update(string msg) {
    this.msg_from_subject_ = msg;
    PrintInfo();
}
void OrderGroup::UnRegister() {
    this.order_group_center_ptr_.UnRegister(GetPointer(this));
    PrintFormat("OrderGroup: %d is unregistered from order group center.", this.group_id_);
}
void OrderGroup::PrintInfo() {
    PrintFormat("OrderGroup: %d gets a new msg [%s]", this.group_id_, this.msg_from_subject_);
}

// Member Functions for Order Group.
int OrderGroup::GetOrdersByGroupId() {
    return this.GetOrdersByGroupId(this.group_id_);
}
int OrderGroup::GetOrdersByGroupId(int group_id) {
    ArrayFree(this.orders_in_history);
    ArrayFree(this.orders_in_trades);
    return this.GetOrdersByGroupId(this.orders_in_history, this.orders_in_trades, this.group_id_);
}
int OrderGroup::GetOrdersByGroupId(OrderInMarket& orders_in_history_out[],
                                   OrderInMarket& orders_in_trades_out[],
                                   int group_id_in) {
    if (group_id_in < 0) {
        PrintFormat("The group_id is a invalid number.");
        return -1;
    }
    int total_num = OrdersTotal();
    int group_magic_number = this.order_group_center_ptr_.GetMagicNumberByGroupId(this.group_id_);
    HashSet<int>* group_magic_number_set = new HashSet<int>();

    ArrayResize(orders_in_history_out, ORDER_GROUP_MAX_ORDERS);
    if (!OrderGetUtils::GetOrdersInHistoryWithMagicNumber(
                        this.group_magic_number_, orders_in_history_out)) {
        return -1;
    }
    ArrayResize(orders_in_trades_out, ORDER_GROUP_MAX_ORDERS);
    if (!OrderGetUtils::GetOrdersInTradesWithMagicNumber(
                        this.group_magic_number_, orders_in_trades_out)) {
        return -1;
    }
    return 0;
};
int OrderGroup::GetTotalNumOfOrdersInTrades() {
    this.GetOrdersByGroupId();
    return ArraySize(orders_in_trades);
}
double OrderGroup::GetCurrentProfit() {
    this.GetOrdersByGroupId();
    this.cur_profit_ = 0;
    for (int cc_states_i = 0; cc_states_i < ArraySize(this.orders_in_trades); cc_states_i++) {
        this.cur_profit_ += this.orders_in_trades[cc_states_i].order_profit;
    }
    return this.cur_profit_;
}
double OrderGroup::GetMaxFloatingProfit() {
    this.cur_profit_ = this.GetCurrentProfit();
    if (this.cur_profit_ > 0) {
        this.max_floating_profits_ = MathMax(MathAbs(this.cur_profit_), this.max_floating_profits_);
    }
    return this.max_floating_profits_;
}
double OrderGroup::GetMaxFloatingLoss() {
    this.cur_profit_ = this.GetCurrentProfit();
    if (this.cur_profit_ < 0) {
        this.max_floating_loss_ = MathMax(MathAbs(this.cur_profit_), this.max_floating_loss_);
    }
    return this.max_floating_loss_;
}