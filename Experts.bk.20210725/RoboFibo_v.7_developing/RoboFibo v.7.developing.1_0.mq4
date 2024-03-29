#property  copyright "EU_KILLER_基础模板"
#property  link      "https://www.eahub.cn/thread-737-1-1.html"
#property description "来EAHub下载更多EA。"

#include <ThirdPartyLib/UsedUtils/OrderManageUtils.mqh>
#include <ThirdPartyLib/UsedUtils/HedgeUtilsDual.mqh>
#include <ThirdPartyLib/UsedUtils/AccountInfoUtils.mqh>
#include <ThirdPartyLib/UsedUtils/UIUtils.mqh>

enum ENUM_Trading_Mode  {
   PendingLimitOrderFollowTrend = 0,
   PendingLimitOrderReversalTrend = 1,
   PendingStopOrderFollowTrend = 2,
   PendingStopOrderReversalTrend = 3
};

enum ENUM_Candlestick_Mode {
   ToAvoidNews = 0,
   ToTriggerOrder = 1
};


//------------------
OrderManageUtils ou();
AccountInfoUtils ai_utils();
UIUtils ui_utils();

ENUM_BASE_CORNER 按钮定位=CORNER_RIGHT_LOWER;

extern bool ShowComment=true;
extern  ENUM_Trading_Mode TradingMode = PendingStopOrderReversalTrend;
extern bool UseMM=false ;   
extern double Risk=0.1  ;   
extern double FixedLots=0.01  ;   
extern double LotsExponent=1.1  ;   
extern bool UseTakeProfit=false ;   
extern int   TakeProfit=200  ;   
extern bool UseStopLoss=false ;   
extern int   StopLoss=200  ;   
extern bool AutoTargetMoney=true  ;   
extern double TargetMoneyFactor=20  ;   
extern double TargetMoney=0  ;   
extern bool AutoStopLossMoney=false ;   
extern double StoplossFactor=0  ;   
extern double StoplossMoney=0  ;   
extern bool UseTrailing=false ;   
extern int   TrailingStop=20  ;   
extern int   TrailingStart=0  ;   
extern ENUM_Candlestick_Mode CandlestickMode = ToAvoidNews;
extern int   CandlestickHighLow=500  ;   
extern int   MaxOrderBuy=50  ;   
extern int   MaxOrderSell=50  ;   
extern int   PendingDistance=20  ;   
extern int   Pipstep=20  ;
extern double PipstepExponent=1  ;   
extern double MaxSpreadPlusCommission=50  ;   
extern bool HighToLow=true  ;   
extern double HighFibo=76.4  ;   
extern double LowFibo=23.6  ;   
extern int   StartBar=1  ;   
extern int   BarsBack=20  ;
extern bool ShowFibo=true  ;   
extern int   Slippage=3  ;   
extern int   MagicNumber=1  ;   
extern string TradeComment="[EAHub]RoboFibo v.7";
extern bool TradeMonday=true  ;   
extern bool TradeTuesday=true  ;   
extern bool TradeWednesday=true  ;   
extern bool TradeThursday=true  ;   
extern bool TradeFriday=true  ;   
extern int   StartHour=0  ;   
extern int   StartMinute=0  ;   
extern int   EndHour=23  ;   
extern int   EndMinute=59  ;   
double    MAX_LOTS_CONSTANT = 10000.0;

double    fibo_level_0 = 0.0;
double    fibo_level_1 = 0.236;
double    fibo_level_2 = 0.382;
double    fibo_level_3 = 0.5;
double    fibo_level_4 = 0.618;
double    fibo_level_5 = 0.764;
double    fibo_level_7 = 1.0;

uint      line_color = Blue;
uint      fibo_level_line_color = DarkGray;
double    总_do11ko[];
double    总_do12ko[];
double    总_do13ko[];
double    总_do14ko[];
double    总_do15ko[];
double    总_do16ko[];
double    总_do17ko[];
double    总_do18ko[];
double    total_buy_profit = 0.0;
double    total_sell_profit = 0.0;
bool      is_close_all_buy_orders = false;
bool      is_close_all_sell_orders = false;
int       总_in_23 = 0;
int       总_in_24 = 0;
int       cur_max_sell_ordernum = 0;
int       cur_max_buy_ordernum = 0;
int       总_in_27 = 0;
int       总_in_28 = 0;
double    HistoryAskMinusBid[30];
int       cur_symbol_digits = 0;
double    cur_symbol_points = 0.0;
int       nomalize_step_for_change_lots = 0;
double    minimum_permitted_lots = 0.0;
double    max_permitted_lots = 0.0;
double    risk_factor = 0.0;
double    max_spread_plus_commission = 0.0;
double    pending_distance = 0.0;
double    总_do_38 = 0.0;
double    总_do_39 = 0.0;
double    总_do_40 = 0.0;
double    总_do_41 = 0.0;
double    总_do_42 = 0.0;
double    input_candlestick_high_low = 0.0;
bool      总_bo_44 = false;
double    commission_rate = 0.0;
int       spread_track_total = 0;
double    init_commission_rate = 0.0;
bool      总_bo_48 = true;
double    cur_using_time_frame = PERIOD_H4;
int       总_in_51 = 0;
double    price_difference = 0.0;
double    总_do_53 = 0.0;
double    总_do_54 = 0.0;
double    总_do_55 = 0.0;
double    target_buy_money = 0.0;
double    target_sell_money = 0.0;
double    stop_loss_money_buy = 0.0;
double    stop_loss_money_sell = 0.0;
bool      is_testing_ok = false;

#import   "stdlib.ex4"
string ErrorDescription( int err_code);
#import     

int init() {
    int       cur_time_frame;
    double    step_for_change_lots;
    //----- -----

    ArrayInitialize(HistoryAskMinusBid,0.0);
    cur_symbol_digits = MarketInfo(NULL,MODE_DIGITS) ;
    cur_symbol_points = MarketInfo(NULL,MODE_POINT) ;
    Print("Digits: " + string(cur_symbol_digits) + " Point: " + DoubleToString(cur_symbol_points,cur_symbol_digits));
    step_for_change_lots = MarketInfo(Symbol(),MODE_LOTSTEP) ;
    nomalize_step_for_change_lots = MathLog(step_for_change_lots) / (-2.302585092994) ;
    minimum_permitted_lots = MathMax(FixedLots,MarketInfo(Symbol(),MODE_MINLOT)) ;
    max_permitted_lots = MathMin(MAX_LOTS_CONSTANT,MarketInfo(Symbol(),MODE_MAXLOT)) ;
    risk_factor = Risk / 100.0 ;
    max_spread_plus_commission = NormalizeDouble(MaxSpreadPlusCommission * cur_symbol_points,cur_symbol_digits + 1) ;
    pending_distance = NormalizeDouble(PendingDistance * cur_symbol_points,cur_symbol_digits) ;
    input_candlestick_high_low = NormalizeDouble(cur_symbol_points * CandlestickHighLow,cur_symbol_digits) ;
    总_bo_44 = false ;
    commission_rate = NormalizeDouble(init_commission_rate * cur_symbol_points,cur_symbol_digits + 1) ;

    if ( !(IsTesting()) ) {
        cur_time_frame = Period() ;
        switch(Period()) {
            case PERIOD_M1 :
             cur_using_time_frame = 5.0 ;
                break;
            case PERIOD_M5 :
             cur_using_time_frame = 15.0 ;
                break;
            case PERIOD_M15 :
             cur_using_time_frame = 30.0 ;
                break;
            case PERIOD_M30 :
             cur_using_time_frame = 60.0 ;
                break;
            case PERIOD_H1 :
             cur_using_time_frame = 240.0 ;
                break;
            case PERIOD_H4 :
             cur_using_time_frame = 1440.0 ;
                break;
            case PERIOD_D1:
             cur_using_time_frame = 10080.0 ;
                break;
            case PERIOD_W1 :
             cur_using_time_frame = 43200.0 ;
                break;
            case PERIOD_MN1 :
             cur_using_time_frame = 43200.0 ;
        }
    }

    DeleteAllObjects ( );
    SetIndexBuffer(0,总_do11ko);
    SetIndexBuffer(1,总_do12ko);
    SetIndexBuffer(2,总_do13ko);
    SetIndexBuffer(3,总_do14ko);
    SetIndexBuffer(4,总_do15ko);
    SetIndexBuffer(5,总_do16ko);
    SetIndexBuffer(6,总_do17ko);
    SetIndexBuffer(7,总_do18ko);
    SetIndexLabel(0,"Fibo_" + DoubleToString(fibo_level_0,4));
    SetIndexLabel(1,"Fibo_" + DoubleToString(fibo_level_1,4));
    SetIndexLabel(2,"Fibo_" + DoubleToString(fibo_level_2,4));
    SetIndexLabel(3,"Fibo_" + DoubleToString(fibo_level_3,4));
    SetIndexLabel(4,"Fibo_" + DoubleToString(fibo_level_4,4));
    SetIndexLabel(5,"Fibo_" + DoubleToString(fibo_level_5,4));
    SetIndexLabel(7,"Fibo_" + DoubleToString(fibo_level_7,4));

    InitGraphItems();
    return(0);
}
//init <<==
//---------- ----------  ---------- ----------

// 获取按钮对象函数, 初始化并获取对应的按钮对象
void InitGraphItems() {
    int 按钮X=120;
    int 按钮Y=25;
    int 按钮间隔X=50;
    int 按钮间隔Y=25;

    // Y从下往上，x从右往左
    ui_utils.button("平多按钮","平多","平多",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*4,
                    45,20,按钮定位,clrFireBrick,clrBlack);
    ui_utils.button("平空按钮","平空","平空",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*3,
                    45,20,按钮定位,clrMediumVioletRed,clrBlack);
    ui_utils.button("平盈利多按钮","平盈利多","平盈利多",按钮X+按钮间隔X*0,按钮Y+按钮间隔Y*4,
                    60,20,按钮定位,clrMediumSeaGreen,clrBlack);
    ui_utils.button("平盈利空按钮","平盈利空","平盈利空",按钮X+按钮间隔X*0,按钮Y+按钮间隔Y*3,
                    60,20,按钮定位,clrChocolate,clrBlack);
    ui_utils.button("全平按钮","全平","全平",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*2,
                    45,20,按钮定位,clrDarkViolet,clrBlack);
    ui_utils.button("EA开关按钮","开启EA","关闭EA",按钮X+按钮间隔X*0,按钮Y+按钮间隔Y*2,
                    60,20,按钮定位,clrBlue,clrRed);
    ui_utils.button("测试按钮","测试","测试",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*0,
                    60,20,按钮定位,clrDarkViolet,clrBlack);
}

