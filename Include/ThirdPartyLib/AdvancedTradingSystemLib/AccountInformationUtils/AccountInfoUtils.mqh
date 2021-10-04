// #ifndef act
//    #define act
// #endif
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashSet.mqh>

class AccountInfoUtils {
    public:
        AccountInfoUtils() {};
        ~AccountInfoUtils() {};
    public:
       static double GetCurrentTotalProfit(int magic_number);
       static double GetCurrentTotalProfit(HashSet<int>* magic_number);
       static double GetCurrentTotalLots(int magic_number);
       static double GetCurrentTotalLots(HashSet<int>* magic_number);
       static double GetCurrentFloatingProfit(int magic_number);
       static double GetCurrentFloatingProfit(HashSet<int>* magic_number);
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
double AccountInfoUtils::GetCurrentTotalProfit(HashSet<int>* magic_number_set) {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && magic_number_set.contains(OrderMagicNumber())) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();;
        }
    }

    int orders_history_total = OrdersHistoryTotal();
    for (int oh_i = orders_history_total - 1; oh_i >= 0; oh_i--) {
        if (OrderSelect(oh_i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol()
            && magic_number_set.contains(OrderMagicNumber())) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();;
        }
    }

    return(TotalProfit);
}
double AccountInfoUtils::GetCurrentTotalLots(int magic_number) {
    double total_lots = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == magic_number) {
            total_lots = total_lots + OrderLots();
        }
    }
    return total_lots;
}
double AccountInfoUtils::GetCurrentTotalLots(HashSet<int>* magic_number_set) {
    double total_lots = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && magic_number_set.contains(OrderMagicNumber())) {
            total_lots = total_lots + OrderLots();
        }
    }
    return total_lots;
}
double AccountInfoUtils::GetCurrentFloatingProfit(int magic_number) {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && OrderMagicNumber() == magic_number) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();
        }
    }
    return TotalProfit;
}
double AccountInfoUtils::GetCurrentFloatingProfit(HashSet<int>* magic_number) {
    double TotalProfit = 0;
    int orders_total = OrdersTotal();
    for (int i = orders_total - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()
            && magic_number.contains(OrderMagicNumber())) {
            TotalProfit = TotalProfit + OrderProfit() + OrderCommission() + OrderSwap();
        }
    }
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