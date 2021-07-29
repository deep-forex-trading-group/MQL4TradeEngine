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
            delete &ui_utils;
            delete mt_manager;
            delete btn1;
            delete btn2;
            delete btn3;
            delete btn4;
            delete btn5;
            delete btn6;
            delete btn7;
            delete btn8;
        }
    public:
        void InitGraphItems();
        void RefreshButtonsStates();
    private:
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
        Button* btn1;
        Button* btn2;
        Button* btn3;
        Button* btn4;
        Button* btn5;
        Button* btn6;
        Button* btn7;
        Button* btn8;
};