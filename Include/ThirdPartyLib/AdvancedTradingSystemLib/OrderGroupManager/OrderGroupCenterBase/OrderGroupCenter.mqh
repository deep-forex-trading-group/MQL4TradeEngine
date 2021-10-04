#include "../OrderGroupBase/OrderGroupSubjectBase.mqh"
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

class OrderGroupCenter : public OrderGroupSubject {
    public:
        OrderGroupCenter(string name) {
            this.group_center_name_ = name;
            this.registered_magic_number_max_ = 0;
            this.order_center_magic_number_base_ = this.GetOrderCenterMagicNumberBase();
            PrintFormat("Initialize OrderGroupCenter [%s].", this.group_center_name_);
        }
        virtual ~OrderGroupCenter() {
            PrintFormat("Deinitialize OrderGroupCenter [%s].", this.group_center_name_);
            this.SaveDeleteOrderGroups();
            SaveDeletePtr(&order_group_observer_list_);
            SaveDeletePtr(&group_id_to_magic_number);
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
        int UpdateGroupMagicNumber(int group_id);
        void CreateMsg(string msg);
        string GetName() { return this.group_center_name_; };
        void SetName(string name) { this.group_center_name_ = name; };

    public:
        int GetMagicNumberByGroupId(int group_id);
    // Member variables
    protected:
        LinkedList<OrderGroupObserver*> order_group_observer_list_;
        HashMap<int,int> group_id_to_magic_number;
        string observer_msg_;
        string group_center_name_;
        int registered_magic_number_max_;
        int order_center_magic_number_base_;
    // Member functions
        void SaveDeleteOrderGroups() {
            for (Iter<OrderGroupObserver*> it(this.order_group_observer_list_); !it.end(); it.next()) {
                OrderGroupObserver* og = it.current();
                SaveDeletePtr(og);
            }
        };
        // TODO: Needs to accomplish to avoid Stoping EA,
        //       and avoid MAGIC NUMBER conflicts with previous started EA
        //       need to get the base number from a file instead of hard-coding.
        int GetOrderCenterMagicNumberBase() {
            MinMaxMagicNumber res = OrderGetUtils::GetAllOrdersWithoutSymbol();
            if (res.is_success) {
                return res.max_magic_number + 1;
            } else {
                return ORDER_GROUP_CENTER_MAGIC_BASE;
            }
        }
        int AllocateMagicNumber();
};