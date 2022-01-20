#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/DataStructure.mqh>

class TrendingStrategyParams : StrategyParams {
	public:
		TrendingStrategyParams(ConfigFile* config_file) : StrategyParams(config_file) {
// TrendingParamTitle
			this.param_1 = INTEGER_MIN_INT;
			this.param_2 = INTEGER_MIN_INT;
// Refresh at the final step
			this.RefreshStrategyParams();
		}
		~TrendingStrategyParams() {};
	public:
		void PrintAllParams();
		void RefreshStrategyParams();
		bool IsParamsValid();
	public:
// TrendingParamTitle
			double param_1;
			double param_2;
};

bool TrendingStrategyParams::IsParamsValid() {
	return true;
};
void TrendingStrategyParams::PrintAllParams() {
	PrintFormat("-------------------------- Starts TrendingStrategyParams --------------------");
// TrendingParamTitle
	PrintFormat("TrendingStrategyParams [%s:%.4f]", "param_1", this.param_1);
	PrintFormat("TrendingStrategyParams [%s:%.4f]", "param_2", this.param_2);
	PrintFormat("-------------------------- Ends TrendingStrategyParams --------------------");
};
void TrendingStrategyParams::RefreshStrategyParams() {
	this.config_file_.RefreshConfigFile();
// TrendingParamTitle
	this.param_1 = StringToDouble(this.AssignConfigItem("TrendingParamTitle", "param_1"));
	this.param_2 = StringToDouble(this.AssignConfigItem("TrendingParamTitle", "param_2"));
};