#include "AutoAdjustOrderGroup.mqh"

bool AutoAdjustOrderGroup::CreateAutoSellOrder(double pip, string comment) {
    string comm = this.GetGroupComment();
    if (OrderSendUtils::CreateSellOrder(this.group_auto_nm_, pip, comment) == -1) {
        PrintFormat("Create Sell Order {%s} failed.", comm);
        return false;
    }
    return true;
}
bool AutoAdjustOrderGroup::CreateSigBuyOrder(double pip, string comment) {
    string comm = this.GetGroupComment();
    PrintFormat(comm);
    if (OrderSendUtils::CreateBuyOrder(this.group_sig_nm_, pip, comment) == -1) {
        PrintFormat("Create Buy Order {%s} failed.", comm);
        return false;
    }
    return true;
}
bool AutoAdjustOrderGroup::CreateSigSellOrder(double pip, string comment) {
    string comm = this.GetGroupComment();
    if (OrderSendUtils::CreateSellOrder(this.group_sig_nm_, pip, comment) == -1) {
        PrintFormat("Create Sell Order {%s} failed.", comm);
        return false;
    }
    return true;
}
bool AutoAdjustOrderGroup::UpdateMagicNumber() {
    if (this.group_sig_nm_ >= this.neg_nm_range_.left
        || this.group_sig_nm_ < this.neg_nm_range_.right + 1) {
        PrintFormat("UpdateMagicNumber() failed for {%s}, sig_[%d < %d]",
                    this.group_name_, this.group_sig_nm_, this.neg_nm_range_.right);
        return false;
    }
    if (this.group_auto_nm_ <= this.pos_nm_range_.left
        || this.group_auto_nm_ > this.pos_nm_range_.right - 1) {
        PrintFormat("UpdateMagicNumber() failed for {%s}, auto_[%d > %d]",
                    this.group_name_, this.group_auto_nm_, this.pos_nm_range_.left);
        return false;
    }
    this.whole_order_magic_number_set_.remove(this.group_auto_nm_);
    this.whole_order_magic_number_set_.remove(this.group_sig_nm_);
    // Updates the member variables for magic numbers
    this.group_auto_nm_ += 1;
    this.group_sig_nm_ -= 1;

    this.whole_order_magic_number_set_.add(this.group_auto_nm_);
    this.whole_order_magic_number_set_.add(this.group_sig_nm_);
    return true;
}