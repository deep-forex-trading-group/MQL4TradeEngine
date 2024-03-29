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
int OrderGroup::RefreshOrderInfo() {
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

    ArrayResize(orders_in_history_out, ORDER_GROUP_MAX_ORDERS);
    if (!OrderGetUtils::GetOrdersInHistoryWithMagicNumberSet(
                        this.whole_order_magic_number_set_, orders_in_history_out)) {
        return -1;
    }
    ArrayResize(orders_in_trades_out, ORDER_GROUP_MAX_ORDERS);
    if (!OrderGetUtils::GetOrdersInTradesWithMagicNumberSet(
                        this.whole_order_magic_number_set_, orders_in_trades_out)) {
        return -1;
    }
    return 0;
};
int OrderGroup::GetTotalNumOfOrdersInTrades() {
    this.RefreshOrderInfo();
    return ArraySize(this.orders_in_trades);
}

double OrderGroup::GetCurrentProfit() {
    this.RefreshOrderInfo();
    this.cur_profit_ = 0;
    for (int cc_states_i = 0; cc_states_i < ArraySize(this.orders_in_trades); cc_states_i++) {
        this.cur_profit_ += this.orders_in_trades[cc_states_i].order_profit;
        this.cur_profit_ += this.orders_in_trades[cc_states_i].order_swap;
        this.cur_profit_ += this.orders_in_trades[cc_states_i].order_commission;
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
void OrderGroup::PrintAllOrders() {
    this.RefreshOrderInfo();
    Print("--------------------- OrdersHistory Starts ---------------------");
    int arr_print_size = ArraySize(this.orders_in_history);
    for (int arr_print_i = 0; arr_print_i < arr_print_size; arr_print_i++) {
        OrderInMarket oi = this.orders_in_history[arr_print_i];
        oi.PrintOrderInMarket();
    }
    Print("--------------------- OrdersHistory Ends ---------------------");

    Print("--------------------- OrdersInTrade Starts ---------------------");
    arr_print_size = ArraySize(this.orders_in_trades);
    for (int arr_print_i = 0; arr_print_i < arr_print_size; arr_print_i++) {
        OrderInMarket oi = this.orders_in_trades[arr_print_i];
        oi.PrintOrderInMarket();
    }
    Print("--------------------- OrdersInTrade Ends ---------------------");
}