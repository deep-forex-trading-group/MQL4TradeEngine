#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/DataStructure.mqh>

class AutoAdjustStrategyParams : StrategyParams {
    public:
        AutoAdjustStrategyParams(ConfigFile* config_file) : StrategyParams(config_file) {
// Adjust Params
            this.pip_start_lots = INTEGER_MIN_INT;
            this.pip_step = INTEGER_MIN_INT;
            this.pip_factor = INTEGER_MIN_INT;
            this.sig_order_name = "default";
            this.sig_order_magic_number = INTEGER_MIN_INT;
            this.lots_exponent = INTEGER_MIN_INT;
            this.pip_step_exponent = INTEGER_MIN_INT;
// SignalOrder Params
            this.target_profit_factor = INTEGER_MIN_INT;
            this.RefreshStrategyParams();
        };
        ~AutoAdjustStrategyParams() {};

    public:
        void PrintAllParams();
        void RefreshStrategyParams();
        bool IsParamsValid();

    public:
// Adjust Params
        double pip_start_lots;
        double pip_step;
        double pip_factor;
        double lots_exponent;
        double pip_step_exponent;
        double target_profit_factor;
// SignalOrder Params
        string sig_order_name;
        int sig_order_magic_number;
};

bool AutoAdjustStrategyParams::IsParamsValid() {
// Adjust Params
    if (this.pip_start_lots >= 0.05) {
        return false;
    }

    if (this.pip_step <= 2) {
        return false;
    }

    if (this.pip_factor < 1 || this.pip_factor > 2) {
        return false;
    }

    if (this.lots_exponent < 1 || this.lots_exponent > 2) {
        return false;
    }

    if (this.pip_step_exponent < 1 || this.pip_step_exponent > 2) {
        return false;
    }

    if (this.target_profit_factor < 10 || this.target_profit_factor > 200) {
        return false;
    }

// SignalOrder Params
    if (this.sig_order_name == "default") {
        return false;
    }

    if (this.sig_order_magic_number == INTEGER_MIN_INT) {
        return false;
    }

    return true;
};
void AutoAdjustStrategyParams::PrintAllParams() {
// Adjust Params
    PrintFormat("-------------------------- Starts AutoAdjustStrategyParams --------------------");
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_start_lots", this.pip_start_lots);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_step", this.pip_step);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_factor", this.pip_factor);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "lots_exponent", this.lots_exponent);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_step_exponent", this.pip_step_exponent);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "target_profit_factor", this.target_profit_factor);
// SignalOrder Params
    PrintFormat("AutoAdjustStrategyParams [%s:%s]", "sig_order_name", this.sig_order_name);
    PrintFormat("AutoAdjustStrategyParams [%s:%d]", "sig_order_magic_number", this.sig_order_magic_number);
    PrintFormat("-------------------------- Ends AutoAdjustStrategyParams --------------------");
};
void AutoAdjustStrategyParams::RefreshStrategyParams() {
    this.config_file_.RefreshConfigFile();

// Adjust Params
    this.pip_start_lots = StringToDouble(this.AssignConfigItem("Adjust", "pip_start_lots"));
    this.pip_step = StringToDouble(this.AssignConfigItem("Adjust", "pip_step"));
    this.pip_factor = StringToDouble(this.AssignConfigItem("Adjust", "pip_factor"));
    this.lots_exponent = StringToDouble(this.AssignConfigItem("Adjust", "lots_exponent"));
    this.pip_step_exponent = StringToDouble(this.AssignConfigItem("Adjust", "pip_step_exponent"));
    this.target_profit_factor = StringToDouble(this.AssignConfigItem("Adjust", "target_profit_factor"));

// SignalOrder Params
    this.sig_order_name = this.AssignConfigItem("SignalOrder", "sig_order_name");
    this.sig_order_magic_number = (int) StringToInteger(this.AssignConfigItem("SignalOrder", "sig_order_magic_number"));
}