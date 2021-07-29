// #ifndef act
//    #define act
// #endif

class AccountInfoUtils {
    public:
        AccountInfoUtils() {};
        ~AccountInfoUtils() {};
    public:
       static double GetCurrentTotalProfit(int magic_number);
       static double GetCurrentFloatingProfit(int magic_number);
       static double GetCurrentBuyFloatingProfit(int magic_number);
       static double GetCurrentSellFloatingProfit(int magic_number);
};

double AccountInfoUtils::GetCurrentTotalProfit(int magic_number) {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == magic_number) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();;
        }
    }

    int orders_history_total = OrdersHistoryTotal();
    for (int oh_i = orders_history_total - 1; oh_i >= 0; oh_i--) {
        if (OrderSelect(oh_i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == magic_number) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();;
        }
    }

    return(TotalProfit);
}

double AccountInfoUtils::GetCurrentFloatingProfit(int magic_number) {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    #ifdef act
        if (orders_total > 0)
        Print("------------start: orders_total---------------");
    #endif
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == magic_number) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();
            #ifdef act
                OrderPrint();
                Print("OrderProfit: ", OrderProfit() + OrderCommission() + OrderSwap());
            #endif
        }
    }
    #ifdef act
        if (orders_total > 0)
        Print("-------------end: orders_total--------------");
    #endif
    return TotalProfit;
}

double AccountInfoUtils::GetCurrentBuyFloatingProfit(int magic_number) {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_BUY && OrderMagicNumber() == magic_number) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();
        }
    }
    return(TotalProfit);
}

double AccountInfoUtils::GetCurrentSellFloatingProfit(int magic_number) {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderType() == OP_SELL && OrderMagicNumber() == magic_number) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();
        }
    }
    return(TotalProfit);
}