#include "DataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/AutoAdjustCenter/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>

class AutoAdjustStrategy : public Strategy {
    public:
        AutoAdjustStrategy(string strategy_name) :
                           is_sig_buy_activated_(false) {
            this.auto_adjust_order_group_center_ = new AutoAdjustOrderGroupCenter("ad_center");
            if (!this.auto_adjust_order_group_center_.IsInitSuccess()) {
                this.init_success_ = false;
                return;
            }
            this.init_success_ = true;
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
            SafeDeletePtr(this.auto_adjust_order_group_);
            SafeDeletePtr(this.auto_adjust_order_group_center_);
            SafeDeletePtr(this.params_);
        };

// Implements the abstract methods in base class Strategy
    public:
        bool IsInitSuccess() { return this.init_success_; };
        int ExecuteStrategy() const;
        int OnTickExecute(CommentContent* comment_content);
        int OnTickExecute();
        void OnTickSetUIAutoInfo(UIAutoInfo& ui_auto_info) {
            this.is_sig_buy_activated_ = ui_auto_info.is_sig_buy_activated;
            this.is_sig_sell_activated_ = ui_auto_info.is_sig_sell_activated;
        }
        int OnActionExecute();
        int SetAutoAdjustOrderGroup(AutoAdjustOrderGroup* auto_adjust_order_group);
        void PrintStrategyInfo() const;
        AutoAdjustStrategyParams* GetAutoAdjustStrategyParams() {
            return this.params_;
        }
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
            PrintFormat("Initialize AutoAdjustStrategy [%s].", this.strategy_name_);
            return true;
        }
        void OnTickShowBasicInfo();
    private:
        bool init_success_;
        bool is_sig_buy_activated_;
        bool is_sig_sell_activated_;
        CommentContent* comment_content_;
    private:
        AutoAdjustOrderGroup* auto_adjust_order_group_;
        AutoAdjustOrderGroupCenter* auto_adjust_order_group_center_;
        AutoAdjustStrategyParams* params_;
};