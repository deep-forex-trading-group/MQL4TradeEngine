#include <ThirdPartyLib/MqlExtendLib/Collection/Copy.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ModuleTestManager/all.mqh>

#include "AIRobotConstant.mqh"

class AIRobotUI {
    public:
        AIRobotUI() {
            this.button_section_set_pos = CORNER_RIGHT_LOWER;
//            this.mt_manager = new ModuleTestManager();
            this.InitGraphItems();
        }
        ~AIRobotUI() {
            PrintFormat("Deinitialize the AIRobotUI. ");
            SafeDeletePtr(comment_content_);
            SafeDeletePtr(mt_manager);
            SafeDeletePtr(this.btn_open_sig_test);
            SafeDeletePtr(this.btn_is_show_comment);
            SafeDeletePtr(this.btn_close_buy);
            SafeDeletePtr(this.btn_close_sell);
            SafeDeletePtr(this.btn_close_profit_buy);
            SafeDeletePtr(this.btn_close_profit_sell);
            SafeDeletePtr(this.btn_close_all);
            SafeDeletePtr(this.ea_openclose);
            SafeDeletePtr(this.ea_test);
            SafeDeletePtr(this.ea_test_sec);
        }
    public:
        void RefreshUI() {
            this.RefreshButtonsStates();
        }
        CommentContent* GetCommentContent() {
            return this.comment_content_;
        }
    private:
        void RefreshButtonsStates();
        void InitGraphItems() {
            this.comment_content_ = new CommentContent();
            this.InitButtons();
            this.RefreshUI();
        }
        ENUM_BASE_CORNER button_section_set_pos;
        ModuleTestManager* mt_manager;
    private:
        CommentContent* comment_content_;
        void InitButtons();
        int button_x;
        int button_y;
        int button_inter_x;
        int button_inter_y;
        int button_length;
        int button_width;
        Button* btn_open_sig_test;
        Button* btn_is_show_comment;
        Button* btn_close_buy;
        Button* btn_close_sell;
        Button* btn_close_profit_buy;
        Button* btn_close_profit_sell;
        Button* btn_close_all;
        Button* ea_openclose;
        Button* ea_test;
        Button* ea_test_sec;
};