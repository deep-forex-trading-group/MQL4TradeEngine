#include "../OrderGroupBase/OrderGroupSubjectBase.mqh"
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

// Observer Register management methods implementations.
int OrderGroupCenter::Register(OrderGroupObserver *observer) {
    this.order_group_observer_list_.add(observer);
    int cur_order_group_id = this.registered_magic_number_max_;
    int cur_magic_number = this.AllocateMagicNumber();
    this.group_id_to_magic_number.set(cur_order_group_id, cur_magic_number);
    return cur_order_group_id;
}
void OrderGroupCenter::UnRegister(OrderGroupObserver *observer) {
    this.order_group_observer_list_.remove(observer);
}
void OrderGroupCenter::UnRegister(OrderGroupObserver *observer, int group_id) {
    if (this.group_id_to_magic_number.contains(group_id)) {
        this.group_id_to_magic_number.remove(group_id);
    } else {
        PrintFormat("[GroupRemoveFailed] %s center does not have the group with %d", this.group_center_name_, group_id);
    }

    this.UnRegister(observer);
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
int OrderGroupCenter::UpdateGroupMagicNumber(int group_id) {
    this.observer_msg_ = StringFormat("update the magic number for group with group_id[%d]", group_id);
    int magic_number_rtn = this.AllocateMagicNumber();
    this.group_id_to_magic_number.set(group_id, magic_number_rtn);
    Notify();
    return magic_number_rtn;
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
int OrderGroupCenter::GetMagicNumberByGroupId(int group_id) {
    return this.order_center_magic_number_base_ + group_id;
}
int OrderGroupCenter::AllocateMagicNumber() {
    int allocated_magic_number = this.order_center_magic_number_base_ + this.registered_magic_number_max_;
    this.registered_magic_number_max_++;
    return allocated_magic_number;
}