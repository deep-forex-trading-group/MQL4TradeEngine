#include "../OrderGroupBase/OrderGroupSubjectBase.mqh"
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include "OrderGroupCenter.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/LinkedList.mqh>

// Observer Register management methods implementations.
int OrderGroupCenter::Register(OrderGroupObserver *observer) {
    this.order_group_observer_list_.add(observer);
    return this.GetNumOfObservers();
}
void OrderGroupCenter::UnRegister(OrderGroupObserver *observer) {
    this.order_group_observer_list_.remove(observer);
}
void OrderGroupCenter::Notify() {
    if (this.GetNumOfObservers() == 0) {
        PrintFormat("OrderGroupCenter [%s] has no observer", this.group_center_name_);
        return;
    }
    for (Iter<OrderGroupObserver*> it(this.order_group_observer_list_); !it.end(); it.next()) {
        OrderGroupObserver* observer = it.current();
        observer.Update(this.observer_msg_);
    }
}
int OrderGroupCenter::GetNumOfObservers() {
    return order_group_observer_list_.size();
}
void OrderGroupCenter::SomeBusinessLogic() {
    this.observer_msg_ = "changes the observer_msg_";
    Notify();
    Print("Doing some business logics.");
}
void OrderGroupCenter::CreateMsg(string msg) {
    this.observer_msg_ = msg;
    Notify();
}
void OrderGroupCenter::PrintInfo() {
    if (this.GetNumOfObservers() == 0) {
        PrintFormat("There are no observers in the Order Group Center [%s].", this.group_center_name_);
        return;
    }
    PrintFormat("All Observers information for the Order Group Center [%s].", this.group_center_name_);
    for (Iter<OrderGroupObserver*> it(this.order_group_observer_list_); !it.end(); it.next()) {
        OrderGroupObserver* observer = it.current();
        observer.PrintInfo();
    }
}
void OrderGroupCenter::SetName(string name) {
    this.group_center_name_ = name;
}
int OrderGroupCenter::GetMagicNumberBaseByGroupId(int group_id) {
    return ORDER_GROUP_MAGIC_BASE + ORDER_GROUP_MAX_ORDERS * group_id + 1;
}