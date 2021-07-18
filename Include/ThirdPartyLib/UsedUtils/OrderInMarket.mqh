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

public:
    OrderInMarket() {}
    ~OrderInMarket() {}
    void PrintOrderInMarket() {
        PrintFormat("OrderInMarket <%s, %s, %s, %s, %s, %s, %s, %s, %s>",
                    order_lots, order_open_price, order_close_price,
                    order_comment, order_close_time, order_profit,
                    order_type, order_ticket, order_position);
    }
};