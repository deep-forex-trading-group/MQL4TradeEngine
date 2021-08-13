//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "鱼儿编程 QQ：276687220"
#property link      "http://babelfish.taobao.com/"
#import "kernel32.dll"
int CopyFileW(string a0,string a1,int a2);
bool CreateDirectoryW(string a0,int a1);
extern bool 是否显示文字标签=true;
input string FILES文件夹路径="";
input string 中转路径="";
string 中转路径2="";
string FILES文件夹路径2;
extern string 跟踪主账号="";
extern string 货币对名称附加="";
extern int 跟单允许秒误差=300;
extern double 跟单允许点误差=100;
extern bool 反向跟单=false;
extern bool 跟踪挂单=true;
extern string comm1="---------个别货币对无法正常跟单时使用------------";
extern bool 货币对名称强制修正开关=false;
extern string 所跟货币对名称="XAUUSD";
extern string 下单货币对名称="GOLD";
extern string comm2="---------------------";
extern double 跟主账户单量大于等于N单子=0;
extern double 跟主账户单量小于等于M单子=100;
extern bool 直接进单需价格更优=false;
extern double 优于点数=0.5;
extern string comm3="---注意功能开关别重复------------------";
extern bool 跟踪止损止盈=false;
extern bool 自行设置止损止盈=true;
extern double 自行设置初始止损=50;
extern double 自行设置初始止盈=50;
extern bool 移动止损开关=true;
extern double 移动止损激活点数=30;
extern double 回调离场距离=10;
extern string comm4="---------------------";
extern bool 离场后可再次进场=true;
extern bool 跟踪平仓=true;
extern string comm5="---------------------";
extern double 单量比例=1;
extern bool 使用固定单量=false;
extern double 固定单量=0.1;
extern bool 使用净值比例计算单量=false;
extern double 每1000美金净值对应单量=0.1;
extern bool 使用余额比例计算单量=false;
extern double 每1000美金余额对应单量=0.1;
extern bool 使用两个账户净值比计算单量=false;
extern double 两账户净值比系数M=1;
double 对方净值;
extern string comm6="---------------------";
extern bool 限定可做的货币对=false;
extern string 限制可做货币对1="";
extern string 限制可做货币对2="";
extern string 限制可做货币对3="";
extern string 限制可做货币对4="";
extern string 限制可做货币对5="";
extern string 限制可做货币对6="";
extern string 限制可做货币对7="";
extern string 限制可做货币对8="";
extern string 限制可做货币对9="";
extern string 限制可做货币对10="";
string 限制可做货币对[100];
extern string comm7="---------------------";
extern bool 限定不可做的货币对=false;
extern string 限制不可做货币对1="";
extern string 限制不可做货币对2="";
extern string 限制不可做货币对3="";
extern string 限制不可做货币对4="";
extern string 限制不可做货币对5="";
extern string 限制不可做货币对6="";
extern string 限制不可做货币对7="";
extern string 限制不可做货币对8="";
extern string 限制不可做货币对9="";
extern string 限制不可做货币对10="";
string 限制不可做货币对[100];
extern string comm8="---------------------";
extern string 自定义部分备注="";
extern string 自定义部分备注2="顺";
extern string 自定义部分备注3="反";
extern int X=20;
extern int Y=20;
extern int Y间隔=15;
extern color 标签颜色=Yellow;
extern int 标签字体大小=10;
extern int 固定角=1;

int        OrderTicketX[200];
string     OrderSymbolX[200];
int        OrderTypeX[200];
double     OrderLotsX[200];
double     OrderStopLossX[200];
double     OrderTakeProfitX[200];
string     OrderCommentX[200];
int        OrderMagicNumberX[200];
datetime   OrderOpenTimeX[200];
double     OrderOpenPriceX[200];

int        OrderTicketXH[200];
string     OrderSymbolXH[200];
int        OrderTypeXH[200];
double     OrderLotsXH[200];
double     OrderStopLossXH[200];
double     OrderTakeProfitXH[200];
string     OrderCommentXH[200];
int        OrderMagicNumberXH[200];
datetime   OrderOpenTimeXH[200];
double     OrderOpenPriceXH[200];
double 滑点=100;
double 单量反馈X;
//=========================================================================== 
int init()
  {
   限制可做货币对[1]=限制可做货币对1;
   限制可做货币对[2]=限制可做货币对2;
   限制可做货币对[3]=限制可做货币对3;
   限制可做货币对[4]=限制可做货币对4;
   限制可做货币对[5]=限制可做货币对5;
   限制可做货币对[6]=限制可做货币对6;
   限制可做货币对[7]=限制可做货币对7;
   限制可做货币对[8]=限制可做货币对8;
   限制可做货币对[9]=限制可做货币对9;
   限制可做货币对[10]=限制可做货币对10;

   限制不可做货币对[1]=限制不可做货币对1;
   限制不可做货币对[2]=限制不可做货币对2;
   限制不可做货币对[3]=限制不可做货币对3;
   限制不可做货币对[4]=限制不可做货币对4;
   限制不可做货币对[5]=限制不可做货币对5;
   限制不可做货币对[6]=限制不可做货币对6;
   限制不可做货币对[7]=限制不可做货币对7;
   限制不可做货币对[8]=限制不可做货币对8;
   限制不可做货币对[9]=限制不可做货币对9;
   限制不可做货币对[10]=限制不可做货币对10;

   for(int ix=0;ix<200;ix++)
     {
      OrderSymbolX[ix]="";
      OrderCommentX[ix]="";
      OrderSymbolXH[ix]="";
      OrderCommentXH[ix]="";
     }
   if(IsDllsAllowed()==false)
      Alert("请允许调用动态链接库");

   return(0);
  }
//===========================================================================
int deinit()
  {

   return(0);
  }
