class UIComponent {
    public:
        UIComponent(string name, ENUM_OBJECT component_type,
                    int width, int height, string font_style, int font_size) :
                    name_(name),  component_type_(component_type),
                    width_(width), height_(height),
                    font_style_(font_style), font_size_(font_size),
                    x_dis_(-100), y_dis_(-100), corner_(CORNER_RIGHT_UPPER),
                    x_idx_(-1), y_idx_(-1) {
            if(ObjectFind(0,this.name_)==-1) {
                ObjectCreate(0, this.name_, this.component_type_, 0, 0, 0);
            }
            this.SetUIComponentPosition();
            this.SetUIComponentFont();
            this.SetUIComponentSize();
        };
        virtual ~UIComponent() {
            ObjectDelete(this.name_);
        };
    public:
        virtual void OnTickCheckState() = 0;
        void SetXIdx(int x_idx) { this.x_idx_ = x_idx; }
        int GetXIdx() { return this.x_idx_; }
        void SetYIdx(int y_idx) { this.y_idx_ = y_idx; }
        int GetYIdx() { return this.y_idx_; }
        void SetUIComponentPosition(int x_dis, int y_dis, ENUM_BASE_CORNER corner);
        void SetUIComponentPosition();
        void SetUIComponentFont(string font_style, int font_size);
        void SetUIComponentFont();
        void SetUIComponentSize(int width, int height);
        void SetUIComponentSize();
    protected:
        string name_;
        ENUM_OBJECT component_type_;

        // Position Attributes
        int x_dis_;
        int y_dis_;
        int width_;
        int height_;
        ENUM_BASE_CORNER corner_;

        // Font Attributes
        string font_style_;
        int font_size_;

        // x and y index in the UIFrame
        int x_idx_;
        int y_idx_;
};
void UIComponent::SetUIComponentPosition(int x_dis, int y_dis, ENUM_BASE_CORNER corner) {
    this.x_dis_ = x_dis;
    this.y_dis_ = y_dis;
    this.corner_ = corner;
    this.SetUIComponentPosition();
}
void UIComponent::SetUIComponentFont(string font_style, int font_size) {
    this.font_style_ = font_style;
    this.font_size_ = font_size;
    this.SetUIComponentFont();
}
void UIComponent::SetUIComponentSize(int width, int height) {
    this.width_ = width;
    this.height_ = height;
    this.SetUIComponentSize();
}
void UIComponent::SetUIComponentPosition() {
    ObjectSetInteger(0, this.name_, OBJPROP_XDISTANCE, this.x_dis_);
    ObjectSetInteger(0, this.name_, OBJPROP_YDISTANCE, this.y_dis_);
    ObjectSetInteger(0, this.name_, OBJPROP_CORNER, this.corner_);
}
void UIComponent::SetUIComponentFont() {
    ObjectSetString(0, this.name_, OBJPROP_FONT, this.font_style_);
    ObjectSetInteger(0, this.name_, OBJPROP_FONTSIZE, this.font_size_);
}
void UIComponent::SetUIComponentSize() {
    ObjectSetInteger(0, this.name_, OBJPROP_XSIZE, this.width_);
    ObjectSetInteger(0, this.name_, OBJPROP_YSIZE, this.height_);
}