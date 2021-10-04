#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
class AutoAdjustStrategyParams {
    public:
        AutoAdjustStrategyParams(ConfigFile* config_file) {
            this.config_file_ = config_file;
            this.pip_start_lots = -1;
            this.pip_step = -1;
            this.pip_factor = -1;
            this.sig_order_name = "default";
            this.sig_order_magic_number = -1;
            this.lots_exponent = -1;
            this.pip_step_exponent = -1;
            this.RefreshStrategyParams();
        };
        ~AutoAdjustStrategyParams() {};

    public:
        void PrintAllParams();
        void RefreshStrategyParams();
        bool IsParamsValid();

    public:
        double pip_start_lots;
        double pip_step;
        double pip_factor;
        double lots_exponent;
        double pip_step_exponent;
        string sig_order_name;
        int sig_order_magic_number;

    private:
        ConfigFile* config_file_;
};

bool AutoAdjustStrategyParams::IsParamsValid() {
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

    if (this.sig_order_name == "default") {
        return false;
    }

    if (this.sig_order_magic_number >= -1) {
        return false;
    }

    return true;
};
void AutoAdjustStrategyParams::PrintAllParams() {
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_start_lots", this.pip_start_lots);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_step", this.pip_step);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_factor", this.pip_factor);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "lots_exponent", this.lots_exponent);
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f]", "pip_step_exponent", this.pip_step_exponent);
    PrintFormat("AutoAdjustStrategyParams [%s:%s]", "sig_order_name", this.sig_order_name);
    PrintFormat("AutoAdjustStrategyParams [%s:%d]", "sig_order_magic_number", this.sig_order_magic_number);
};
void AutoAdjustStrategyParams::RefreshStrategyParams() {
    this.config_file_.RefreshConfigFile();

    string pip_start_lots_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "pip_start_lots", pip_start_lots_res);
    this.pip_start_lots = StringToDouble(pip_start_lots_res[0]);

    string pip_step_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "pip_step", pip_step_res);
    this.pip_step = StringToDouble(pip_step_res[0]);

    string pip_factor_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "pip_factor", pip_factor_res);
    this.pip_factor = StringToDouble(pip_factor_res[0]);

    string lots_exponent_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "lots_exponent", lots_exponent_res);
    this.lots_exponent = StringToDouble(lots_exponent_res[0]);

    string pip_step_exponent_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "pip_step_exponent", pip_step_exponent_res);
    this.pip_step_exponent = StringToDouble(pip_step_exponent_res[0]);

    string sig_order_name_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("SignalOrder", "sig_order_name", sig_order_name_res);
    this.sig_order_name = sig_order_name_res[0];

    string sig_order_magic_number_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("SignalOrder",
                                                        "sig_order_magic_number", sig_order_magic_number_res);
    this.sig_order_magic_number = (int) StringToInteger(sig_order_magic_number_res[0]);
}