//===========================================================================
int start()
  {

   if(IsTradeAllowed()==false)
     {
      Comment("           不允许智能交易");
      return(0);
     }

   if(IsDllsAllowed()==false)
      return(0);

   if(中转路径=="")
     {
      CreateDirectoryW("C:\\鱼儿编程跟单软件中转路径",0);
      中转路径2="C:\\鱼儿编程跟单软件中转路径";
     }
   else
      中转路径2=中转路径;

   while(true)
     {

      if(FILES文件夹路径!="")
         FILES文件夹路径2=FILES文件夹路径;
      else
         FILES文件夹路径2=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files";

      int t=CopyFileW(中转路径2+"\\"+跟踪主账号+"3.csv",FILES文件夹路径2+"\\"+跟踪主账号+"3.csv",0);

      int handle;
      handle=FileOpen(跟踪主账号+"3.csv",FILE_CSV|FILE_READ,';');

      if(handle>0)
        {
         对方净值=StrToDouble(FileReadString(handle));
         FileClose(handle);
        }

      提取信号();
      跟踪市价单();
      提取历史信号();

      修改订单止损止盈();

      if(跟踪平仓)
         平单();

      if(移动止损开关==true)
         gengzong(-100,移动止损激活点数,回调离场距离,1,-1,"");

      Comment(
              "\n历史0:"+OrderTicketXH[0]+" "+OrderSymbolXH[0]+" "+OrderTypeXH[0]+" "+OrderLotsXH[0]+
              "\n历史1:"+OrderTicketXH[1]+" "+OrderSymbolXH[1]+" "+OrderTypeXH[1]+" "+OrderLotsXH[1]+
              "\n历史2:"+OrderTicketXH[2]+" "+OrderSymbolXH[2]+" "+OrderTypeXH[2]+" "+OrderLotsXH[2]+
              "\n历史3:"+OrderTicketXH[3]+" "+OrderSymbolXH[3]+" "+OrderTypeXH[3]+" "+OrderLotsXH[3]+
              "\n历史4:"+OrderTicketXH[4]+" "+OrderSymbolXH[4]+" "+OrderTypeXH[4]+" "+OrderLotsXH[4]+
              "\n历史5:"+OrderTicketXH[5]+" "+OrderSymbolXH[5]+" "+OrderTypeXH[5]+" "+OrderLotsXH[5]+
              "\n历史6:"+OrderTicketXH[6]+" "+OrderSymbolXH[6]+" "+OrderTypeXH[6]+" "+OrderLotsXH[6]+
              "\n"+
              "\n持有0:"+OrderTicketX[0]+" "+OrderSymbolX[0]+" "+OrderTypeX[0]+" "+OrderLotsX[0]+" 对应"+已跟单对应记录(OrderTicketX[0])+" 时间"+TimeToStr(OrderOpenTimeX[0])+
              "\n持有1:"+OrderTicketX[1]+" "+OrderSymbolX[1]+" "+OrderTypeX[1]+" "+OrderLotsX[1]+" 对应"+已跟单对应记录(OrderTicketX[1])+" 时间"+TimeToStr(OrderOpenTimeX[1])+
              "\n持有2:"+OrderTicketX[2]+" "+OrderSymbolX[2]+" "+OrderTypeX[2]+" "+OrderLotsX[2]+" 对应"+已跟单对应记录(OrderTicketX[2])+" 时间"+TimeToStr(OrderOpenTimeX[2])+
              "\n持有3:"+OrderTicketX[3]+" "+OrderSymbolX[3]+" "+OrderTypeX[3]+" "+OrderLotsX[3]+" 对应"+已跟单对应记录(OrderTicketX[3])+" 时间"+TimeToStr(OrderOpenTimeX[3])+
              "\n持有4:"+OrderTicketX[4]+" "+OrderSymbolX[4]+" "+OrderTypeX[4]+" "+OrderLotsX[4]+" 对应"+已跟单对应记录(OrderTicketX[4])+" 时间"+TimeToStr(OrderOpenTimeX[4])+
              "\n持有5:"+OrderTicketX[5]+" "+OrderSymbolX[5]+" "+OrderTypeX[5]+" "+OrderLotsX[5]+" 对应"+已跟单对应记录(OrderTicketX[5])+" 时间"+TimeToStr(OrderOpenTimeX[5])+
              "\n持有6:"+OrderTicketX[6]+" "+OrderSymbolX[6]+" "+OrderTypeX[6]+" "+OrderLotsX[6]+" 对应"+已跟单对应记录(OrderTicketX[6])+" 时间"+TimeToStr(OrderOpenTimeX[6])
              );

      string 内容[100];
      内容[0]="跟踪主账号: "+跟踪主账号;
      内容[1]="使用固定单量: "+使用固定单量;
      内容[2]="使用净值比例计算单量: "+使用净值比例计算单量;
      内容[3]="使用余额比例计算单量: "+使用余额比例计算单量;
      内容[4]="单量: "+单量反馈X;
      内容[5]="对方净值: "+对方净值;
      内容[6]="自己净值: "+AccountEquity();
      if(对方净值!=0)
      内容[7]="双边净值比*M: "+DoubleToStr(AccountEquity()/对方净值*两账户净值比系数M,2);
      for(int ixx=0;ixx<=7;ixx++)
         固定位置标签("标签"+ixx,内容[ixx],X,Y+Y间隔*ixx,标签颜色,标签字体大小,固定角);

   
      ChartRedraw();
      if(!(!IsStopped() && IsExpertEnabled() && IsTesting()==false && IsOptimization()==false))
         return;
      Sleep(300);
     }
   return;
  }
