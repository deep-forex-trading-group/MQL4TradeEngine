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
            MinMaxMagicNumber min_max_mn = this.GetOrderCenterMagicNumberBase();
            this.magic_number_max_ = min_max_mn.max_magic_number;
            this.magic_number_min_ = min_max_mn.min_magic_number;
            this.group_id_base_ = this.magic_number_max_ % CNT_GROUP_MAGIC_NUMBER + 1;
            this.order_group_observer_list_ = new LinkedList<OrderGroupObserver*>();
            this.group_id_to_magic_number_ = new HashMap<int, int>();
            this.group_id_to_group_info_ = new HashMap<int, OrderGroupInfo*>();
            PrintFormat("Initialize OrderGroupCenter [%s].", this.group_center_name_);
        }
        virtual ~OrderGroupCenter() {
            PrintFormat("Deinitialize OrderGroupCenter [%s].", this.group_center_name_);

            SaveDeletePtr(order_group_observer_list_);
            SaveDeletePtr(group_id_to_magic_number_);
            SaveDeletePtr(group_id_to_group_info_);
        }

    // Observer communications management methods
    public:
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
        int GetMagicNumberByGroupId(int group_id) {
            return this.group_id_base_ + group_id;
        }
        GroupMNRanges OnStartGetMNRanges(int group_id) {
            if (this.group_id_to_group_info_.contains(group_id)) {
                return this.group_id_to_group_info_[group_id].g_mn_ranges;
            }
            GroupMNRanges g_mn_ranges = {1,1,-1,-1};
            return g_mn_ranges;
        }
    // Member variables
    protected:
        LinkedList<OrderGroupObserver*>* order_group_observer_list_;
        HashMap<int,int>* group_id_to_magic_number_;
        HashMap<int, OrderGroupInfo*>* group_id_to_group_info_;
        string observer_msg_;
        string group_center_name_;
        int magic_number_max_;
        int magic_number_min_;
        int group_id_base_;
    // Member functions
<<<<<<< Updated upstream
        void SaveDeleteOrderGroups() {
            for (Iter<OrderGroupObserver*> it(this.order_group_observer_list_); !it.end(); it.next()) {
                OrderGroupObserver* og = it.current();
                SafeDeletePtr(og);
            }
        };
=======
>>>>>>> Stashed changes
        // TODO: Needs to accomplish to avoid Stoping EA,
        //       and avoid MAGIC NUMBER conflicts with previous started EA
        //       need to get the base number from a file instead of hard-coding.
        MinMaxMagicNumber GetOrderCenterMagicNumberBase() {
            MinMaxMagicNumber res = OrderGetUtils::GetAllOrdersWithoutSymbol();
            res.max_magic_number = (res.max_magic_number % CNT_GROUP_MAGIC_NUMBER) + 1;
            res.min_magic_number = (res.min_magic_number % CNT_GROUP_MAGIC_NUMBER) - 1;
            if (res.is_success) {
                PrintFormat("Set magic_base with current symbol [%s] using history orders, set <%d:%d>",
                             MarketInfoUtils::GetSymbol(), res.max_magic_number, res.min_magic_number);
            } else {
                PrintFormat("There are no history order with current symbol [%s], set <%d:%d>",
                             MarketInfoUtils::GetSymbol(), res.max_magic_number, res.min_magic_number);
            }
            return res;
        }
        GroupMNRanges AllocateMagicNumber();
};