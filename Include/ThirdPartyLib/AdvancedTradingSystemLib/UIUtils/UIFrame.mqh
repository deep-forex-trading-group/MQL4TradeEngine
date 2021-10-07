#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "UIComponent.mqh"

class UIFrame {
    public:
        UIFrame(string name, int x_axis_dis, int y_axis_dis,
                int x_axis_inter, int y_axis_inter,
                ENUM_BASE_CORNER ui_frame_corner) :
                name_(name), x_axis_dis_(x_axis_dis), y_axis_dis_(y_axis_dis),
                x_axis_inter_(x_axis_inter), y_axis_inter_(y_axis_inter),
                ui_frame_corner_(ui_frame_corner) {
            this.ui_component_set_ = new HashSet<UIComponent*>();
        };
        ~UIFrame() {
            this.ui_component_set_.clear();
            SafeDeletePtr(this.ui_component_set_);
        };
    public:
        void AddUIComponent(int x_idx, int y_idx, UIComponent* ui_component) {
            ui_component.SetXIdx(x_idx);
            ui_component.SetYIdx(y_idx);
            ui_component.SetUIComponentPosition(this.x_axis_dis_ + ui_component.GetXIdx() * this.x_axis_inter_,
                                                this.y_axis_dis_ + ui_component.GetYIdx() * this.y_axis_inter_,
                                                this.ui_frame_corner_);
            this.ui_component_set_.add(ui_component);
        };
        void RemoveUIComponent(UIComponent* ui_component) {
            if (!this.ui_component_set_.contains(ui_component)) {
                return;
            }
            this.ui_component_set_.remove(ui_component);
        };
        void ResetAllComponentsPosition() {
            for (Iter<UIComponent*> iter(this.ui_component_set_); !iter.end(); iter.next()) {
                UIComponent* ui_component_cur = iter.current();
                ui_component_cur.SetUIComponentPosition();
            }
        }
        void ResetAllComponentsFont() {
            for (Iter<UIComponent*> iter(this.ui_component_set_); !iter.end(); iter.next()) {
                UIComponent* ui_component_cur = iter.current();
                ui_component_cur.SetUIComponentFont();
            }
        }
        void OnTickCheckUIStates() {
            for(Iter<UIComponent*> iter(this.ui_component_set_); !iter.end(); iter.next()) {
                UIComponent* ui_component_cur = iter.current();
                ui_component_cur.OnTickCheckState();
            }
        }


    private:
        string name_;
        int x_axis_dis_;
        int y_axis_dis_;
        int x_axis_inter_;
        int y_axis_inter_;
        ENUM_BASE_CORNER ui_frame_corner_;

    private:
        HashSet<UIComponent*>* ui_component_set_;
};