#include "OrderGroup.mqh"

// Observer register functionaliy
void OrderGroup::Update(string msg) {
    this.msg_from_subject_ = msg;
    PrintInfo();
}
void OrderGroup::UnRegister() {
    this.order_group_center_ptr_.UnRegister(GetPointer(this));
    PrintFormat("OrderGroup: %d is unregistered from order group center.", this.group_id_);
}
void OrderGroup::PrintInfo() {
    PrintFormat("OrderGroup: %d gets a new msg [%s]", this.group_id_, this.msg_from_subject_);
}