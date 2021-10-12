#include "../StrategyBase/StrategyConstant.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>

class Strategy {
    public:
        virtual ~Strategy() {
            SafeDeletePtr(this.config_file_);
        };
        bool IsInitSuccess() { return this.init_success_; };
// OnTick is for every tick check to execute strategy
        // BeforeTickExecute() makes some preparations for strategy execution
        virtual int BeforeTickExecute() = 0;
        // Strategy Execution
        virtual int OnTickExecute() = 0;
        // After Strategy Execution, updates some OrderManager
        virtual int AfterTickExecute() = 0;
// OnAction is for outer activated, such as using button to activate
        virtual int OnActionExecute() = 0;
        virtual void PrintStrategyInfo() const = 0;
        string GetStrategyName() {
            return this.strategy_name_;
        }
        int SetConfigFile(ConfigFile* config_file);
        bool SetStrategyCommentContent(CommentContent* cc_in);
        void RefreshConfigFile() const;
    protected:
        bool CheckConfigFileValid() const;
    protected:
        string strategy_name_;
        bool init_success_;
    protected:
        ConfigFile* config_file_;
        CommentContent* st_comment_content;
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

bool Strategy::SetStrategyCommentContent(CommentContent* cc_in) {
    if (IsPtrInvalid(cc_in)) {
        PrintFormat("CommentContent is invalid for %s. ", this.strategy_name_);
        return false;
    }
    SafeDeletePtr(this.st_comment_content);
    this.st_comment_content = cc_in;
    return true;
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