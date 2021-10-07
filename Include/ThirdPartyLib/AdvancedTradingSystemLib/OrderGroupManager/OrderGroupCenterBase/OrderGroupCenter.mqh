#include "../OrderGroupBase/OrderGroupSubjectBase.mqh"
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>
#include "DataStructure.mqh"

class OrderGroupCenter : public OrderGroupSubject {
    public:
        OrderGroupCenter(string name) {
            this.group_center_name_ = name;
            MinMaxMagicNumber min_max_mn[1];
            if (this.GetOrderCenterMagicNumberBase(min_max_mn) == FAILED) {
                this.init_success = false;
                return;
            }
            this.init_success = true;
            this.magic_number_max_ = min_max_mn[0].max_magic_number;
            this.magic_number_min_ = min_max_mn[0].min_magic_number;
            this.group_id_base_ = (this.magic_number_max_ / CNT_MN_PER_GROUP) + 1;
            this.order_group_observer_list_ = new LinkedList<OrderGroupObserver*>();
            this.group_id_to_magic_number_ = new HashMap<int, int>();
            this.group_id_to_group_info_ = new HashMap<int, OrderGroupInfo*>();
            PrintFormat("Initialize OrderGroupCenter [%s].", this.group_center_name_);
        }
        virtual ~OrderGroupCenter() {
            PrintFormat("Deinitialize OrderGroupCenter [%s].", this.group_center_name_);

            SafeDeleteCollectionPtr(this.order_group_observer_list_);
            SafeDeleteCollectionPtr(this.group_id_to_magic_number_);
            MapDeleteUtils<int, OrderGroupInfo*>::SafeFreeHashMap(this.group_id_to_group_info_);
        }

    // Observer communications management methods
    public:
        int IsInitSuccess() {
            return this.init_success;
        }
        // Returns the group_id when new OrderGroup registered.
        int Register(OrderGroupObserver *observer);
        void UnRegister(OrderGroupObserver *observer);
        void UnRegister(OrderGroupObserver *observer, int group_id);
        void Notify();
        void PrintInfo();
        int GetNumOfObservers();
        void SomeBusinessLogic();
        void CreateMsg(string msg);
        string GetName() { return this.group_center_name_; };
        void SetName(string name) { this.group_center_name_ = name; };

    public:
        GroupMNRanges OnStartGetMNRanges(int group_id) {
            if (this.group_id_to_group_info_.contains(group_id)) {
                return this.group_id_to_group_info_[group_id].g_mn_ranges;
            }
            GroupMNRanges g_mn_ranges = {1,1,-1,-1};
            return g_mn_ranges;
        }
    // Member variables
    protected:
        int init_success;
        LinkedList<OrderGroupObserver*>* order_group_observer_list_;
        HashMap<int,int>* group_id_to_magic_number_;
        HashMap<int, OrderGroupInfo*>* group_id_to_group_info_;
        string observer_msg_;
        string group_center_name_;
        int magic_number_max_;
        int magic_number_min_;
        int group_id_base_;
    // Member functions
        // TODO: Needs to accomplish to avoid Stoping EA,
        //       need to get the base number from a file instead of hard-coding.
        int GetOrderCenterMagicNumberBase(MinMaxMagicNumber& res_out_arr[]) {
            res_out_arr[0] = OrderGetUtils::GetAllOrdersWithoutSymbolAndZeroMN();

            res_out_arr[0].max_magic_number = (res_out_arr[0].max_magic_number / CNT_MN_PER_GROUP) * CNT_MN_PER_GROUP;
            res_out_arr[0].max_magic_number += CNT_MN_PER_GROUP;
            res_out_arr[0].min_magic_number = (res_out_arr[0].min_magic_number / CNT_MN_PER_GROUP) * CNT_MN_PER_GROUP;
            res_out_arr[0].min_magic_number -= CNT_MN_PER_GROUP;

            if (res_out_arr[0].is_success) {
                PrintFormat("Set magic_base with current symbol [%s] using history orders, set <%d:%d>",
                             MarketInfoUtils::GetSymbol(),
                             res_out_arr[0].max_magic_number,
                             res_out_arr[0].min_magic_number);
            } else {
                PrintFormat("There are no history order with current symbol [%s], set <%d:%d>",
                             MarketInfoUtils::GetSymbol(),
                             res_out_arr[0].max_magic_number,
                             res_out_arr[0].min_magic_number);
            }
            return SUCCEEDED;
        }
        GroupMNRanges AllocateMagicNumber();
};