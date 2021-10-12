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
        AutoAdjustStrategy(string strategy_name) {
            this.auto_adjust_order_group_center_ = new AutoAdjustOrderGroupCenter("ad_center");
            if (!this.auto_adjust_order_group_center_.IsInitSuccess()) {
                this.init_success_ = false;
                return;
            }
            this.init_success_ = true;
            this.auto_adjust_order_group_ = new AutoAdjustOrderGroup(
                                                    "ad_group", this.auto_adjust_order_group_center_);
            if (!this.AutoAdjustStrategyCommonConstructor(strategy_name)) {
                this.init_success_ = false;
            }
        };
        AutoAdjustStrategy(string strategy_name,
                           AutoAdjustOrderGroup* auto_adjust_order_group,
                           AutoAdjustOrderGroupCenter* auto_adjust_order_group_center)
                            : auto_adjust_order_group_(auto_adjust_order_group),
                              auto_adjust_order_group_center_(auto_adjust_order_group_center) {
            if (!this.AutoAdjustStrategyCommonConstructor(strategy_name)) {
                this.init_success_ = false;
            }
        };
        ~AutoAdjustStrategy() {
            PrintFormat("Deinitialize AutoAdjustStrategy [%s].", this.strategy_name_);
            SafeDeletePtr(this.auto_adjust_order_group_);
            SafeDeletePtr(this.auto_adjust_order_group_center_);
            SafeDeletePtr(this.params_);
        };

// Implements the abstract methods in base class Strategy
    public:
        int ExecuteStrategy() const;
        int BeforeTickExecute();
        int OnTickExecute();
        int AfterTickExecute();
        void OnTickSetUIAutoInfo(UIAutoInfo& ui_auto_info) {
            this.ui_auto_info_ = ui_auto_info;
        }
        int OnActionExecute();
        int SetAutoAdjustOrderGroup(AutoAdjustOrderGroup* auto_adjust_order_group);
        void PrintStrategyInfo() const;
        AutoAdjustStrategyParams* GetAutoAdjustStrategyParams() { return this.params_; }
    private:
        bool AutoAdjustStrategyCommonConstructor(string strategy_name) {
            this.strategy_name_ = strategy_name;
            this.config_file_ = new ConfigFile("adjust_config.txt");
            this.params_ = new AutoAdjustStrategyParams(this.config_file_);
            if (!this.params_.IsParamsValid()) {
                PrintFormat("Params of AutoAdjustStrategy [%s] is invalid, Init Failed! ", this.strategy_name_);
                return false;
            }
            this.params_.PrintAllParams();
            this.num_part_close_ = 0;
            PrintFormat("Initialize AutoAdjustStrategy [%s].", this.strategy_name_);
            return true;
        }
        void BeforeTickShowBasicInfo();
        int CheckMNUpdate() {
            if (this.auto_adjust_order_group_.GetTotalNumOfOrdersInTrades() == 0
                && !this.auto_adjust_order_group_.UpdateMagicNumbersAll()) {
                PrintFormat("UpdatedMagicNumber failed, Strategy[%s] BANNED.",
                            this.strategy_name_);
                return FAILED;
            }
            return SUCCEEDED;
        }
        double GetCurrentAddLotsByFactor(double cur_total_lots);
        double GetCurrentAddLots(int num_orders);
        double GetCurrentAddLotsManual(int num_orders);
        double GetCurrentManulLots();
        double GetLotsBase(double start_lots, double part_close_factor, int num_part_close) {
            return MarketInfoUtils::NormalizeLotsUp(
                                    start_lots / MathPow((1/part_close_factor), num_part_close));
        }
        // Checks Current Level (for auto part close)
        bool CheckIfAutoPartClose(double cur_total_lots, double cur_total_profit,
                                  bool is_cur_level_already_part_close);
        void ResetNumPartClose() { this.num_part_close_ = 0; }
        // TODO:所有与组状态相关的变量，加上Set UnSet 和 Reset方法
        void SetIsCurLevelAlreadyPartClose() { this.is_cur_level_already_part_close_ = true; }
        void UnSetIsCurLevelAlreadyPartClose() { this.is_cur_level_already_part_close_ = false; }
        void ResetIsCurLevelAlreadyPartClose() { this.UnSetIsCurLevelAlreadyPartClose(); }
        void IncNumPartClose() { this.num_part_close_++; }
    private:
        UIAutoInfo ui_auto_info_;
        int num_part_close_;
        bool is_cur_level_already_part_close_;
    private:
        AutoAdjustOrderGroup* auto_adjust_order_group_;
        AutoAdjustOrderGroupCenter* auto_adjust_order_group_center_;
        AutoAdjustStrategyParams* params_;
};