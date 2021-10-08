#include "OrderGroupCenter.mqh"
#include "../OrderGroupBase/OrderGroupSubjectBase.mqh"
#include "../OrderGroupBase/OrderGroupObserverBase.mqh"
#include "../OrderGroupBase/OrderGroupConstant.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include "DataStructure.mqh"

// Observer Register management methods implementations.
int OrderGroupCenter::Register(OrderGroupObserver *observer) {
    this.order_group_observer_list_.add(observer);

    OrderGroupInfo* g_info_ptr = new OrderGroupInfo();
    g_info_ptr.group_id = this.group_id_base_;
    this.group_id_base_ += 1;

    GroupMNRanges g_mn_ranges = this.AllocateGroupMNRanges();
    g_info_ptr.g_mn_ranges = g_mn_ranges;

    this.group_id_to_group_info_.set(g_info_ptr.group_id, g_info_ptr);
    this.group_id_to_magic_number_.set(g_info_ptr.group_id, g_info_ptr.g_mn_ranges.pos_right);
    return g_info_ptr.group_id;
}
void OrderGroupCenter::UnRegister(OrderGroupObserver *observer) {
    this.order_group_observer_list_.remove(observer);
}
void OrderGroupCenter::UnRegister(OrderGroupObserver *observer, int group_id) {
    if (this.group_id_to_magic_number_.contains(group_id)) {
        this.group_id_to_magic_number_.remove(group_id);
        this.group_id_to_group_info_.remove(group_id);
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
GroupMNRanges OrderGroupCenter::AllocateGroupMNRanges() {
    GroupMNRanges cur_g_mn_ranges = {INTEGER_MIN_INT, INTEGER_MIN_INT,
                                     INTEGER_MAX_INT, INTEGER_MAX_INT};
    cur_g_mn_ranges.pos_left = this.magic_number_max_;
    cur_g_mn_ranges.pos_right = this.magic_number_max_ + CNT_MN_PER_GROUP - 1;
    cur_g_mn_ranges.neg_left = this.magic_number_min_;
    cur_g_mn_ranges.neg_right = this.magic_number_min_ - CNT_MN_PER_GROUP + 1;
    this.magic_number_max_ += CNT_MN_PER_GROUP;
    this.magic_number_min_ -= CNT_MN_PER_GROUP;
    return cur_g_mn_ranges;
}