#include "AutoAdjustOrderGroup.mqh"

bool AutoAdjustOrderGroup::CreateManulBuyOrder(double lots, string comment) {
    string comm_grp = this.GetGroupComment();
    string comm = StringFormat("%s#bm#%s", comm_grp, comment);
    if (OrderSendUtils::CreateBuyOrder(this.group_manul_mn_, lots, comm) == -1) {
        return false;
    }
    return true;
}
bool AutoAdjustOrderGroup::CreateManulSellOrder(double lots, string comment) {
    string comm_grp = this.GetGroupComment();
    string comm = StringFormat("%s#sm#%s", comm_grp, comment);
    if (OrderSendUtils::CreateSellOrder(this.group_manul_mn_, lots, comm) == -1) {
        return false;
    }
    return true;
}
bool AutoAdjustOrderGroup::CreateSigBuyOrder(double lots, string comment) {
    string comm_grp = this.GetGroupComment();
    string comm = StringFormat("%s#bs#%s", comm_grp, comment);
    if (OrderSendUtils::CreateBuyOrder(this.group_sig_mn_, lots, comm) == -1) {
        PrintFormat("Create Buy Order {%s} failed.", comm);
        return false;
    }
    return true;
}
bool AutoAdjustOrderGroup::CreateSigSellOrder(double lots, string comment) {
    string comm_grp = this.GetGroupComment();
    string comm = StringFormat("%s#ss#%s", comm_grp, comment);
    if (OrderSendUtils::CreateSellOrder(this.group_sig_mn_, lots, comm) == -1) {
        PrintFormat("Create Sell Order {%s} failed.", comm);
        return false;
    }
    return true;
}
bool AutoAdjustOrderGroup::UpdateMagicNumbersAll() {
    if (this.CheckPosMNValid(1)) {
        PrintFormat("Updates pos mn failed, insufficient!");
        return false;
    }
    if (this.CheckNegMNValid(2)) {
        PrintFormat("Updates neg mn failed, insufficient!");
        return false;
    }
    int updated_mn = this.UpdateMagicNumber(this.group_auto_mn_, POS_MN);
    if (updated_mn == INVALID_GRP_MN) {
        PrintFormat("Updates group_auto_mn_[%d] failed!", this.group_auto_mn_);
        return false;
    }
    this.group_auto_mn_ = updated_mn;

    updated_mn = this.UpdateMagicNumber(this.group_sig_mn_, NEG_MN);
    if (updated_mn == INVALID_GRP_MN) {
        PrintFormat("Updates group_sig_mn_[%d] failed!", this.group_sig_mn_);
        return false;
    }
    this.group_sig_mn_ = updated_mn;

    updated_mn = this.UpdateMagicNumber(this.group_manul_mn_, NEG_MN);
    if (updated_mn == INVALID_GRP_MN) {
        PrintFormat("Updates group_sig_mn_[%d] failed!", this.group_manul_mn_);
        return false;
    }
    this.group_manul_mn_ = updated_mn;

    return true;
}
int AutoAdjustOrderGroup::UpdateMagicNumber(int mn_to_update, MN_DIR mn_dir) {
    int allocated_mn = INVALID_GRP_MN;
    if (OrderGetUtils::GetNumOfAllOrdersInTrades(mn_to_update) != 0) {
        PrintFormat("Updates_mn_failed for num of orders is not 0!");
        return allocated_mn;
    }
    allocated_mn = this.AllocateGroupMN(mn_dir);
    if (allocated_mn == INVALID_GRP_MN) {
        PrintFormat("Updates_mn_failed for allocated failed!");
        return allocated_mn;
    }
    this.whole_order_magic_number_set_.remove(mn_to_update);
    this.whole_order_magic_number_set_.add(allocated_mn);
    return allocated_mn;
}