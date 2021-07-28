class AutoAdjustStrategyParams {
    public:
        AutoAdjustStrategyParams() {
            this.magic_number_cur_order = -1;
        };
        ~AutoAdjustStrategyParams() {};

    public:
        void printAllParams();

    public:
        int magic_number_cur_order;
};

void AutoAdjustStrategyParams::printAllParams() {
    PrintFormat("AutoAdjustStrategyParams[%s:%d]",
                "magic_number_cur_order", this.magic_number_cur_order);
};