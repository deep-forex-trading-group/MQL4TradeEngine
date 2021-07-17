//+------------------------------------------------------------------+
//|                                             军用级趋势攻击对冲EA  |
//+------------------------------------------------------------------+
// coding_style: 
// 1. self-comment 通过函数名就知道要干什么，不需要看实现细节
// 2. 最大程度实现功能封装解耦，超过20行代码的通用功能封装成函数
// 3. 函数分块管理: 把同类功能的函数和变量尽可能写在一起，方遍管理

// TODO: 重点，被套的时候为了解套，应该全程开启盈亏对冲随时冲掉单子，但是一直保留一单信号单

#property copyright "文艺复兴科技公司大中华区分公司-江枫,清泉"
#property link      ""
#include <UsedUtils/OrderManageUtils.mqh>
#include <UsedUtils/HedgeUtilsDual.mqh>
#include <UsedUtils/AccountInfoUtils.mqh>
#include <UsedUtils/UIUtils.mqh>

#include "Executors/HedgeExecutors.mqh"
#include "Conf/Configuration.mqh"

// 外部输入参数
input ENUM_BASE_CORNER 按钮定位=CORNER_RIGHT_LOWER;
extern double 下单手数 = 0.01; // 下单手数
extern double 累加间隔 = 20.0; // 累加间隔
extern double 回调间隔 = 20.0; // 回调间隔
extern int 盈利开启对冲单量 = 2; // 盈利开启对冲单量
extern int 亏损开启对冲单量 = 2; // 亏损开启对冲单量
extern int 盈利最大单量 = 100; // 最大单量
extern int 亏损最大单量 = 100; // 最大单量
extern double 解套金额 = 10.0; // 解套金额(单位美元)
extern double 最大盈利金额 = 10.0; // 最大盈利金额(单位美元)
extern double 硬止损 = 10000.0; // 解套金额(单位美元)
extern double 平均单止损 = 10000.0; // 解套金额(单位美元)
extern double 盈亏对冲上沿 = 0.3; // 盈亏对冲上沿(单位美元)
extern double 盈亏对冲下沿 = 0.1; // 盈亏对冲下沿(单位美元)
extern int    方向 = 0; // 方向1多,2空，0双开
// extern int    方向线均线参数 = 1000;
// extern int    突破回调 = 1; // 突破或者回调,突破1回调2
// extern int    突破带距离 = 5;
// extern int    操作线均线参数   = 60; // 均线周期
// extern int    iMA_OpenDistance = 2; // 开单距离西安
extern bool   CheckNewBar = true;

// Magic Numbers
Configuration conf;
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

bool is_already_buy_hedged = false;
bool is_already_sell_hedged = false;

#ifndef TestMode1 
   #define TestMode1 
#endif

OrderManageUtils ou();
HedgeUtilsDual *hu_buy = new HedgeUtilsDualBuy();
HedgeUtilsDual *hu_sell = new HedgeUtilsDualSell();
AccountInfoUtils ai_utils();
UIUtils ui_utils();
   
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
   delete hu_buy;
   delete hu_sell;
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
//   下单手数 = NormalizeDouble(AccountEquity() * 4/100000,2);
   // // 若盈利大于最大盈利则全部平仓
   ShowCurrentAccountStates();
   if (CheckPingCang()) {
      return;
   }
   // ObjectSetInteger(0,"标签单向对冲按钮",OBJPROP_STATE,1);
   // 刷新图像界面，例如平仓按钮
   RefreshGraphItems();
}

bool StartTesting() {
   int buy_orders_num = ou.GetNumOfBuyOrders();
   int sell_orders_num = ou.GetNumOfSellOrders();;
   int total_loss_num = ou.GetNumOfLossOrders();
   bool 是否亏损 = (total_loss_num >= 亏损开启对冲单量);
   Print("是否亏损: ", 是否亏损);
   Print("total_loss_num: ", total_loss_num);
   return true;
}

