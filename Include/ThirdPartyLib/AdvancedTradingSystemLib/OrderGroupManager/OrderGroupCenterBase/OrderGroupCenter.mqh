#include "../OrderGroupBase/OrderGroupSubjectBase.mqh"
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/LinkedList.mqh>

class OrderGroupCenter : public OrderGroupSubject {
    public:
        OrderGroupCenter(string name) {
            this.group_center_name_ = name;
            PrintFormat("Initialize OrderGroupCenter.");
        }
        virtual ~OrderGroupCenter() {
            PrintFormat("Deinitialize OrderGroupCenter [%s].", this.group_center_name_);
            delete &order_group_observer_list_;
        }

    // Observer communications management methods
    public:
        int Register(OrderGroupObserver *observer);
        void UnRegister(OrderGroupObserver *observer);
        void Notify();
        void PrintInfo();
        int GetNumOfObservers();
        void SomeBusinessLogic();
        void CreateMsg(string msg);
        void SetName(string name);

    public:
        int GetMagicNumberBaseByGroupId(int group_id);
    // Member variables
    protected:
        LinkedList<OrderGroupObserver*> order_group_observer_list_;
        string observer_msg_;
        string group_center_name_;
};