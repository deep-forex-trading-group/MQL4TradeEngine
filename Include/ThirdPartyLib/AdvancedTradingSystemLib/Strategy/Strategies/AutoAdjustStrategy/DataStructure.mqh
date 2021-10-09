#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/DataStructure.mqh>

class AutoAdjustStrategyParams : StrategyParams {
    public:
        AutoAdjustStrategyParams(ConfigFile* config_file) : StrategyParams(config_file) {
// Adjust Params
            this.start_lots = INTEGER_MIN_INT;
            this.pip_step = INTEGER_MIN_INT;
            this.pip_step_max = INTEGER_MAX_INT;
            this.pip_factor = INTEGER_MIN_INT;
            this.lots_exponent = INTEGER_MIN_INT;
            this.target_profit_factor = INTEGER_MIN_INT;
            this.pip_step_exponent = INTEGER_MIN_INT;
// Refreshes Strategy Params
            this.RefreshStrategyParams();
        };
        ~AutoAdjustStrategyParams() {};

    public:
        void PrintAllParams();
        void RefreshStrategyParams();
        bool IsParamsValid();

    public:
// PipStepParams
        double pip_step;
        double pip_step_max;
        double pip_factor;
        double pip_step_exponent;
// LotsParams
        double start_lots;
        double lots_exponent;
        double lots_max;
// [Auto]
        double is_auto_sig;
        double auto_dir;
// [Close]
        double total_close_factor;
// [Target]
        double target_profit_factor;
};

bool AutoAdjustStrategyParams::IsParamsValid() {
// PipStepParams
    if (this.pip_step <= 2) {
        return false;
    }

    if (this.pip_step_max >= INTEGER_MAX_INT) {
        return false;
    }

    if (this.pip_factor < 1 || this.pip_factor > 2) {
        return false;
    }

    if (this.pip_step_exponent < 1 || this.pip_step_exponent > 2) {
        return false;
    }
// LotsParams
    if (this.start_lots >= 0.5) {
        return false;
    }

    if (this.lots_exponent < 1 || this.lots_exponent > 5) {
        return false;
    }

    if (this.lots_max > 5) {
        return false;
    }
// Auto
    if (!(this.is_auto_sig == 0 || this.is_auto_sig == 1)) {
        return false;
    }

    if (!(this.auto_dir == 0 || this.auto_dir == 1)) {
        return false;
    }
// Target
    if (this.target_profit_factor < 10 || this.target_profit_factor > 200000) {
        return false;
    }
// Close
    if (!(this.total_close_factor >= 0 && this.total_close_factor < 1)) {
        return false;
    }
    return true;
};
void AutoAdjustStrategyParams::PrintAllParams() {
    PrintFormat("-------------------------- Starts AutoAdjustStrategyParams --------------------");
// PipStepParams
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_step", this.pip_step);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_step_max", this.pip_step_max);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_factor", this.pip_factor);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_step_exponent", this.pip_step_exponent);
// LotsParams
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "start_lots", this.start_lots);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "lots_exponent", this.lots_exponent);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "lots_max", this.lots_max);
// Auto
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "is_auto_sig", this.is_auto_sig);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "auto_dir", this.auto_dir);
// Target
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "target_profit_factor", this.target_profit_factor);
// Close
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "total_close_factor", this.total_close_factor);
    PrintFormat("-------------------------- Ends AutoAdjustStrategyParams --------------------");
};
void AutoAdjustStrategyParams::RefreshStrategyParams() {
    this.config_file_.RefreshConfigFile();

// PipStepParams
    this.pip_step = StringToDouble(this.AssignConfigItem("PipStepParams", "pip_step"));
    this.pip_step_max = StringToDouble(this.AssignConfigItem("PipStepParams", "pip_step_max"));
    this.pip_factor = StringToDouble(this.AssignConfigItem("PipStepParams", "pip_factor"));
    this.pip_step_exponent = StringToDouble(this.AssignConfigItem("PipStepParams", "pip_step_exponent"));
// LotsParams
    this.start_lots = StringToDouble(this.AssignConfigItem("LotsParams", "start_lots"));
    this.lots_exponent = StringToDouble(this.AssignConfigItem("LotsParams", "lots_exponent"));
    this.lots_max = StringToDouble(this.AssignConfigItem("LotsParams", "lots_max"));
// Auto Params
    this.is_auto_sig = StringToDouble(this.AssignConfigItem("Auto", "is_auto_sig"));
    this.auto_dir = StringToDouble(this.AssignConfigItem("Auto", "auto_dir"));
// Target
    this.target_profit_factor = StringToDouble(this.AssignConfigItem("Target", "target_profit_factor"));
// Close Params
    this.total_close_factor = StringToDouble(this.AssignConfigItem("Close", "total_close_factor"));
}

// Communications with UI
struct UIAutoInfo {
    bool is_sig_buy_activated;
    bool is_sig_sell_activated;
    bool is_close_open_buy_activated;
    bool is_close_open_sell_activated;
    bool is_close_profit_buy_activated;
    bool is_close_profit_sell_activated;
    bool is_part_close_activated;
    bool is_add_buy_activated;
    bool is_add_sell_activated;
    UIAutoInfo() {
        is_sig_buy_activated = false;
        is_sig_sell_activated = false;
        is_close_open_buy_activated = false;
        is_close_open_sell_activated = false;
        is_close_profit_buy_activated = false;
        is_close_profit_sell_activated = false;
        is_part_close_activated = false;
        is_add_buy_activated = false;
        is_add_sell_activated = false;
    }
};