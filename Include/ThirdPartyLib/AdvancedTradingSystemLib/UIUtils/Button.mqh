class Button {
    public:
        Button(string name,string txt1,string txt2,
               int XX,int YX,
               int XL,int YL,
               int WZ,color A,color B);
        ~Button() {};
    public:
        void CheckButtonState(string name, string pressed_txt, string unpressed_txt,
                              color pressed_clr, color unpressed_clr);
        bool IsButtonPressed(string btn_name);
        void UnPressButton(string btn_name);
        void PressButton(string btn_name);
};

Button::Button(string name,string txt1,string txt2,
               int XX,int YX,
               int XL,int YL,
               int WZ,color A,color B) {
    if(ObjectFind(0,name)==-1) {
        ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
    }

    ObjectSetInteger(0,name,OBJPROP_XDISTANCE,XX);
    ObjectSetInteger(0,name,OBJPROP_YDISTANCE,YX);
    ObjectSetInteger(0,name,OBJPROP_XSIZE,XL);
    ObjectSetInteger(0,name,OBJPROP_YSIZE,YL);
    ObjectSetString(0,name,OBJPROP_FONT,"微软雅黑");
    ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
    ObjectSetInteger(0,name,OBJPROP_CORNER,WZ);

    CheckButtonState(name, txt1, txt2, A, B);
}

void Button::CheckButtonState(string name, string pressed_txt, string unpressed_txt,
                              color pressed_clr, color unpressed_clr) {
    if (ObjectGetInteger(0,name,OBJPROP_STATE)==1) {
        ObjectSetInteger(0,name,OBJPROP_COLOR,pressed_clr);
        ObjectSetInteger(0,name,OBJPROP_BGCOLOR,unpressed_clr);
        ObjectSetString(0,name,OBJPROP_TEXT,pressed_txt);
    } else {
        ObjectSetInteger(0,name,OBJPROP_COLOR,unpressed_clr);
        ObjectSetInteger(0,name,OBJPROP_BGCOLOR,pressed_clr);
        ObjectSetString(0,name,OBJPROP_TEXT,unpressed_txt);
    }
}

bool Button::IsButtonPressed(string btn_name) {
    return (ObjectGetInteger(0,btn_name,OBJPROP_STATE)==1);
}

void Button::UnPressButton(string btn_name) {
    ObjectSetInteger(0,btn_name,OBJPROP_STATE,0);
}

void Button::PressButton(string btn_name) {
    ObjectSetInteger(0,btn_name,OBJPROP_STATE,1);
}