#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
class AutoAdjustStrategyParams {
    public:
        AutoAdjustStrategyParams(ConfigFile* config_file) {
            this.config_file_ = config_file;
            this.pip_start_lots = -1;
            this.pip_step = -1;
            this.pip_factor = -1;
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
    return true;
};
void AutoAdjustStrategyParams::PrintAllParams() {
    PrintFormat("AutoAdjustStrategyParams [%s:%.4f], [%s:%.4f], [%s:%.4f]",
                "pip_start_lots", this.pip_start_lots,
                "pip_step", this.pip_step,
                "pip_factor", this.pip_factor);
};
void AutoAdjustStrategyParams::RefreshStrategyParams() {
    this.config_file_.RefreshConfigFile();

    string pip_start_lots_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "pip_start_lots", pip_start_lots_res);
    this.pip_start_lots = StringToDouble(pip_start_lots_res[0]);

    string pip_step_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "pip_step", pip_step_res);
    this.pip_start_lots = StringToDouble(pip_step_res[0]);

    string pip_factor_res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName("Adjust", "pip_factor", pip_factor_res);
    this.pip_factor = StringToDouble(pip_factor_res[0]);
}