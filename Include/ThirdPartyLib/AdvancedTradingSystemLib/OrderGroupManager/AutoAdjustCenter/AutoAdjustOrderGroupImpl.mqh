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