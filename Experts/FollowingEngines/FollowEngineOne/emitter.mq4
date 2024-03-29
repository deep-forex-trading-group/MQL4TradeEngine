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
string 中转文件名="";
input string FILES文件夹路径="";
string FILES文件夹路径2;
input string 中转路径="";
string 中转路径2="";
extern bool 修正货币对名称=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   if(IsDllsAllowed()==false)
      Alert("请允许调用动态链接库");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {

   if(IsDllsAllowed()==false)
      return(0);

   Comment("----------已开启跟单------------");

   if(中转路径=="")
     {
      CreateDirectoryW("C:\\鱼儿编程跟单软件中转路径",0);
      中转路径2="C:\\鱼儿编程跟单软件中转路径";
     }
   else
      中转路径2=中转路径;

   while(true)
     {
      Comment("----------鱼儿编程跟单软件发射端------------"
              +"\n--------------已开启跟单发射端------------");
      中转文件名=DoubleToStr(AccountNumber(),0);

      int handle;
      handle=FileOpen(中转文件名+".csv",FILE_CSV|FILE_WRITE,';');
      if(handle>0)
        {
         for(int i=0;i<OrdersTotal();i++)
            if(OrderSelect(i,SELECT_BY_POS))
              {
               string name=OrderSymbol();

               if(修正货币对名称)
                  name=StringSubstr(OrderSymbol(),0,6);

               if(修正货币对名称)
                  if(StringFind(name,"GOLD",0)==0)
                     name="GOLD";

               FileWrite(handle,OrderTicket(),name,OrderType(),OrderLots(),OrderStopLoss(),OrderTakeProfit(),OrderComment(),OrderMagicNumber(),OrderOpenTime()-TimeCurrent()+TimeLocal(),OrderOpenPrice());

              }
         FileClose(handle);
        }

      handle=FileOpen(中转文件名+"2.csv",FILE_CSV|FILE_WRITE,';');
      if(handle>0)
        {
         for(i=OrdersHistoryTotal();i>=0;i--)
            if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
               if(OrderType()<6)
                 {
                  FileWrite(handle,OrderTicket(),OrderSymbol(),OrderType(),OrderLots(),OrderStopLoss(),OrderTakeProfit(),OrderComment(),OrderMagicNumber(),OrderOpenTime()-TimeCurrent()+TimeLocal(),OrderOpenPrice());
                 }
         FileClose(handle);
        }

      handle=FileOpen(中转文件名+"3.csv",FILE_CSV|FILE_WRITE,';');
      if(handle>0)
        {
         FileWrite(handle,AccountEquity());
         FileClose(handle);
        }
        
      if(FILES文件夹路径!="")
         FILES文件夹路径2=FILES文件夹路径;
      else
         FILES文件夹路径2=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files";

      int t=CopyFileW(FILES文件夹路径2+"\\"+中转文件名+".csv",中转路径2+"\\"+中转文件名+".csv",0);

      t=CopyFileW(FILES文件夹路径2+"\\"+中转文件名+"2.csv",中转路径2+"\\"+中转文件名+"2.csv",0);
      t=CopyFileW(FILES文件夹路径2+"\\"+中转文件名+"3.csv",中转路径2+"\\"+中转文件名+"3.csv",0);

      if(!(!IsStopped() && IsExpertEnabled() && IsTesting()==false && IsOptimization()==false))
         return(0);
      Sleep(300);
     }
   return(0);
  }

//+------------------------------------------------------------------+
