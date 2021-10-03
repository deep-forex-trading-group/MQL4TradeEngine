#include "../OrderGroupBase/OrderGroupSubjectBase.mqh"
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/LinkedList.mqh>

class OrderGroupCenter : public OrderGroupSubject {
    public:
        OrderGroupCenter(string name) {
            this.group_center_name_ = name;
            this.group_id_max_ = 0;
            this.order_center_magic_number_base_ = this.GetOrderCenterMagicNumberBase();
            PrintFormat("Initialize OrderGroupCenter [%s].", this.group_center_name_);
        }
        virtual ~OrderGroupCenter() {
            PrintFormat("Deinitialize OrderGroupCenter [%s].", this.group_center_name_);
            this.SaveDeleteOrderGroups();
            SaveDeletePtr(&order_group_observer_list_);
        }

    // Observer communications management methods
    public:
        // Returns the group_id when new OrderGroup registered.
        int Register(OrderGroupObserver *observer);
        void UnRegister(OrderGroupObserver *observer);
        void Notify();
        void PrintInfo();
        int GetNumOfObservers();
        void SomeBusinessLogic();
        void CreateMsg(string msg);
        string GetName() { return this.group_center_name_; };
        void SetName(string name) { this.group_center_name_ = name; };

    public:
        int GetMagicNumberByGroupId(int group_id);
    // Member variables
    protected:
        LinkedList<OrderGroupObserver*> order_group_observer_list_;
        string observer_msg_;
        string group_center_name_;
        int group_id_max_;
        int order_center_magic_number_base_;
    // Member functions
        void SaveDeleteOrderGroups() {
            for (Iter<OrderGroupObserver*> it(this.order_group_observer_list_); !it.end(); it.next()) {
                OrderGroupObserver* og = it.current();
                SaveDeletePtr(og);
            }
        };
        // TODO: Needs to accomplish to avoid Stoping EA,
        // TODO: and avoid MAGIC NUMBER conflicts with previous started EA
        int GetOrderCenterMagicNumberBase() {
            return ORDER_GROUP_CENTER_MAGIC_BASE;
        }
};