void RefreshButtonsStates() {
    ui_utils.CheckButtonState("平多按钮","平多","平多",clrFireBrick,clrBlack);
    ui_utils.CheckButtonState("平空按钮","平空","平空",clrMediumVioletRed,clrBlack);
    ui_utils.CheckButtonState("平盈利多按钮","平盈利多","平盈利多",clrMediumSeaGreen,clrBlack);
    ui_utils.CheckButtonState("平盈利空按钮","平盈利空","平盈利空",clrChocolate,clrBlack);
    ui_utils.CheckButtonState("全平按钮","全平","全平",clrDarkViolet,clrBlack);
    ui_utils.CheckButtonState("EA开关按钮","开启EA","关闭EA",clrBlue,clrRed);
    ui_utils.CheckButtonState("测试按钮","关闭测试","开启测试",clrDarkViolet,clrBlack);

    if(ObjectGetInteger(0,"平多按钮",OBJPROP_STATE)==1) {
        ou.CloseAllBuyOrders(MagicNumber);
        ObjectSetInteger(0,"平多按钮",OBJPROP_STATE,0);
    }

    if(ObjectGetInteger(0,"平空按钮",OBJPROP_STATE)==1) {
        ou.CloseAllSellOrders(MagicNumber);
        ObjectSetInteger(0,"平空按钮",OBJPROP_STATE,0);
    }

    if(ObjectGetInteger(0,"平盈利多按钮",OBJPROP_STATE)==1) {
        ou.CloseAllBuyProfitOrders(MagicNumber, 0.1);
        ObjectSetInteger(0,"平盈利多按钮",OBJPROP_STATE,0);
    }

    if(ObjectGetInteger(0,"平盈利空按钮",OBJPROP_STATE)==1) {
        ou.CloseAllSellProfitOrders(MagicNumber, 0.1);
        ObjectSetInteger(0,"平盈利空按钮",OBJPROP_STATE,0);
    }

    if(ObjectGetInteger(0,"全平按钮",OBJPROP_STATE)==1) {
        ou.CloseAllOrders(MagicNumber);
        ObjectSetInteger(0,"全平按钮",OBJPROP_STATE,0);
    }

    if (ObjectGetInteger(0,"测试按钮",OBJPROP_STATE)==1) {
       is_testing_ok = true;
    } else {
       is_testing_ok = false;
    }
}