bool HuiTiaoJiaCang() {
   //int TradeSignal = GetSignal();
   int total_buy_orders = ou.GetNumOfBuyOrders();
   int total_sell_orders = ou.GetNumOfSellOrders();

   if (total_buy_orders > 0 && total_buy_orders < 亏损最大单量  && (方向 == 0 || 方向 == 1)) {
      OrderInMarket lres[1];
      ou.GetLowestOpenPriceOrder(lres);
      if (Ask - lres[0].order_open_price <= -回调间隔*vPoint) {
         ui_utils.laber("回调多",Yellow,0);
         ou.CreateBuyOrder(下单手数, 0, 0);
      }
         
   }

   if (total_sell_orders > 0 && total_sell_orders < 亏损最大单量 && (方向 == 0 || 方向 == 2)) {
      OrderInMarket hres[1];
      ou.GetHighestOpenPriceOrder(hres);
      Print("最高单价: ", hres[0].order_open_price);
      if (Bid - hres[0].order_open_price >= 回调间隔*vPoint) {
         ui_utils.laber("回调空",Yellow,0);
         ou.CreateSellOrder(下单手数, 0, 0);
      }
   }
   
   return true;
}

bool CheckPingCang() {
   double total_floating_profit = ai_utils.GetCurrentFloatingProfit();
   if (total_floating_profit >= 最大盈利金额) {
      ou.CloseAllOrders();
      Print("Target Profit ", 最大盈利金额, " is achieved with profit ", total_floating_profit);
      ui_utils.laber("止盈",Blue,0);
      ResetAllButtonOpenStates();
      return true;
   }

   // 若套住时，盈利大于解套盈利则全部平仓
   if (ou.GetNumOfBuyOrders() > 0 && ou.GetNumOfSellOrders() > 0 && total_floating_profit >= 解套金额) {
      ou.CloseAllOrders();
      Print("Dissolution Target Profit ", 解套金额, " is achieved with profit ", total_floating_profit);
      ui_utils.laber("解套",Yellow,0);
      ResetAllButtonOpenStates();
      return true;
   }

   if ((ou.GetNumOfBuyOrders() > 0 || ou.GetNumOfSellOrders() > 0) && total_floating_profit <= -硬止损) {
      ou.CloseAllOrders();
      Print("Dissolution Target Loss ", 硬止损, " is achieved with profit ", total_floating_profit);
      ui_utils.laber("止损",Red,0);
      ResetAllButtonOpenStates();
      return true;
   }

   if (ou.GetNumOfBuyOrders() > 0 && total_floating_profit <= -平均单止损*ou.GetNumOfBuyOrders()) {
      ou.CloseAllBuyOrders();
      ui_utils.laber("买止损",Red,0);
      ResetAllButtonOpenStates();
      return true;
   }

   if (ou.GetNumOfSellOrders() > 0 && total_floating_profit <= -平均单止损*ou.GetNumOfSellOrders()) {
      ou.CloseAllSellOrders();
      ui_utils.laber("卖止损",Red,0);
      ResetAllButtonOpenStates();
      return true;
   }

   return false;
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
   is_already_buy_hedged = false;
   is_already_sell_hedged = false;
}

