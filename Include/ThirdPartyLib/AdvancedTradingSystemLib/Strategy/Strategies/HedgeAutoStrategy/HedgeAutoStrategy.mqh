#include "DataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/HedgeAutoCenter/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

class HedgeAutoStrategy : public Strategy {
    public:
        HedgeAutoStrategy(string strategy_name) {
            PrintFormat("st_name: %s", strategy_name);
            this.hedge_auto_order_group_center_ = new HedgeAutoOrderGroupCenter("ha_center");
            if (!hedge_auto_order_group_center_.IsInitSuccess()) {
                this.init_success_ = false;
                return;
            }
            this.magic_sell_num_ = -1;
            this.magic_buy_num_ = 1;
            this.magic_big_buy_num_ = 2;
            this.magic_big_sell_num_ = -2;
            this.hedge_auto_order_group_ = new HedgeAutoOrderGroup(
                                                    "ha_group", this.hedge_auto_order_group_center_);
            this.init_success_ = this.HedgeAutoStrategyCommonConstructor(strategy_name);
        };
        ~HedgeAutoStrategy() {
            PrintFormat("Deinitialize AutoAdjustStrategy [%s].", this.strategy_name_);
            SafeDeletePtr(this.params_);
            SafeDeletePtr(this.hedge_auto_order_group_center_);
            SafeDeletePtr(this.hedge_auto_order_group_);
        };
    // Implements the abstract methods in base class Strategy
    public:
        int ExecuteStrategy() const;
        int BeforeTickExecute();
        int OnTickExecute();
        int AfterTickExecute();
        int OnActionExecute();
        void PrintStrategyInfo() const;
//        HedgeAutoStrategyParams* GetParams() { return this.params_; }

    private:
        bool HedgeAutoStrategyCommonConstructor(string strategy_name) {
            this.strategy_name_ = strategy_name;
            this.config_file_ = new ConfigFile("hedge_auto_config.txt");
            this.params_ = new HedgeAutoStrategyParams(this.config_file_);
            this.params_.PrintAllParams();
            if (!this.params_.IsParamsValid()) {
                PrintFormat("Params of  HedgeAutoStrategy [%s] is invalid, Init Failed!",
                            this.strategy_name_);
                return false;
            }
            PrintFormat("Initialize AutoAdjustStrategy [%s].", this.strategy_name_);
            return true;
        }
        bool ExecuteBuyOnTick();
        bool ExecuteSellOnTick();
        double GetAddLots(double base_lots, double lots_exponent, int num_orders, double lots_max);
        double GetTargetMoney(double base_lots, double target_money_factor,
                              int num_orders, double lots_exponent);
        double GetTargetMoneyByTotalLots(double total_lots, double target_money_factor);
    private:
        int magic_sell_num_;
        int magic_buy_num_;
        int magic_big_buy_num_;
        int magic_big_sell_num_;
        bool is_big_sell_act;
        bool is_big_buy_act;
        HedgeAutoStrategyParams* params_;
        HedgeAutoOrderGroupCenter* hedge_auto_order_group_center_;
        HedgeAutoOrderGroup* hedge_auto_order_group_;
};