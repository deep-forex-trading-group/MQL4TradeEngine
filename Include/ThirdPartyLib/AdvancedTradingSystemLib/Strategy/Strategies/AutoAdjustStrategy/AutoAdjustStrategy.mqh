#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "../../StrategyBase/all.mqh"
#include "DataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/AutoAdjustCenter/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class AutoAdjustStrategy : public Strategy {
    public:
        AutoAdjustStrategy(string strategy_name) {
            this.auto_adjust_order_group_center_ = new AutoAdjustOrderGroupCenter("ad_center");
            this.auto_adjust_order_group_ = new AutoAdjustOrderGroup(
                                                    "ad_group", this.auto_adjust_order_group_center_);
            this.AutoAdjustStrategyCommonConstructor(strategy_name);
        };
        AutoAdjustStrategy(string strategy_name,
                           AutoAdjustOrderGroup* auto_adjust_order_group,
                           AutoAdjustOrderGroupCenter* auto_adjust_order_group_center)
                            : auto_adjust_order_group_(auto_adjust_order_group),
                              auto_adjust_order_group_center_(auto_adjust_order_group_center) {
            this.AutoAdjustStrategyCommonConstructor(strategy_name);
        };
        ~AutoAdjustStrategy() {
            PrintFormat("Deinitialize AutoAdjustStrategy [%s].", this.strategy_name_);
            SaveDeletePtr(this.auto_adjust_order_group_);
            SaveDeletePtr(this.auto_adjust_order_group_center_);
            SaveDeletePtr(this.params_);
            SaveDeletePtr(this.ou_get_);
            SaveDeletePtr(this.ou_send_);
        };
    private:
        bool AutoAdjustStrategyCommonConstructor(string strategy_name) {
            this.strategy_name_ = strategy_name;
            this.config_file_ = new ConfigFile("adjust_config.txt");
            this.params_ = new AutoAdjustStrategyParams(this.config_file_);
            if (!this.params_.IsParamsValid()) {
                PrintFormat("AutoAdjustStrategy [%s] is invalid, Init Failed! ", this.strategy_name_);
                return false;
            }
            this.params_.PrintAllParams();
            this.auto_adjust_order_group_.AddsExtraOrderMagicNumber(this.params_.sig_order_magic_number);
            this.ou_get_ = new OrderGetUtils();
            this.ou_send_ = new OrderSendUtils();
            PrintFormat("Initialize AutoAdjustStrategy [%s].", this.strategy_name_);
            return true;
        }

// Implements the abstract methods in base class Strategy
    public:
        int ExecuteStrategy() const;
        int OnTickExecute();
        int OnActionExecute();
        int SetAutoAdjustOrderGroup(AutoAdjustOrderGroup* auto_adjust_order_group);
        void PrintStrategyInfo() const;
        AutoAdjustStrategyParams* GetAutoAdjustStrategyParams() {
            return this.params_;
        }
    private:
        AutoAdjustOrderGroup* auto_adjust_order_group_;
        AutoAdjustOrderGroupCenter* auto_adjust_order_group_center_;
        AutoAdjustStrategyParams* params_;
        OrderGetUtils* ou_get_;
        OrderSendUtils* ou_send_;
};