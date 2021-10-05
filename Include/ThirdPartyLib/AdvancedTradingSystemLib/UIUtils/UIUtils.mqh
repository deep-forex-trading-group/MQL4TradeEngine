class UIUtils {
    public:
        UIUtils() {};
        ~UIUtils() {};
    public:
        static void Laber(string a,color b,int jl);
        static void FixLocationLabel(string name, string content,
                                     int corner_left_dis, int corner_right_dis,
                                     string font_type, color font_color, int font_size, int corner_of_charts);
        bool IsButtonPressed(string btn_name);
        void UnPressButton(string btn_name);
        void PressButton(string btn_name);
};
void UIUtils::Laber(string a,color b,int jl) {
    if(IsOptimization())
        return;

    int pp=WindowBarsPerChart();
    double hh=High[iHighest(Symbol(),0,MODE_HIGH,pp,0)];
    double ll=Low[iLowest(Symbol(),0,MODE_LOW,pp,0)];
    double 文字小距离=(hh-ll)*0.03;

    ObjectDelete("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a);
    ObjectCreate("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,
                    OBJ_TEXT,0,Time[0],Low[0]-jl*文字小距离);
    ObjectSetText("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,a,8,"Times New Roman",b);
}
void UIUtils::FixLocationLabel(string name, string content,
                               int corner_left_dis, int corner_right_dis,
                               string font_type, color font_color, int font_size, int corner_of_charts) {
    if(sizeof(content)==0)
        return;

    if(ObjectFind(name)==-1) {
        ObjectDelete(name);
        ObjectCreate(name,OBJ_LABEL,0,0,0);
    }

    ObjectSet(name, OBJPROP_XDISTANCE, corner_left_dis);
    ObjectSet(name, OBJPROP_YDISTANCE, corner_right_dis);
    ObjectSetText(name, content, font_size, font_type, font_color);
    ObjectSet(name, OBJPROP_CORNER, corner_of_charts);
}
bool UIUtils::IsButtonPressed(string btn_name) {
    return (ObjectGetInteger(0,btn_name,OBJPROP_STATE)==1);
}
void UIUtils::UnPressButton(string btn_name) {
    ObjectSetInteger(0,btn_name,OBJPROP_STATE,0);
}
void UIUtils::PressButton(string btn_name) {
    ObjectSetInteger(0,btn_name,OBJPROP_STATE,1);
}