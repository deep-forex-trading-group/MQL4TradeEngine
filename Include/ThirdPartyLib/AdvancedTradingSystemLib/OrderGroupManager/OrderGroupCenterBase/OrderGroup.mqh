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
    // TODO: to separate the signal_order and auto_order with different MAGIC_NUMBER
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
        double GetCurrentProfitInTradesAndHistory() {
            return AccountInfoUtils::GetTotalProfit(this.whole_order_magic_number_set_, IN_TRADES_OR_HISTORY);
        }

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
        int AllocateGroupMN(MN_DIR mn_dir) {
            int cur_allocate_res = INVALID_GRP_MN;
// TODO: InTrades Track
// TODO: 在Order Management中考虑pending order过滤的情况 加上(order_type == buy || order_type == sell)的情形
            if (mn_dir == POS_MN
                && (this.pos_mn_idx_ >= this.pos_mn_range_.left && this.pos_mn_idx_ <= pos_mn_range_.right - 1)) {
                cur_allocate_res = this.pos_mn_idx_;
                this.pos_mn_idx_++;
                return cur_allocate_res;
            }

            if (mn_dir == NEG_MN
                && (this.neg_mn_idx_ <= this.neg_mn_range_.left && this.neg_mn_idx_ >= this.neg_mn_range_.right + 1)) {
                cur_allocate_res = this.neg_mn_idx_;
                this.neg_mn_idx_--;
                return cur_allocate_res;
            }

            PrintFormat("Update Magic Number failed for group [%s], <%d,%d,%d>,<%d,%d,%d>",
                        this.group_name_,
                        this.pos_mn_range_.left, this.pos_mn_idx_, this.pos_mn_range_.right,
                        this.neg_mn_range_.left, this.neg_mn_idx_, this.neg_mn_range_.right);

            return cur_allocate_res;
        }

};