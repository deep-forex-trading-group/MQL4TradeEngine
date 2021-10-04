#include "UIUtils.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

class CommentContent {
    public:
        CommentContent() {
            this.corner_left_distance = 20;
            this.corner_top_distance = 20;
            this.y_axis_interval = 30;
            this.font_color = Red;
            this.font_size = 12;
            this.corner_base = CORNER_LEFT_UPPER;
        };
        ~CommentContent() {
            SaveDeletePtr(&title_to_field_double_);
        };
    public:
        void UpdateTitleToFieldDoubleTerm(string title, double field) {
            if (this.title_to_field_double_.contains(title)) {
                this.title_to_field_double_.set(title, field);
            }
            this.title_to_field_double_.set(title, field);
        }
        bool RemoveTitleToFieldDoubleTerm(string title) {
            if (this.title_to_field_double_.contains(title)) {
                this.title_to_field_double_.remove(title);
                return true;
            } else {
                return false;
            }
        }
        void ClearTitleToFieldDoubleTerm(string title) {
            this.title_to_field_double_.clear();
        }
        bool ShowCommentContent();
    private:
        HashMap<string,double> title_to_field_double_;
        int corner_left_distance;
        int corner_top_distance;
        int y_axis_interval;
        color font_color;
        int font_size;
        ENUM_BASE_CORNER corner_base;
};

bool CommentContent::ShowCommentContent() {
    int i_item = 0;
    foreachm(string, title, double, field, this.title_to_field_double_) {
        string showing_item = StringFormat("%s : %.5f", title, field);
        UIUtils::FixLocationLabel(showing_item, showing_item,
                                  this.corner_left_distance,
                                  this.corner_top_distance + this.y_axis_interval*i_item,
                                  this.font_color, this.font_size, this.corner_base);
        i_item++;
    }
    return true;
}