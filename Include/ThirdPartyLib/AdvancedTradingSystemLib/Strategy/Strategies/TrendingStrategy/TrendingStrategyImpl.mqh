#include "TrendingStrategy.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

int TrendingStrategy::ExecuteStrategy() const {
    return SUCCEEDED;
}
int TrendingStrategy::BeforeTickExecute() {
    if (!this.params_.IsParamsValid()) {
        return FAILED;
    }
    return SUCCEEDED;
}
int TrendingStrategy::OnTickExecute() {
    PrintFormat("%s OnTickExecute", this.strategy_name_);
    return SUCCEEDED;
}
int TrendingStrategy::AfterTickExecute() {
    return SUCCEEDED;
};
int TrendingStrategy::OnActionExecute() {
    return SUCCEEDED;
}
void TrendingStrategy::PrintStrategyInfo() const {

}