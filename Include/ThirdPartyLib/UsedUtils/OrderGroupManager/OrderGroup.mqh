#include <ThirdPartyLib/UsedUtils/OrderManageUtils/OrderInMarket.mqh>
#include <ThirdPartyLib/UsedUtils/OrderArrayUtils.mqh>
#include "OrderGroupBase/all.mqh"
#include "OrderGroupCenter.mqh"

class OrderGroup : public OrderGroupObserver {
    public:
        OrderGroup(OrderGroupCenter *order_group_center_ptr) {
            this.order_group_center_ptr_ = order_group_center_ptr;
            this.group_id_ = this.order_group_center_ptr_.register(GetPointer(this));
            if (this.group_id_ == -1) {
                PrintFormat("Registered the group failed!");
            }
            this.getOrdersByGroupId(this.orders_in_history, this.orders_in_trades, this.group_id_);
            this.msg_from_subject_ = "Init subject msg";
            PrintFormat("Initialized Order Group [%d].", this.group_id_);

        };
        virtual ~OrderGroup() {
            PrintFormat("Deinitialize order group [%d]", this.group_id_);
            delete &order_array_utils;
        };

// Observer register functionaliy
    public:
        void update(string msg);
        void unRegister();
        void printInfo();
    private:
        OrderGroupCenter *order_group_center_ptr_;

// Utils Variables
    private:
        OrderArrayUtils order_array_utils;

// Member Variables and Functions
    private:
        int group_id_;
        OrderInMarket orders_in_history[];
        OrderInMarket orders_in_trades[];
        string msg_from_subject_;

    public:
        int getGroupId();
        int getGroupOrders(OrderInMarket& res[], OrderInMarket& orders_in_trades[]);
        int getOrdersByGroupId(OrderInMarket& orders_in_history[], OrderInMarket& orders_in_trades[],
                               int group_id);
};

// Observer register functionaliy
void OrderGroup::update(string msg) {
    this.msg_from_subject_ = msg;
    printInfo();
}
void OrderGroup::unRegister() {
    this.order_group_center_ptr_.unRegister(GetPointer(this));
    PrintFormat("OrderGroup: %d is unregistered from order group center.", this.group_id_);
}
void OrderGroup::printInfo() {
    PrintFormat("OrderGroup: %d gets a new msg [%s]", this.group_id_, this.msg_from_subject_);
}

// Member Functions for Order Group.
int OrderGroup::getGroupId() {
    if (this.group_id_ == -1) {
        string msg = StringFormat("OrderGroup id is %d and it is invalid", this.group_id_);
        Print(msg);
        Alert(msg);
    }
    return this.group_id_;
};
int OrderGroup::getOrdersByGroupId(OrderInMarket& orders_in_history_out[],
                                   OrderInMarket& orders_in_trades_out[],
                                   int group_id_in) {
    if (group_id_in < 0) {
        PrintFormat("The group_id is a invalid number.");
        return -1;
    }
    int total_num = OrdersTotal();
    double lowest_price = -1;
    int lowest_ticket = -1;
    int group_magic_number = this.order_group_center_ptr_.getMagicNumberByGroupId(group_id_in);
    // Gets the order in history pool
    int res_i = 0;
    for (int i = total_num - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == group_magic_number) {

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
            && OrderMagicNumber() == group_magic_number) {

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
    return 0;
};
