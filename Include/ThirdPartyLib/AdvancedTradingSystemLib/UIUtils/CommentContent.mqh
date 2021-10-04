#include "UIUtils.mqh"

class CommentContent {
    public:
        CommentContent() {};
        ~CommentContent() {};
    public:
        static bool ShowCurrentAccountStates();
        static bool ShowFixLabelContent(string& content_showing[], int len);
};

bool CommentContent::ShowCurrentAccountStates() {
   string arr[100];
   arr[0] = ("total_float_profit: " + DoubleToStr(1.11));
   arr[1] = ("max_total_floating_profit: " + DoubleToStr(1.11));
   CommentContent::ShowFixLabelContent(arr, 2);
   return true;
}

// 显示标签
bool CommentContent::ShowFixLabelContent(string& content_showing[], int len) {
   int X=20;
   int Y=20;
   int Y间隔=15;
   color 标签颜色=Yellow;
   int 标签字体大小=10;
   ENUM_BASE_CORNER 固定角=0;

   for(int i = 0 ; i < ArraySize(content_showing) && i < len; i++) {
      UIUtils::FixLocationLabel("标签"+DoubleToStr(i),content_showing[i],X,Y+Y间隔*i,标签颜色,标签字体大小,固定角);
   }

   return true;
}