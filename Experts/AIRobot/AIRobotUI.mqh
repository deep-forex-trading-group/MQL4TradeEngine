#include <ThirdPartyLib/MqlExtendLib/Collection/Copy.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/UIUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ModuleTestManager/all.mqh>

#include "AIRobotConstant.mqh"

class AIRobotUI {
    public:
        AIRobotUI() {
            this.button_section_set_pos = CORNER_RIGHT_LOWER;
            this.mt_manager = new ModuleTestManager();
        }
        ~AIRobotUI() {
            delete &ui_utils;
            delete &ou_get;
            delete &ou_close;
            delete &ou_send;
            delete &ou_print;
            delete mt_manager;
        }
    public:
        void InitGraphItems();
        void RefreshButtonsStates();
    private:
        UIUtils ui_utils;
        OrderGetUtils ou_get;
        OrderCloseUtils ou_close;
        OrderSendUtils ou_send;
        OrderPrintUtils ou_print;
        ENUM_BASE_CORNER button_section_set_pos;
        ModuleTestManager* mt_manager;
};