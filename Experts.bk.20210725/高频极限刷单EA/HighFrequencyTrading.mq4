//+------------------------------------------------------------------+
//|                                             高频趋势回调EA        |
//+------------------------------------------------------------------+
// coding_style: 
// 1. self-comment 通过函数名就知道要干什么，不需要看实现细节
// 2. 最大程度实现功能封装解耦，超过20行代码的通用功能封装成函数
// 3. 函数分块管理: 把同类功能的函数和变量尽可能写在一起，方遍管理

#property copyright "文艺复兴科技公司-江清泉"
#property link      ""

#include "Executors/HedgeExecutors.mqh"
#include "Conf/Configuration.mqh"

#include <ThirdPartyLib/UsedUtils/OrderManageUtils.mqh>
#include <ThirdPartyLib/UsedUtils/HedgeUtilsDual.mqh>
#include <ThirdPartyLib/UsedUtils/AccountInfoUtils.mqh>
#include <ThirdPartyLib/UsedUtils/UIUtils.mqh>

#include <ThirdPartyLib/Trade/Order.mqh>
#include <ThirdPartyLib/Trade/OrderPool.mqh>
#include <ThirdPartyLib/Trade/OrderManager.mqh>

// 外部输入参数
input ENUM_BASE_CORNER 按钮定位=CORNER_RIGHT_LOWER;
extern string marting_conf_path="";

// 检查是Bar触发还是实时触发
extern bool CheckNewBar = true;

// Magic Numbers
Configuration* conf = new Configuration();
int MagicNumberBuy = conf.MagicNumberBuy;   
int MagicNumberSell = conf.MagicNumberSell;

// Market Info
int vDigits;
double vPoint;
double Spread;
datetime TimePrev = Time[0];

// Account Info
double account_equity;
double max_total_floating_profit;
double min_total_floating_profit;
double min_total_close_and_floating_profit;
double max_total_close_and_floating_profit;


#ifndef TestMode1 
   #define TestMode1 
#endif

OrderManageUtils ou();
AccountInfoUtils ai_utils();
UIUtils ui_utils();
OrderManager om(Symbol());
HedgeExecutor he(conf);

int OnInit() {
   vPoint  = Point;
   vDigits = Digits;
   TimePrev = Time[0];
   Spread = NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD),vDigits)*vPoint;
   InitGraphItems();
   Print("init_magic_number: ",MagicNumberBuy, ", ", MagicNumberSell);
   return(0);
}

void OnDeinit(const int reason) {
   delete &ou;
   delete &ai_utils;
   delete &ui_utils;
}

void OnTick() {
   // 如果条件不允许，则不做交易
   if (!Check()) {
      return;
   }
   if(TimePrev == Time[0] && CheckNewBar == true) return;
   TimePrev = Time[0];
   ShowCurrentAccountStates();

   // 刷新图像界面，例如平仓按钮
   RefreshGraphItems();
}

bool StartTesting() {
   Print("start testing new ");
   LinkedList<Order*> list;
   // TradingPool pool;

   he.execute();
   // foreachorder(pool)
   // {
   //    OrderPrint(); // to compare with Order.toString
   //    list.push(new Order());
   // }
   // PrintFormat("There are %d orders. ",list.size());
   
   return true;
}

//+-------------------------- Strategy Execute Areas ----------------------------------------+
//+--------------------------  主要用于主策略逻辑执行  ----------------------------------------+

// 每个tick调用检查是否允许交易
bool Check() {
   if(IsTradeAllowed()==false) {
      Comment("不允许智能交易");
      return false;
   }
   
   return true;
}

//+-------------------------- Graph Items Areas ----------------------------------------+
//+-------------------------- 主要用于前端展示   -----------------------------------------+

// 初始化图形显示
bool RefreshGraphItems() {
   RefreshButtonsStates();
   return true;
}

// 初始化按钮对象，初始化按钮对象的值

void ResetAllButtonOpenStates() {
   ObjectSetInteger(0,"标签单向对冲按钮",OBJPROP_STATE,0);
   ObjectSetInteger(0,"标签自动做多",OBJPROP_STATE,0);
   ObjectSetInteger(0,"标签自动做空",OBJPROP_STATE,0);
}

void RefreshButtonsStates() {

   if(ObjectGetInteger(0,"标签触发测试按钮",OBJPROP_STATE)==1) {
      StartTesting();
      ObjectSetInteger(0,"标签触发测试按钮",OBJPROP_STATE,0);
   }

   if(ObjectGetInteger(0,"标签加多按钮",OBJPROP_STATE)==1) {
      Print("activate buy button");
      om.buy(0.01,0,0,"Group Testing 1");
      ObjectSetInteger(0,"标签加多按钮",OBJPROP_STATE,0);
   }

   if(ObjectGetInteger(0,"标签加空按钮",OBJPROP_STATE)==1) {
      Print("activate sell button");
      om.sell(0.01,0,0,conf.ORDER_COMMENT);
      ObjectSetInteger(0,"标签加空按钮",OBJPROP_STATE,0);
   }
   

}

