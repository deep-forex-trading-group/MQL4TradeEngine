#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/DataStructure.mqh>

class TemplateStrategyParams : StrategyParams {
	public:
		TemplateStrategyParams(ConfigFile* config_file) : StrategyParams(config_file) {
// TemplateParamTitle
			this.param_1 = INTEGER_MIN_INT;
			this.param_2 = INTEGER_MIN_INT;
// Refresh at the final step
			this.RefreshStrategyParams();
		}
		~TemplateStrategyParams() {};
	public:
		void PrintAllParams();
		void RefreshStrategyParams();
		bool IsParamsValid();
	public:
// TemplateParamTitle
			double param_1;
			double param_2;
};

bool TemplateStrategyParams::IsParamsValid() {
	return true;
};
void TemplateStrategyParams::PrintAllParams() {
	PrintFormat("-------------------------- Starts TemplateStrategyParams --------------------");
// TemplateParamTitle
	PrintFormat("TemplateStrategyParams [%s:%.4f]", "param_1", this.param_1);
	PrintFormat("TemplateStrategyParams [%s:%.4f]", "param_2", this.param_2);
	PrintFormat("-------------------------- Ends TemplateStrategyParams --------------------");
};
void TemplateStrategyParams::RefreshStrategyParams() {
	this.config_file_.RefreshConfigFile();
// TemplateParamTitle
	this.param_1 = StringToDouble(this.AssignConfigItem("TemplateParamTitle", "param_1"));
	this.param_2 = StringToDouble(this.AssignConfigItem("TemplateParamTitle", "param_2"));
};