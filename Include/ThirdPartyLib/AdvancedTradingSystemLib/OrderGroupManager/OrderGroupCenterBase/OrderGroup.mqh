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
        OrderGroup(OrderGroupCenter *order_group_center_ptr) {
            this.order_group_center_ptr_ = order_group_center_ptr;
            this.group_id_ = this.order_group_center_ptr_.Register(GetPointer(this));
            // Gets Magic Number Ranges from Center
            GroupMNRanges g_mn_ranges = this.order_group_center_ptr_.OnStartGetMNRanges(this.group_id_);
            this.pos_nm_range_.left = g_mn_ranges.pos_left;
            this.pos_nm_range_.right = g_mn_ranges.pos_right;
            this.neg_nm_range_.left = g_mn_ranges.neg_left;
            this.neg_nm_range_.right = g_mn_ranges.neg_right;
            // Assigns and Initializes the magic number for Auto and Sig
            this.group_auto_nm_ = g_mn_ranges.pos_left + 1;
            this.group_sig_nm_ = g_mn_ranges.neg_left - 1;
            this.whole_order_magic_number_set_ = new HashSet<int>();
            this.whole_order_magic_number_set_.add(this.group_auto_nm_);
            this.whole_order_magic_number_set_.add(this.group_sig_nm_);
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
        int GetGroupId() { return this.group_id_; };
        int GetGroupAutoMagicNumber() { return this.group_auto_nm_; }
        int GetGroupSigMagicNumber() { return this.group_sig_nm_; }
        string GetGroupName() { return this.group_name_ == "" ? "Unammed" : this.group_name_; };
// Order State Refreshing Functions (IMPORTANT MAINTAIN FUNCTIONS)
        int RefreshOrderGroupState() {
            return SUCCEEDED;
        }
        bool UpdateAutoMN() {
            if (OrderGetUtils::GetNumOfAllOrdersInTrades(this.group_auto_nm_) == 0) {
                if (!this.UpdateMagicNumber()) {
                    PrintFormat("RefreshOrderGroupState() failed for UpdateMagicNumber() failed");
                    return false;
                }
            }
            return true;
        }
        bool UpdateSigMN() {
            if (OrderGetUtils::GetNumOfAllOrdersInTrades(this.group_sig_nm_) == 0) {
                if (!this.UpdateMagicNumber()) {
                    PrintFormat("RefreshOrderGroupState() failed for UpdateMagicNumber() failed");
                    return false;
                }
            }
            return true;
        }
        int RefreshOrderInfo();
// Get Order Functions
        int GetOrdersByGroupId(int group_id);
        int GetOrdersByGroupId(OrderInMarket& orders_in_history[], OrderInMarket& orders_in_trades[],
                               int group_id);
        int GetTotalNumOfOrdersInTrades();
        HashSet<int>* GetWholeOrderMagicSet() { return this.whole_order_magic_number_set_; }
// Create Order Functions
        bool CreateAutoBuyOrder(double pip) { return this.CreateAutoBuyOrder(pip, ""); }
        bool CreateAutoBuyOrder(double pip, string comment);
        bool CreateAutoSellOrder(double pip) { return this.CreateAutoSellOrder(pip, ""); }
        bool CreateAutoSellOrder(double pip, string comment);
        bool CreateSigBuyOrder(double pip) { return this.CreateSigBuyOrder(pip, ""); }
        bool CreateSigBuyOrder(double pip, string comment);
        bool CreateSigSellOrder(double pip) { return this.CreateSigSellOrder(pip, ""); }
        bool CreateSigSellOrder(double pip, string comment);
        bool AddOneOrderByStepPipReverse(int buy_or_sell, double pip_step, double lots) {
            bool is_success = OrderSendUtils::AddOneOrderByStepPipReverse(
                                                                this.whole_order_magic_number_set_,
                                                                this.group_auto_nm_,
                                                                buy_or_sell, pip_step, lots,
                                                                this.GetGroupBaseComment());
            return is_success;
        }
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
// Gets the information about some important information about OrderGroup
        double GetCurrentProfit();
        double GetMaxFloatingProfit();
        double GetMaxFloatingLoss();
// Print Orders Information
        void PrintAllOrders();
// Maintains the extra orders
        bool AddsExtraOrderMagicNumber(long extra_order_magic_number) {
            return this.whole_order_magic_number_set_.add((int) extra_order_magic_number);
        }
    protected:
        OrderGroupCenter *order_group_center_ptr_;

// Member Variables
    protected:
        string group_name_;
        int group_id_;
        int group_auto_nm_;
        int group_sig_nm_;
        OrderInMarket orders_in_history[];
        OrderInMarket orders_in_trades[];
        string msg_from_subject_;
        double cur_profit_;
        double max_floating_loss_;
        double max_floating_profits_;
        MagicNumberRange pos_nm_range_;
        MagicNumberRange neg_nm_range_;
        HashSet<int>* whole_order_magic_number_set_;
// Utils Functions
    protected:
        bool UpdateMagicNumber() {
            if (this.group_sig_nm_ >= this.neg_nm_range_.left
                || this.group_sig_nm_ < this.neg_nm_range_.right + 1) {
                PrintFormat("UpdateMagicNumber() failed for {%s}, sig_[%d < %d]",
                            this.group_name_, this.group_sig_nm_, this.neg_nm_range_.right);
                return false;
            }
            if (this.group_auto_nm_ <= this.pos_nm_range_.left
                || this.group_auto_nm_ > this.pos_nm_range_.right - 1) {
                PrintFormat("UpdateMagicNumber() failed for {%s}, auto_[%d > %d]",
                            this.group_name_, this.group_auto_nm_, this.pos_nm_range_.left);
                return false;
            }
            this.whole_order_magic_number_set_.remove(this.group_auto_nm_);
            this.whole_order_magic_number_set_.remove(this.group_sig_nm_);
            // Updates the member variables for magic numbers
            this.group_auto_nm_ += 1;
            this.group_sig_nm_ -= 1;
            
            this.whole_order_magic_number_set_.add(this.group_auto_nm_);
            this.whole_order_magic_number_set_.add(this.group_sig_nm_);
            return true;
        }
        string GetGroupBaseComment() {
            string comm_for_group = StringFormat("#s#%s#%s#%s#%s#%s#",
                                                 this.order_group_center_ptr_.GetName(),
                                                 this.group_name_,
                                                 IntegerToString(this.group_id_),
                                                 IntegerToString(this.group_auto_nm_),
                                                 IntegerToString(this.group_sig_nm_));
            return comm_for_group;
        }

};