#include "UIUtils.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

class CommentContent {
    public:
        CommentContent() {
            this.corner_left_distance = 20;
            this.corner_top_distance = 20;
            this.y_axis_interval = 30;
            this.font_color = clrBlack;
            this.font_size = 10;
            this.font_type = "粗体";
            this.corner_base = CORNER_LEFT_UPPER;
            this.is_show = false;
        };
        ~CommentContent() {
            this.ClearAllTitleToFieldTerms();
            SafeDeletePtr(&title_to_field_double_map_);
            SafeDeletePtr(&title_to_field_string_map_);
        };
    public:
        void SetTitleToFieldStringTerm(string title, string field) {
            this.title_to_field_string_map_.set(title, field);
        }
        void SetTitleToFieldDoubleTerm(string title, double field) {
            this.title_to_field_double_map_.set(title, field);
        }
        bool RemoveTitleToFieldStringTerm(string title) {
            if (this.title_to_field_string_map_.contains(title)) {
                ObjectDelete(title);
                this.title_to_field_string_map_.remove(title);
                return true;
            } else {
                return false;
            }
        }
        bool RemoveTitleToFieldDoubleTerm(string title) {
            if (this.title_to_field_double_map_.contains(title)) {
                ObjectDelete(title);
                this.title_to_field_double_map_.remove(title);
                return true;
            } else {
                return false;
            }
        }
        int GetNumOfTitleToFieldStringTerm() {
            return this.title_to_field_string_map_.size();
        }
        int GetNumOfTitleToFieldDoubleTerm() {
            return this.title_to_field_double_map_.size();
        }
        void ClearAllTitleToFieldTerms() {
            if (this.GetNumOfTitleToFieldDoubleTerm() != 0) {
                foreachm(string, title, double, field, this.title_to_field_double_map_) {
                    ObjectDelete(title);
                }
                this.title_to_field_double_map_.clear();
            }
            if (this.GetNumOfTitleToFieldStringTerm() != 0) {
                foreachm(string, title, string, field, this.title_to_field_string_map_) {
                    ObjectDelete(title);
                }
                this.title_to_field_string_map_.clear();
            }
        }
        bool ShowCommentContent();
        void HideCommentContent();
    private:
        bool is_show;
        HashMap<string, double> title_to_field_double_map_;
        HashMap<string, string> title_to_field_string_map_;
        int corner_left_distance;
        int corner_top_distance;
        int y_axis_interval;
        string font_type;
        color font_color;
        int font_size;
        ENUM_BASE_CORNER corner_base;
};

bool CommentContent::ShowCommentContent() {
    int i_item = 0;
    foreachm(string, title, double, field, this.title_to_field_double_map_) {
        string showing_item = StringFormat("%s: %.5f", title, field);
        UIUtils::FixLocationLabel(title, showing_item,
                                  this.corner_left_distance,
                                  this.corner_top_distance + this.y_axis_interval*i_item,
                                  this.font_type, this.font_color, this.font_size, this.corner_base);
        i_item++;
    }

    foreachm(string, title, string, field, this.title_to_field_string_map_) {
        string showing_item = StringFormat("%s: %s", title, field);
        UIUtils::FixLocationLabel(title, showing_item,
                                  this.corner_left_distance,
                                  this.corner_top_distance + this.y_axis_interval*i_item,
                                  this.font_type, this.font_color, this.font_size, this.corner_base);
        i_item++;
    }
    return true;
}

void CommentContent::HideCommentContent() {
    foreachm(string, title, double, field, this.title_to_field_double_map_) {
        ObjectDelete(title);
    }
    foreachm(string, title, string, field, this.title_to_field_string_map_) {
        ObjectDelete(title);
    }
}