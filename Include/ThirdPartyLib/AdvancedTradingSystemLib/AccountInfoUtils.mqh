// #ifndef act
//    #define act
// #endif

class AccountInfoUtils {
// 加入MagicNumber好判断
    public:
        AccountInfoUtils() {};
        ~AccountInfoUtils() {};
    public:
       double GetCurrentTotalProfit();
       double GetCurrentFloatingProfit();
       double GetCurrentBuyFloatingProfit();
       double GetCurrentSellFloatingProfit();
};

double AccountInfoUtils::GetCurrentTotalProfit() {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();;
        }
    }

    int orders_history_total = OrdersHistoryTotal();
    for (int oh_i = orders_history_total - 1; oh_i >= 0; oh_i--) {
        if (OrderSelect(oh_i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();;
        }
    }

    return(TotalProfit);
}

double AccountInfoUtils::GetCurrentFloatingProfit() {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    #ifdef act
        if (orders_total > 0)
        Print("------------start: orders_total---------------");
    #endif
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
            TotalProfit = TotalProfit + OrderProfit();
            #ifdef act
                OrderPrint();
                Print("OrderProfit: ", OrderProfit());
            #endif
        }
    }
    #ifdef act
        if (orders_total > 0)
        Print("-------------end: orders_total--------------");
    #endif
    return TotalProfit;
}

double AccountInfoUtils::GetCurrentBuyFloatingProfit() {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_BUY) {
            TotalProfit = TotalProfit + OrderProfit();
        }
    }
    return(TotalProfit);
}

double AccountInfoUtils::GetCurrentSellFloatingProfit() {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL) {
            TotalProfit = TotalProfit + OrderProfit();
        }
    }
    return(TotalProfit);
}