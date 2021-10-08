#include "OrderGroup.mqh"

bool OrderGroup::CloseAllOrders(int buy_or_sell) {
    if (this.whole_order_magic_number_set_.size() == 0) {
        return false;
    }
    bool is_success_close = false;
    if (buy_or_sell == BUY_ORDER_SEND || buy_or_sell == BUY_AND_SELL_SEND) {
        is_success_close = (is_success_close
                            || OrderCloseUtils::CloseAllBuyOrders(this.whole_order_magic_number_set_));
    }
    if (buy_or_sell == SELL_ORDER_SEND || buy_or_sell == BUY_AND_SELL_SEND) {
        is_success_close = (is_success_close
                            || OrderCloseUtils::CloseAllSellOrders(this.whole_order_magic_number_set_));
    }
    return is_success_close;
}
int OrderGroup::AllocateGroupMN(MN_DIR mn_dir) {
    int cur_allocate_res = INVALID_GRP_MN;

    if (mn_dir == POS_MN
        && (this.pos_mn_idx_ >= this.pos_mn_range_.left && this.pos_mn_idx_ <= pos_mn_range_.right - 1)) {
        cur_allocate_res = this.pos_mn_idx_;
        this.pos_mn_idx_++;
        return cur_allocate_res;
    }

    if (mn_dir == NEG_MN
        && (this.neg_mn_idx_ <= this.neg_mn_range_.left && this.neg_mn_idx_ >= this.neg_mn_range_.right + 1)) {
        cur_allocate_res = this.neg_mn_idx_;
        this.neg_mn_idx_--;
        return cur_allocate_res;
    }

    PrintFormat("Update Magic Number failed for group [%s], <%d,%d,%d>,<%d,%d,%d>",
                this.group_name_,
                this.pos_mn_range_.left, this.pos_mn_idx_, this.pos_mn_range_.right,
                this.neg_mn_range_.left, this.neg_mn_idx_, this.neg_mn_range_.right);

    return cur_allocate_res;
    }