#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderInMarket.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderArrayUtils.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include "OrderGroupCenter.mqh"

class OrderGroup : public OrderGroupObserver {
    public:
        OrderGroup(OrderGroupCenter *order_group_center_ptr) {
            this.order_group_center_ptr_ = order_group_center_ptr;
            this.group_id_ = this.order_group_center_ptr_.Register(GetPointer(this));
            this.total_num_orders_ = 0;
            this.group_magic_number_base_ = this.order_group_center_ptr_.GetMagicNumberBaseByGroupId(this.group_id_);
            this.msg_from_subject_ = "Init subject msg";
            PrintFormat("Initialized Order Group [%d].", this.group_id_);
        };
        virtual ~OrderGroup() {
            PrintFormat("Deinitialize order group [%d]", this.group_id_);
            delete &order_array_utils;
        };

// Observer communications functionality
    public:
        void Update(string msg);
        void UnRegister();
        void PrintInfo();
// Public Apis for users to call
    public:
        int GetGroupId();
        int GetGroupOrders(OrderInMarket& res[], OrderInMarket& orders_in_trades[]);
        int GetOrdersByGroupId();
        int GetOrdersByGroupId(int group_id);
        int GetOrdersByGroupId(OrderInMarket& orders_in_history[], OrderInMarket& orders_in_trades[],
                               int group_id);
        int GetTotalNumOfOrders();

    protected:
        OrderGroupCenter *order_group_center_ptr_;

// Utils Variables
    protected:
        OrderArrayUtils order_array_utils;

// Member Variables
    protected:
        int group_id_;
        int total_num_orders_;
        int group_magic_number_base_;
        OrderInMarket orders_in_history[];
        OrderInMarket orders_in_trades[];
        string msg_from_subject_;
// Member Functions
    protected:
        void GetGroupMagicNumberSet(HashSet<int>* group_magic_number_set);
        int GenerateNewOrderMagicNumber();
};

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
int OrderGroup::GetGroupId() {
    if (this.group_id_ == -1) {
        string msg = StringFormat("OrderGroup id is %d and it is invalid", this.group_id_);
        Print(msg);
        Alert(msg);
    }
    return this.group_id_;
};
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
    ArrayResize(orders_in_history_out, ORDER_GROUP_MAX_ORDERS);
    ArrayResize(orders_in_trades_out, ORDER_GROUP_MAX_ORDERS);
    if (group_id_in < 0) {
        PrintFormat("The group_id is a invalid number.");
        return -1;
    }
    int total_num = OrdersTotal();
    int group_magic_number_base = this.order_group_center_ptr_.GetMagicNumberBaseByGroupId(group_id_in);
    HashSet<int>* group_magic_number_set = new HashSet<int>();
    this.GetGroupMagicNumberSet(group_magic_number_set);

    // Gets the order in history pool
    int res_i = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()
            && group_magic_number_set.contains(OrderMagicNumber())) {

            OrderInMarket oi();
            oi.order_lots = OrderLots();
            oi.order_open_price = OrderOpenPrice();
            oi.order_close_price = OrderClosePrice();
            oi.order_comment = OrderComment();
            oi.order_close_time = OrderCloseTime();
            oi.order_profit = OrderProfit();
            oi.order_type = OrderType();
            oi.order_ticket = OrderTicket();
            oi.order_position = i;

            orders_in_history_out[res_i] = oi;
            res_i++;
        }
    }
    ArrayResize(orders_in_history_out, res_i);
    // Gets the order in trading pool
    res_i = 0;
    for (int rs_trades_i = total_num - 1; rs_trades_i >= 0; rs_trades_i--) {
        if (OrderSelect(rs_trades_i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && group_magic_number_set.contains(OrderMagicNumber())) {

            OrderInMarket oi();
            oi.order_lots = OrderLots();
            oi.order_open_price = OrderOpenPrice();
            oi.order_close_price = OrderClosePrice();
            oi.order_comment = OrderComment();
            oi.order_close_time = OrderCloseTime();
            oi.order_profit = OrderProfit();
            oi.order_type = OrderType();
            oi.order_ticket = OrderTicket();
            oi.order_position = rs_trades_i;

            orders_in_trades_out[res_i] = oi;
            res_i++;
        }
    }
    ArrayResize(orders_in_trades_out, res_i);
    delete group_magic_number_set;
    return 0;
};
int OrderGroup::GetTotalNumOfOrders() {
    return this.total_num_orders_;
}
void OrderGroup::GetGroupMagicNumberSet(HashSet<int>* group_magic_number_set) {
    for (int gm_i = 0; gm_i < this.total_num_orders_; gm_i++) {
        int current_magic_num = this.group_magic_number_base_ + gm_i;
        group_magic_number_set.add(current_magic_num);
    }
}
int OrderGroup::GenerateNewOrderMagicNumber() {
    int num = this.group_magic_number_base_ + this.total_num_orders_;
    this.total_num_orders_++;
    return num;
}