//+------------------------------------------------------------------+
void 固定位置标签(string 名称,string 内容,int X,int Y,color C,int 字体大小,int 固定角)
  {
   if(ObjectFind(名称)==-1)
     {
      ObjectDelete(名称);
      ObjectCreate(名称,OBJ_LABEL,0,0,0);
     }
   ObjectSet(名称,OBJPROP_XDISTANCE,X);
   ObjectSet(名称,OBJPROP_YDISTANCE,Y);
   ObjectSetText(名称,内容,字体大小,"宋体",C);
   ObjectSet(名称,OBJPROP_CORNER,固定角);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void gengzong(int type,double 启动距离,double 保持距离,double 跳跃距离,int magic,string comm)
  {
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS))
         //if(OrderSymbol()==Symbol())
         if(OrderType()==type || type==-100)
            if(OrderMagicNumber()==magic || magic==-1)
               if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                 {
                  RefreshRates();
                  double a=OrderClosePrice();
                  double PointX=MarketInfo(OrderSymbol(),MODE_POINT);
                  double DigitsX=MarketInfo(OrderSymbol(),MODE_DIGITS);
                  if(保持距离<MarketInfo(OrderSymbol(),MODE_STOPLEVEL)/系数(OrderSymbol()))
                     return(0);

                  if(OrderType()==OP_BUY)
                     if(a-OrderOpenPrice()>启动距离*PointX*系数(OrderSymbol()))
                        if(NormalizeDouble(a-(保持距离*系数(OrderSymbol())+跳跃距离)*PointX,DigitsX)>=OrderStopLoss() || OrderStopLoss()==0)
                          {
                           OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(a-保持距离*PointX*系数(OrderSymbol()),DigitsX),OrderTakeProfit(),0);
                           报错组件("");
                          }

                  if(OrderType()==OP_SELL)
                     if(OrderOpenPrice()-a>启动距离*PointX*系数(OrderSymbol()))
                        if(NormalizeDouble(a+(保持距离*系数(OrderSymbol())+跳跃距离)*PointX,DigitsX)<=OrderStopLoss() || OrderStopLoss()==0)
                          {
                           OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(a+保持距离*PointX*系数(OrderSymbol()),DigitsX),OrderTakeProfit(),0);
                           报错组件("");
                          }
                 }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 平单()
  {
   for(int i2=0;i2<200;i2++)
      if(OrderTicketXH[i2]!=0)
         if(OrderSelect(findlassorder(-100,-1,"后","现在",OrderTicketXH[i2]),SELECT_BY_TICKET))
            if(OrderCloseTime()==0)
               if(StringSubstr(OrderComment(),StringFind(OrderComment(),"[",0)+1,StringFind(OrderComment(),"]",0)-StringFind(OrderComment(),"[",0)-1)==DoubleToStr(OrderTicketXH[i2],0))
                  if(OrderCloseTime()==0)
                    {
                       {
                        if(OrderType()>1)
                          {
                           OrderDelete(OrderTicket());
                           报错组件("");
                          }
                        else
                          {
                           OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),滑点);
                           报错组件("");
                          }
                       }
                    }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int 已跟单对应记录(int ti)
  {

   if(ti==0)
      return(-1);
   return(findlassorder(-100,-1,"后","现在",ti)+findlassorder(-100,-1,"后","历史",ti)+1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int findlassorder(int type,int magic,string fx,string 现在与历史,string comm)
  {
   if(现在与历史=="现在")
      if(fx=="后")
         for(int i=OrdersTotal()-1;i>=0;i--)
           {
            if(OrderSelect(i,SELECT_BY_POS))
               //if(Symbol()==OrderSymbol())
               if(OrderMagicNumber()==magic || magic==-1)
                  if(OrderType()==type || type==-100)
                     if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                        return(OrderTicket());
           }

   if(现在与历史=="现在")
      if(fx=="前")
         for(i=0;i<OrdersTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS))
               //if(Symbol()==OrderSymbol())
               if(OrderMagicNumber()==magic || magic==-1)
                  if(OrderType()==type || type==-100)
                     if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                        return(OrderTicket());
           }

   if(现在与历史=="历史")
      if(fx=="后")
         for(i=OrdersHistoryTotal()-1;i>=0;i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
               //if(Symbol()==OrderSymbol())
               if(OrderMagicNumber()==magic || magic==-1)
                  if(OrderType()==type || (type==-100 && OrderType()<=5 && OrderType()>=0))
                     if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                        if(OrderCloseTime()!=0)
                           return(OrderTicket());
           }

   if(现在与历史=="历史")
      if(fx=="前")
         for(i=0;i<OrdersHistoryTotal();i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
               //if(Symbol()==OrderSymbol())
               if(OrderMagicNumber()==magic || magic==-1)
                  if(OrderType()==type || (type==-100 && OrderType()<=5 && OrderType()>=0))
                     if(StringFind(OrderComment(),comm,0)!=-1 || comm=="")
                        if(OrderCloseTime()!=0)
                           return(OrderTicket());
           }
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 修改订单止损止盈()
  {
   if(跟踪挂单)
      for(int i=0;i<200;i++)
         if(OrderSelect(已跟单对应记录(OrderTicketX[i]),SELECT_BY_TICKET))
            if(OrderCloseTime()==0)
               if(OrderType()>1)
                  if(OrderOpenPrice()!=OrderOpenPriceX[i])
                    {

                     OrderModify(OrderTicket(),OrderOpenPriceX[i],OrderStopLoss(),OrderTakeProfit(),0);
                    }

   if(跟踪止损止盈)
      for(i=0;i<200;i++)
         if(OrderSelect(已跟单对应记录(OrderTicketX[i]),SELECT_BY_TICKET))
            if(OrderCloseTime()==0)
              {

               if(反向跟单==false)
                  if(!(OrderStopLoss()==OrderStopLossX[i] && OrderTakeProfit()==OrderTakeProfitX[i]))
                     OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLossX[i],OrderTakeProfitX[i],0);

               if(反向跟单)
                  if(!(OrderTakeProfit()==OrderStopLossX[i] && OrderStopLoss()==OrderTakeProfitX[i]))
                     OrderModify(OrderTicket(),OrderOpenPrice(),OrderTakeProfitX[i],OrderStopLossX[i],0);
              }
  }
