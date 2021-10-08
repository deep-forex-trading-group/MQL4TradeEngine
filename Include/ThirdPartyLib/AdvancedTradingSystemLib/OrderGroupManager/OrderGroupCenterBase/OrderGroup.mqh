#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/AccountInformationUtils/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include "OrderGroupCenter.mqh"
#include "DataStructure.mqh"
#include "Constant.mqh"

class OrderGroup : public OrderGroupObserver {
    public:
        OrderGroup(string name, OrderGroupCenter *order_group_center_ptr) :
                   group_name_(name), order_group_center_ptr_(order_group_center_ptr) {
            this.group_id_ = this.order_group_center_ptr_.Register(GetPointer(this));
            // Gets Magic Number Ranges from Center
            GroupMNRanges g_mn_ranges = this.order_group_center_ptr_.OnStartGetMNRanges(this.group_id_);
            this.pos_mn_range_.left = g_mn_ranges.pos_left;
            this.pos_mn_range_.right = g_mn_ranges.pos_right;
            this.pos_mn_idx_ = this.pos_mn_range_.left;
            this.neg_mn_range_.left = g_mn_ranges.neg_left;
            this.neg_mn_range_.right = g_mn_ranges.neg_right;
            this.neg_mn_idx_ = this.neg_mn_range_.left;
            this.whole_order_magic_number_set_ = new HashSet<int>();

            this.cur_profit_ = 0;
            this.max_floating_loss_ = 0;
            this.max_floating_profits_ = 0;
            this.msg_from_subject_ = "Init subject msg";
            this.init_success_ = true;
            PrintFormat("Initialize Order Group [%d].", this.group_id_);
        };
        virtual ~OrderGroup() {
            PrintFormat("Deinitialize order group [%d]", this.group_id_);
            SafeDeleteCollectionPtr(whole_order_magic_number_set_);
        };

// Observer communications functionality
    public:
        void Update(string msg) {
            this.msg_from_subject_ = msg;
            PrintInfo();
        }
        void UnRegister() {
            this.order_group_center_ptr_.UnRegister(GetPointer(this));
            PrintFormat("OrderGroup: %d is unregistered from order group center.", this.group_id_);
        }
        void PrintInfo() {
            PrintFormat("OrderGroup: %d gets a new msg [%s]", this.group_id_, this.msg_from_subject_);
        }
// Public Apis for users to call
    public:

// Group Basic Information Getters
        int GetGroupId() { return this.group_id_; };
        string GetGroupName() { return this.group_name_ == "" ? "Unammed" : this.group_name_; };
        bool IsInitSuccess() { return this.init_success_; }

// Group Orders Information Getters
        int GetTotalNumOfOrdersInTrades() {
            return OrderGetUtils::GetNumOfAllOrdersInTrades(this.whole_order_magic_number_set_);
        }
        double GetCurrentTotalLotsInTrades() {
            return AccountInfoUtils::GetCurrentTotalLots(this.whole_order_magic_number_set_,
                                                         IN_TRADES);
        }
        double GetCurrentProfitInTrades() {
            return AccountInfoUtils::GetCurrentFloatingProfit(this.whole_order_magic_number_set_);
        }
        double GetCurrentProfitInHistory() {
            return AccountInfoUtils::GetTotalProfit(this.whole_order_magic_number_set_, IN_HISTORY);
        }
        double GetCurrentProfitInTradesAndHistory() {
            return AccountInfoUtils::GetTotalProfit(this.whole_order_magic_number_set_, IN_TRADES_OR_HISTORY);
        }
// TODO: To Fixes after implements total_info_for_one_loop
        double GetMaxFloatingProfit();
        double GetMaxFloatingLoss();

// MagicNumberSet Getter
        HashSet<int>* GetWholeOrderMagicSet() { return this.whole_order_magic_number_set_; }

// Close Order Functions
        bool CloseAllOrders(int buy_or_sell);
        bool CloseProfitOrders(int buy_or_sell, double profit);

// Print Orders Information
        void PrintAllOrders();
    protected:
        OrderGroupCenter *order_group_center_ptr_;

// Member Variables
    protected:
        string group_name_;
        int group_id_;
        bool init_success_;
        OrderInMarket orders_in_history[];
        OrderInMarket orders_in_trades[];
        string msg_from_subject_;
        double cur_profit_;
        double max_floating_loss_;
        double max_floating_profits_;
        MagicNumberRange pos_mn_range_;
        int pos_mn_idx_;
        MagicNumberRange neg_mn_range_;
        int neg_mn_idx_;
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

// Magic Number Manipulations
        int AllocateGroupMN(MN_DIR mn_dir);
        bool CheckPosMNValid(int num_of_mn) {
            return (this.pos_mn_idx_ + num_of_mn < this.pos_mn_range_.left
                    || this.pos_mn_idx_ + num_of_mn > pos_mn_range_.right - 1);
        }
        bool CheckNegMNValid(int num_of_mn) {
            return (this.neg_mn_idx_ - num_of_mn > this.neg_mn_range_.left
                    || this.neg_mn_idx_ - num_of_mn < this.neg_mn_range_.right + 1);
        }
};