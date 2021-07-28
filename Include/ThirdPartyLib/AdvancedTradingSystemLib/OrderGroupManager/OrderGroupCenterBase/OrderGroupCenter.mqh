#include "../OrderGroupBase/OrderGroupBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/LinkedList.mqh>

class OrderGroupCenter {
    public:
        OrderGroupCenter() {
            PrintFormat("Initialize OrderGroupCenter.");
        }
        virtual ~OrderGroupCenter() {
            PrintFormat("Deinitialize OrderGroupCenter [%s].", this.group_center_name_);
            delete &order_group_observer_list;
        }

    // Observer register management methods
    public:
        int register(OrderGroupObserver *observer);
        void unRegister(OrderGroupObserver *observer);
        void notify();
        void printInfo();
        int getNumOfObservers();
        void someBusinessLogic();
        void createMsg(string msg);
        void setName(string name);

    public:
        int getMagicNumberByGroupId(int group_id);
    // Observer register management member variables
    private:
        LinkedList<OrderGroupObserver*> order_group_observer_list;
        string observer_msg_;
        string group_center_name_;
};

// Observer register management methods implementations.
int OrderGroupCenter::register(OrderGroupObserver *observer) {
    if (CheckPointer(GetPointer(this.order_group_observer_list)) == POINTER_INVALID) {
        Print("order_group_observer_list is null.");
        return -1;
    }
    this.order_group_observer_list.add(observer);
    return this.getNumOfObservers();
}
void OrderGroupCenter::unRegister(OrderGroupObserver *observer) {
    this.order_group_observer_list.remove(observer);
}
void OrderGroupCenter::notify() {
    if (this.getNumOfObservers() == 0) {
        PrintFormat("OrderGroupCenter [%s] has no observer", this.group_center_name_);
        return;
    }
    for (Iter<OrderGroupObserver*> it(this.order_group_observer_list); !it.end(); it.next()) {
        OrderGroupObserver* observer = it.current();
        observer.update(this.observer_msg_);
    }
}
int OrderGroupCenter::getNumOfObservers() {
    PrintFormat("The # of observers is: %d", order_group_observer_list.size());
    return order_group_observer_list.size();
}
void OrderGroupCenter::someBusinessLogic() {
    this.observer_msg_ = "changes the observer_msg_";
    notify();
    Print("Doing some business logics.");
}
void OrderGroupCenter::createMsg(string msg) {
    this.observer_msg_ = msg;
    notify();
}
void OrderGroupCenter::printInfo() {
    if (this.getNumOfObservers() == 0) {
        PrintFormat("There are no observers in the Order Group Center [%s].", this.group_center_name_);
        return;
    }
    PrintFormat("All Observers information for the Order Group Center [%s].", this.group_center_name_);
    for (Iter<OrderGroupObserver*> it(this.order_group_observer_list); !it.end(); it.next()) {
        OrderGroupObserver* observer = it.current();
        observer.printInfo();
    }
}
void OrderGroupCenter::setName(string name) {
    this.group_center_name_ = name;
}
int OrderGroupCenter::getMagicNumberByGroupId(int group_id) {
    return ORDER_GROUP_MAGIC_BASE + group_id;
}