// 获取按钮对象函数, 初始化并获取对应的按钮对象
void InitGraphItems() {
   int 按钮X=120;
   int 按钮Y=25;
   int 按钮间隔X=50;
   int 按钮间隔Y=25;
   
   // Y从下往上，x从右往左
   ui_utils.按钮("标签自动做多","自动多","关自动多",按钮X+按钮间隔X*2,按钮Y+按钮间隔Y*4,45,20,按钮定位,clrBlue,clrAqua);
   ui_utils.按钮("标签自动做空","自动空","关自动空",按钮X+按钮间隔X*2,按钮Y+按钮间隔Y*3,45,20,按钮定位,clrYellow,clrRed);
   ui_utils.按钮("标签平多按钮","平多","平多",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*4,45,20,按钮定位,clrFireBrick,clrBlack);
   ui_utils.按钮("标签平空按钮","平空","平空",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*3,45,20,按钮定位,clrMediumVioletRed,clrBlack);
   ui_utils.按钮("标签加多按钮","加多","加多",按钮X+按钮间隔X*0,按钮Y+按钮间隔Y*4,45,20,按钮定位,clrMediumSeaGreen,clrBlack);
   ui_utils.按钮("标签加空按钮","加空","加空",按钮X+按钮间隔X*0,按钮Y+按钮间隔Y*3,45,20,按钮定位,clrChocolate,clrBlack);
   ui_utils.按钮("标签全平按钮","全平按钮","全平按钮",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*2,45,20,按钮定位,clrDarkViolet,clrBlack);

   // 触发信号单
   ui_utils.按钮("标签单向对冲按钮","关闭对冲","单向对冲",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*1,45,20,按钮定位,clrDarkViolet,clrBlack);
   //ui_utils.按钮("标签触发多空对冲按钮","关闭对冲","多空对冲",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*0,45,20,按钮定位,clrDarkViolet,clrBlack);
   ui_utils.按钮("标签触发测试按钮","关闭测试","触发测试",按钮X+按钮间隔X*2,按钮Y+按钮间隔Y*0,45,20,按钮定位,clrDarkViolet,clrBlack);
   ui_utils.按钮("标签加单按钮","关闭加单","触发加单",按钮X+按钮间隔X*2,按钮Y+按钮间隔Y*1,45,20,按钮定位,clrDarkViolet,clrBlack);
}


bool ShowCurrentAccountStates() {
   double total_floating_profit = ai_utils.GetCurrentFloatingProfit();
   max_total_floating_profit = fmax(max_total_floating_profit, total_floating_profit);
   min_total_floating_profit = fmin(min_total_floating_profit, total_floating_profit);
   double total_close_and_floating_profit = ai_utils.GetCurrentTotalProfit();
   min_total_close_and_floating_profit = fmin(min_total_close_and_floating_profit, total_close_and_floating_profit);
   max_total_close_and_floating_profit = fmax(total_close_and_floating_profit, total_close_and_floating_profit);

   string arr[100];
   arr[0] = ("total_float_profit: " + DoubleToStr(total_floating_profit));
   arr[1] = ("max_total_floating_profit: " + DoubleToStr(max_total_floating_profit));
   arr[2] = ("min_total_floating_profit: " + DoubleToStr(min_total_floating_profit));
   arr[3] = ("min_total_close_and_floating_profit: " + DoubleToStr(min_total_close_and_floating_profit));
   arr[4] = ("max_total_close_and_floating_profit: " + DoubleToStr(max_total_close_and_floating_profit));
   arr[5] = ("total_close_and_floating_profit: " + DoubleToStr(total_close_and_floating_profit));
   ShowFixLabelContent(arr, 6);
   return true;
}

// 显示标签
bool ShowFixLabelContent(string& content_showing[], int len) {
   int X=20;
   int Y=20;
   int Y间隔=15;
   color 标签颜色=Yellow;
   int 标签字体大小=10;
   ENUM_BASE_CORNER 固定角=0;

   for(int i = 0 ; i < ArraySize(content_showing) && i < len; i++) {
      ui_utils.固定位置标签("标签"+i,content_showing[i],X,Y+Y间隔*i,标签颜色,标签字体大小,固定角);
   }

   return true;
}

bool IsNewBar() {
   // Print("Time[0], ", Time[0], "TimePrev, ", TimePrev);
   return Time[0] == TimePrev; 
}
