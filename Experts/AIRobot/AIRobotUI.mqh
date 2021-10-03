#include <ThirdPartyLib/MqlExtendLib/Collection/Copy.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ModuleTestManager/all.mqh>

#include "AIRobotConstant.mqh"

class AIRobotUI {
    public:
        AIRobotUI() {
            this.button_section_set_pos = CORNER_RIGHT_LOWER;
            this.mt_manager = new ModuleTestManager();
            this.InitGraphItems();
        }
        ~AIRobotUI() {
            PrintFormat("Deinitialize the AIRobotUI. ");
            delete &ui_utils;
            delete mt_manager;
            delete this.btn_open_sig_test;
            delete this.btn_close_buy;
            delete this.btn_close_sell;
            delete this.btn_close_profit_buy;
            delete this.btn_close_profit_sell;
            delete this.btn_close_all;
            delete this.ea_openclose;
            delete this.ea_test;
            delete this.ea_test_sec;
        }
    public:
        void RefreshButtonsStates();
    private:
        void InitGraphItems();
        UIUtils ui_utils;
        ENUM_BASE_CORNER button_section_set_pos;
        ModuleTestManager* mt_manager;
    private:
        int button_x;
        int button_y;
        int button_inter_x;
        int button_inter_y;
        int button_length;
        int button_width;
        Button* btn_open_sig_test;
        Button* btn_close_buy;
        Button* btn_close_sell;
        Button* btn_close_profit_buy;
        Button* btn_close_profit_sell;
        Button* btn_close_all;
        Button* ea_openclose;
        Button* ea_test;
        Button* ea_test_sec;
};