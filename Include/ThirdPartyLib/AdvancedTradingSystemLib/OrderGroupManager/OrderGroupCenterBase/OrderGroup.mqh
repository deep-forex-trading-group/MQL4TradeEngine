#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/AccountInformationUtils/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include "OrderGroupCenter.mqh"
#include "DataStructure.mqh"

class OrderGroup : public OrderGroupObserver {
    public:
    // TODO: to separate the signal_order and auto_order with different MAGIC_NUMBER
        OrderGroup(string name, OrderGroupCenter *order_group_center_ptr) :
                   group_name_(name), order_group_center_ptr_(order_group_center_ptr) {
            this.group_id_ = this.order_group_center_ptr_.Register(GetPointer(this));
            // Gets Magic Number Ranges from Center
            GroupMNRanges g_mn_ranges = this.order_group_center_ptr_.OnStartGetMNRanges(this.group_id_);
            this.pos_mn_range_.left = g_mn_ranges.pos_left;
            this.pos_mn_range_.right = g_mn_ranges.pos_right;
            this.neg_mn_range_.left = g_mn_ranges.neg_left;
            this.neg_mn_range_.right = g_mn_ranges.neg_right;
            this.whole_order_magic_number_set_ = new HashSet<int>();

            this.cur_profit_ = 0;
            this.max_floating_loss_ = 0;
            this.max_floating_profits_ = 0;
            this.msg_from_subject_ = "Init subject msg";
            PrintFormat("Initialize Order Group [%d].", this.group_id_);
        };
        virtual ~OrderGroup() {
            PrintFormat("Deinitialize order group [%d]", this.group_id_);
            SafeDeleteCollectionPtr(whole_order_magic_number_set_);
        };

// Observer communications functionality
    public:
        void Update(string msg);
        void UnRegister();
        void PrintInfo();
// Public Apis for users to call
    public:
// Gets Group Basic Information
        int GetGroupId() { return this.group_id_; };
        string GetGroupName() { return this.group_name_ == "" ? "Unammed" : this.group_name_; };

// Gets Group Orders Information
        int GetTotalNumOfOrdersInTrades();
        double GetCurrentTotalLotsInTrades() {
            return AccountInfoUtils::GetCurrentTotalLots(this.whole_order_magic_number_set_,
                                                         IN_TRADES);
        }
        double GetCurrentProfitInTrades();
// TODO: To Fixes after implements total_info_for_one_loop
        double GetMaxFloatingProfit();
        double GetMaxFloatingLoss();

// MagicNumberSet Getter
        HashSet<int>* GetWholeOrderMagicSet() { return this.whole_order_magic_number_set_; }

// Close Order Functions
        bool CloseAllOrders() {
            if (this.whole_order_magic_number_set_.size() == 0) {
                return false;
            } else {
                for(Iter<int> it(this.whole_order_magic_number_set_); !it.end(); it.next()) {
                    OrderCloseUtils::CloseAllOrders(it.current());
                }
            }
            return true;
        }

// Print Orders Information
        void PrintAllOrders();
    protected:
        OrderGroupCenter *order_group_center_ptr_;

// Member Variables
    protected:
        string group_name_;
        int group_id_;
        OrderInMarket orders_in_history[];
        OrderInMarket orders_in_trades[];
        string msg_from_subject_;
        double cur_profit_;
        double max_floating_loss_;
        double max_floating_profits_;
        MagicNumberRange pos_mn_range_;
        MagicNumberRange neg_mn_range_;
        HashSet<int>* whole_order_magic_number_set_;
// Utils Functions
    protected:
        string GetGroupBaseComment() {
            string comm_for_group = StringFormat("#%s#%s#%s",
                                                 this.order_group_center_ptr_.GetName(),
                                                 this.group_name_,
                                                 IntegerToString(this.group_id_));
            return comm_for_group;
        }

};