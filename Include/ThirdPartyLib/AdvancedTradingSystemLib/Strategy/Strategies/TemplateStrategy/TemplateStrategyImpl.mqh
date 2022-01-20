#include "TemplateStrategy.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

int TemplateStrategy::ExecuteStrategy() const {
    return SUCCEEDED;
}
int TemplateStrategy::BeforeTickExecute() {
    if (!this.params_.IsParamsValid()) {
        return FAILED;
    }
    return SUCCEEDED;
}
int TemplateStrategy::OnTickExecute() {
    PrintFormat("%s OnTickExecute", this.strategy_name_);
    return SUCCEEDED;
}
int TemplateStrategy::AfterTickExecute() {
    return SUCCEEDED;
};
int TemplateStrategy::OnActionExecute() {
    return SUCCEEDED;
}
void TemplateStrategy::PrintStrategyInfo() const {

}