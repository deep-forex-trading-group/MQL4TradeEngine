#include <ThirdPartyLib/MqlExtendLib/Collection/Copy.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/UIUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>

#include "AIRobotConstant.mqh"

struct RefreshButtonsStatesParams {
    int magic_number;
    bool is_testing_ok;
};

struct RefreshButtonsStatesRet {
    bool is_testing_ok;
};

class AIRobotUI {
    public:
        AIRobotUI() {
            this.button_section_set_pos = CORNER_RIGHT_LOWER;
        }
        ~AIRobotUI() {
            delete &ui_utils;
            delete &ou_get;
            delete &ou_close;
            delete &ou_send;
            delete &ou_print;
        }
    private:
        UIUtils ui_utils;
        OrderGetUtils ou_get;
        OrderCloseUtils ou_close;
        OrderSendUtils ou_send;
        OrderPrintUtils ou_print;
        ENUM_BASE_CORNER button_section_set_pos;

    public:
        void InitGraphItems();
        RefreshButtonsStatesRet RefreshButtonsStates(RefreshButtonsStatesParams& params);
};