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
        // Deprecated: All the orders in the same group shares only one magic number.
        //             The magic number provided by the OrderGroupCenter once the group initialized.
        void GetGroupMagicNumberSet(HashSet<int>* group_magic_number_set);
        int GenerateNewOrderMagicNumber();
};