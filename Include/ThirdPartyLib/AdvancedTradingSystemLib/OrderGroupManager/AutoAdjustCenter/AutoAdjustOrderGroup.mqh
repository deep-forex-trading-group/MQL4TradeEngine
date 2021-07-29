#include "../OrderGroupCenterBase/all.mqh"
#include "AutoAdjustOrderGroupCenter.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderInMarket.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class AutoAdjustOrderGroup : public OrderGroup {
    public:
        AutoAdjustOrderGroup(string name, AutoAdjustOrderGroupCenter *order_group_center_ptr)
                                : name_(name), OrderGroup(order_group_center_ptr){
            this.config_file_ = new ConfigFile("Config", "adjust_config.txt");
        };
        ~AutoAdjustOrderGroup() {
            SaveDeletePtr(this.config_file_);
        };

    public:
        // Gets the information about max_floating_loss_/max_floating_profits_/cur_profit_;
        double GetCurrentProfit();
    private:
        string name_;
        ConfigFile* config_file_;
        double max_floating_loss_;
        double max_floating_profits_;
        double cur_profit_;
};

double AutoAdjustOrderGroup::GetCurrentProfit() {
    this.GetOrdersByGroupId();
    this.cur_profit_ = 0;
    for (int cc_states_i = 0; cc_states_i < ArraySize(this.orders_in_trades); cc_states_i++) {
        this.cur_profit_ += this.orders_in_trades[cc_states_i].order_profit;
    }
    return this.cur_profit_;
}
