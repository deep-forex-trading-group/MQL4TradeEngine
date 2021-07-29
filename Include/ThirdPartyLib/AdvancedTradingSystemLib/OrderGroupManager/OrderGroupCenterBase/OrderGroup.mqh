#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/AccountInformationUtils/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include "OrderGroupCenter.mqh"

class OrderGroup : public OrderGroupObserver {
    public:
        OrderGroup(OrderGroupCenter *order_group_center_ptr) {
            this.order_group_center_ptr_ = order_group_center_ptr;
            this.group_id_ = this.order_group_center_ptr_.Register(GetPointer(this));
            this.group_magic_number_ = this.order_group_center_ptr_
                                            .GetMagicNumberByGroupId(this.group_id_);
            this.cur_profit_ = 0;
            this.max_floating_loss_ = 0;
            this.max_floating_profits_ = 0;
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
        int GetGroupId() { return this.group_id_; };
        string GetGroupName() { return this.group_name_ == "" ? "Unammed" : this.group_name_; };
        int GetOrdersByGroupId();
        int GetOrdersByGroupId(int group_id);
        int GetOrdersByGroupId(OrderInMarket& orders_in_history[], OrderInMarket& orders_in_trades[],
                               int group_id);
        int GetTotalNumOfOrdersInTrades();
        bool CreateBuyOrder(double pip) { return this.CreateBuyOrder(pip, ""); }
        bool CreateBuyOrder(double pip, string comment);
        bool CreateSellOrder(double pip) { return this.CreateSellOrder(pip, ""); }
        bool CreateSellOrder(double pip, string comment);
        // Gets the information about some important information about OrderGroup
        double GetCurrentProfit();
        double GetMaxFloatingProfit();
        double GetMaxFloatingLoss();

    protected:
        OrderGroupCenter *order_group_center_ptr_;

// Utils Variables
    protected:
        OrderArrayUtils order_array_utils;
        OrderSendUtils ou_send;
        OrderCloseUtils ou_close;
        OrderGetUtils ou_get;
        OrderPrintUtils ou_print;
        AccountInfoUtils ac_utils;

// Member Variables
    protected:
        string group_name_;
        int group_id_;
        int group_magic_number_;
        OrderInMarket orders_in_history[];
        OrderInMarket orders_in_trades[];
        string msg_from_subject_;
        double cur_profit_;
        double max_floating_loss_;
        double max_floating_profits_;
};