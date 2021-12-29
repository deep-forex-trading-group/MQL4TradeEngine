#include "AutoAdjustStrategy.mqh"

int AutoAdjustStrategy::ExecuteStrategy() const {
    return SUCCEEDED;
}
int AutoAdjustStrategy::BeforeTickExecute() {
    this.BeforeTickShowBasicInfo();
    if (!this.params_.IsParamsValid()) {
        return FAILED;
    }
    return SUCCEEDED;
}

// TODO: 迫在眉睫，Decouple BeforeTick和AfterTick
// 凡是平仓都要CheckMN, 凡是加仓都要return
int AutoAdjustStrategy::OnTickExecute() {
// TODO:加动态盈亏比
// TODO:盈利平仓根据初始下单手数计算，也就是说，部分平仓之后盈利目标是否要提高一些，保证总体盈亏比？
// TODO:部分平仓之后手数问题，0.01, 0.01, 0.01, 0.02(to 0.01), 留下了三个0.01
// TODO:所有部分平仓逻辑的Edge Case想一遍
// TODO:反解Resse的倍数怎么算的
// TODO:增加输出函数
// TODO: UI加按钮解耦
// TODO: 利润目标只按照初始仓位来算?
// TODO: EH回测时要遍历所有订单, 回测较慢
// TODO: 一定要有信心，此为刷单之神奇，永恒塔之复刻，可以初始手数大，套多了之后部分平仓把整体手数降下来
// TODO: 增加python代码来计算每个品种的加仓间隔和手数
    int num_orders = this.auto_adjust_order_group_.GetNumOfAutoOrdersInTrades();
    double total_lots_cur = this.auto_adjust_order_group_.GetCurrentTotalLotsInTrades();
//    double lots = GetCurrentAddLotsManual(total_lots_cur);
    double lots = GetCurrentAddLotsManual(num_orders);
    double cur_total_profit = this.auto_adjust_order_group_.GetCurrentProfitInTradesAndHistory();
    double lots_base = this.GetLotsBase(this.params_.start_lots,
                                        this.params_.total_part_close_factor, this.num_part_close_);
    double target_profit_money =
                NormalizeDouble(total_lots_cur * this.params_.target_profit_factor, 2);
    double target_part_close_profit_money =
                NormalizeDouble(total_lots_cur * this.params_.close_part_target_profit_factor, 2);
    this.st_comment_content_.SetTitleToFieldDoubleTerm("基础手数", lots_base);
// Checks auto signal trading
    if (this.params_.is_auto_sig == 1 && this.params_.auto_dir == 0) {
        if (this.auto_adjust_order_group_.GetTotalNumOfOrdersInTrades() == 0) {
            this.auto_adjust_order_group_.CreateSigBuyOrder(this.params_.start_lots);
            return SUCCEEDED;
        }
    }
    if (this.params_.is_auto_sig == 1 && this.params_.auto_dir == 1) {
        if (this.auto_adjust_order_group_.GetTotalNumOfOrdersInTrades() == 0) {
            this.auto_adjust_order_group_.CreateSigSellOrder(this.params_.start_lots);
            return SUCCEEDED;
        }
    }
// Activates button buy or close
    if (this.ui_auto_info_.is_sig_buy_activated) {
         if (this.auto_adjust_order_group_.GetTotalNumOfOrdersInTrades() == 0) {
            this.auto_adjust_order_group_.CreateSigBuyOrder(this.params_.start_lots);
            return SUCCEEDED;
         } else {
            this.auto_adjust_order_group_.CreateManulBuyOrder(this.GetCurrentManulLots());
            return SUCCEEDED;
         }

    }
    if (this.ui_auto_info_.is_sig_sell_activated) {
        if (this.auto_adjust_order_group_.GetTotalNumOfOrdersInTrades() == 0) {
            this.auto_adjust_order_group_.CreateSigSellOrder(this.params_.start_lots);
            return SUCCEEDED;
        } else {
            this.auto_adjust_order_group_.CreateManulSellOrder(this.GetCurrentManulLots());
            return SUCCEEDED;
        }
    }
    if (cur_total_profit <= -this.params_.close_stop_loss_money) {
        if (this.auto_adjust_order_group_.CloseAllOrders(BUY_AND_SELL_SEND)) {
            UIUtils::Laber("止损平仓", clrLime,0);
            if (this.CheckMNUpdate() == FAILED) {
                return FAILED;
            }
            this.ResetIsCurLevelAlreadyPartClose();
            this.ResetNumPartClose();
            return SUCCEEDED;
        }
    }
// Auto Part Close Orders
    if (this.params_.is_auto_part_close == 1) {
        if (this.CheckIfAutoPartClose(total_lots_cur, cur_total_profit, 
                                      this.is_cur_level_already_part_close_)
            && this.auto_adjust_order_group_.ClosePartOrders(this.params_.total_part_close_factor)) {
            UIUtils::Laber("部分平", clrDeepSkyBlue,0);
            if (this.CheckMNUpdate() == FAILED) {
                return FAILED;
            }
            this.SetIsCurLevelAlreadyPartClose();
            this.SetIsInPartCloseState();
            this.IncNumPartClose();
        }
        this.st_comment_content_.SetTitleToFieldDoubleTerm("是否在部分平仓状态",
                                                           this.is_cur_level_already_part_close_ ? 1 : 0);
        if (cur_total_profit >= target_part_close_profit_money + INVALID_SMALL_MONEY
            && this.is_cur_level_already_part_close_) {
            this.auto_adjust_order_group_.CloseAllOrders(BUY_AND_SELL_SEND);
            // Close all orders and the state of the group changes
            // So we just refresh the state, to update the magic number for the group

            if (this.CheckMNUpdate() == FAILED) {
                return FAILED;
            }
            this.ResetIsInPartCloseState();
            this.ResetIsCurLevelAlreadyPartClose();
            this.ResetNumPartClose();
            UIUtils::Laber("亏损盈利平仓",clrMediumOrchid,0);
        }
    }
    if (this.ui_auto_info_.is_part_close_activated) {
        if (this.auto_adjust_order_group_.ClosePartOrders(this.params_.total_part_close_factor)) {
            UIUtils::Laber("部分平", clrDeepSkyBlue,0);
            if (this.CheckMNUpdate() == FAILED) {
                return FAILED;
            }
            this.IncNumPartClose();
        }
    }
    if (this.ui_auto_info_.is_close_open_buy_activated) {
        if (this.auto_adjust_order_group_.CloseAllOrders(BUY_ORDER_SEND)) {
            UIUtils::Laber("手平多",clrDeepPink,0);
            if (this.CheckMNUpdate() == FAILED) {
                return FAILED;
            }
            this.ResetIsInPartCloseState();
            this.ResetIsCurLevelAlreadyPartClose();
            this.ResetNumPartClose();
        }
    }
    if (this.ui_auto_info_.is_close_open_sell_activated) {
        if (this.auto_adjust_order_group_.CloseAllOrders(SELL_ORDER_SEND)) {
            UIUtils::Laber("手平空",clrDeepPink,0);
            if (this.CheckMNUpdate() == FAILED) {
                return FAILED;
            }
            this.ResetIsInPartCloseState();
            this.ResetIsCurLevelAlreadyPartClose();
            this.ResetNumPartClose();
        }
    }
    if (this.ui_auto_info_.is_close_profit_buy_activated) {
        if (this.auto_adjust_order_group_.CloseProfitOrders(BUY_ORDER_SEND, INVALID_SMALL_MONEY)) {
            UIUtils::Laber("平盈多",clrGreen,0);
            if (this.CheckMNUpdate() == FAILED) {
                return FAILED;
            }
        }
    }
    if (this.ui_auto_info_.is_close_profit_sell_activated) {
        if (this.auto_adjust_order_group_.CloseProfitOrders(SELL_ORDER_SEND, INVALID_SMALL_MONEY)) {
            UIUtils::Laber("平盈空",clrGreen,0);
            if (this.CheckMNUpdate() == FAILED) {
                return FAILED;
            }
        }
    }
    this.act_comment_content_.SetTitleToFieldDoubleTerm("当前账户总盈亏", AccountInfoUtils::GetCurrentAccountTotalProfit());
    double profit_history = this.auto_adjust_order_group_.GetCurrentProfitInHistory();
    this.st_comment_content_.SetTitleToFieldDoubleTerm("历史获利", profit_history);

    OrderInMarket res[1];
    bool is_sig_exist = OrderGetUtils::GetOrderInTrade(this.auto_adjust_order_group_.GetGroupSigMagicNumber(), res);
    int send_order_dir = INTEGER_MIN_INT;
    if (is_sig_exist) {
        send_order_dir = res[0].order_type == OP_BUY ? BUY_ORDER_SEND  : (
                         res[0].order_type == OP_SELL ? SELL_ORDER_SEND  : send_order_dir);
    }
//    double pip_step_add = NormalizeDouble(
//                                this.params_.pip_step * MathPow(this.params_.pip_step_exponent, num_orders),0);
    double pip_step_add = NormalizeDouble(this.params_.pip_step * this.params_.pip_factor, 0);
    if (pip_step_add > this.params_.pip_step_max) { pip_step_add = this.params_.pip_step_max; }
    double cur_float_profit = this.auto_adjust_order_group_.GetCurrentProfitInTrades();

//    double target_profit_money =
//                    NormalizeDouble(this.params_.start_lots * num_orders * this.params_.target_profit_factor  * this.params_.lots_exponent, 2);

    this.st_comment_content_.SetTitleToFieldDoubleTerm("总头寸", total_lots_cur);
    this.st_comment_content_.SetTitleToFieldDoubleTerm("目标利润(因子)", this.params_.target_profit_factor);
// TODO: 紧紧结合Frero，不要轻言放弃,核心是每一波利润拿到最大浮亏的一定比例再走，马丁倍数放小一点，时间换空间

    this.st_comment_content_.SetTitleToFieldDoubleTerm("当前组(总)利润", cur_total_profit);
    this.st_comment_content_.SetTitleToFieldDoubleTerm("当前浮动盈亏", cur_float_profit);
    this.st_comment_content_.SetTitleToFieldDoubleTerm("目标利润(钱)", target_profit_money);
    if (target_profit_money + INVALID_SMALL_MONEY <= cur_total_profit) {
        this.auto_adjust_order_group_.CloseAllOrders(BUY_AND_SELL_SEND);
        // Close all orders and the state of the group changes
        // So we just refresh the state, to update the magic number for the group
        if (this.CheckMNUpdate() == FAILED) {
            return FAILED;
        }
        this.ResetIsInPartCloseState();
        this.ResetIsCurLevelAlreadyPartClose();
        this.ResetNumPartClose();
        UIUtils::Laber("盈利平仓",Red,0);
    }

    this.st_comment_content_.SetTitleToFieldDoubleTerm("加仓点数", pip_step_add);
    if (this.auto_adjust_order_group_.AddOneOrderByStepPipReverse(send_order_dir, pip_step_add, lots)) {
        ResetIsCurLevelAlreadyPartClose();
    }
    return SUCCEEDED;
}
int AutoAdjustStrategy::AfterTickExecute() {
    this.auto_adjust_order_group_.AfterTickExecute();
    return SUCCEEDED;
}
void AutoAdjustStrategy::BeforeTickShowBasicInfo() {
    // Base Information to show.
//    this.st_comment_content_.SetTitleToFieldDoubleTerm(
//                                "cur_group_auto_mn", this.auto_adjust_order_group_.GetGroupAutoMagicNumber());
//    this.st_comment_content_.SetTitleToFieldDoubleTerm(
//                                "cur_group_sig_mn", this.auto_adjust_order_group_.GetGroupSigMagicNumber());
//    this.st_comment_content_.SetTitleToFieldDoubleTerm(
//                                "cur_group_manul_mn", this.auto_adjust_order_group_.GetGroupManualMagicNumber());
//    this.st_comment_content_.SetTitleToFieldDoubleTerm(
//                                "cur_group_id", this.auto_adjust_order_group_.GetGroupId());
    this.st_comment_content_.SetTitleToFieldDoubleTerm(
                                "最大浮亏", this.auto_adjust_order_group_.GetMaxFloatingLoss());
    this.st_comment_content_.SetTitleToFieldDoubleTerm(
                                "最大浮盈", this.auto_adjust_order_group_.GetMaxFloatingProfit());
    this.st_comment_content_.SetTitleToFieldDoubleTerm(
                                "当前订单利润", this.auto_adjust_order_group_.GetCurrentProfitOrdersInTradesProfit());
}
int AutoAdjustStrategy::OnActionExecute() {
    PrintFormat("AutoAdjustStrategy {%s} executed OnActionExecute", this.strategy_name_);
    if (!this.CheckConfigFileValid()) {
        return FAILED;
    }
    string start_lots = this.config_file_.GetConfigFieldByTitleAndFieldName(
                                                        "Adjust", "start_lots");
    double start_lots_double = StringToDouble(start_lots);
//    this.auto_adjust_order_group_.CreateSigBuyOrder(start_lots_double);
    this.auto_adjust_order_group_.CreateSigSellOrder(start_lots_double);
    return SUCCEEDED;
}
int AutoAdjustStrategy::SetAutoAdjustOrderGroup(AutoAdjustOrderGroup* auto_adjust_order_group) {
    if (IsPtrInvalid(auto_adjust_order_group)) {
        PrintFormat("The auto_adjust_order_group pointer passed in the AutoAdjustStrategy {%s} is invalid",
                     this.strategy_name_);
        return FAILED;
    }
    PrintFormat("Sets the AutoAdjustStrategy {%s} with auto_adjust_order_group {%s}",
                this.strategy_name_, auto_adjust_order_group.GetGroupName());
    this.auto_adjust_order_group_ = auto_adjust_order_group;
    return SUCCEEDED;
}
void AutoAdjustStrategy::PrintStrategyInfo() const {
    PrintFormat("Current Strategy is a AutoAdjustStrategy, the name is %s, ",
                this.strategy_name_);
    if (this.CheckConfigFileValid()) {
        this.config_file_.PrintAllConfigItems();;
    }
}
bool AutoAdjustStrategy::CheckIfAutoPartClose(double cur_total_lots, double cur_total_profit,
                                              bool is_cur_level_already_part_close) {
    if (is_cur_level_already_part_close) {
        return false;
    }
//    double lots_base = this.GetLotsBase(this.params_.start_lots, this.params_.total_part_close_factor, this.num_part_close_);
    double lots_base = this.params_.start_lots;
    if (cur_total_lots < lots_base * this.params_.close_part_lots_factor_threshold) {
        return false;
    }
    // TODO: 参数10提出来，检查所有的类似这种绝对值参数，都提出来
    // TODO: 马上解决回测太慢的问题，用hashset模拟订单管理
    double target_stop_loss_money = -this.params_.close_part_pips_threshold * cur_total_lots * 10;
    return cur_total_profit >= target_stop_loss_money + INVALID_SMALL_MONEY;
}
double AutoAdjustStrategy::GetCurrentAddLotsByFactor(double cur_total_lots) {
    double add_lots = cur_total_lots * this.params_.add_lots_factor;
    add_lots = MathMin(this.params_.lots_max, add_lots);
    return add_lots;
}
double AutoAdjustStrategy::GetCurrentAddLotsManual(int num_orders) {
    double lots_base = this.GetLotsBase(this.params_.start_lots, this.params_.total_part_close_factor, this.num_part_close_);
    int ml_size = ArraySize(this.params_.manul_lots_step_factor_arr);
    double lots_factor = num_orders >= ml_size ? this.params_.manul_lots_step_factor_arr[ml_size - 1]
                                                : this.params_.manul_lots_step_factor_arr[num_orders];
    double lots = NormalizeDouble(lots_base * lots_factor, 2);

    lots = MathMin(this.params_.lots_max, lots);
    return lots;
}
double AutoAdjustStrategy::GetCurrentAddLots(int num_orders) {
    double lots_base = this.GetLotsBase(this.params_.start_lots, this.params_.total_part_close_factor, this.num_part_close_);
    double lots = NormalizeDouble(lots_base * MathPow(this.params_.lots_exponent, num_orders / 2), 2);

//    double lots = NormalizeDouble(this.params_.start_lots * MathPow(this.params_.lots_exponent, num_orders / 3), 2);
    lots = MathMin(this.params_.lots_max, lots);
    return lots;
}
double AutoAdjustStrategy::GetCurrentManulLots() {
    double lots_base = MarketInfoUtils::NormalizeLotsUp(
                                        this.params_.start_lots / MathPow(2, this.num_part_close_));
    PrintFormat("%.4f", this.num_part_close_);
    PrintFormat("%.4f", this.params_.start_lots);

    return lots_base;
}