int start() {
    bool      is_demo;
    string    子_st_2;
    datetime  子_da_3;
    double    pip_step_sell;
    double    pip_step_buy;
    double    last_sell_price;
    double    last_buy_price;
    int       last_err;
    string    last_err_discript;
    int       success_sent_order_ticket;
    double    open_price_and_pending_dis;
    double    profit_over_pricedifference;
    // is_candlestick_ok (-1 or 0 : not take first order, 1 : take first order)
    int       is_candlestick_ok;
    int       cur_order_type;
    bool      is_order_modifiy_success;
    double    order_open_price;
    double    risk_amount_lots;
    double    buy_order_lots;
    double    sell_order_lots;
    double    stop_loss_price_calc;
    double    take_profit_price_calc;
    double    take_profit_price;
    double    stop_loss_price;
    double    cur_high_price;
    double    cur_low_price;
    double    prev_high_price;
    double    prev_low_price;
    int       子_in_28;
    int       子_in_29;
    double    lowest_price;
    double    highest_price;
    int       lowest_price_index;
    int       highest_price_index;
    double    子_do_34;
    double    子_do_35;
    double    fibo_lower_bound;
    double    f_level_0;
    double    f_level_1;
    double    f_level_2;
    double    f_level_3;
    double    f_level_4;
    double    fibo_upper_bound;
    int       order_pos;
    double    ask_minus_bid;
    double    cur_spread;
    int       spread_track_idx;
    double    average_spread;
    double    ask_plush_comm_rate;
    double    bid_minus_comm_rate;
    double    average_spread_add_commission_rate;
    double    cur_high_minus_low;
    double    prev_high_minus_low;
    int       num_cur_guadan;
    string    err_commission_prompt;
    int       spread_tc;
    //----- -----

    is_demo = IsDemo() ;
    if ( !(is_demo) )
    {
    //Alert("You can not use the program with a real account!");
    //return(0);
    }
    RefreshButtonsStates();
    if(ObjectGetInteger(0,"EA开关按钮",OBJPROP_STATE)==1) {
       return(0);
    }
    子_st_2 = "2016.8.25" ;
    子_da_3 = StringToTime(子_st_2) ;
    if ( TimeCurrent() >= 子_da_3 ) {
    //Alert("The trial version has been expired!");
    //return(0);
    }
    if ( ShowFibo == 1 ) {
    CalcFibo();
    }
    pip_step_sell = NormalizeDouble(Pipstep * MathPow(PipstepExponent,CountTradesSell()),0) ;
    pip_step_buy = NormalizeDouble(Pipstep * MathPow(PipstepExponent,CountTradesBuy()),0) ;
//    last_sell_price = FindLastSellPrice_Hilo();
//    last_buy_price = FindLastBuyPrice_Hilo() ;

    OrderInMarket lowest_buy_price_order[1];
    ou.GetLowestBuyOpenPriceOrder(lowest_buy_price_order, MagicNumber);
    last_buy_price = lowest_buy_price_order[0].order_open_price;

    OrderInMarket highest_sell_price_order[1];
    ou.GetHighestSellOpenPriceOrder(highest_sell_price_order, MagicNumber);
    last_sell_price = highest_sell_price_order[0].order_open_price;

    last_err = 0 ;
    success_sent_order_ticket = 0 ;
    open_price_and_pending_dis = 0.0 ;
    profit_over_pricedifference = 0.0 ;
    is_candlestick_ok = 0 ;
    cur_order_type = 0 ;
    is_order_modifiy_success = false ;
    order_open_price = 0.0 ;
    risk_amount_lots = 0.0 ;
    buy_order_lots = 0.0 ;
    sell_order_lots = 0.0 ;
    stop_loss_price_calc = 0.0 ;
    take_profit_price_calc = 0.0 ;
    take_profit_price = 0.0 ;
    take_profit_price = 0.0 ;
    // current bar highest and lowest price
    cur_high_price = iHigh(NULL,PERIOD_CURRENT,0) ;
    cur_low_price = iLow(NULL,PERIOD_CURRENT,0) ;
    // previous bar highest and lowest price
    prev_high_price = iHigh(NULL,PERIOD_CURRENT,1) ;
    prev_low_price = iLow(NULL,PERIOD_CURRENT,1) ;
    子_in_28 = 0 ;
    子_in_29 = 0 ;
    lowest_price = 0.0 ;
    highest_price = 0.0 ;
    lowest_price_index = iLowest(NULL,0,MODE_LOW,BarsBack,StartBar) ;
    highest_price_index = iHighest(NULL,0,MODE_HIGH,BarsBack,StartBar) ;
    子_do_34 = 0.0 ;
    子_do_35 = 0.0 ;
    highest_price = High[highest_price_index] ;
    lowest_price = Low[lowest_price_index] ;
    price_difference = highest_price - lowest_price ;
    fibo_lower_bound = LowFibo / 100.0 * price_difference + lowest_price ;
    f_level_0 = price_difference * 0.236 + lowest_price ;
    f_level_1 = price_difference * 0.382 + lowest_price ;
    f_level_2 = price_difference * 0.5 + lowest_price ;
    f_level_3 = price_difference * 0.618 + lowest_price ;
    f_level_4 = price_difference * 0.764 + lowest_price ;
    fibo_upper_bound = HighFibo / 100.0 * price_difference + lowest_price ;
    if (!(总_bo_44)) {
    for (order_pos = OrdersHistoryTotal() - 1 ; order_pos >= 0 ; order_pos = order_pos - 1) {
    if ( !(OrderSelect(order_pos,SELECT_BY_POS,MODE_HISTORY)) || !(OrderProfit()!=0.0)
        || !(OrderClosePrice()!=OrderOpenPrice())
        || OrderSymbol() != Symbol() )   continue;
       总_bo_44 = true ;
       profit_over_pricedifference=MathAbs(OrderProfit() / (OrderClosePrice() - OrderOpenPrice()));
       commission_rate = ( -(OrderCommission())) / profit_over_pricedifference ;
       break;
    }
    }
    risk_amount_lots = NormalizeDouble(
                        AccountBalance() * AccountLeverage() * risk_factor / MarketInfo(Symbol(),MODE_LOTSIZE),
                        nomalize_step_for_change_lots) ;
    if (!(UseMM)) {
        risk_amount_lots = FixedLots ;
    }
    target_sell_money = risk_amount_lots * TargetMoneyFactor * CountTradesSell() * LotsExponent ;

    if (!(AutoTargetMoney)) {
        target_sell_money = TargetMoney ;
    }

    target_buy_money = risk_amount_lots * TargetMoneyFactor * CountTradesBuy ( ) * LotsExponent ;
    if ( !(AutoTargetMoney) ) {
        target_buy_money = TargetMoney ;
    }

    stop_loss_money_sell = risk_amount_lots * StoplossFactor * CountTradesSell ( ) * LotsExponent ;
    if ( !(AutoStopLossMoney) ) {
        stop_loss_money_sell = StoplossMoney ;
    }

    stop_loss_money_buy = risk_amount_lots * StoplossFactor * CountTradesBuy ( ) * LotsExponent ;
    if ( !(AutoStopLossMoney) ) {
        stop_loss_money_buy = StoplossMoney ;
    }

    ask_minus_bid = Ask - Bid ;
    ArrayCopy(HistoryAskMinusBid,HistoryAskMinusBid,0,1,29);
    HistoryAskMinusBid[29] = ask_minus_bid;
    if ( spread_track_total < 30 ) {
        spread_track_total = spread_track_total + 1;
    }
    cur_spread = 0.0 ;
    spread_tc = 29 ;
    for (spread_track_idx = 0 ; spread_track_idx < spread_track_total ; spread_track_idx = spread_track_idx + 1) {
        cur_spread = cur_spread + HistoryAskMinusBid[spread_tc] ;
        spread_tc = spread_tc - 1;
    }
    average_spread = cur_spread / spread_track_total ;
    ask_plush_comm_rate = NormalizeDouble(Ask + commission_rate,cur_symbol_digits) ;
    bid_minus_comm_rate = NormalizeDouble(Bid - commission_rate,cur_symbol_digits) ;
    average_spread_add_commission_rate = NormalizeDouble(
                                            average_spread + commission_rate,cur_symbol_digits + 1) ;
    cur_high_minus_low = cur_high_price - cur_low_price ;
    prev_high_minus_low = prev_high_price - prev_low_price ;

    if ( Bid - last_sell_price >= pip_step_sell * Point() ){
        cur_max_sell_ordernum = MaxOrderSell ;
    } else {
        cur_max_sell_ordernum = 1 ;
    }
    if ( last_buy_price - Ask >= pip_step_buy * Point() ) {
        cur_max_buy_ordernum = MaxOrderBuy ;
    } else {
        cur_max_buy_ordernum = 1 ;
    }

    // ToAvoidNews:　当前ｋ线和前一根k线高低点差值都必须小于等于阈值(50)才允许开单，防止新闻导致价格突变
    // ToTriggerOrder: 当前k线必须大于阈值(50)才允许开单,这样可以拿到最好的价位
    if ( CandlestickMode != ToAvoidNews ) {
        if ( CandlestickMode == ToTriggerOrder
           && cur_high_minus_low > input_candlestick_high_low ) {
            if ( Bid > fibo_upper_bound || (is_testing_ok && Bid > f_level_3) ) {
                is_candlestick_ok = -1 ;
            } else {
                if ( Bid < fibo_lower_bound || (is_testing_ok && Bid < f_level_1)) {
                    is_candlestick_ok = 1 ;
                 }
            }
        }
    } else {
        if ( cur_high_minus_low <= input_candlestick_high_low
           && prev_high_minus_low <= input_candlestick_high_low ) {
            if ( Bid > fibo_upper_bound || (is_testing_ok && Bid > f_level_3)) {
                is_candlestick_ok = -1 ;
            } else {
                if ( Bid < fibo_lower_bound || (is_testing_ok && Bid < f_level_1)) {
                    is_candlestick_ok = 1 ;
                }
            }
        }
    }

    // 修改挂单逻辑: 实现动态跟踪价格追单，使得价格始终保持在当前价加上pending_distance的价位上
    //             例如 对于OP_BUYSTOP订单，挂单价位始终保持在open_price_and_pending_dis == (Ask + pending_distance)
    //             的位置，若价格回落，则调低价格继续追单，一直追到价格突破一瞬间把挂单刺进去
    //             [这样控制会有一个好处，就是精准入场订单，在突破的一瞬间把单子刺进去，防止假突破]
    //             TODO: 接下来研究的重点是对这个逻辑进行改进,
    //             TODO: 1. 追高的时候和回调的时候是不是该分开处理，追高是希望一瞬间拿到最好的价位，要不要取消这个逻辑(可能这个观点有问题)
    //             TODO: 2. 逆势补仓的时候，如果碰到数据行情或者什么原因，导致一瞬间价格回落太多，要不要缓一缓逆势加仓

    // 筛选出正在交易的订单,统计正在交易的订单数量，并且修改挂单逻辑
    num_cur_guadan = 0 ;
    for (order_pos = 0 ; order_pos < OrdersTotal() ; order_pos = order_pos + 1) {

        if ( !(OrderSelect(order_pos,SELECT_BY_POS,MODE_TRADES))
           || OrderMagicNumber() != MagicNumber )   continue;
        cur_order_type = OrderType() ;
        if ( cur_order_type == OP_BUY || cur_order_type == OP_SELL || OrderSymbol() != Symbol() )   continue;
        num_cur_guadan = num_cur_guadan + 1;


        switch(cur_order_type) {
            // buy stop: 买入止损，在当前价格上方挂买单
            case OP_BUYSTOP:
                order_open_price = NormalizeDouble(OrderOpenPrice(),cur_symbol_digits) ;
                open_price_and_pending_dis = NormalizeDouble(Ask + pending_distance,cur_symbol_digits) ;
                if ( !(open_price_and_pending_dis < order_open_price) )   break;
                stop_loss_price_calc = NormalizeDouble(
                                                open_price_and_pending_dis - StopLoss * Point(),cur_symbol_digits) ;
                take_profit_price_calc = NormalizeDouble(
                                                TakeProfit * Point() + open_price_and_pending_dis,cur_symbol_digits) ;
                stop_loss_price = stop_loss_price_calc ;
                if ( !(UseStopLoss) ) {
                    stop_loss_price = 0.0 ;
                }
                take_profit_price = take_profit_price_calc ;
                if ( !(UseTakeProfit) ) {
                    take_profit_price = 0.0 ;
                }
                if ( OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() ) {
                    is_order_modifiy_success = OrderModify(OrderTicket(),open_price_and_pending_dis,
                                                            stop_loss_price,take_profit_price,0,Blue) ;
                }
                if ( is_order_modifiy_success )   break;
                last_err = GetLastError() ;
                last_err_discript = ErrorDescription(last_err) ;
                Print("BUYSTOP Modify Error Code: " + string(last_err)
                        + " Message: " + last_err_discript
                        + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                        + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                        + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
                break;
            case OP_SELLSTOP:
                order_open_price = NormalizeDouble(OrderOpenPrice(),cur_symbol_digits) ;
                open_price_and_pending_dis = NormalizeDouble(Bid - pending_distance,cur_symbol_digits) ;
                if ( !(open_price_and_pending_dis > order_open_price) )   break;
                stop_loss_price_calc = NormalizeDouble(
                                                    StopLoss * Point() + open_price_and_pending_dis,cur_symbol_digits);
                take_profit_price_calc = NormalizeDouble(
                                                    open_price_and_pending_dis - TakeProfit * Point(),cur_symbol_digits);
                stop_loss_price = stop_loss_price_calc ;
                if ( !(UseStopLoss) ) {
                    stop_loss_price = 0.0 ;
                }
                take_profit_price = take_profit_price_calc ;
                if ( !(UseTakeProfit) ) {
                    take_profit_price = 0.0 ;
                }
                if ( OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() ) {
                    is_order_modifiy_success = OrderModify(OrderTicket(),open_price_and_pending_dis,
                                                            stop_loss_price,take_profit_price,0,Red) ;
                }
                if ( is_order_modifiy_success )   break;
                last_err = GetLastError() ;
                last_err_discript = ErrorDescription(last_err) ;
                Print("SELLSTOP Modify Error Code: " + string(last_err)
                        + " Message: " + last_err_discript
                        + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                        + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                        + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
                break;
            case OP_SELLLIMIT:
                order_open_price = NormalizeDouble(OrderOpenPrice(),cur_symbol_digits) ;
                open_price_and_pending_dis = NormalizeDouble(Bid + pending_distance,cur_symbol_digits) ;
                if ( !(open_price_and_pending_dis < order_open_price) )   break;
                stop_loss_price_calc = NormalizeDouble(
                                                StopLoss * Point() + open_price_and_pending_dis,cur_symbol_digits);
                take_profit_price_calc = NormalizeDouble(
                                                open_price_and_pending_dis - TakeProfit * Point(),cur_symbol_digits);
                stop_loss_price = stop_loss_price_calc ;
                if ( !(UseStopLoss) ) {
                    stop_loss_price = 0.0 ;
                }
                take_profit_price = take_profit_price_calc ;
                if ( !(UseTakeProfit) ) {
                    take_profit_price = 0.0 ;
                }
                if ( OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() ) {
                    is_order_modifiy_success = OrderModify(OrderTicket(),open_price_and_pending_dis,
                                                            stop_loss_price, take_profit_price,0,Red) ;
                }
                if ( is_order_modifiy_success )   break;
                last_err = GetLastError() ;
                last_err_discript = ErrorDescription(last_err) ;
                Print("BUYLIMIT Modify Error Code: " + string(last_err)
                        + " Message: " + last_err_discript
                        + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                        + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                        + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
                   break;
            case OP_BUYLIMIT:
                order_open_price = NormalizeDouble(OrderOpenPrice(),cur_symbol_digits) ;
                open_price_and_pending_dis = NormalizeDouble(Ask - pending_distance,cur_symbol_digits) ;
                if ( !(open_price_and_pending_dis > order_open_price) )   break;
                stop_loss_price_calc = NormalizeDouble(
                                                  open_price_and_pending_dis - StopLoss * Point(),cur_symbol_digits);
                take_profit_price_calc = NormalizeDouble(
                                                  TakeProfit * Point() + open_price_and_pending_dis,cur_symbol_digits);
                stop_loss_price = stop_loss_price_calc ;
                if ( !(UseStopLoss) ) {
                    stop_loss_price = 0.0 ;
                }
                take_profit_price = take_profit_price_calc ;
                if ( !(UseTakeProfit) ) {
                    take_profit_price = 0.0 ;
                }
                if ( OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() )
                 {
                 is_order_modifiy_success = OrderModify(OrderTicket(),open_price_and_pending_dis,
                                                        stop_loss_price, take_profit_price,0,Blue) ;
                 }
                if ( is_order_modifiy_success )   break;
                last_err = GetLastError() ;
                last_err_discript = ErrorDescription(last_err) ;
                Print("SELLLIMIT Modify Error Code: " + string(last_err)
                        + " Message: " + last_err_discript
                        + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                        + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                        + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
        }
    }

    if ( CountTradesBuy() == 0 ) {
    is_close_all_buy_orders = false ;
    }
    if ( CountTradesSell() == 0 ) {
    is_close_all_sell_orders = false ;
    }

    TotalProfitbuy();
    TotalProfitsell();

    if(ShowComment) ChartComment(last_buy_price,last_sell_price,
                                cur_max_buy_ordernum,cur_max_sell_ordernum,
                                is_candlestick_ok,num_cur_guadan);

    // 买单整体达到 止损 或者 止盈 金额，则平掉所有买单
    if ( ( target_buy_money>0.0 && total_buy_profit >= target_buy_money )
    || ( -(stop_loss_money_buy)<0.0 && total_buy_profit <= -(stop_loss_money_buy))  ) {
    is_close_all_buy_orders = true ;
    }

    if ( is_close_all_buy_orders ) { OpenOrdCloseBuy(); }

    // 卖单整体达到 止损 或者 止盈 金额，则平掉所有卖单
    if ( ( target_sell_money>0.0 && total_sell_profit>=target_sell_money )
    || ( -(stop_loss_money_sell)<0.0 && total_sell_profit<= -(stop_loss_money_sell)) ) {
    is_close_all_sell_orders = true ;
    }
    if ( is_close_all_sell_orders ) {
    OpenOrdCloseSell();
    }

    // Track是否收紧止损
    if ( UseTrailing ) { MoveTrailingStop(); }

    // Check每周哪天不做交易
    if ( !(TradeMonday) && DayOfWeek() == 1 ) { return(0); }
    if ( !(TradeTuesday) && DayOfWeek() == 2 ) { return(0); }
    if ( !(TradeWednesday) && DayOfWeek() == 3 ) { return(0); }
    if ( !(TradeThursday) && DayOfWeek() == 4 ) { return(0); }
    if ( !(TradeFriday) && DayOfWeek() == 5 ) { return(0); }

    // TODO:为什么只用卖价Bid来定入场点?
    //
    switch(TradingMode) {
        case PendingLimitOrderFollowTrend:
            if ( Bid < fibo_lower_bound && CountTradesSell() >= cur_max_sell_ordernum ) {
                return(0);
            }
            if ( !(Bid>fibo_upper_bound) || CountTradesBuy() < cur_max_buy_ordernum )   break;
            return(0);

        case PendingStopOrderFollowTrend:
            if ( Bid < fibo_lower_bound && CountTradesSell() >= cur_max_sell_ordernum ) {
                return(0);
            }
            if ( !(Bid>fibo_upper_bound) || CountTradesBuy() < cur_max_buy_ordernum )   break;
            return(0);

        case PendingLimitOrderReversalTrend:
            if ( Bid>fibo_upper_bound && CountTradesSell() >= cur_max_sell_ordernum ) {
                return(0);
            }
            if ( !(Bid < fibo_lower_bound) || CountTradesBuy() < cur_max_buy_ordernum )   break;
            return(0);

        // Bid<=fibo_upper_bound || CountTradesSell() < cur_max_sell_ordernum
        // &&
        // Bid >= fibo_lower_bound || CountTradesBuy() < cur_max_buy_ordernum
        // 对于卖单，若价格高于upper_bound, 且卖单单量>=最大单量设置，则不加仓
        // 对于买单，同理
        // 总结来说，就是价格在[lower_bound,upper_bound]区间之内表示价格没有偏离太离谱
        //            买卖单量需要最大单量限制来限制最终的加单数量
        case PendingStopOrderReversalTrend:
            if ( Bid>fibo_upper_bound && CountTradesSell() >= cur_max_sell_ordernum ) {
                Print("fibo_upper_bound:" + fibo_upper_bound + ", rt_1");
                return(0);
            }
            if ( !(Bid < fibo_lower_bound) || CountTradesBuy() < cur_max_buy_ordernum )   break;
            Print("fibo_lower_bound:" + fibo_lower_bound + ", rt_2");
            return(0);
    }

    switch(TradingMode) {
        case PendingLimitOrderFollowTrend:
            if ( num_cur_guadan != 0 || is_candlestick_ok == 0
                || !(average_spread_add_commission_rate<=max_spread_plus_commission)
                || !(CheckTradingTimeValid()) )   break;
            risk_amount_lots = AccountBalance() * AccountLeverage() * risk_factor / MarketInfo(Symbol(),15) ;
            if ( !(UseMM) ) {
                risk_amount_lots = FixedLots ;
            }

            buy_order_lots = NormalizeDouble(
                                        risk_amount_lots * MathPow(LotsExponent,CountTradesBuy()),cur_symbol_digits);
            buy_order_lots = MathMax(minimum_permitted_lots,buy_order_lots) ;
            buy_order_lots = MathMin(max_permitted_lots,buy_order_lots) ;
            sell_order_lots = NormalizeDouble(
                                        risk_amount_lots * MathPow(LotsExponent,CountTradesSell()),cur_symbol_digits);
            sell_order_lots = MathMax(minimum_permitted_lots,sell_order_lots);
            sell_order_lots = MathMin(max_permitted_lots,sell_order_lots);

            if ( is_candlestick_ok <  0 ) {
                open_price_and_pending_dis = NormalizeDouble(Ask - pending_distance,cur_symbol_digits) ;
                stop_loss_price_calc = NormalizeDouble(
                                            open_price_and_pending_dis - StopLoss * Point(),cur_symbol_digits) ;
                take_profit_price_calc = NormalizeDouble(
                                            TakeProfit * Point() + open_price_and_pending_dis,cur_symbol_digits) ;
                stop_loss_price = stop_loss_price_calc ;
                if ( !(UseStopLoss) ) {
                    stop_loss_price = 0.0 ;
                }
                take_profit_price = take_profit_price_calc ;
                if ( !(UseTakeProfit) ) {
                    take_profit_price = 0.0 ;
                }
                success_sent_order_ticket = OrderSend(Symbol(),OP_BUYLIMIT,buy_order_lots,
                                                        open_price_and_pending_dis,Slippage,
                                                        stop_loss_price,take_profit_price,
                                                        TradeComment,MagicNumber,0,Blue) ;
                if ( success_sent_order_ticket > 0 ) break;
                last_err = GetLastError() ;
                last_err_discript = ErrorDescription(last_err) ;
                Print("BUYLIMIT Send Error Code: " + string(last_err)
                        + " Message: " + last_err_discript
                        + " LT: " + DoubleToString(buy_order_lots,cur_symbol_digits)
                        + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                        + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                        + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
                break;
            }

            open_price_and_pending_dis = NormalizeDouble(Bid + pending_distance,cur_symbol_digits) ;
            stop_loss_price_calc = NormalizeDouble(StopLoss * Point() + open_price_and_pending_dis,cur_symbol_digits);
            take_profit_price_calc = NormalizeDouble(
                                                open_price_and_pending_dis - TakeProfit * Point(),cur_symbol_digits) ;
            stop_loss_price = stop_loss_price_calc ;

            if ( !(UseStopLoss) ) {
                stop_loss_price = 0.0 ;
            }
            take_profit_price = take_profit_price_calc ;
            if ( !(UseTakeProfit) ) {
                take_profit_price = 0.0 ;
            }
            success_sent_order_ticket = OrderSend(Symbol(),OP_SELLLIMIT,sell_order_lots,
                                                    open_price_and_pending_dis,Slippage,
                                                    stop_loss_price,take_profit_price,
                                                    TradeComment,MagicNumber,0,Red);
            if ( success_sent_order_ticket > 0 )   break;
            last_err = GetLastError() ;
            last_err_discript = ErrorDescription(last_err) ;
            Print("SELLLIMIT Send Error Code: " + string(last_err)
                    + " Message: " + last_err_discript
                    + " LT: " + DoubleToString(sell_order_lots,cur_symbol_digits)
                    + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                    + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                    + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                    + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                    + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
            break;
        case PendingLimitOrderReversalTrend:
            if ( num_cur_guadan != 0 || is_candlestick_ok == 0
                || !(average_spread_add_commission_rate<=max_spread_plus_commission)
                || !(CheckTradingTimeValid()) )   break;
            risk_amount_lots = AccountBalance() * AccountLeverage() * risk_factor / MarketInfo(Symbol(),15) ;
            if ( !(UseMM) ) {
                risk_amount_lots = FixedLots ;
            }
            buy_order_lots = NormalizeDouble(
                                        risk_amount_lots * MathPow(LotsExponent,CountTradesBuy()),cur_symbol_digits);
            buy_order_lots = MathMax(minimum_permitted_lots,buy_order_lots) ;
            buy_order_lots = MathMin(max_permitted_lots,buy_order_lots) ;
            sell_order_lots = NormalizeDouble(
                                        risk_amount_lots * MathPow(LotsExponent,CountTradesSell()),cur_symbol_digits);
            sell_order_lots = MathMax(minimum_permitted_lots,sell_order_lots) ;
            sell_order_lots = MathMin(max_permitted_lots,sell_order_lots) ;
            if ( is_candlestick_ok <  0 ) {
                open_price_and_pending_dis = NormalizeDouble(Bid + pending_distance,cur_symbol_digits) ;
                stop_loss_price_calc = NormalizeDouble(
                                                StopLoss * Point() + open_price_and_pending_dis,cur_symbol_digits);
                take_profit_price_calc = NormalizeDouble(
                                                open_price_and_pending_dis - TakeProfit * Point(),cur_symbol_digits);
                stop_loss_price = stop_loss_price_calc ;
                if ( !(UseStopLoss) ) {
                    stop_loss_price = 0.0 ;
                }
                take_profit_price = take_profit_price_calc ;
                if ( !(UseTakeProfit) ) {
                    take_profit_price = 0.0 ;
                }
                success_sent_order_ticket = OrderSend(Symbol(),OP_SELLLIMIT,sell_order_lots,
                                                        open_price_and_pending_dis,Slippage,
                                                        stop_loss_price,take_profit_price,
                                                        TradeComment,MagicNumber,0,Red) ;
                if ( success_sent_order_ticket > 0 )   break;
                last_err = GetLastError() ;
                last_err_discript = ErrorDescription(last_err) ;
                Print("SELLLIMIT Send Error Code: " + string(last_err)
                        + " Message: " + last_err_discript
                        + " LT: " + DoubleToString(sell_order_lots,cur_symbol_digits)
                        + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                        + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                        + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
                   break;
            }

            open_price_and_pending_dis = NormalizeDouble(Ask - pending_distance,cur_symbol_digits) ;
            stop_loss_price_calc = NormalizeDouble(open_price_and_pending_dis - StopLoss * Point(),cur_symbol_digits) ;
            take_profit_price_calc = NormalizeDouble(
                                                TakeProfit * Point() + open_price_and_pending_dis,cur_symbol_digits) ;
            stop_loss_price = stop_loss_price_calc ;
            if ( !(UseStopLoss) ) {
                stop_loss_price = 0.0 ;
            }
            take_profit_price = take_profit_price_calc ;
            if ( !(UseTakeProfit) ) {
                take_profit_price = 0.0 ;
            }
            success_sent_order_ticket = OrderSend(Symbol(),OP_BUYLIMIT,buy_order_lots,
                                                    open_price_and_pending_dis,Slippage,
                                                    stop_loss_price,take_profit_price,
                                                    TradeComment,MagicNumber,0,Blue) ;
            if ( success_sent_order_ticket > 0 )   break;
            last_err = GetLastError() ;
            last_err_discript = ErrorDescription(last_err) ;
            Print("BUYLIMIT Send Error Code: " + string(last_err)
                    + " Message: " + last_err_discript
                    + " LT: " + DoubleToString(buy_order_lots,cur_symbol_digits)
                    + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                    + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                    + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                    + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                    + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
            break;
        case PendingStopOrderFollowTrend :
            if ( num_cur_guadan != 0 || is_candlestick_ok == 0
                || !(average_spread_add_commission_rate<=max_spread_plus_commission)
                || !(CheckTradingTimeValid()) )   break;
            risk_amount_lots = AccountBalance() * AccountLeverage() * risk_factor / MarketInfo(Symbol(),15) ;
            if ( !(UseMM) ) {
                risk_amount_lots = FixedLots ;
            }
            buy_order_lots = NormalizeDouble(
                                        risk_amount_lots * MathPow(LotsExponent,CountTradesBuy()),cur_symbol_digits);
            buy_order_lots = MathMax(minimum_permitted_lots,buy_order_lots) ;
            buy_order_lots = MathMin(max_permitted_lots,buy_order_lots) ;
            sell_order_lots = NormalizeDouble(
                                        risk_amount_lots * MathPow(LotsExponent,CountTradesSell()),cur_symbol_digits);
            sell_order_lots = MathMax(minimum_permitted_lots,sell_order_lots) ;
            sell_order_lots = MathMin(max_permitted_lots,sell_order_lots) ;
            if ( is_candlestick_ok <  0 ) {
                open_price_and_pending_dis = NormalizeDouble(Ask + pending_distance,cur_symbol_digits) ;
                stop_loss_price_calc = NormalizeDouble(
                                                open_price_and_pending_dis - StopLoss * Point(),cur_symbol_digits) ;
                take_profit_price_calc = NormalizeDouble(
                                                TakeProfit * Point() + open_price_and_pending_dis,cur_symbol_digits) ;
                stop_loss_price = stop_loss_price_calc ;
                if ( !(UseStopLoss) ) {
                    stop_loss_price = 0.0 ;
                }
                take_profit_price = take_profit_price_calc ;
                if ( !(UseTakeProfit) ) {
                    take_profit_price = 0.0 ;
                }
                success_sent_order_ticket = OrderSend(Symbol(),OP_BUYSTOP,buy_order_lots,
                                                        open_price_and_pending_dis,Slippage,
                                                        stop_loss_price,take_profit_price,
                                                        TradeComment,MagicNumber,0,Blue) ;
                if ( success_sent_order_ticket > 0 )   break;
                last_err = GetLastError() ;
                last_err_discript = ErrorDescription(last_err) ;
                Print("BUYSTOP Send Error Code: " + string(last_err)
                        + " Message: " + last_err_discript
                        + " LT: " + DoubleToString(buy_order_lots,cur_symbol_digits)
                        + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                        + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                        + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
                   break;
            }
            open_price_and_pending_dis = NormalizeDouble(Bid - pending_distance,cur_symbol_digits) ;
            stop_loss_price_calc = NormalizeDouble(StopLoss * Point() + open_price_and_pending_dis,cur_symbol_digits);
            take_profit_price_calc = NormalizeDouble(
                                               open_price_and_pending_dis - TakeProfit * Point(),cur_symbol_digits);
            stop_loss_price = stop_loss_price_calc ;
            if ( !(UseStopLoss) ) {
                stop_loss_price = 0.0 ;
            }
            take_profit_price = take_profit_price_calc ;
            if ( !(UseTakeProfit) ) {
                take_profit_price = 0.0 ;
            }

            success_sent_order_ticket = OrderSend(Symbol(),OP_SELLSTOP,sell_order_lots,
                                                    open_price_and_pending_dis,Slippage,
                                                    stop_loss_price,take_profit_price,
                                                    TradeComment,MagicNumber,0,Red) ;
            if ( success_sent_order_ticket > 0 )   break;
            last_err = GetLastError() ;
            last_err_discript = ErrorDescription(last_err) ;

            Print("1 SELLSTOP Send Error Code: " + ", debug volume: " + sell_order_lots
                    + ", Message: " + last_err_discript
                    + " LT: " + DoubleToString(sell_order_lots,cur_symbol_digits)
                    + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                    + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                    + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                    + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                    + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
            break;
        case PendingStopOrderReversalTrend:
            if ( num_cur_guadan != 0 || is_candlestick_ok == 0
                || !(average_spread_add_commission_rate<=max_spread_plus_commission)
                || !(CheckTradingTimeValid()) )   break;
            risk_amount_lots = AccountBalance() * AccountLeverage() * risk_factor / MarketInfo(Symbol(),15) ;
            if ( !(UseMM) )  {
                risk_amount_lots = FixedLots ;
            }
            buy_order_lots = NormalizeDouble(
                                        risk_amount_lots * MathPow(LotsExponent,CountTradesBuy()),cur_symbol_digits) ;
            buy_order_lots = MathMax(minimum_permitted_lots,buy_order_lots) ;
            buy_order_lots = MathMin(max_permitted_lots,buy_order_lots) ;
            sell_order_lots = NormalizeDouble(
                                        risk_amount_lots * MathPow(LotsExponent,CountTradesSell()),cur_symbol_digits) ;
            sell_order_lots = MathMax(minimum_permitted_lots,sell_order_lots) ;
            sell_order_lots = MathMin(max_permitted_lots,sell_order_lots) ;
            if ( is_candlestick_ok <  0 ) {
                open_price_and_pending_dis = NormalizeDouble(Bid - pending_distance,cur_symbol_digits) ;
                stop_loss_price_calc = NormalizeDouble(
                                            StopLoss * Point() + open_price_and_pending_dis,cur_symbol_digits) ;
                take_profit_price_calc = NormalizeDouble(
                                            open_price_and_pending_dis - TakeProfit * Point(),cur_symbol_digits) ;
                stop_loss_price = stop_loss_price_calc ;
                if ( !(UseStopLoss) ) {
                    stop_loss_price = 0.0 ;
                }
                take_profit_price = take_profit_price_calc ;
                if ( !(UseTakeProfit) ) {
                 take_profit_price = 0.0 ;
                }
                success_sent_order_ticket = OrderSend(Symbol(),OP_SELLSTOP,sell_order_lots,
                                                        open_price_and_pending_dis,Slippage,
                                                        stop_loss_price,take_profit_price,
                                                        TradeComment,MagicNumber,0,Red) ;

                if ( success_sent_order_ticket > 0 )   break;
                last_err = GetLastError() ;
                last_err_discript = ErrorDescription(last_err) ;
                Print("2 SELLSTOP Send Error Code: " + string(last_err)
                        + ", debug volume: " + sell_order_lots
                        + ", Message: " + last_err_discript
                        + " LT: " + DoubleToString(sell_order_lots,cur_symbol_digits)
                        + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                        + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                        + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                        + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
                   break;
            }

            open_price_and_pending_dis = NormalizeDouble(Ask + pending_distance,cur_symbol_digits) ;
            stop_loss_price_calc = NormalizeDouble(open_price_and_pending_dis - StopLoss * Point(),cur_symbol_digits) ;
            take_profit_price_calc = NormalizeDouble(
                                            TakeProfit * Point() + open_price_and_pending_dis,cur_symbol_digits) ;
            stop_loss_price = stop_loss_price_calc ;
            if ( !(UseStopLoss) ) {
                stop_loss_price = 0.0 ;
            }
            take_profit_price = take_profit_price_calc ;
            if ( !(UseTakeProfit) ) {
                take_profit_price = 0.0 ;
            }
            success_sent_order_ticket = OrderSend(Symbol(),OP_BUYSTOP,buy_order_lots,
                                                    open_price_and_pending_dis,Slippage,
                                                    stop_loss_price,take_profit_price,
                                                    TradeComment,MagicNumber,0,Blue) ;
            if ( success_sent_order_ticket > 0 )   break;

            last_err = GetLastError() ;
            last_err_discript = ErrorDescription(last_err) ;
            Print("BUYSTOP Send Error Code: " + string(last_err)
                    + " Message: " + last_err_discript
                    + " LT: " + DoubleToString(buy_order_lots,cur_symbol_digits)
                    + " OP: " + DoubleToString(open_price_and_pending_dis,cur_symbol_digits)
                    + " SL: " + DoubleToString(take_profit_price,cur_symbol_digits)
                    + " TP: " + DoubleToString(take_profit_price,cur_symbol_digits)
                    + " Bid: " + DoubleToString(Bid,cur_symbol_digits)
                    + " Ask: " + DoubleToString(Ask,cur_symbol_digits));
    }

    err_commission_prompt = "AvgSpread:" + DoubleToString(average_spread,cur_symbol_digits)
                        + "  Commission rate:" + DoubleToString(commission_rate,cur_symbol_digits + 1)
                        + "  Real avg. spread:"
                        + DoubleToString(average_spread_add_commission_rate,cur_symbol_digits + 1);
    if ( average_spread_add_commission_rate>max_spread_plus_commission ) {
    err_commission_prompt = err_commission_prompt + "\n" + "The EA can not run with this spread ( "
                            + DoubleToString(average_spread_add_commission_rate,cur_symbol_digits + 1)
                            + " > " + DoubleToString(max_spread_plus_commission,cur_symbol_digits + 1) + " )" ;
    }

    return(0);
}
//start <<==
//---------- ----------  ---------- ----------
int deinit() {
    Comment("");
    DeleteAllObjects ( );
    return(0);
}
//deinit <<==

//---------- ----------  ---------- ----------
 int CheckTradingTimeValid() {
 if ( ( Hour() > StartHour && Hour() < EndHour )
        || ( Hour() == StartHour && Minute() >= StartMinute )
        || (Hour() == EndHour && Minute() <  EndMinute) ) {
    return(1);
 }
 return(0);
}
// CheckTradingTimeValid <<==

//---------- ----------  ---------- ----------
void MoveTrailingStop() {
    int cur_order_num;
    //----- -----

    for (cur_order_num = 0 ; cur_order_num < OrdersTotal() ; cur_order_num = cur_order_num + 1) {
    // 遍历正在持有的订单(包括买单和卖单),OrderType() > 1
    if ( !(OrderSelect(cur_order_num,SELECT_BY_POS,MODE_TRADES)) || OrderType() > 1
        || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber )   continue;

    //        根据下图来理解买单追击止损逻辑
    //        ---------------Ask--------------------
    //        ---------------Ask - TrailingStart --------------------
    //                      上面大于下面,说明买单已经盈利超过(TrailingStart+TrailingStop)的点数，
    //                      则将追击止损位收到Bid - TrailingStop的位置
    //                      注意: 买单止损是卖单，故而用卖价来收止损
    //        ---------------cur_price + TrailingStop------------
    //        ---------------cur_price------------

    //  买单追击止损逻辑,联系上图理解
    if ( OrderType() == OP_BUY ) {
        if ( TrailingStop <= 0
            || !(NormalizeDouble(Ask - TrailingStart * Point(),Digits())>NormalizeDouble(
                                                                TrailingStop * Point() + OrderOpenPrice(),Digits())) )
             continue;

        // 要收紧的止损价位Bid - TrailingStop必须大于原订单止损价位(这样修改才有意义，达到收紧止损的效果)
        // 原订单止损价位必须不为零，也就是说当前已经启动了止损模式，才去修改止损
        if ( ( !(NormalizeDouble(OrderStopLoss(),Digits())<NormalizeDouble(Bid - TrailingStop * Point(),Digits()))
                        && !(OrderStopLoss()==0.0) )
              || !(OrderModify(OrderTicket(),OrderOpenPrice(),
                                NormalizeDouble(Bid - TrailingStop * Point(),Digits()),OrderTakeProfit(),0,Blue))
              || GetLastError() != 0 )   continue;
        Print(Symbol() + ": Trailing Buy OrderModify ok ");
        continue;
    }

    //        ---------------cur_price------------
    //        ---------------cur_price - TrailingStop------------
    //                       下面的价格小于上面的价格，说明卖单已经盈利超过(TrailingStart+TrailingStop)的点数，
    //                       则将追击止损位收到Ask + TrailingStop的位置
    //                       注意: 卖单止损是买单，故而用买价来收止损
    //        ---------------Bid + TrailingStart------------
    //        ---------------Bid------------

    // 卖单追击止损逻辑,联系上图理解
    if ( TrailingStop <= 0
      || !(NormalizeDouble(TrailingStart * Point() + Bid,Digits())<NormalizeDouble(
                                                                   OrderOpenPrice() - TrailingStop * Point(),Digits())))
      continue;

    // 要收紧的止损价位Ask + TrailingStop必须小于原订单止损价位(这样修改才有意义，达到收紧止损的效果)
    // 原订单止损价位必须不为零，也就是说当前已经启动了止损模式，才去修改止损
    if ( ( !(NormalizeDouble(OrderStopLoss(),Digits())>NormalizeDouble(TrailingStop * Point() + Ask,Digits()))
                    && !(OrderStopLoss()==0.0) )
         || !(OrderModify(OrderTicket(),OrderOpenPrice(),
                        NormalizeDouble(TrailingStop * Point() + Ask,Digits()),OrderTakeProfit(),0,Red))
         || GetLastError() != 0 )   continue;
      Print(Symbol() + ": Trailing Sell OrderModify ok ");
    }
}
//MoveTrailingStop <<==
//---------- ----------  ---------- ----------
// TODO:理解  总_in_23_  代表的含义 和 为什么要与 MagicNumber比较
 int ScanOpenTrades() {
    int       total_order_number;
    int       order_number;
    int       cur_order_ticket;
    //----- -----

    total_order_number = OrdersTotal() ;
    order_number = 0 ;
    for (cur_order_ticket = 0 ; cur_order_ticket <= total_order_number - 1 ; cur_order_ticket = cur_order_ticket + 1) {
        // 遍历正在持有的订单(包括买单和卖单),OrderType() > 1
        if ( !(OrderSelect(cur_order_ticket,SELECT_BY_POS,MODE_TRADES)) || OrderType() > 1 )   continue;

        if ( 总_in_23 > 0 && OrderMagicNumber() == 总_in_23 ) {
            order_number = order_number + 1;
        }
//        Print("Order Ticket: " + cur_order_ticket + ", OrderMagicNumber = " + OrderMagicNumber());
//        Print("总_in_23: " + 总_in_23);
        if ( 总_in_23 != 0 )   continue;
        order_number = order_number + 1;
    }
    return(order_number);
}
//ScanOpenTrades <<==
//---------- ----------  ---------- ----------

int ScanOpenTradesSymbol() {
    int       total_order_number;
    int       order_number;
    int       cur_order_ticket;
    //----- -----

    total_order_number = OrdersTotal() ;
    order_number = 0 ;
    for (cur_order_ticket = 0 ; cur_order_ticket <= total_order_number - 1 ; cur_order_ticket = cur_order_ticket + 1) {
        if ( !(OrderSelect(cur_order_ticket,SELECT_BY_POS,MODE_TRADES)) || OrderType() > 1 )   continue;

        if ( OrderSymbol() == Symbol() && 总_in_23 > 0 && OrderMagicNumber() == 总_in_23 ) {
            order_number = order_number + 1;
        }
        if ( OrderSymbol() != Symbol() || 总_in_23 != 0 )   continue;
        order_number = order_number + 1;
    }
    return(order_number);
}
//ScanOpenTradesSymbol <<==
//---------- ----------  ---------- ----------

void OpenOrdCloseBuy() {
    int       total_order_number;
    int       cur_order_position;
    int       cur_order_type;
    bool      is_close_success;
    bool      is_selected_order;
    //----- -----

    is_selected_order = false ;
    total_order_number = OrdersTotal() ;
    for (cur_order_position = 0 ; cur_order_position < total_order_number ; cur_order_position = cur_order_position + 1) {
        if ( !(OrderSelect(cur_order_position,SELECT_BY_POS,MODE_TRADES)) )   continue;
        cur_order_type = OrderType() ;
        is_close_success = false ;
        is_selected_order = false ;
        if ( OrderSymbol() == Symbol() && MagicNumber > 0 && OrderMagicNumber() == MagicNumber ) {
           is_selected_order = true ;
        } else {
           if ( OrderSymbol() == Symbol() && MagicNumber == 0 ) {
                is_selected_order = true ;
           }
        }
        if ( !(is_selected_order) )   continue;
        switch(cur_order_type) {
            case OP_BUY :
                is_close_success = OrderClose(OrderTicket(),OrderLots(),
                                                MarketInfo(OrderSymbol(),MODE_BID),Slippage,Blue) ;
                break;
            case OP_BUYLIMIT :
                // 0xFFFFFF : White Color
                if ( !(OrderDelete(OrderTicket(),0xFFFFFFFF)) )   break;
            case OP_BUYSTOP :
                if ( !(OrderDelete(OrderTicket(),0xFFFFFFFF)) )   break;
            default :
                if ( is_close_success )   break;
            Print(" OrderClose failed with error #",GetLastError());
            Sleep(3000);
        }
    }
}
//OpenOrdCloseBuy <<==
//---------- ----------  ---------- ----------
void OpenOrdCloseSell() {
    int       total_order_number;
    int       order_number;
    int       cur_order_type;
    bool      is_close_success;
    bool      is_selected_order;
    //----- -----

    is_selected_order = false ;
    total_order_number = OrdersTotal() ;
    for (order_number = 0 ; order_number < total_order_number ; order_number = order_number + 1) {
        if ( !(OrderSelect(order_number,SELECT_BY_POS,MODE_TRADES)) )   continue;
        cur_order_type = OrderType() ;
        is_close_success = false ;
        is_selected_order = false ;
        if ( OrderSymbol() == Symbol() && MagicNumber > 0 && OrderMagicNumber() == MagicNumber ) {
            is_selected_order = true ;
        } else {
            if ( OrderSymbol() == Symbol() && MagicNumber == 0 ) {
                is_selected_order = true ;
            }
        }
        if ( !(is_selected_order) )   continue;
        switch(cur_order_type) {
            case OP_SELL :
                is_close_success = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),10),Slippage,Red) ;
                break;
            case OP_SELLLIMIT :
                if ( !(OrderDelete(OrderTicket(),0xFFFFFFFF)) )   break;
            case OP_SELLSTOP :
                if ( !(OrderDelete(OrderTicket(),0xFFFFFFFF)) )   break;
            default :
                if ( is_close_success )   break;
            Print(" OrderClose failed with error #",GetLastError());
            Sleep(3000);
        }
    }
}
//OpenOrdCloseSell <<==
//---------- ----------  ---------- ----------

 void TotalProfitbuy() {
    int       total_order_number;
    int       order_number;
    int       cur_order_type;
    bool      is_valid_trade;

    total_order_number = OrdersTotal() ;
    total_buy_profit = 0.0 ;
    for (order_number = 0 ; order_number < total_order_number ; order_number = order_number + 1) {
        // 筛选出正在交易的订单
        if ( !(OrderSelect(order_number,SELECT_BY_POS,MODE_TRADES)) )   continue;
        cur_order_type = OrderType() ;
        is_valid_trade = false ;
        if ( OrderSymbol() == Symbol() && MagicNumber > 0 && OrderMagicNumber() == MagicNumber ) {
            is_valid_trade = true ;
        } else {
            if ( OrderSymbol() == Symbol() && MagicNumber == 0 ) {
                is_valid_trade = true ;
            }
        }
        if ( !(is_valid_trade) || cur_order_type != OP_BUY)   continue;
        total_buy_profit = OrderProfit() + OrderCommission() + OrderSwap() + total_buy_profit ;
    }
}

//TotalProfitbuy <<==
//---------- ----------  ---------- ----------
 void TotalProfitsell() {
    int       total_order_number;
    int       order_number;
    int       cur_order_type;
    bool      is_valid_trade;
    //----- -----

    total_order_number = OrdersTotal() ;
    total_sell_profit = 0.0 ;
    for (order_number = 0 ; order_number < total_order_number ; order_number = order_number + 1)  {
        if ( !(OrderSelect(order_number,SELECT_BY_POS,MODE_TRADES)) )   continue;
        cur_order_type = OrderType() ;
        is_valid_trade = false ;
        if ( OrderSymbol() == Symbol() && MagicNumber > 0 && OrderMagicNumber() == MagicNumber ) {
            is_valid_trade = true ;
        } else {
            if ( OrderSymbol() == Symbol() && MagicNumber == 0 ) {
                is_valid_trade = true ;
            }
        }
        if ( !(is_valid_trade) || cur_order_type != OP_SELL)   continue;
        total_sell_profit = OrderProfit() + OrderCommission() + OrderSwap() + total_sell_profit ;
    }
}
//TotalProfitsell <<==
//---------- ----------  ---------- ----------
 void ChartComment(double last_buy_price, double last_sell_price,
                    int c_max_buy_ordernum, int c_max_sell_ordernum,
                    int is_candlestick_ok, int num_cur_guadan) {
    string    display_info_str;
    string    dot_line_str;
    string    enter_str;
    //----- -----

    display_info_str = "" ;
    dot_line_str = "----------------------------------------\n" ;
    enter_str = "\n" ;
    display_info_str = "----------------------------------------\n" ;
    display_info_str = "----------------------------------------\nName = " + AccountName() + "\n" ;
    display_info_str = display_info_str + "Broker" + " " + "=" + " " + AccountCompany() + "\n" ;
    display_info_str = display_info_str + "Account Leverage" + " " + "=" + " " + "1:" + DoubleToString(AccountLeverage(),0) + "\n" ;
    display_info_str = display_info_str + "Account Balance" + " " + "=" + " " + DoubleToString(AccountBalance(),2) + "\n" ;
    display_info_str = display_info_str + "Account Equity" + " " + "=" + " " + DoubleToString(AccountEquity(),2) + "\n" ;
    display_info_str = display_info_str + "Day Profit" + " " + "=" + " " + DoubleToString(AccountBalance() - startBalanceD1 ( ),2) + enter_str ;
    display_info_str = display_info_str + dot_line_str;
    display_info_str = display_info_str + "ALL Open Orders = " + string(ScanOpenTrades ( )) + enter_str ;
    display_info_str = display_info_str + Symbol() + " ALL Order = " + string(ScanOpenTradesSymbol ( )) + enter_str ;
    display_info_str = display_info_str + "Open Buy  = " + string(CountTradesBuy ( )) + enter_str ;
    display_info_str = display_info_str + "Open Sell = " + string(CountTradesSell ( )) + enter_str ;
    display_info_str = display_info_str + dot_line_str;
    display_info_str = display_info_str + "Target Money Buy = " + DoubleToString(target_buy_money,2) + enter_str ;
    display_info_str = display_info_str + "Stoploss Money Buy = " + DoubleToString( -(stop_loss_money_buy),2) + enter_str ;
    display_info_str = display_info_str + dot_line_str;
    display_info_str = display_info_str + "Target Money Sell = " + DoubleToString(target_sell_money,2) + enter_str ;
    display_info_str = display_info_str + "Stoploss Money Sell = " + DoubleToString( -(stop_loss_money_sell),2) + enter_str ;
    display_info_str = display_info_str + dot_line_str;
    display_info_str = display_info_str + "Buy Profit(USD) = " + DoubleToString(total_buy_profit,2) + enter_str ;
    display_info_str = display_info_str + "Sell Profit(USD) = " + DoubleToString(total_sell_profit,2) + enter_str ;
    display_info_str = display_info_str + dot_line_str;
    display_info_str = display_info_str + "last_buy_price: " + DoubleToString(last_buy_price) + enter_str;
    display_info_str = display_info_str + "last_sell_price: " + DoubleToString(last_sell_price) + enter_str;

    display_info_str = display_info_str + "cur_max_buy_ordernum: " + IntegerToString(c_max_buy_ordernum) + enter_str;
    display_info_str = display_info_str + "cur_max_sell_ordernum: " + IntegerToString(c_max_sell_ordernum) + enter_str;
    display_info_str = display_info_str + "is_candlestick_ok: " + IntegerToString(is_candlestick_ok) + enter_str;
    display_info_str = display_info_str + "num_cur_guadan: " + IntegerToString(num_cur_guadan) + enter_str;

    Comment(display_info_str);
 }
//ChartComment <<==
//---------- ----------  ---------- ----------
 void DeleteAllObjects()
 {
  int       total_order_number;
  string    子_st_2;
  int       cur_order_ticket;
//----- -----

 cur_order_ticket = 0 ;
 total_order_number = ObjectsTotal(-1) ;
 for (cur_order_ticket = ObjectsTotal(-1) - 1 ; cur_order_ticket >= 0 ; cur_order_ticket = cur_order_ticket - 1)
  {
  if ( HighToLow )
   {
   子_st_2 = ObjectName(cur_order_ticket) ;
   if ( StringFind(子_st_2,"v_u_hl",0) > -1 )
    {
    ObjectDelete(子_st_2);
    }
   if ( StringFind(子_st_2,"v_l_hl",0) > -1 )
    {
    ObjectDelete(子_st_2);
    }
   if ( StringFind(子_st_2,"Fibo_hl",0) > -1 )
    {
    ObjectDelete(子_st_2);
    }
   if ( StringFind(子_st_2,"trend_hl",0) > -1 )
    {
    ObjectDelete(子_st_2);
    }
   WindowRedraw();
    continue;
   }
  子_st_2 = ObjectName(cur_order_ticket) ;
  if ( StringFind(子_st_2,"v_u_lh",0) > -1 )
   {
   ObjectDelete(子_st_2);
   }
  if ( StringFind(子_st_2,"v_l_lh",0) > -1 )
   {
   ObjectDelete(子_st_2);
   }
  if ( StringFind(子_st_2,"Fibo_lh",0) > -1 )
   {
   ObjectDelete(子_st_2);
   }
  if ( StringFind(子_st_2,"trend_lh",0) > -1 )
   {
   ObjectDelete(子_st_2);
   }
  WindowRedraw();
  }
 }
//DeleteAllObjects <<==
//---------- ----------  ---------- ----------
 void CalcFibo() {
  double    highest_price;
  double    lowest_price;
  int       lowest_price_index;
  int       highest_price_index;
  int       cur_fibo_level;
//----- -----

 lowest_price_index = iLowest(NULL,0,MODE_LOW,BarsBack,StartBar) ;
 highest_price_index = iHighest(NULL,0,MODE_HIGH,BarsBack,StartBar) ;
 highest_price = High[highest_price_index] ;
 lowest_price = Low[lowest_price_index] ;
 if ( HighToLow ) {
  DrawVerticalLine ( "v_u_hl",highest_price_index,line_color);
  DrawVerticalLine ( "v_l_hl",lowest_price_index,line_color);
  if ( ObjectFind("trend_hl") == -1 )
   {
   ObjectCreate("trend_hl",OBJ_TREND,0,Time[highest_price_index],
                 highest_price,Time[lowest_price_index],lowest_price,0,0.0);
   }
  ObjectSet("trend_hl",OBJPROP_TIME1,Time[highest_price_index]);
  ObjectSet("trend_hl",OBJPROP_TIME2,Time[lowest_price_index]);
  ObjectSet("trend_hl",OBJPROP_PRICE1,highest_price);
  ObjectSet("trend_hl",OBJPROP_PRICE2,lowest_price);
  ObjectSet("trend_hl",OBJPROP_STYLE,STYLE_DOT);
  ObjectSet("trend_hl",OBJPROP_RAY,0.0);
  if ( ObjectFind("Fibo_hl") == -1 )
   {
   ObjectCreate("Fibo_hl",OBJ_FIBO,0,0,highest_price,0,lowest_price,0,0.0);
   }
  ObjectSet("Fibo_hl",OBJPROP_PRICE1,highest_price);
  ObjectSet("Fibo_hl",OBJPROP_PRICE2,lowest_price);
  ObjectSet("Fibo_hl",OBJPROP_LEVELCOLOR,fibo_level_line_color);
  ObjectSet("Fibo_hl",OBJPROP_FIBOLEVELS,8.0);

// Set Each Fibo Level
  ObjectSet("Fibo_hl",210,fibo_level_0);
  ObjectSetFiboDescription("Fibo_hl",0,"SWING LOW (0.0) - %$");
  ObjectSet("Fibo_hl",211,fibo_level_1);
  ObjectSetFiboDescription("Fibo_hl",1,"BREAKOUT AREA (23.6) -  %$");
  ObjectSet("Fibo_hl",212,fibo_level_2);
  ObjectSetFiboDescription("Fibo_hl",2,"CRITICAL AREA (38.2) -  %$");
  ObjectSet("Fibo_hl",213,fibo_level_3);
  ObjectSetFiboDescription("Fibo_hl",3,"CRITICAL AREA (50.0) -  %$");
  ObjectSet("Fibo_hl",214,fibo_level_4);
  ObjectSetFiboDescription("Fibo_hl",4,"CRITICAL AREA (61.8) -  %$");
  ObjectSet("Fibo_hl",215,fibo_level_5);
  ObjectSetFiboDescription("Fibo_hl",5,"BREAKOUT AREA (76.4) -  %$");
  ObjectSet("Fibo_hl",217,fibo_level_7);
  ObjectSetFiboDescription("Fibo_hl",7,"SWING HIGH (100.0) - %$");
  ObjectSet("Fibo_hl",OBJPROP_RAY,1.0);
  WindowRedraw();
  for (cur_fibo_level = 0 ; cur_fibo_level < 100 ; cur_fibo_level = cur_fibo_level + 1) {
   总_do17ko[cur_fibo_level] = NormalizeDouble((highest_price - lowest_price) * fibo_level_7 + lowest_price,Digits());
   总_do16ko[cur_fibo_level] = NormalizeDouble((highest_price - lowest_price) * fibo_level_5 + lowest_price,Digits());
   总_do15ko[cur_fibo_level] = NormalizeDouble((highest_price - lowest_price) * fibo_level_4 + lowest_price,Digits());
   总_do14ko[cur_fibo_level] = NormalizeDouble((highest_price - lowest_price) * fibo_level_3 + lowest_price,Digits());
   总_do13ko[cur_fibo_level] = NormalizeDouble((highest_price - lowest_price) * fibo_level_2 + lowest_price,Digits());
   总_do12ko[cur_fibo_level] = NormalizeDouble((highest_price - lowest_price) * fibo_level_1 + lowest_price,Digits());
   总_do11ko[cur_fibo_level] = NormalizeDouble((highest_price - lowest_price) * fibo_level_0 + lowest_price,Digits());
  }
  return;
 }
 DrawVerticalLine ( "v_u_lh",highest_price_index,line_color);
 DrawVerticalLine ( "v_l_lh",lowest_price_index,line_color);
 if ( ObjectFind("trend_hl") == -1 ) {
  ObjectCreate("trend_lh",OBJ_TREND,0,
                Time[lowest_price_index],lowest_price,
                Time[highest_price_index],highest_price,0,0.0);
 }
 ObjectSet("trend_lh",OBJPROP_TIME1,Time[lowest_price_index]);
 ObjectSet("trend_lh",OBJPROP_TIME2,Time[highest_price_index]);
 ObjectSet("trend_lh",OBJPROP_PRICE1,lowest_price);
 ObjectSet("trend_lh",OBJPROP_PRICE2,highest_price);
 ObjectSet("trend_lh",OBJPROP_STYLE,2.0); 
 ObjectSet("trend_lh",OBJPROP_RAY,0.0); 
 if ( ObjectFind("Fibo_lh") == -1 )
  {
  ObjectCreate("Fibo_lh",OBJ_FIBO,0,0,lowest_price,0,highest_price,0,0.0);
  }
 ObjectSet("Fibo_lh",OBJPROP_PRICE1,lowest_price);
 ObjectSet("Fibo_lh",OBJPROP_PRICE2,highest_price);
 ObjectSet("Fibo_lh",OBJPROP_LEVELCOLOR,fibo_level_line_color);
 ObjectSet("Fibo_lh",OBJPROP_FIBOLEVELS,8.0); 
 ObjectSet("Fibo_lh",210,fibo_level_0);
 ObjectSetFiboDescription("Fibo_lh",0,"SWING LOW (0.0) - %$"); 
 ObjectSet("Fibo_lh",211,fibo_level_1);
 ObjectSetFiboDescription("Fibo_lh",1,"BREAKOUT AREA (23.6) -  %$"); 
 ObjectSet("Fibo_lh",212,fibo_level_2);
 ObjectSetFiboDescription("Fibo_lh",2,"CRITICAL AREA (38.2) -  %$"); 
 ObjectSet("Fibo_lh",213,fibo_level_3);
 ObjectSetFiboDescription("Fibo_lh",3,"CRITICAL AREA (50.0) -  %$"); 
 ObjectSet("Fibo_lh",214,fibo_level_4);
 ObjectSetFiboDescription("Fibo_lh",4,"CRITICAL AREA (61.8) -  %$"); 
 ObjectSet("Fibo_lh",215,fibo_level_5);
 ObjectSetFiboDescription("Fibo_lh",5,"BREAKOUT AREA (76.4) -  %$"); 
 ObjectSet("Fibo_lh",217,fibo_level_7);
 ObjectSetFiboDescription("Fibo_lh",7,"SWING HIGH (100.0) - %$"); 
 ObjectSet("Fibo_lh",OBJPROP_RAY,1.0); 
 WindowRedraw(); 
 for (cur_fibo_level = 0 ; cur_fibo_level < 100 ; cur_fibo_level = cur_fibo_level + 1)
  {
  总_do11ko[cur_fibo_level] = NormalizeDouble(highest_price,4);
  总_do12ko[cur_fibo_level] = NormalizeDouble(highest_price - (highest_price - lowest_price) * fibo_level_1,Digits());
  总_do13ko[cur_fibo_level] = NormalizeDouble(highest_price - (highest_price - lowest_price) * fibo_level_2,Digits());
  总_do14ko[cur_fibo_level] = NormalizeDouble(highest_price - (highest_price - lowest_price) * fibo_level_3,Digits());
  总_do15ko[cur_fibo_level] = NormalizeDouble(highest_price - (highest_price - lowest_price) * fibo_level_4,Digits());
  总_do16ko[cur_fibo_level] = NormalizeDouble(highest_price - (highest_price - lowest_price) * fibo_level_5,Digits());
  总_do17ko[cur_fibo_level] = NormalizeDouble(lowest_price,4);
  }
 }
//CalcFibo <<==
//---------- ----------  ---------- ----------
// DrawVerticalLine ( "v_u_lh",highest_price_index,vertical_line_color);
 void DrawVerticalLine( string vertical_line_obj_name,int highest_price_index,color vertical_line_color)
 {
 if ( ObjectFind(vertical_line_obj_name) == -1 )
  {
  ObjectCreate(vertical_line_obj_name,OBJ_VLINE,0,Time[highest_price_index],0.0,0,0.0,0,0.0); 
  ObjectSet(vertical_line_obj_name,OBJPROP_COLOR,vertical_line_color); 
  ObjectSet(vertical_line_obj_name,OBJPROP_STYLE,1.0); 
  ObjectSet(vertical_line_obj_name,OBJPROP_WIDTH,1.0); 
  WindowRedraw(); 
  return;
  }
 ObjectDelete(vertical_line_obj_name); 
 ObjectCreate(vertical_line_obj_name,OBJ_VLINE,0,Time[highest_price_index],0.0,0,0.0,0,0.0); 
 ObjectSet(vertical_line_obj_name,OBJPROP_COLOR,vertical_line_color); 
 ObjectSet(vertical_line_obj_name,OBJPROP_STYLE,1.0); 
 ObjectSet(vertical_line_obj_name,OBJPROP_WIDTH,1.0); 
 WindowRedraw(); 
 }
//DrawVerticalLine <<==
//---------- ----------  ---------- ----------
 double FindLastBuyPrice_Hilo()
  {
   double    order_open_price;
   int       cur_order_ticket;
   int       order_ticket;
   int       cur_order_num;
 //----- -----

  cur_order_ticket = 0 ;
  order_ticket = 0 ;

  for (cur_order_num=OrdersTotal() - 1 ; cur_order_num >= 0 ; cur_order_num=cur_order_num - 1)
   {
   if ( !(OrderSelect(cur_order_num,SELECT_BY_POS,MODE_TRADES)) || OrderSymbol() != Symbol()
        || OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol()
        || OrderMagicNumber() != MagicNumber
        || OrderType() != OP_BUY )   continue;
   cur_order_ticket = OrderTicket() ;
   if ( cur_order_ticket <= order_ticket )   continue;
   order_open_price = OrderOpenPrice() ;
   order_ticket = cur_order_ticket ;
   }
  return(order_open_price);
  }
//FindLastBuyPrice_Hilo <<==
//---------- ----------  ---------- ----------
double FindLastSellPrice_Hilo() {
    double    order_open_price;
    int       cur_order_ticket;
    int       order_ticket;
    int       cur_order_num;
    //----- -----

    cur_order_ticket = 0 ;
    order_ticket = 0 ;
    for (cur_order_num=OrdersTotal() - 1 ; cur_order_num >= 0 ; cur_order_num=cur_order_num - 1) {
        if ( !(OrderSelect(cur_order_num,SELECT_BY_POS,MODE_TRADES))
        || OrderSymbol() != Symbol()
        || OrderMagicNumber() != MagicNumber || OrderType() != OP_SELL )   continue;
        cur_order_ticket = OrderTicket() ;
        if ( cur_order_ticket <= order_ticket )   continue;
        order_open_price = OrderOpenPrice() ;
        order_ticket = cur_order_ticket ;
    }
    return(order_open_price);
}
//FindLastSellPrice_Hilo <<==
//---------- ----------  ---------- ----------
 int CountTradesSell()
 {
  int       total_order_number;
  int       order_number;
//----- -----

 order_number = 0 ;
 total_order_number = 0 ;
 for (order_number = OrdersTotal() - 1 ; order_number >= 0 ; order_number = order_number - 1)
  {
  if ( !(OrderSelect(order_number,SELECT_BY_POS,MODE_TRADES))
        || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber
        || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber
        || OrderType() != 1 )   continue;
  total_order_number = total_order_number + 1;
  }
 return(total_order_number);
 }
//CountTradesSell <<==
//---------- ----------  ---------- ----------
 int CountTradesBuy()
 {
  int       total_order_number;
  int       order_number;
//----- -----

 order_number = 0 ;
 total_order_number = 0 ;
 for (order_number = OrdersTotal() - 1 ; order_number >= 0 ; order_number = order_number - 1)
  {
  if ( !(OrderSelect(order_number,SELECT_BY_POS,MODE_TRADES))
  || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber
  || OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber
  || OrderType() != 0 )   continue;
  total_order_number = total_order_number + 1;
  }
 return(total_order_number);
 }
//CountTradesBuy <<==
//---------- ----------  ---------- ----------
 double startBalanceD1()
 {
  double    total_profit;
  int       order_total_number;
  datetime  cur_date;
  int       cur_order_ticket;
  double    start_balance_d1;
//----- -----

 order_total_number = OrdersHistoryTotal() ;
 cur_date = iTime(NULL,PERIOD_D1,0) ;
 for (cur_order_ticket = order_total_number ; cur_order_ticket >= 0 ; cur_order_ticket = cur_order_ticket - 1)
  {
  if ( !(OrderSelect(cur_order_ticket,SELECT_BY_POS,MODE_HISTORY))
        || OrderCloseTime() < cur_date )   continue;
  total_profit = OrderProfit() + OrderCommission() + OrderSwap() + total_profit ;
  }
 start_balance_d1 = NormalizeDouble(AccountBalance() - total_profit,2) ;
 return(start_balance_d1);
 }
//startBalanceD1 <<==
//---------- ----------  ---------- ----------
