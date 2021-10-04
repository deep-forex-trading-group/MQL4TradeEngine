#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
class StrategyParams {
    public:
        StrategyParams(ConfigFile* config_file) {
            this.config_file_ = config_file;
        };
        virtual ~StrategyParams() {
            SaveDeletePtr(this.config_file_);
        };

    public:
        virtual void PrintAllParams() = 0;
        virtual void RefreshStrategyParams() = 0;
        virtual bool IsParamsValid() = 0;

    protected:
        ConfigFile* config_file_;
        string AssignConfigItem(string title, string field_name);
};

string StrategyParams::AssignConfigItem(string title, string field_name) {
    string res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName(title, field_name, res);
    return res[0];
}