#include <ThirdPartyLib/MqlExtendLib/Collection/Copy.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/UIUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ModuleTestManager/all.mqh>

#include "AIRobotConstant.mqh"
#include "DataStructure.mqh"

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
            SafeDeletePtr(this.btn_ui_frame);
            SafeDeletePtr(mt_manager);
            SafeDeletePtr(this.btn_part_close);
            SafeDeletePtr(this.btn_at_add_buy);
            SafeDeletePtr(this.btn_at_add_sell);
            SafeDeletePtr(this.btn_at_open_buy_sig);
            SafeDeletePtr(this.btn_at_open_sell_sig);
            SafeDeletePtr(this.btn_is_show_comment);
            SafeDeletePtr(this.btn_close_buy);
            SafeDeletePtr(this.btn_close_sell);
            SafeDeletePtr(this.btn_close_profit_buy);
            SafeDeletePtr(this.btn_close_profit_sell);
            SafeDeletePtr(this.btn_close_all);
            SafeDeletePtr(this.btn_ea_openclose);
            SafeDeletePtr(this.btn_ea_test);
            SafeDeletePtr(this.btn_ea_test_sec);
        }
    public:
        void OnTickRefreshUI(UIRetData* ui_ret_data_out) {
            this.btn_ui_frame.OnTickCheckUIStates();
            this.OnTickRefreshButtonsStates(ui_ret_data_out);
        }
        CommentContent* GetCommentContent() {
            return this.comment_content_;
        }
    private:
        void OnTickRefreshButtonsStates(UIRetData* ui_ret_data_out);
        void InitGraphItems() {
            this.comment_content_ = new CommentContent();
            this.InitButtons();
        }
        void InitButtons();

    private:
        ModuleTestManager* mt_manager;
        CommentContent* comment_content_;

        UIFrame* btn_ui_frame;
        string btn_ui_frame_name;
        int button_x;
        int button_y;
        int button_inter_x;
        int button_inter_y;
        ENUM_BASE_CORNER button_section_set_pos;
        int button_width;
        int button_height;
// AT Strategy Buttons
        Button* btn_part_close;
        Button* btn_at_add_buy;
        Button* btn_at_add_sell;
        Button* btn_at_open_buy_sig;
        Button* btn_at_open_sell_sig;
// Show Comments Controls
        Button* btn_is_show_comment;
        Button* btn_close_buy;
        Button* btn_close_sell;
        Button* btn_close_profit_buy;
        Button* btn_close_profit_sell;
        Button* btn_close_all;
        Button* btn_ea_openclose;
        Button* btn_ea_test;
        Button* btn_ea_test_sec;
};