class OrderInMarket {
    public:
       double order_lots;
       double order_open_price;
       double order_close_price;
       string order_comment;
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
        int copyOrder(OrderInMarket& dst[]);
};

void OrderInMarket::PrintOrderInMarket() {
    PrintFormat("OrderInMarket <%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s>",
                order_lots, order_open_price, order_close_price,
                order_comment, order_close_time, order_profit,
                order_type, order_ticket, order_position,
                order_swap, order_commission);
}

int OrderInMarket::copyOrder(OrderInMarket& dst[]) {
    OrderInMarket other();

    other.order_lots = this.order_lots;
    other.order_open_price = this.order_open_price;
    other.order_close_price = this.order_close_price;
    other.order_comment = this.order_comment;
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

