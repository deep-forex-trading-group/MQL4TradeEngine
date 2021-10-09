#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>

class StrategyParams {
    public:
        StrategyParams(ConfigFile* config_file) {
            this.config_file_ = config_file;
        };
        virtual ~StrategyParams() {
            SafeDeletePtr(this.config_file_);
        };

    public:
        virtual void PrintAllParams() = 0;
        virtual void RefreshStrategyParams() = 0;
        virtual bool IsParamsValid() = 0;

    protected:
        ConfigFile* config_file_;
        string AssignConfigItem(string title, string field_name);
        bool AssignConfigItem(string title, string field_name, string& res[]);
};

string StrategyParams::AssignConfigItem(string title, string field_name) {
    string res[1];
    this.config_file_.GetConfigFieldByTitleAndFieldName(title, field_name, res);
    return res[0];
}
bool StrategyParams::AssignConfigItem(string title, string field_name, string& res[]) {
    return this.config_file_.GetConfigFieldByTitleAndFieldName(
                             title, field_name, res) == SUCCEEDED;

}