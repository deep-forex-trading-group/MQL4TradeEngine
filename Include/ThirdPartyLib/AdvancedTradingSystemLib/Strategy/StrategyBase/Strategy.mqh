#include "../StrategyBase/StrategyConstant.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>

class Strategy {
    public:
        virtual ~Strategy() {
            SafeDeletePtr(this.config_file_);
        };
// OnTick is for every tick check to execute strategy
        virtual int OnTickExecute() = 0;
// OnAction is for outer activated, such as using button to activate
        virtual int OnActionExecute() = 0;
        virtual void PrintStrategyInfo() const = 0;
        int SetConfigFile(ConfigFile* config_file);
        void RefreshConfigFile() const;
    protected:
        bool CheckConfigFileValid() const;
    protected:
        ConfigFile* config_file_;
        string strategy_name_;
};

int Strategy::SetConfigFile(ConfigFile* config_file) {
    if (IsPtrInvalid(config_file)) {
        PrintFormat("This is a invalid pointer for the config_file in Strategy {%s}.",
                    this.strategy_name_);
        return FAILED;
    }
    SafeDeletePtr(this.config_file_);
    this.config_file_ = config_file;
    return SUCCEEDED;
}

bool Strategy::CheckConfigFileValid() const {
    if (IsPtrInvalid(this.config_file_)) {
        PrintFormat("current config_file_ pointer for Strategy {%s} is invalid.",
                    this.strategy_name_);
        return false;
    }
    return true;
}

void Strategy::RefreshConfigFile() const {
    if (IsPtrInvalid(this.config_file_)) {
        PrintFormat("current config_file_ pointer for Strategy {%s} is invalid.",
                    this.strategy_name_);
        return;
    }
    this.config_file_.RefreshConfigFile();
}