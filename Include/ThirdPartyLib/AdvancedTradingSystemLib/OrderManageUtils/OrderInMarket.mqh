class OrderInMarket {
    public:
       int order_magic_number;
       double order_lots;
       double order_open_price;
       double order_close_price;
       string order_comment;
       datetime order_open_time;
       datetime order_close_time;
       double order_profit;
       int order_type;
       int order_ticket;
       int order_position;
       double order_swap;
       double order_commission;

    public:
        OrderInMarket() {}
        ~OrderInMarket() {}
        void PrintOrderInMarket();
        void GetOrderFromMarket(int order_position_in);
        int copyOrder(OrderInMarket& dst[]);
};

void OrderInMarket::PrintOrderInMarket() {
    string order_close_dt_str = "" + (string) order_close_time;
    string order_open_dt_str = "" + (string) order_open_time;
    PrintFormat("OrderInMarket <%d, %.6f, %.6f, %.6f, %s, %s, %s, %.6f,%d, %d, %d, %.6f, %.6f>",
                order_magic_number, order_lots, order_open_price, order_close_price,
                order_comment, order_open_dt_str, order_close_dt_str, order_profit,
                order_type, order_ticket, order_position,
                order_swap, order_commission);
}

void OrderInMarket::GetOrderFromMarket(int order_position_in) {
    this.order_magic_number = OrderMagicNumber();
    this.order_lots = OrderLots();
    this.order_open_price = OrderOpenPrice();
    this.order_close_price = OrderClosePrice();
    this.order_comment = OrderComment();
    this.order_open_time = OrderOpenTime();
    this.order_close_time = OrderCloseTime();
    this.order_profit = OrderProfit();
    this.order_type = OrderType();
    this.order_ticket = OrderTicket();
    this.order_position = order_position_in;
    this.order_swap = OrderSwap();
    this.order_commission = OrderCommission();
}

int OrderInMarket::copyOrder(OrderInMarket& dst[]) {
    OrderInMarket other();

    other.order_magic_number = this.order_magic_number;
    other.order_lots = this.order_lots;
    other.order_open_price = this.order_open_price;
    other.order_close_price = this.order_close_price;
    other.order_comment = this.order_comment;
    other.order_open_time = this.order_open_time;
    other.order_close_time = this.order_close_time;
    other.order_profit = this.order_profit;
    other.order_type = this.order_type;
    other.order_ticket = this.order_ticket;
    other.order_position = this.order_position;
    other.order_swap = this.order_swap;
    other.order_commission = this.order_commission;
    
    ArrayResize(dst, 1);
    dst[0] = other;
    return 0;
}

