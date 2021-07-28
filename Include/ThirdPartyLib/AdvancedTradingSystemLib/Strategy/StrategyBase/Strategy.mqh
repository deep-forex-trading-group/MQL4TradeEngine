#include "../StrategyBase/StrategyConstant.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class Strategy {
    public:
        virtual ~Strategy() {};
// Abstract Methods to force sub-classes to implement them
        virtual int ExecuteStrategy() const = 0;
        virtual void PrintStrategyInfo() const = 0;
        int SetConfigFile(ConfigFile* config_file);
    protected:
        bool CheckConfigFileValid() const;
    protected:
        ConfigFile* config_file_;
        string strategy_name_;
};

int Strategy::SetConfigFile(ConfigFile* config_file) {
    SaveDeletePtr(this.config_file_);
    if (IsPtrInvalid(config_file)) {
        PrintFormat("This is a invalid pointer for the config_file in Strategy {%s}.",
                    this.strategy_name_);
        return FAILED;
    }
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