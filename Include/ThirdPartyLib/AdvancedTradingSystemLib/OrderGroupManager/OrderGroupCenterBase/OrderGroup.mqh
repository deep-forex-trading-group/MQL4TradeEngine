#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderInMarket.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderArrayUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderGetUtils.mqh>
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
    if (group_id_in < 0) {
        PrintFormat("The group_id is a invalid number.");
        return -1;
    }
    int total_num = OrdersTotal();
    int group_magic_number_base = this.order_group_center_ptr_.GetMagicNumberBaseByGroupId(group_id_in);
    HashSet<int>* group_magic_number_set = new HashSet<int>();
    this.GetGroupMagicNumberSet(group_magic_number_set);

    ArrayResize(orders_in_history_out, ORDER_GROUP_MAX_ORDERS);
    if (!OrderGetUtils::GetOrdersInHistoryWithMagicNumberSet(group_magic_number_set, orders_in_history_out)) {
        delete group_magic_number_set;
        return -1;
    }
    ArrayResize(orders_in_trades_out, ORDER_GROUP_MAX_ORDERS);
    if (!OrderGetUtils::GetOrdersInTradesWithMagicNumberSet(group_magic_number_set, orders_in_trades_out)) {
        delete group_magic_number_set;
        return -1;
    }
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