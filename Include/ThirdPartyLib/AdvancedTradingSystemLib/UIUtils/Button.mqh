class Button {
    public:
       // 按钮name，按下时显示的文字, 抬起时显示的文字
       // 按钮离X轴的距离, 按钮离Y轴的距离, 按钮长度, 按钮高度
       // 按钮定位, 按钮按下的颜色, 按钮抬起的颜色
        Button(string name,string pressed_txt,string unpressed_txt,
               int x_dis,int y_dis, int width,int height,
               int corner, color pressed_clr,color unpressed_clr);
        ~Button() {};
    public:
        void CheckButtonState();
        bool IsButtonPressed();
        void UnPressButton();
        void PressButton();
    private:
        string btn_name_;
        string pressed_txt_;
        string unpressed_txt_;
        color pressed_clr_;
        color unpressed_clr_;
};

Button::Button(string name,string pressed_txt,string unpressed_txt,
               int x_dis,int y_dis, int width,int height,
               int corner,color pressed_clr,color unpressed_clr) {
    this.btn_name_ = name;
    this.pressed_txt_ = pressed_txt;
    this.unpressed_txt_ = unpressed_txt;
    this.pressed_clr_ = pressed_clr;
    this.unpressed_clr_ = unpressed_clr;

    if(ObjectFind(0,name)==-1) {
        ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
    }

    ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x_dis);
    ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y_dis);
    ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
    ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
    ObjectSetString(0,name,OBJPROP_FONT,"微软雅黑");
    ObjectSetInteger(0,name,OBJPROP_FONTSIZE,5);
    ObjectSetInteger(0,name,OBJPROP_CORNER,corner);

    this.CheckButtonState();
}

void Button::CheckButtonState() {
    if (this.IsButtonPressed()) {
        ObjectSetInteger(0,this.btn_name_,OBJPROP_COLOR,this.pressed_clr_);
        ObjectSetInteger(0,this.btn_name_,OBJPROP_BGCOLOR,this.unpressed_clr_);
        ObjectSetString(0,this.btn_name_,OBJPROP_TEXT,this.pressed_txt_);
    } else {
        ObjectSetInteger(0,this.btn_name_,OBJPROP_COLOR,this.unpressed_clr_);
        ObjectSetInteger(0,this.btn_name_,OBJPROP_BGCOLOR,this.pressed_clr_);
        ObjectSetString(0,this.btn_name_,OBJPROP_TEXT,this.unpressed_txt_);
    }
}

bool Button::IsButtonPressed() {
    return (ObjectGetInteger(0,this.btn_name_,OBJPROP_STATE)==1);
}

void Button::UnPressButton() {
    ObjectSetInteger(0,this.btn_name_,OBJPROP_STATE,0);
}

void Button::PressButton() {
    ObjectSetInteger(0,this.btn_name_,OBJPROP_STATE,1);
}