void RefreshButtonsStates() {
   // 如果按下按钮则做对应操作
   int buy_orders_num = ou.GetNumOfBuyOrders(), sell_orders_num = ou.GetNumOfSellOrders();
   double total_floating_profit = ai_utils.GetCurrentFloatingProfit();
   if(ObjectGetInteger(0,"标签全平按钮",OBJPROP_STATE)==1) {
      ou.CloseAllOrders();
      ObjectSetInteger(0,"标签全平按钮",OBJPROP_STATE,0);
      is_already_buy_hedged = false;
      is_already_sell_hedged = false;
      ResetAllButtonOpenStates();
   }

   if(ObjectGetInteger(0,"标签平多",OBJPROP_STATE)==1) {
      ou.CloseAllBuyOrders();
      ObjectSetInteger(0,"标签平多",OBJPROP_STATE,0);
      ResetAllButtonOpenStates();
   }
   if(ObjectGetInteger(0,"标签平空",OBJPROP_STATE)==1) {
      ou.CloseAllSellOrders();
      ObjectSetInteger(0,"标签平空",OBJPROP_STATE,0);
      ResetAllButtonOpenStates();
   }

   if(ObjectGetInteger(0,"标签加多",OBJPROP_STATE)==1) {
      ou.CreateBuyOrder(下单手数,0,0);
      ObjectSetInteger(0,"标签加多",OBJPROP_STATE,0);
   }

   if(ObjectGetInteger(0,"标签加空",OBJPROP_STATE)==1) {
      ou.CreateSellOrder(下单手数,0,0);
      ObjectSetInteger(0,"标签加空",OBJPROP_STATE,0);
   }

   if(ObjectGetInteger(0,"标签自动做多",OBJPROP_STATE)==1) {
      if (total_floating_profit >=0) {
         if (buy_orders_num > 0 && buy_orders_num < 盈利最大单量) {
               ou.AddOneOrderByStepPip(0, 累加间隔, 下单手数);
         }
      } else {
         if (buy_orders_num > 0 && buy_orders_num < 亏损最大单量) {
               ou.AddOneOrderByStepPip(0, 累加间隔, 下单手数);
         }
      }
      HuiTiaoJiaCang();
   }

   if(ObjectGetInteger(0,"标签自动做空",OBJPROP_STATE)==1) {
      if (total_floating_profit >=0) {
         if (sell_orders_num >=0 && sell_orders_num < 盈利最大单量) {
            ou.AddOneOrderByStepPip(1, 累加间隔, 下单手数);
         }
      } else {
         if (sell_orders_num >=0 && sell_orders_num < 亏损最大单量) {
            ou.AddOneOrderByStepPip(1, 累加间隔, 下单手数);
         }
      }
      HuiTiaoJiaCang();
   }
   
   if(ObjectGetInteger(0,"标签单向对冲按钮",OBJPROP_STATE)==1) {
      // int 开启对冲单量 = total_floating_profit >=0 ? 盈利开启对冲单量 : 亏损开启对冲单量;
      // bool is_kuisun = total_floating_profit < 0;
      buy_orders_num = ou.GetNumOfBuyOrders();
      sell_orders_num = ou.GetNumOfSellOrders();;
      int total_loss_num = ou.GetNumOfLossOrders();
      bool 是否亏损 = (total_loss_num >= 亏损开启对冲单量);
      int 开启对冲单量 = 是否亏损 ? 亏损开启对冲单量 : 盈利开启对冲单量;
      if (sell_orders_num>=开启对冲单量 || is_already_sell_hedged) {
         // 行情调转方向回头，单子冲掉到只剩两个单子，则不开新单
         HedgeUtilsDualParams hedge_sell_params;
         hedge_sell_params.profit_upper = 盈亏对冲上沿;
         hedge_sell_params.profit_lower = 盈亏对冲下沿;
         hedge_sell_params.is_add_new = ou.GetNumOfSellOrders() > 2;
         if (hu_sell.HdegeOrders(hedge_sell_params)) {
            ui_utils.laber(!是否亏损 ? "对冲空" : "亏对冲空",!是否亏损 ? Blue : Red,0);
         }
         is_already_sell_hedged = ou.GetNumOfSellOrders() > 2;
      }

      if (buy_orders_num>=开启对冲单量 || is_already_buy_hedged) {
         // 行情调转方向回头，单子冲掉到只剩两个单子，则不开新单 
         HedgeUtilsDualParams hedge_buy_params;
         hedge_buy_params.profit_upper = 盈亏对冲上沿;
         hedge_buy_params.profit_lower = 盈亏对冲下沿;
         hedge_buy_params.is_add_new = ou.GetNumOfBuyOrders() > 2;
         if (hu_buy.HdegeOrders(hedge_buy_params)) {
            ui_utils.laber(!是否亏损 ? "对冲多" : "亏对冲多",!是否亏损 ? Blue : Red,0);
         }
         is_already_buy_hedged = ou.GetNumOfBuyOrders() > 2;
      }
   }

   // TODO:修改逻辑为
   // 接口逻辑: 
   // 加第一单: 如果(一边有单子 && 所有单子为浮亏状态 && 另一边没有单子) 浮亏第一单间距StepPip点加第一单
   if(ObjectGetInteger(0,"多空对冲按钮",OBJPROP_STATE)==1) {
      int cur_symbol_digits = MarketInfo(NULL,MODE_DIGITS) ;

//      double AddLotsSell = NormalizeDouble(下单手数 * MathPow(2,ou.GetNumOfSellOrders()),cur_symbol_digits);
//      double AddLotsBuy = NormalizeDouble(下单手数 * MathPow(2,ou.GetNumOfBuyOrders()),cur_symbol_digits);

//        double AddLotsSell = NormalizeDouble(下单手数 * MathPow(2,ou.GetNumOfBuyOrders()),cur_symbol_digits);
//        double AddLotsBuy = NormalizeDouble(下单手数 * MathPow(2,ou.GetNumOfSellOrders()),cur_symbol_digits);

        double AddLotsSell = NormalizeDouble(下单手数 * MathPow(
                                            1.2,ou.GetNumOfBuyOrders() + ou.GetNumOfSellOrders()),cur_symbol_digits);
        double AddLotsBuy = AddLotsSell;

//      double AddLotsSell = 下单手数;
//      double AddLotsBuy = 下单手数;
      OrderInMarket lres[1];
      ou.GetLowestOpenPriceOrder(lres);
      if (ou.GetNumOfBuyOrders() == 0) {
         if(lres[0].order_open_price != 0 
            && NormalizeDouble(Bid, Digits) - lres[0].order_open_price <= -累加间隔*vPoint) {
                Print("1st sell , " + AddLotsSell + "," + 下单手数);
                ou.CreateSellOrder(AddLotsSell, 0, 0);
            }

      } else if (ou.GetNumOfBuyOrders() > 0) {
         if(lres[0].order_open_price != 0 
            && NormalizeDouble(Bid, Digits) - lres[0].order_open_price <= -累加间隔*vPoint) {
                Print("add sell , " + AddLotsSell + "," + 下单手数);
                ou.AddOneOrderByStepPip(1,累加间隔,AddLotsSell);
            }

      }

      OrderInMarket hres[1];
      ou.GetHighestOpenPriceOrder(hres);
      if (ou.GetNumOfSellOrders() == 0) {
         if (hres[0].order_open_price != 0 
             && NormalizeDouble(Ask, Digits) - hres[0].order_open_price >= 累加间隔*vPoint) {
                Print("1st buy , " + AddLotsBuy + "," + 下单手数);
                ou.CreateBuyOrder(AddLotsBuy, 0, 0);
             }
      } else if (ou.GetNumOfSellOrders() > 0) {
         if (hres[0].order_open_price != 0 
             && NormalizeDouble(Ask, Digits) - hres[0].order_open_price >= 累加间隔*vPoint)  {
                 Print("add buy , " + AddLotsBuy + "," + 下单手数);
                 ou.AddOneOrderByStepPip(0,累加间隔,AddLotsBuy);
             }

      }
   }
   
   if(ObjectGetInteger(0,"触发测试按钮",OBJPROP_STATE)==1) {
      StartTesting();
      ObjectSetInteger(0,"触发测试按钮",OBJPROP_STATE,0);
   }

   ui_utils.CheckButtonState("标签单向对冲按钮","关闭对冲","单向对冲",clrBlue,clrBlack);
   ui_utils.CheckButtonState("标签自动做多","关自动多","自动多",clrBlue,clrAqua);
   ui_utils.CheckButtonState("标签自动做空","关自动空","自动空",clrYellow,clrRed);
}