//===========================================================================
void 跟踪市价单()
  {

   for(int i=0;i<200;i++)
      if(OrderSymbolX[i]!="" && OrderTicketX[i]!=0)
         if(OrderTypeX[i]<2 || 跟踪挂单)
            if(TimeLocal()-OrderOpenTimeX[i]<=跟单允许秒误差 || StringFind(OrderCommentX[i],"from",0)!=-1)
               if((OrderTypeX[i]==0 && MathAbs(MarketInfo(OrderSymbolX[i],MODE_ASK)-OrderOpenPriceX[i])<=跟单允许点误差*MarketInfo(OrderSymbolX[i],MODE_POINT)*系数(OrderSymbolX[i]))
                  || (OrderTypeX[i]==1 && MathAbs(MarketInfo(OrderSymbolX[i],MODE_BID)-OrderOpenPriceX[i])<=跟单允许点误差*MarketInfo(OrderSymbolX[i],MODE_POINT)*系数(OrderSymbolX[i]))
                  || 跟踪挂单
                  || StringFind(OrderCommentX[i],"from",0)!=-1)
                  if(已跟单对应记录(OrderTicketX[i])==-1)
                     if(OrderLotsX[i]>=跟主账户单量大于等于N单子)
                        if(OrderLotsX[i]<=跟主账户单量小于等于M单子)
                          {
                           double 止损X=0,止盈X=0;
                           if(自行设置止损止盈)
                             {
                              止损X=自行设置初始止损;
                              止盈X=自行设置初始止盈;
                             }

                           if(OrderTypeX[i]<2)
                             {
                              if(反向跟单==false)
                                {
                                 if(直接进单需价格更优==false
                                    ||(OrderTypeX[i]==OP_BUY&&MarketInfo(OrderSymbolX[i],MODE_ASK)<OrderOpenPriceX[i]-优于点数*MarketInfo(OrderSymbolX[i],MODE_POINT)*系数(OrderSymbolX[i]))
                                    ||(OrderTypeX[i]==OP_SELL&&MarketInfo(OrderSymbolX[i],MODE_BID)>OrderOpenPriceX[i]+优于点数*MarketInfo(OrderSymbolX[i],MODE_POINT)*系数(OrderSymbolX[i])))
                                    int t=建立单据(OrderSymbolX[i],OrderTypeX[i],OrderLotsX[i]*单量比例,0,0,止损X,止盈X,自定义部分备注+自定义部分备注2+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                }
                              else
                                {
                                 if(直接进单需价格更优==false
                                    ||(MathAbs(OrderTypeX[i]-1)==OP_BUY&&MarketInfo(OrderSymbolX[i],MODE_ASK)<OrderOpenPriceX[i]-优于点数*MarketInfo(OrderSymbolX[i],MODE_POINT)*系数(OrderSymbolX[i]))
                                    ||(MathAbs(OrderTypeX[i]-1)==OP_SELL&&MarketInfo(OrderSymbolX[i],MODE_BID)>OrderOpenPriceX[i]+优于点数*MarketInfo(OrderSymbolX[i],MODE_POINT)*系数(OrderSymbolX[i])))
                                    t=建立单据(OrderSymbolX[i],MathAbs(OrderTypeX[i]-1),OrderLotsX[i]*单量比例,0,0,止损X,止盈X,自定义部分备注+自定义部分备注3+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                }
                             }

                           if(跟踪挂单)
                             {
                              if(OrderTypeX[i]==OP_BUYLIMIT)
                                {
                                 if(反向跟单==false)
                                    t=建立单据(OrderSymbolX[i],OP_BUYLIMIT,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,自定义部分备注+自定义部分备注2+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                 else
                                    t=建立单据(OrderSymbolX[i],OP_SELLSTOP,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,自定义部分备注+自定义部分备注3+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                }
                              if(OrderTypeX[i]==OP_BUYSTOP)
                                {
                                 if(反向跟单==false)
                                    t=建立单据(OrderSymbolX[i],OP_BUYSTOP,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,自定义部分备注+自定义部分备注2+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                 else
                                    t=建立单据(OrderSymbolX[i],OP_SELLLIMIT,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,自定义部分备注+自定义部分备注3+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                }
                              if(OrderTypeX[i]==OP_SELLLIMIT)
                                {
                                 if(反向跟单==false)
                                    t=建立单据(OrderSymbolX[i],OP_SELLLIMIT,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,自定义部分备注+自定义部分备注2+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                 else
                                    t=建立单据(OrderSymbolX[i],OP_BUYSTOP,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,自定义部分备注+自定义部分备注3+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                }
                              if(OrderTypeX[i]==OP_SELLSTOP)
                                {
                                 if(反向跟单==false)
                                    t=建立单据(OrderSymbolX[i],OP_SELLSTOP,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,自定义部分备注+自定义部分备注3+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                 else
                                    t=建立单据(OrderSymbolX[i],OP_BUYLIMIT,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,自定义部分备注+自定义部分备注3+"["+OrderTicketX[i]+"]",OrderMagicNumberX[i]);
                                }
                             }
                          }
/////////////////////////////////////////////////////////////

   for(i=0;i<200;i++)
      if(OrderSymbolX[i]!="" && OrderTicketX[i]!=0)
         if(OrderTypeX[i]<2 || 跟踪挂单)
            if(离场后可再次进场)
               if(OrderLotsX[i]>=跟主账户单量大于等于N单子)
                  if(OrderLotsX[i]<=跟主账户单量小于等于M单子)
                     if(findlassorder(-100,-1,"后","现在",OrderTicketX[i])==-1)
                        if(findlassorder(-100,-1,"后","历史",OrderTicketX[i])!=-1)
                          {

                           止损X=0;
                           止盈X=0;
                           if(自行设置止损止盈)
                             {
                              止损X=自行设置初始止损;
                              止盈X=自行设置初始止盈;
                             }
                           if(OrderTypeX[i]==OP_BUY)
                             {
                              if(反向跟单==false)
                                 t=建立单据X(OrderSymbolX[i],OP_BUY,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,OrderTicketX[i],OrderMagicNumberX[i]);
                              else
                                 t=建立单据X(OrderSymbolX[i],OP_SELL,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,OrderTicketX[i],OrderMagicNumberX[i]);
                             }

                           if(OrderTypeX[i]==OP_SELL)
                             {
                              if(反向跟单==false)
                                 t=建立单据X(OrderSymbolX[i],OP_SELL,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,OrderTicketX[i],OrderMagicNumberX[i]);
                              else
                                 t=建立单据X(OrderSymbolX[i],OP_BUY,OrderLotsX[i]*单量比例,OrderOpenPriceX[i],0,止损X,止盈X,OrderTicketX[i],OrderMagicNumberX[i]);
                             }
                           报错组件("离场后补单");
                          }



  }
//===========================================================================
void 提取历史信号()
  {
   if(FILES文件夹路径!="")
      FILES文件夹路径2=FILES文件夹路径;
   else
      FILES文件夹路径2=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files";

   int t=CopyFileW(中转路径2+"\\"+跟踪主账号+"2.csv",FILES文件夹路径2+"\\"+跟踪主账号+"2.csv",0);

   int handle;
   handle=FileOpen(跟踪主账号+"2.csv",FILE_CSV|FILE_READ,';');

   if(handle>0)
     {
      for(int i=0;i<200;i++)
        {
         OrderTicketXH[i]=StrToInteger(FileReadString(handle));
         string namexx=FileReadString(handle);
         OrderSymbolXH[i]=namexx+货币对名称附加;
         if(StringFind(namexx,"XAUUSD",0)!=-1 || StringFind(namexx,"GOLD",0)!=-1)
            if(iClose(OrderSymbolXH[i],0,0)==0 || iClose(OrderSymbolXH[i],0,0)==-1 || iClose(OrderSymbolXH[i],0,0)==EMPTY_VALUE)
              {
               string NEWNAME="XAUUSD"+货币对名称附加;
               if(!(iClose(NEWNAME,0,0)==0 || iClose(NEWNAME,0,0)==-1 || iClose(NEWNAME,0,0)==EMPTY_VALUE))
                  OrderSymbolXH[i]=NEWNAME;
               NEWNAME="GOLD"+货币对名称附加;
               if(!(iClose(NEWNAME,0,0)==0 || iClose(NEWNAME,0,0)==-1 || iClose(NEWNAME,0,0)==EMPTY_VALUE))
                  OrderSymbolXH[i]=NEWNAME;
              }

         if(货币对名称强制修正开关)
            if(namexx==所跟货币对名称)
               OrderSymbolXH[i]=下单货币对名称;

         OrderTypeXH[i]=       StrToInteger(FileReadString(handle));
         OrderLotsXH[i]=       StrToDouble(FileReadString(handle));
         if(OrderTicketXH[i]!=0)
            if(OrderTypeXH[i]<6)
              {
               OrderStopLossXH[i]=NormalizeDouble(StrToDouble(FileReadString(handle)),MarketInfo(OrderSymbolXH[i],MODE_DIGITS));
               OrderTakeProfitXH[i]=NormalizeDouble(StrToDouble(FileReadString(handle)),MarketInfo(OrderSymbolXH[i],MODE_DIGITS));
              }

         OrderCommentXH[i]=FileReadString(handle);
         OrderMagicNumberXH[i]=StrToInteger(FileReadString(handle));
         OrderOpenTimeXH[i]=StrToInteger(FileReadString(handle));
         OrderOpenPriceXH[i]=StrToDouble(FileReadString(handle));
         if(FileIsEnding(handle))
            break;
        }
      FileClose(handle);
     }
  }
//===========================================================================
void 提取信号()
  {
   if(FILES文件夹路径!="")
      FILES文件夹路径2=FILES文件夹路径;
   else
      FILES文件夹路径2=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files";

   int t=CopyFileW(中转路径2+"\\"+跟踪主账号+".csv",FILES文件夹路径2+"\\"+跟踪主账号+".csv",0);

   int handle;
   handle=FileOpen(跟踪主账号+".csv",FILE_CSV|FILE_READ|FILE_SHARE_WRITE|FILE_SHARE_READ,';');

   if(handle>0)
     {
      ArrayInitialize(OrderTicketX,0);
      ArrayInitialize(OrderTypeX,0);
      ArrayInitialize(OrderLotsX,0);
      ArrayInitializeX(OrderSymbolX,"",200);

      for(int i=0;i<200;i++)
        {
         OrderTicketX[i]=StrToInteger(FileReadString(handle));
         string namexx=FileReadString(handle);
         OrderSymbolX[i]=namexx+货币对名称附加;

         if(StringFind(namexx,"XAUUSD",0)!=-1 || StringFind(namexx,"GOLD",0)!=-1)
            if(iClose(OrderSymbolX[i],0,0)==0 || iClose(OrderSymbolX[i],0,0)==-1 || iClose(OrderSymbolX[i],0,0)==EMPTY_VALUE)
              {
               string NEWNAME="XAUUSD"+货币对名称附加;
               if(!(iClose(NEWNAME,0,0)==0 || iClose(NEWNAME,0,0)==-1 || iClose(NEWNAME,0,0)==EMPTY_VALUE))
                  OrderSymbolX[i]=NEWNAME;
               NEWNAME="GOLD"+货币对名称附加;
               if(!(iClose(NEWNAME,0,0)==0 || iClose(NEWNAME,0,0)==-1 || iClose(NEWNAME,0,0)==EMPTY_VALUE))
                  OrderSymbolX[i]=NEWNAME;
              }

         if(货币对名称强制修正开关)
            if(namexx==所跟货币对名称)
               OrderSymbolX[i]=下单货币对名称;

         OrderTypeX[i]=       StrToInteger(FileReadString(handle));
         OrderLotsX[i]=       StrToDouble(FileReadString(handle));

         if(OrderTicketX[i]!=0)
            if(OrderTypeX[i]<6)
              {
               OrderStopLossX[i]=NormalizeDouble(StrToDouble(FileReadString(handle)),MarketInfo(OrderSymbolX[i],MODE_DIGITS));
               OrderTakeProfitX[i]=NormalizeDouble(StrToDouble(FileReadString(handle)),MarketInfo(OrderSymbolX[i],MODE_DIGITS));
              }

         OrderCommentX[i]=FileReadString(handle);
         OrderMagicNumberX[i]=StrToInteger(FileReadString(handle));
         OrderOpenTimeX[i]=StrToInteger(FileReadString(handle));
         OrderOpenPriceX[i]=StrToDouble(FileReadString(handle));
         if(FileIsEnding(handle))
            break;
        }
      FileClose(handle);
     }
  }
//=========================================================================== 
void ArrayInitializeX(string &A[],string b,int c)
  {
   for(int i=0;i<c;i++)
      A[i]=b;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double 系数(string symbol)
  {
   int 系数=1;
   if(
      MarketInfo(symbol,MODE_DIGITS)==3
      || MarketInfo(symbol,MODE_DIGITS)==5
      || (StringFind(symbol,"XAU",0)==0 && MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"GOLD",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      ||(StringFind(symbol,"Gold",0)==0&&MarketInfo(symbol,MODE_DIGITS)==2)
      || (StringFind(symbol,"USD_GLD",0)==0 && MarketInfo(symbol,MODE_DIGITS)==2)
      )系数=10;

   if(StringFind(symbol,"XAU",0)==0 && MarketInfo(symbol,MODE_DIGITS)==3)系数=100;

   return(系数);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void laber(string a,color b)
  {
   if(是否显示文字标签==true)
     {
      ObjectDelete("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a);
      ObjectCreate("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,OBJ_TEXT,0,Time[0],Low[0]);
      ObjectSetText("箭头"+TimeToStr(Time[0],TIME_DATE|TIME_MINUTES)+a,a,8,"Times New Roman",b);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool 货币对属于范围(string symbol,string &symbolX[])
  {
   for(int ix=0;ix<11;ix++)
      if(symbol==symbolX[ix])
         return(true);

   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int 建立单据(string 货币对,int 类型,double 单量,double 价位,double 间隔,double 止损,double 止盈,string 备注,int magic)
  {

   if(使用固定单量)
      单量=固定单量;

   if(使用净值比例计算单量)
      单量=AccountEquity()/1000*每1000美金净值对应单量;

   if(使用余额比例计算单量)
      单量=AccountBalance()/1000*每1000美金余额对应单量;

   if(使用两个账户净值比计算单量&&对方净值!=0)
   单量=单量*AccountEquity()/对方净值*两账户净值比系数M;



   单量反馈X=单量;

   if(限定可做的货币对 && 货币对属于范围(货币对,限制可做货币对)==false)
      return(-1);

   if(限定不可做的货币对 && 货币对属于范围(货币对,限制不可做货币对))
      return(-1);



   if(MarketInfo(货币对,MODE_LOTSTEP)<10)int 单量小数保留X=0;
   if(MarketInfo(货币对,MODE_LOTSTEP)<1)单量小数保留X=1;
   if(MarketInfo(货币对,MODE_LOTSTEP)<0.1)单量小数保留X=2;

   单量=NormalizeDouble(单量,单量小数保留X);

   if(单量<MarketInfo(货币对,MODE_MINLOT))
     {
      laber("低于最低单量",Yellow);
      return(-1);
     }

   if(单量>MarketInfo(货币对,MODE_MAXLOT))
      单量=MarketInfo(货币对,MODE_MAXLOT);

   int t;
   int i;
   double zs,zy;
   double POINT=MarketInfo(货币对,MODE_POINT)*系数(货币对);
   int DIGITS=MarketInfo(货币对,MODE_DIGITS);
   int 滑点2=滑点*系数(货币对);
   价位=NormalizeDouble(价位,MarketInfo(货币对,MODE_DIGITS));
   if(类型==OP_BUY)
     {
      RefreshRates();
      t=OrderSend(货币对,OP_BUY,单量,MarketInfo(货币对,MODE_ASK),滑点2,0,0,备注,magic,0);
      报错组件("");
      if(OrderSelect(t,SELECT_BY_TICKET))
        {
         if(止损!=0 && 止盈!=0)
            OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损*POINT,DIGITS),NormalizeDouble(OrderOpenPrice()+止盈*POINT,DIGITS),0);

         if(止损==0 && 止盈!=0)
            OrderModify(OrderTicket(),OrderOpenPrice(),0,NormalizeDouble(OrderOpenPrice()+止盈*POINT,DIGITS),0);

         if(止损!=0 && 止盈==0)
            OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-止损*POINT,DIGITS),0,0);

         报错组件("");
        }
     }

   if(类型==OP_SELL)
     {
      RefreshRates();
      t=OrderSend(货币对,OP_SELL,单量,MarketInfo(货币对,MODE_BID),滑点2,0,0,备注,magic,0);
      报错组件("");
      if(OrderSelect(t,SELECT_BY_TICKET))
        {
         if(止损!=0 && 止盈!=0)
            OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损*POINT,DIGITS),NormalizeDouble(OrderOpenPrice()-止盈*POINT,DIGITS),0);

         if(止损==0 && 止盈!=0)
            OrderModify(OrderTicket(),OrderOpenPrice(),0,NormalizeDouble(OrderOpenPrice()-止盈*POINT,DIGITS),0);

         if(止损!=0 && 止盈==0)
            OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+止损*POINT,DIGITS),0,0);
        }
      报错组件("");
     }

   if(类型==OP_BUYLIMIT || 类型==OP_BUYSTOP)
     {
      if(价位==0)
        {
         RefreshRates();
         价位=MarketInfo(货币对,MODE_ASK);
        }

      if(类型==OP_BUYLIMIT)
        {
         if(止损!=0 && 止盈!=0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT-止损*POINT,DIGITS),NormalizeDouble(价位-间隔*POINT+止盈*POINT,DIGITS),备注,magic,0);
         if(止损==0 && 止盈!=0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位-间隔*POINT+止盈*POINT,DIGITS),备注,magic,0);
         if(止损!=0 && 止盈==0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT-止损*POINT,DIGITS),0,备注,magic,0);
         if(止损==0 && 止盈==0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0);
        }

      if(类型==OP_BUYSTOP)
        {
         if(止损!=0 && 止盈!=0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT-止损*POINT,DIGITS),NormalizeDouble(价位+间隔*POINT+止盈*POINT,DIGITS),备注,magic,0);
         if(止损==0 && 止盈!=0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位+间隔*POINT+止盈*POINT,DIGITS),备注,magic,0);
         if(止损!=0 && 止盈==0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT-止损*POINT,DIGITS),0,备注,magic,0);
         if(止损==0 && 止盈==0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0);
        }
      报错组件("");
     }

   if(类型==OP_SELLLIMIT || 类型==OP_SELLSTOP)
     {
      if(价位==0)
        {
         RefreshRates();
         价位=MarketInfo(货币对,MODE_BID);
        }

      if(类型==OP_SELLSTOP)
        {
         if(止损!=0 && 止盈!=0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT+止损*POINT,DIGITS),NormalizeDouble(价位-间隔*POINT-止盈*POINT,DIGITS),备注,magic,0);
         if(止损==0 && 止盈!=0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位-间隔*POINT-止盈*POINT,DIGITS),备注,magic,0);
         if(止损!=0 && 止盈==0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT+止损*POINT,DIGITS),0,备注,magic,0);
         if(止损==0 && 止盈==0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0);
        }

      if(类型==OP_SELLLIMIT)
        {
         if(止损!=0 && 止盈!=0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT+止损*POINT,DIGITS),NormalizeDouble(价位+间隔*POINT-止盈*POINT,DIGITS),备注,magic,0);
         if(止损==0 && 止盈!=0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位+间隔*POINT-止盈*POINT,DIGITS),备注,magic,0);
         if(止损!=0 && 止盈==0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT+止损*POINT,DIGITS),0,备注,magic,0);
         if(止损==0 && 止盈==0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0);
        }
      报错组件("");
     }
   return(t);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int 建立单据X(string 货币对,int 类型,double 单量,double 价位,double 间隔,double 止损,double 止盈,string 备注,int magic)
  {

   if(MarketInfo(货币对,MODE_LOTSTEP)<10)int 单量小数保留X=0;
   if(MarketInfo(货币对,MODE_LOTSTEP)<1)单量小数保留X=1;
   if(MarketInfo(货币对,MODE_LOTSTEP)<0.1)单量小数保留X=2;

   单量=NormalizeDouble(单量,单量小数保留X);

   if(单量<MarketInfo(货币对,MODE_MINLOT))
     {
      laber("低于最低单量",Yellow);
      return(-1);
     }

   if(单量>MarketInfo(货币对,MODE_MAXLOT))
      单量=MarketInfo(货币对,MODE_MAXLOT);

   int t;
   int i;
   double zs,zy;
   double POINT=MarketInfo(货币对,MODE_POINT)*系数(货币对);
   int DIGITS=MarketInfo(货币对,MODE_DIGITS);
   int 滑点2=滑点*系数(货币对);
   价位=NormalizeDouble(价位,MarketInfo(货币对,MODE_DIGITS));

   if(类型==OP_BUY)
     {
      if(价位==0)
        {
         RefreshRates();
         价位=MarketInfo(货币对,MODE_ASK);
        }

      if(MarketInfo(货币对,MODE_ASK)>价位)
        {
         if(止损!=0 && 止盈!=0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT-止损*POINT,DIGITS),NormalizeDouble(价位-间隔*POINT+止盈*POINT,DIGITS),备注,magic,0);
         if(止损==0 && 止盈!=0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位-间隔*POINT+止盈*POINT,DIGITS),备注,magic,0);
         if(止损!=0 && 止盈==0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT-止损*POINT,DIGITS),0,备注,magic,0);
         if(止损==0 && 止盈==0)
            t=OrderSend(货币对,OP_BUYLIMIT,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0);
        }

      if(MarketInfo(货币对,MODE_ASK)<价位)
        {
         if(止损!=0 && 止盈!=0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT-止损*POINT,DIGITS),NormalizeDouble(价位+间隔*POINT+止盈*POINT,DIGITS),备注,magic,0);
         if(止损==0 && 止盈!=0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位+间隔*POINT+止盈*POINT,DIGITS),备注,magic,0);
         if(止损!=0 && 止盈==0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT-止损*POINT,DIGITS),0,备注,magic,0);
         if(止损==0 && 止盈==0)
            t=OrderSend(货币对,OP_BUYSTOP,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0);
        }
      报错组件("");
     }

   if(类型==OP_SELL)
     {
      if(价位==0)
        {
         RefreshRates();
         价位=MarketInfo(货币对,MODE_BID);
        }

      if(MarketInfo(货币对,MODE_BID)>价位)
        {
         if(止损!=0 && 止盈!=0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT+止损*POINT,DIGITS),NormalizeDouble(价位-间隔*POINT-止盈*POINT,DIGITS),备注,magic,0);
         if(止损==0 && 止盈!=0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位-间隔*POINT-止盈*POINT,DIGITS),备注,magic,0);
         if(止损!=0 && 止盈==0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位-间隔*POINT+止损*POINT,DIGITS),0,备注,magic,0);
         if(止损==0 && 止盈==0)
            t=OrderSend(货币对,OP_SELLSTOP,单量,NormalizeDouble(价位-间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0);
        }

      if(MarketInfo(货币对,MODE_BID)<价位)
        {
         if(止损!=0 && 止盈!=0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT+止损*POINT,DIGITS),NormalizeDouble(价位+间隔*POINT-止盈*POINT,DIGITS),备注,magic,0);
         if(止损==0 && 止盈!=0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,NormalizeDouble(价位+间隔*POINT-止盈*POINT,DIGITS),备注,magic,0);
         if(止损!=0 && 止盈==0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,NormalizeDouble(价位+间隔*POINT+止损*POINT,DIGITS),0,备注,magic,0);
         if(止损==0 && 止盈==0)
            t=OrderSend(货币对,OP_SELLLIMIT,单量,NormalizeDouble(价位+间隔*POINT,DIGITS),滑点2,0,0,备注,magic,0);
        }
      报错组件("");
     }
   return(t);
  }
