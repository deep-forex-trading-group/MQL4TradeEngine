#include "UIComponent.mqh"

class Button : public UIComponent {
    public:
       // 按钮name，按下时显示的文字, 抬起时显示的文字
       // 按钮离X轴的距离, 按钮离Y轴的距离, 按钮长度, 按钮高度
       // 按钮定位, 按钮按下的颜色, 按钮抬起的颜色
        Button(string name,
               int width,int height,
               string pressed_txt, color pressed_clr,
               string unpressed_txt, color unpressed_clr)
               : UIComponent(name, OBJ_BUTTON, width, height, "微软雅黑", 5),
                 pressed_txt_(pressed_txt), pressed_clr_(pressed_clr),
                 unpressed_txt_(unpressed_txt), unpressed_clr_(unpressed_clr) 
                 { this.OnTickCheckState(); };
        ~Button() {};
    public:
        void OnTickCheckState() {
            this.CheckButtonState();
        }
        bool IsButtonPressed();
        void UnPressButton();
        void PressButton();
    private:
        void InitButtonState();
        void CheckButtonState();
        void ChangeButtonPosition(int x_dis, int y_dis, int width, int height, ENUM_BASE_CORNER corner);
        void ChangeButtonFont(string font_style, int font_size);
    private:

        // Pressed and Unpressed Attributes
        string pressed_txt_;
        string unpressed_txt_;
        color pressed_clr_;
        color unpressed_clr_;
};

void Button::CheckButtonState() {
    if (this.IsButtonPressed()) {
        ObjectSetInteger(0,this.name_,OBJPROP_COLOR,this.pressed_clr_);
        ObjectSetInteger(0,this.name_,OBJPROP_BGCOLOR,this.unpressed_clr_);
        ObjectSetString(0,this.name_,OBJPROP_TEXT,this.pressed_txt_);
    } else {
        ObjectSetInteger(0,this.name_,OBJPROP_COLOR,this.unpressed_clr_);
        ObjectSetInteger(0,this.name_,OBJPROP_BGCOLOR,this.pressed_clr_);
        ObjectSetString(0,this.name_,OBJPROP_TEXT,this.unpressed_txt_);
    }
}
bool Button::IsButtonPressed() {
    return (ObjectGetInteger(0,this.name_,OBJPROP_STATE)==1);
}

void Button::UnPressButton() {
    ObjectSetInteger(0,this.name_,OBJPROP_STATE,0);
}

void Button::PressButton() {
    ObjectSetInteger(0,this.name_,OBJPROP_STATE,1);
}