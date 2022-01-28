#include "DataStructure.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderGroupManager/HedgeAutoCenter/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/MarketInfoUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

class TrendingStrategy : public Strategy {
    public:
        TrendingStrategy(string strategy_name) {
            PrintFormat("st_name: %s", strategy_name);
            this.init_success_ = this.TrendingStrategyCommonConstructor(strategy_name);
        }
        ~TrendingStrategy() {
            PrintFormat("Deinitialize TrendingStrategy [%s].", this.strategy_name_);
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
        bool TrendingStrategyCommonConstructor(string strategy_name) {
            this.strategy_name_ = strategy_name;
            this.config_file_ = new ConfigFile("trending_config.txt");
            this.params_ = new TrendingStrategyParams(this.config_file_);
            this.params_.PrintAllParams();
            if (!this.params_.IsParamsValid()) {
                PrintFormat("Params of TrendingStrategy [%s] is invalid, Init Failed!",
                            this.strategy_name_);
                return false;
            }
            PrintFormat("Initialize TrendingStrategy [%s] Successfully!", this.strategy_name_);
            return true;
        }
    private:
        TrendingStrategyParams* params_;
};