//--------------------------------------
//------------------------------------
void 报错组件(string a)
  {

   int t=GetLastError();
   string 报警;
   if(t!=0)
      switch(t)
        {
         case 0:报警="错误代码:"+0+"没有错误返回";break;
         case 1:报警="错误代码:"+1+"没有错误返回但结果不明";break;
         case 2:报警="错误代码:"+2+"一般错误";break;
         case 3:报警="错误代码:"+3+"无效交易参量";break;
         case 4:报警="错误代码:"+4+"交易服务器繁忙";break;
         case 5:报警="错误代码:"+5+"客户终端旧版本";break;
         case 6:报警="错误代码:"+6+"没有连接服务器";break;
         case 7:报警="错误代码:"+7+"没有权限";break;
         case 8:报警="错误代码:"+8+"请求过于频繁";break;
         case 9:报警="错误代码:"+9+"交易运行故障";break;
         case 64:报警="错误代码:"+64+"账户禁止";break;
         case 65:报警="错误代码:"+65+"无效账户";break;
         case 128:报警="错误代码:"+128+"交易超时";break;
         case 129:报警="错误代码:"+129+"无效价格";break;
         case 130:报警="错误代码:"+130+"无效停止";break;
         case 131:报警="错误代码:"+131+"无效交易量";break;
         case 132:报警="错误代码:"+132+"市场关闭";break;
         case 133:报警="错误代码:"+133+"交易被禁止";break;
         case 134:报警="错误代码:"+134+"资金不足";break;
         case 135:报警="错误代码:"+135+"价格改变";break;
         case 136:报警="错误代码:"+136+"开价";break;
         case 137:报警="错误代码:"+137+"经纪繁忙";break;
         case 138:报警="错误代码:"+138+"重新开价";break;
         case 139:报警="错误代码:"+139+"定单被锁定";break;
         case 140:报警="错误代码:"+140+"只允许看涨仓位";break;
         case 141:报警="错误代码:"+141+"过多请求";break;
         case 145:报警="错误代码:"+145+"因为过于接近市场，修改否定";break;
         case 146:报警="错误代码:"+146+"交易文本已满";break;
         case 147:报警="错误代码:"+147+"时间周期被经纪否定";break;
         case 148:报警="错误代码:"+148+"开单和挂单总数已被经纪限定";break;
         case 149:报警="错误代码:"+149+"当对冲备拒绝时,打开相对于现有的一个单置";break;
         case 150:报警="错误代码:"+150+"把为反FIFO规定的单子平掉";break;
         case 4000:报警="错误代码:"+4000+"没有错误";break;
         case 4001:报警="错误代码:"+4001+"错误函数指示";break;
         case 4002:报警="错误代码:"+4002+"数组索引超出范围";break;
         case 4003:报警="错误代码:"+4003+"对于调用堆栈储存器函数没有足够内存";break;
         case 4004:报警="错误代码:"+4004+"循环堆栈储存器溢出";break;
         case 4005:报警="错误代码:"+4005+"对于堆栈储存器参量没有内存";break;
         case 4006:报警="错误代码:"+4006+"对于字行参量没有足够内存";break;
         case 4007:报警="错误代码:"+4007+"对于字行没有足够内存";break;
         case 4008:报警="错误代码:"+4008+"没有初始字行";break;
         case 4009:报警="错误代码:"+4009+"在数组中没有初始字串符";break;
         case 4010:报警="错误代码:"+4010+"对于数组没有内存";break;
         case 4011:报警="错误代码:"+4011+"字行过长";break;
         case 4012:报警="错误代码:"+4012+"余数划分为零";break;
         case 4013:报警="错误代码:"+4013+"零划分";break;
         case 4014:报警="错误代码:"+4014+"不明命令";break;
         case 4015:报警="错误代码:"+4015+"错误转换(没有常规错误)";break;
         case 4016:报警="错误代码:"+4016+"没有初始数组";break;
         case 4017:报警="错误代码:"+4017+"禁止调用DLL ";break;
         case 4018:报警="错误代码:"+4018+"数据库不能下载";break;
         case 4019:报警="错误代码:"+4019+"不能调用函数";break;
         case 4020:报警="错误代码:"+4020+"禁止调用智能交易函数";break;
         case 4021:报警="错误代码:"+4021+"对于来自函数的字行没有足够内存";break;
         case 4022:报警="错误代码:"+4022+"系统繁忙 (没有常规错误)";break;
         case 4050:报警="错误代码:"+4050+"无效计数参量函数";break;
         case 4051:报警="错误代码:"+4051+"无效参量值函数";break;
         case 4052:报警="错误代码:"+4052+"字行函数内部错误";break;
         case 4053:报警="错误代码:"+4053+"一些数组错误";break;
         case 4054:报警="错误代码:"+4054+"应用不正确数组";break;
         case 4055:报警="错误代码:"+4055+"自定义指标错误";break;
         case 4056:报警="错误代码:"+4056+"不协调数组";break;
         case 4057:报警="错误代码:"+4057+"整体变量过程错误";break;
         case 4058:报警="错误代码:"+4058+"整体变量未找到";break;
         case 4059:报警="错误代码:"+4059+"测试模式函数禁止";break;
         case 4060:报警="错误代码:"+4060+"没有确认函数";break;
         case 4061:报警="错误代码:"+4061+"发送邮件错误";break;
         case 4062:报警="错误代码:"+4062+"字行预计参量";break;
         case 4063:报警="错误代码:"+4063+"整数预计参量";break;
         case 4064:报警="错误代码:"+4064+"双预计参量";break;
         case 4065:报警="错误代码:"+4065+"数组作为预计参量";break;
         case 4066:报警="错误代码:"+4066+"刷新状态请求历史数据";break;
         case 4067:报警="错误代码:"+4067+"交易函数错误";break;
         case 4099:报警="错误代码:"+4099+"文件结束";break;
         case 4100:报警="错误代码:"+4100+"一些文件错误";break;
         case 4101:报警="错误代码:"+4101+"错误文件名称";break;
         case 4102:报警="错误代码:"+4102+"打开文件过多";break;
         case 4103:报警="错误代码:"+4103+"不能打开文件";break;
         case 4104:报警="错误代码:"+4104+"不协调文件";break;
         case 4105:报警="错误代码:"+4105+"没有选择定单";break;
         case 4106:报警="错误代码:"+4106+"不明货币对";break;
         case 4107:报警="错误代码:"+4107+"无效价格";break;
         case 4108:报警="错误代码:"+4108+"无效定单编码";break;
         case 4109:报警="错误代码:"+4109+"不允许交易";break;
         case 4110:报警="错误代码:"+4110+"不允许长期";break;
         case 4111:报警="错误代码:"+4111+"不允许短期";break;
         case 4200:报警="错误代码:"+4200+"定单已经存在";break;
         case 4201:报警="错误代码:"+4201+"不明定单属性";break;
         //case 4202:报警="错误代码:"+4202+"定单不存在";break;
         case 4203:报警="错误代码:"+4203+"不明定单类型";break;
         case 4204:报警="错误代码:"+4204+"没有定单名称";break;
         case 4205:报警="错误代码:"+4205+"定单坐标错误";break;
         case 4206:报警="错误代码:"+4206+"没有指定子窗口";break;
         case 4207:报警="错误代码:"+4207+"定单一些函数错误";break;
         case 4250:报警="错误代码:"+4250+"错误设定发送通知到队列中";break;
         case 4251:报警="错误代码:"+4251+"无效参量- 空字符串传递到SendNotification()函数";break;
         case 4252:报警="错误代码:"+4252+"无效设置发送通知(未指定ID或未启用通知)";break;
         case 4253:报警="错误代码:"+4253+"通知发送过于频繁";break;
        }
   if(t!=0)
     {
      Sleep(300);
      Print(a+报警);
      laber(a+报警,Yellow);
     }
  }
//+------------------------------------------------------------------+
