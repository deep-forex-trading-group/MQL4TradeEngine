#include "../OrderGroupCenterBase/all.mqh"
#include "AutoAdjustOrderGroupCenter.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderInMarket.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/AutoAdjustStrategies/DataStructure.mqh>


class AutoAdjustOrderGroup : public OrderGroup {
    public:
        AutoAdjustOrderGroup(string name, AutoAdjustOrderGroupCenter *order_group_center_ptr)
                                : name_(name), OrderGroup(order_group_center_ptr){
            this.config_file_ = new ConfigFile("Config", "adjust_config.txt");
            this.strategy_ = new AutoAdjustStrategy("auto_adjust_st_testing");
            this.strategy_.SetConfigFile(this.config_file_);
            this.st_ctx_ = new StrategyContext(this.strategy_);
        };
        ~AutoAdjustOrderGroup() {
            SaveDeletePtr(this.config_file_);
            SaveDeletePtr(this.strategy_);
            SaveDeletePtr(this.st_ctx_);
        };

    public:
        int OnTick();
        int OnAction();
        // Gets the information about max_floating_loss_/max_floating_profits_/cur_profit_;
        double GetCurrentProfit();
    private:
        string name_;
        ConfigFile* config_file_;
        StrategyContext* st_ctx_;
        AutoAdjustStrategy* strategy_;
        double max_floating_loss_;
        double max_floating_profits_;
        double cur_profit_;
};

int AutoAdjustOrderGroup::OnTick() {
    this.GetCurrentProfit();
    PrintFormat("current_profit: %.2f", this.cur_profit_);
    return SUCCEEDED;
}

int AutoAdjustOrderGroup::OnAction() {
    AutoAdjustStrategyParams* params = new AutoAdjustStrategyParams();
    params.magic_number_cur_order = this.GenerateNewOrderMagicNumber();
    this.strategy_.SetStrategyParams(params);
    this.st_ctx_.SetStrategy(this.strategy_);
    this.st_ctx_.ExecuteStrategy();
    delete params;
    return SUCCEEDED;
}

double AutoAdjustOrderGroup::GetCurrentProfit() {
    this.GetOrdersByGroupId();
    this.cur_profit_ = 0;
    for (int cc_states_i = 0; cc_states_i < ArraySize(this.orders_in_trades); cc_states_i++) {
        this.cur_profit_ += this.orders_in_trades[cc_states_i].order_profit;
    }
    return this.cur_profit_;
}
