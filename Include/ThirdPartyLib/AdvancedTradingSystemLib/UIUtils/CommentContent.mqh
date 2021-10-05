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
            this.is_show = false;
        };
        ~CommentContent() {
            SaveDeletePtr(&title_to_field_double_);
        };
    public:
        void SetTitleToFieldDoubleTerm(string title, double field) {
            this.title_to_field_double_.set(title, field);
        }
        bool RemoveTitleToFieldDoubleTerm(string title) {
            if (this.title_to_field_double_.contains(title)) {
                ObjectDelete(title);
                this.title_to_field_double_.remove(title);
                return true;
            } else {
                return false;
            }
        }
        int GetNumOfTitleToFieldDoubleTerm() {
            return this.title_to_field_double_.size();
        }
       void ClearAllTitleToFieldTerms() {
            if (this.GetNumOfTitleToFieldDoubleTerm() != 0) {
                foreachm(string, title, double, field, this.title_to_field_double_) {
                    ObjectDelete(title);
                }
                this.title_to_field_double_.clear();
            }
        }
        bool ShowCommentContent();
        void HideCommentContent();
    private:
        bool is_show;
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
        UIUtils::FixLocationLabel(title, showing_item,
                                  this.corner_left_distance,
                                  this.corner_top_distance + this.y_axis_interval*i_item,
                                  this.font_color, this.font_size, this.corner_base);
        i_item++;
    }
    return true;
}

void CommentContent::HideCommentContent() {
    foreachm(string, title, double, field, this.title_to_field_double_) {
        ObjectDelete(title);
    }
}