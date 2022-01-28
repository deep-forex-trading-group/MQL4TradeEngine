#include "HedgeAutoStrategy.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

int HedgeAutoStrategy::BeforeTickExecute() {
    if (!this.params_.IsParamsValid()) {
        return FAILED;
    }
    return SUCCEEDED;
}
int HedgeAutoStrategy::OnTickExecute() {
//    double val = iCustom(NULL,0,"Indicators/ShockDKAdv/OscilliateMA",10,15,9,0);
    iCustom(NULL,0,"Indicators/ShockDKAdv/ChandelierTP",2,5,10,0);
    if (this.params_.buy_or_sell == 0 || this.params_.buy_or_sell == 1) ExecuteBuyOnTick();
    if (this.params_.buy_or_sell == 0 || this.params_.buy_or_sell == -1) ExecuteSellOnTick();
    return SUCCEEDED;
}
int HedgeAutoStrategy::AfterTickExecute() {
    return SUCCEEDED;
}
bool HedgeAutoStrategy::ExecuteBuyOnTick() {
    int num_buy = OrderGetUtils::GetNumOfBuyOrders(this.magic_buy_num_);
     // 起始单
    if (num_buy == 0) {
        OrderSendUtils::CreateBuyOrder(this.magic_buy_num_, this.params_.start_lots);
    }
    // 加仓逻辑
    double buy_order_lots = this.GetAddLots(this.params_.start_lots,
                                            this.params_.lots_exponent,
                                            num_buy, this.params_.lots_max);
    OrderSendUtils::AddOneOrderByStepPipReverse(this.magic_buy_num_, this.magic_buy_num_,
                                                BUY_ORDER_SEND, this.params_.pip_step,
                                                buy_order_lots, "");
    HashSet<int>* buy_orders_set = new HashSet<int>();
    buy_orders_set.add(this.magic_buy_num_);
    buy_orders_set.add(this.magic_big_sell_num_);
    double buy_floating_profit = AccountInfoUtils::GetCurrentBuyFloatingProfit(this.magic_buy_num_);
//                                 + AccountInfoUtils::GetCurrentSellFloatingProfit(this.magic_big_sell_num_);
    double buy_total_lots = AccountInfoUtils::GetCurrentTotalLots(this.magic_buy_num_, IN_TRADES);
    // 大手反向保护逻辑
    int big_sell_order_num = OrderGetUtils::GetNumOfSellOrders(this.magic_big_sell_num_);

    if (num_buy >= this.params_.big_lots_order_num
        && big_sell_order_num == 0
        && !this.is_big_sell_act) {
        double AddingLots = NormalizeDouble(buy_total_lots / this.params_.big_lots_on_factor, 2);
        OrderSendUtils::CreateSellOrder(this.magic_big_sell_num_,
                                        AddingLots);
        this.is_big_sell_act = true;
        UIUtils::Laber(StringFormat("SELL_B:%.4f", AddingLots), clrBlue, 0);
    }

    // 大手反向保护止盈
//    int BarsCount = 5;
//    double TRS = 5;
//
//    double liQKA = MathMax(1 - BarsCount*0.1, 0.3);
//    double KliqPoint = High[iHighest(NULL,0,MODE_HIGH,BarsCount,1)] + Open[0]*TRS/10000*liQKA;
//    PrintFormat("KliqPoint: %.4f", KliqPoint);
//    if (AccountInfoUtils::GetCurrentSellFloatingProfit(this.magic_big_sell_num_) > 0
//        && NormalizeDouble(Bid, MarketInfoUtils::GetDigits()) >= KliqPoint) {
//        OrderCloseUtils::CloseAllOrders(this.magic_big_sell_num_);
//        UIUtils::Laber("SELL_TP", clrYellow, 0);
//    }
    // 止盈逻辑
    double target_money_buy = this.GetTargetMoneyByTotalLots(buy_total_lots, this.params_.target_factor);
//    if (num_buy <= this.params_.first_batch_order_num) {
//        target_money_buy = this.GetTargetMoneyByTotalLots(buy_total_lots, this.params_.first_batch_target_factor);
//    }

    if (buy_floating_profit >= target_money_buy) {
        OrderCloseUtils::CloseAllOrders(buy_orders_set);
        this.is_big_sell_act = false;
        if (big_sell_order_num > 0) {
            UIUtils::Laber("SELL_T", clrLawnGreen, 0);
        }
    }
    if (buy_floating_profit <= -200) {
        OrderCloseUtils::CloseAllOrders(buy_orders_set);
        this.is_big_sell_act = false;
        UIUtils::Laber("砍仓", clrYellow, 0);
    }
    SafeDeleteCollectionPtr(buy_orders_set);
    return true;
}
bool HedgeAutoStrategy::ExecuteSellOnTick() {
    int num_sell = OrderGetUtils::GetNumOfSellOrders(this.magic_sell_num_);
    // 起始单
    if (num_sell == 0) {
        OrderSendUtils::CreateSellOrder(this.magic_sell_num_, this.params_.start_lots);
    }
    // 加仓逻辑
    double sell_order_lots = this.GetAddLots(this.params_.start_lots,
                                             this.params_.lots_exponent,
                                             num_sell, this.params_.lots_max);
    OrderSendUtils::AddOneOrderByStepPipReverse(this.magic_sell_num_, this.magic_sell_num_,
                                                SELL_ORDER_SEND, this.params_.pip_step,
                                                sell_order_lots, "");

    HashSet<int>* sell_orders_set = new HashSet<int>();
    sell_orders_set.add(this.magic_sell_num_);
    sell_orders_set.add(this.magic_big_buy_num_);
    double sell_floating_profit = AccountInfoUtils::GetCurrentSellFloatingProfit(this.magic_sell_num_);
//                                  + AccountInfoUtils::GetCurrentBuyFloatingProfit(this.magic_big_buy_num_);
    double sell_total_lots = AccountInfoUtils::GetCurrentTotalLots(this.magic_sell_num_, IN_TRADES);
    // 大手反向保护逻辑
    int big_buy_order_num = OrderGetUtils::GetNumOfBuyOrders(this.magic_big_buy_num_);

    if (num_sell >= this.params_.big_lots_order_num
        && big_buy_order_num == 0
        && !this.is_big_buy_act) {
        double AddingLots = NormalizeDouble(sell_total_lots / this.params_.big_lots_on_factor, 2);
        OrderSendUtils::CreateBuyOrder(this.magic_big_buy_num_,
                                       AddingLots);
        this.is_big_buy_act = true;
        UIUtils::Laber(StringFormat("BUY_B:%.4f", AddingLots), clrRed, 0);
    }
    // 大手反向保护止盈
//    int BarsCount = 3;
//    double TRS = 5;
//
//    double liQKA = MathMax(1 - BarsCount*0.1, 0.3);
//    double DliqPoint = Low[iLowest(NULL,0,MODE_LOW,BarsCount,1)] - Open[0]*TRS/10000*liQKA;
//    PrintFormat("DliqPoint: %.4f", DliqPoint);
//    if (AccountInfoUtils::GetCurrentBuyFloatingProfit(this.magic_big_buy_num_) > 0
//        && NormalizeDouble(Ask, MarketInfoUtils::GetDigits()) <= DliqPoint) {
//        UIUtils::Laber("BUY_TP", clrYellow, 0);
//        OrderCloseUtils::CloseAllOrders(this.magic_big_buy_num_);
//    }

    // 止盈逻辑
    double target_money_sell = this.GetTargetMoneyByTotalLots(sell_total_lots, this.params_.target_factor);
//    if (num_sell <= this.params_.first_batch_order_num) {
//        target_money_sell = this.GetTargetMoneyByTotalLots(sell_total_lots, this.params_.first_batch_target_factor);
//    }

    if (sell_floating_profit >= target_money_sell) {
        OrderCloseUtils::CloseAllOrders(sell_orders_set);
        this.is_big_buy_act = false;
        if (big_buy_order_num > 0) {
            UIUtils::Laber("BUY_T", clrLawnGreen, 0);
        }
    }
    if (sell_floating_profit <= -200) {
        OrderCloseUtils::CloseAllOrders(sell_orders_set);
        this.is_big_buy_act = false;
        UIUtils::Laber("砍仓", clrYellow, 0);
    }
    SafeDeleteCollectionPtr(sell_orders_set);
    return true;
}
double HedgeAutoStrategy::GetAddLots(double base_lots, double lots_exponent, int num_orders, double lots_max) {
    double lots_calc = NormalizeDouble(base_lots * MathPow(lots_exponent,num_orders), MarketInfoUtils::GetDigits());
    return MathMin(lots_calc, lots_max);
}
double HedgeAutoStrategy::GetTargetMoney(double base_lots, double target_money_factor,
                                         int num_orders, double lots_exponent) {
    return  NormalizeDouble(base_lots * target_money_factor * num_orders * lots_exponent,
                            MarketInfoUtils::GetDigits());
}
double HedgeAutoStrategy::GetTargetMoneyByTotalLots(double total_lots, double target_money_factor) {
    return  NormalizeDouble(total_lots*target_money_factor*10, MarketInfoUtils::GetDigits());
}