// 获取按钮对象函数, 初始化并获取对应的按钮对象
void InitGraphItems() {
   int 按钮X=120;
//   int 按钮X=20;
   int 按钮Y=25;
   int 按钮间隔X=50;
   int 按钮间隔Y=25;
   
   // Y从下往上，x从右往左
   ui_utils.按钮("标签自动做多","自动多","关自动多",按钮X+按钮间隔X*2,按钮Y+按钮间隔Y*4,45,20,按钮定位,clrBlue,clrAqua);
   ui_utils.按钮("标签自动做空","自动空","关自动空",按钮X+按钮间隔X*2,按钮Y+按钮间隔Y*3,45,20,按钮定位,clrYellow,clrRed);
   ui_utils.按钮("标签平多","平多","平多",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*4,45,20,按钮定位,clrFireBrick,clrBlack);
   ui_utils.按钮("标签平空","平空","平空",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*3,45,20,按钮定位,clrMediumVioletRed,clrBlack);
   ui_utils.按钮("标签加多","加多","加多",按钮X+按钮间隔X*0,按钮Y+按钮间隔Y*4,45,20,按钮定位,clrMediumSeaGreen,clrBlack);
   ui_utils.按钮("标签加空","加空","加空",按钮X+按钮间隔X*0,按钮Y+按钮间隔Y*3,45,20,按钮定位,clrChocolate,clrBlack);
   ui_utils.按钮("标签全平按钮","全平按钮","全平按钮",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*2,45,20,按钮定位,clrDarkViolet,clrBlack);

   // 触发信号单
//   ui_utils.按钮("标签单向对冲按钮","关闭对冲","单向对冲",
//                按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*1,
//                45,20,按钮定位,clrDarkViolet,clrBlack);
   ui_utils.按钮("标签单向对冲按钮","关闭对冲","单向对冲",
                60+按钮间隔X*1,按钮Y+按钮间隔Y*1,
                45,20,按钮定位,clrDarkBlue,clrOrange);
   ui_utils.按钮("多空对冲按钮","关闭对冲","多空对冲",按钮X+按钮间隔X*1,按钮Y+按钮间隔Y*0,45,20,按钮定位,clrDarkViolet,clrBlack);
   ObjectSetInteger(0,"多空对冲按钮",OBJPROP_STATE,1);
   ui_utils.按钮("触发测试按钮","关闭测试","触发测试",按钮X+按钮间隔X*2,按钮Y+按钮间隔Y*0,45,20,按钮定位,clrDarkViolet,clrBlack);
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

// int GetSignal()
// {
//   int Signal = 0;

//   double iMA_Signal = iMA(Symbol(), 0, 操作线均线参数, 0, MODE_SMMA, PRICE_CLOSE, 0);
//   double iMA_Dir = iMA(Symbol(), 0, 方向线均线参数, 0, MODE_SMMA, PRICE_CLOSE, 0);

//   // 突破做单
//   //Print(iMA_OpenDistance + 突破带距离);
//   //Print((Ask - iMA_Signal)/vPoint);
//   if (突破回调 == 1) {
//    if ((Ask - iMA_Signal)/vPoint >= iMA_OpenDistance
//        && Ask > iMA_Dir
//        && (Ask - iMA_Signal)/vPoint <= (iMA_OpenDistance + 突破带距离) 
//        && Ask > iMA_Signal) Signal = 1;
//    if ((iMA_Signal - Bid)/vPoint >= iMA_OpenDistance
//        && Bid < iMA_Dir
//        &&(iMA_Signal - Bid)/vPoint <= (iMA_OpenDistance + 突破带距离)
//        && Bid < iMA_Signal) Signal = -1;
//   }

//   // 回调做单
//   if (突破回调 == 2) {
//    if ((iMA_Signal - Ask)/vPoint >= iMA_OpenDistance && Ask < iMA_Signal) Signal = 1;
//    if ((Bid - iMA_Signal)/vPoint >= iMA_OpenDistance && Bid > iMA_Signal) Signal = -1;
//   }

//   if (TimeToString(TimeCurrent()) == "2019.04.26 12:50") {
//     Print("tag111: ", TimeToString(TimeCurrent()), ",", Ask, ",", iMA_Signal, 
//           ",",  (iMA_Signal - Ask)/vPoint, ",", 
//           iMA_OpenDistance,  "," , Signal);
//   }
  
//   return(Signal);
// }