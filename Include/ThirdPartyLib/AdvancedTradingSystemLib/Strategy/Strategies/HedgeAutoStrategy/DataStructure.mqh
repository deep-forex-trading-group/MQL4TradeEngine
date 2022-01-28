#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/DataStructure.mqh>

class HedgeAutoStrategyParams : StrategyParams {
	public:
		HedgeAutoStrategyParams(ConfigFile* config_file) : StrategyParams(config_file) {
// SwitchOff
			this.buy_or_sell = INTEGER_MIN_INT;
// PipStepParams
			this.pip_step = INTEGER_MIN_INT;
			this.pip_step_max = INTEGER_MIN_INT;
			this.pip_factor = INTEGER_MIN_INT;
			this.pip_step_exponent = INTEGER_MIN_INT;
// LotsParams
			this.start_lots = INTEGER_MIN_INT;
			this.lots_exponent = INTEGER_MIN_INT;
			this.lots_max = INTEGER_MIN_INT;
// TargetMoneyParams
			this.target_factor = INTEGER_MIN_INT;
			this.first_batch_target_factor = INTEGER_MIN_INT;
			this.first_batch_order_num = INTEGER_MIN_INT;
// BigLotsReverse
			this.big_lots_exponent = INTEGER_MIN_INT;
			this.big_lots_order_num = INTEGER_MIN_INT;
			this.big_lots_on_factor = INTEGER_MIN_INT;
// Refresh at the final step
			this.RefreshStrategyParams();
		}
		~HedgeAutoStrategyParams() {};
	public:
		void PrintAllParams();
		void RefreshStrategyParams();
		bool IsParamsValid();
	public:
// SwitchOff
			double buy_or_sell;
// PipStepParams
			double pip_step;
			double pip_step_max;
			double pip_factor;
			double pip_step_exponent;
// LotsParams
			double start_lots;
			double lots_exponent;
			double lots_max;
// TargetMoneyParams
			double target_factor;
			double first_batch_target_factor;
			double first_batch_order_num;
// BigLotsReverse
			double big_lots_exponent;
			double big_lots_order_num;
			double big_lots_on_factor;
};

bool HedgeAutoStrategyParams::IsParamsValid() {
	return true;
};
void HedgeAutoStrategyParams::PrintAllParams() {
	PrintFormat("-------------------------- Starts HedgeAutoStrategyParams --------------------");
// SwitchOff
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "buy_or_sell", this.buy_or_sell);
// PipStepParams
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "pip_step", this.pip_step);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "pip_step_max", this.pip_step_max);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "pip_factor", this.pip_factor);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "pip_step_exponent", this.pip_step_exponent);
// LotsParams
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "start_lots", this.start_lots);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "lots_exponent", this.lots_exponent);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "lots_max", this.lots_max);
// TargetMoneyParams
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "target_factor", this.target_factor);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "first_batch_target_factor", this.first_batch_target_factor);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "first_batch_order_num", this.first_batch_order_num);
// BigLotsReverse
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "big_lots_exponent", this.big_lots_exponent);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "big_lots_order_num", this.big_lots_order_num);
	PrintFormat("HedgeAutoStrategyParams [%s:%.4f]", "big_lots_on_factor", this.big_lots_on_factor);
	PrintFormat("-------------------------- Ends HedgeAutoStrategyParams --------------------");
};
void HedgeAutoStrategyParams::RefreshStrategyParams() {
	this.config_file_.RefreshConfigFile();
// SwitchOff
	this.buy_or_sell = StringToDouble(this.AssignConfigItem("SwitchOff", "buy_or_sell"));
// PipStepParams
	this.pip_step = StringToDouble(this.AssignConfigItem("PipStepParams", "pip_step"));
	this.pip_step_max = StringToDouble(this.AssignConfigItem("PipStepParams", "pip_step_max"));
	this.pip_factor = StringToDouble(this.AssignConfigItem("PipStepParams", "pip_factor"));
	this.pip_step_exponent = StringToDouble(this.AssignConfigItem("PipStepParams", "pip_step_exponent"));
// LotsParams
	this.start_lots = StringToDouble(this.AssignConfigItem("LotsParams", "start_lots"));
	this.lots_exponent = StringToDouble(this.AssignConfigItem("LotsParams", "lots_exponent"));
	this.lots_max = StringToDouble(this.AssignConfigItem("LotsParams", "lots_max"));
// TargetMoneyParams
	this.target_factor = StringToDouble(this.AssignConfigItem("TargetMoneyParams", "target_factor"));
	this.first_batch_target_factor = StringToDouble(this.AssignConfigItem("TargetMoneyParams", "first_batch_target_factor"));
	this.first_batch_order_num = StringToDouble(this.AssignConfigItem("TargetMoneyParams", "first_batch_order_num"));
// BigLotsReverse
	this.big_lots_exponent = StringToDouble(this.AssignConfigItem("BigLotsReverse", "big_lots_exponent"));
	this.big_lots_order_num = StringToDouble(this.AssignConfigItem("BigLotsReverse", "big_lots_order_num"));
	this.big_lots_on_factor = StringToDouble(this.AssignConfigItem("BigLotsReverse", "big_lots_on_factor"));
};