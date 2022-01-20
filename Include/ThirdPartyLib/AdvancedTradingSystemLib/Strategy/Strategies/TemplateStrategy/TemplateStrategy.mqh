#include "DataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/HedgeAutoCenter/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

class TemplateStrategy : public Strategy {
    public:
        TemplateStrategy(string strategy_name) {
            PrintFormat("st_name: %s", strategy_name);
            this.init_success_ = this.TemplateStrategyCommonConstructor(strategy_name);
        }
        ~TemplateStrategy() {
            PrintFormat("Deinitialize TemplateStrategy [%s].", this.strategy_name_);
            // Delete the containers using SafeDeletePtr(CONTAINER_POINTER)
            SafeDeletePtr(this.params_);
        }
    // Implements the abstract methods in base class Strategy
    public:
        int ExecuteStrategy() const;
        int BeforeTickExecute();
        int OnTickExecute();
        int AfterTickExecute();
        int OnActionExecute();
        void PrintStrategyInfo() const;
    private:
        bool TemplateStrategyCommonConstructor(string strategy_name) {
            this.strategy_name_ = strategy_name;
            this.config_file_ = new ConfigFile("template_config.txt");
            this.params_ = new TemplateStrategyParams(this.config_file_);
            this.params_.PrintAllParams();
            if (!this.params_.IsParamsValid()) {
                PrintFormat("Params of TemplateStrategy [%s] is invalid, Init Failed!",
                            this.strategy_name_);
                return false;
            }
            PrintFormat("Initialize TemplateStrategy [%s] Successfully!", this.strategy_name_);
            return true;
        }
    private:
        TemplateStrategyParams* params_;
};