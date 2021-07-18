class UIUtils {
public:
   // 按钮名称，按下时显示的文字, 抬起时显示的文字
   // 按钮离X轴的距离, 按钮离Y轴的距离
   // 按钮长度, 按钮高度
   // 按钮定位, 按钮按下的颜色, 按钮抬起的颜色
   void 按钮(string name,string txt1,string txt2,
            int XX,int YX,
            int XL,int YL,
            int WZ,color A,color B) {
      if(ObjectFind(0,name)==-1)
         ObjectCreate(0,name,OBJ_BUTTON,0,0,0);

      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,XX);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,YX);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,XL);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,YL);
      ObjectSetString(0,name,OBJPROP_FONT,"微软雅黑");
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
      ObjectSetInteger(0,name,OBJPROP_CORNER,WZ);

      CheckButtonState(name, txt1, txt2, A, B);
   }

   void CheckButtonState(string name, string pressed_txt, string unpressed_txt, 
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

   void laber(string a,color b,int jl) {
      Print(a);
      if(IsOptimization())
         return;

      int pp=WindowBarsPerChart();
      double hh=High[iHighest(Symbol(),0,MODE_HIGH,pp,0)];
      double ll=Low[iLowest(Symbol(),0,MODE_LOW,pp,0)];
      double 文字小距离=(hh-ll)*0.03;

      ObjectDelete("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a);
      ObjectCreate("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,OBJ_TEXT,0,Time[0],Low[0]-jl*文字小距离);
      ObjectSetText("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,a,8,"Times New Roman",b);
   }

   void 固定位置标签(string 名称,string 内容,int XX,int YX,color C,int 字体大小,int 固定角内) {
      if(sizeof(内容)==0)
         return;
      if(ObjectFind(名称)==-1)
      {
         ObjectDelete(名称);
         ObjectCreate(名称,OBJ_LABEL,0,0,0);
      }
      ObjectSet(名称,OBJPROP_XDISTANCE,XX);
      ObjectSet(名称,OBJPROP_YDISTANCE,YX);
      ObjectSetText(名称,内容,字体大小,"宋体",C);
      ObjectSet(名称,OBJPROP_CORNER,固定角内);
  }
};