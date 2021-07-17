//+------------------------------------------------------------------+ 
//|                                        3_Level_ZZ_Semafor.mq4    | 
//+------------------------------------------------------------------+ 
//| 3_Level_ZZ_Semafor_TRO_MODIFIED_VERSION                          |
//| MODIFIED BY AVERY T. HORTON, JR. AKA THERUMPLEDONE@GMAIL.COM     |
//| I am NOT the ORIGINAL author 
//  and I am not claiming authorship of this indicator. 
//  All I did was modify it. I hope you find my modifications useful.|
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "asystem2000" 
#property link      "asystem2000@yandex.ru" 

#property indicator_chart_window 
#property indicator_buffers 6
#property indicator_color1 Aqua 
#property indicator_color2 Aqua  
#property indicator_color3 Blue
#property indicator_color4 Blue
#property indicator_color5 GreenYellow
#property indicator_color6 Magenta
//+--------- TRO MODIFICATION ---------------------------------------+ 

extern bool   Show.Legend        = false;
extern bool   Show.Trendlines    = false; 
extern bool   Show.Retracelines  = false; 
extern bool   Show.Targetlines   = false; 


extern int    myThreshold      = 1;
extern int    myRetracePips    = 20;
extern int    myTargetPips    = 20;

extern bool   Sound    = false;
extern bool   Sound.Alert    = false ;
extern bool   Show.Comment   = false ; 
extern int    myBars         = 100 ;
extern int    NumComments    = 5 ;

//extern string myUpperTrendLineName  = "UpperTrendLine001";
extern color  myUpperTrendLineColor = Aqua; 
extern int    myUpperTrendLineStyle = 2;
extern int    myUpperTrendLineWidth = 1;
extern string myUpperSoundFile      = "analyze sell.wav";

//extern string myLowerTrendLineName  = "LowerTrendLine001";
extern color  myLowerTrendLineColor = Aqua; 
extern int    myLowerTrendLineStyle = 2;
extern int    myLowerTrendLineWidth = 1;
extern string myLowerSoundFile      = "analyze buy.wav";

extern color  myRetraceLineColor = Orange; 
extern int    myRetraceLineStyle = STYLE_DOT;
extern int    myRetraceLineWidth = 1;

extern color  myTargetLineColor = Magenta; 
extern int    myTargetLineStyle = STYLE_DOT;
extern int    myTargetLineWidth = 1;


//---- input parameters 
extern double Period1=5; 
extern double Period2=13; 
extern double Period3=34; 
extern string   Dev_Step_1="1,3";
extern string   Dev_Step_2="8,5";
extern string   Dev_Step_3="21,12";
extern int Symbol_1_Kod=251;
extern int Symbol_2_Kod=161;
extern int Symbol_3_Kod=170;

extern int Symbol_1_Size=1 ;
extern int Symbol_2_Size=2;
extern int Symbol_3_Size=2;


//---- buffers 
double FP_BuferUp[];
double FP_BuferDn[]; 
double NP_BuferUp[];
double NP_BuferDn[]; 
double HP_BuferUp[];
double HP_BuferDn[]; 

int F_Period;
int N_Period;
int H_Period;
int Dev1;
int Stp1;
int Dev2;
int Stp2;
int Dev3;
int Stp3;
//+--------- TRO MODIFICATION ---------------------------------------+ 
string symbol, tChartPeriod,  tShortName ;  
int    digits, period  ; 

bool Trigger1,  Trigger2,  Trigger3 ;

int OldBars = -1 ;

color tColor = Yellow ;

int i, j, k, tltop, tlbot;

string Messages[26], theMessage, space ;

bool roll ;

double point ;
double upperTL[2], lowerTL[2];
double UpperTrendLinePrice, LowerTrendLinePrice, UpperLimit, LowerLimit, xThreshold;
double UpperRetracePrice, LowerRetracePrice, xRetracePips ;
double pUpperTargetPrice, pLowerTargetPrice, UpperTargetPrice, LowerTargetPrice, xTargetPips ;

datetime upperTLtime[2], lowerTLtime[2], upperStime, upperEtime, lowerStime, lowerEtime;

string TAG = "3lzz", OBJ001, OBJ002, OBJ003, OBJ004, OBJ005, OBJ006 ;  
string OBJ007, OBJ008 ;   

//+------------------------------------------------------------------+ 
int init() 
  { 
//+--------- TRO MODIFICATION ---------------------------------------+  
   period       = Period() ;     
   tChartPeriod =  TimeFrameToString(period) ;
   symbol       =  Symbol() ;
   digits       =  Digits ;
   point        =  Point ;   
   
   if(digits == 5 || digits == 3) { digits = digits - 1 ; point = point * 10 ; }   
   
   
   tShortName = "tbb"+ symbol + tChartPeriod  ;
    
   xThreshold   = myThreshold * point ;   
   xRetracePips = myRetracePips * point ;  
   xTargetPips = myTargetPips * point ; 

   OBJ001       = TAG + "001";
   OBJ002       = TAG + "002";  
   OBJ003       = TAG + "003";
   OBJ004       = TAG + "004";  
   OBJ005       = TAG + "005";
   OBJ006       = TAG + "006";  
   OBJ007       = TAG + "007";
   OBJ008       = TAG + "008";  

        
// --------- и║?ee?и║и░ииeио?им ??eии??? ??? ???и░e??икии? ?ии??ид??a
  
  
   if (Period1>0) F_Period=MathCeil(Period1*Period()); else F_Period=0; 
   if (Period2>0) N_Period=MathCeil(Period2*Period()); else N_Period=0; 
   if (Period3>0) H_Period=MathCeil(Period3*Period()); else H_Period=0; 
   
//---- ?ивeидивиди░?aид?им 1 ивио??e 
   if (Period1>0)
   {
   SetIndexStyle(0,DRAW_ARROW,0,Symbol_1_Size); 
   SetIndexArrow(0,Symbol_1_Kod); 
   SetIndexBuffer(0,FP_BuferUp); 
   SetIndexEmptyValue(0,0.0); 
   
   SetIndexStyle(1,DRAW_ARROW,0,Symbol_1_Size); 
   SetIndexArrow(1,Symbol_1_Kod); 
   SetIndexBuffer(1,FP_BuferDn); 
   SetIndexEmptyValue(1,0.0); 
   }
   
//---- ?ивeидивиди░?aид?им 2 ивио??e 
   if (Period2>0)
   {
   SetIndexStyle(2,DRAW_ARROW,0,Symbol_2_Size); 
   SetIndexArrow(2,Symbol_2_Kod); 
   SetIndexBuffer(2,NP_BuferUp); 
   SetIndexEmptyValue(2,0.0); 
   
   SetIndexStyle(3,DRAW_ARROW,0,Symbol_2_Size); 
   SetIndexArrow(3,Symbol_2_Kod); 
   SetIndexBuffer(3,NP_BuferDn); 
   SetIndexEmptyValue(3,0.0); 
   }
//---- ?ивeидивиди░?aид?им 3 ивио??e 
   if (Period3>0)
   {
   SetIndexStyle(4,DRAW_ARROW,0,Symbol_3_Size); 
   SetIndexArrow(4,Symbol_3_Kod); 
   SetIndexBuffer(4,HP_BuferUp); 
   SetIndexEmptyValue(4,0.0); 

   SetIndexStyle(5,DRAW_ARROW,0,Symbol_3_Size); 
   SetIndexArrow(5,Symbol_3_Kod); 
   SetIndexBuffer(5,HP_BuferDn); 
   SetIndexEmptyValue(5,0.0); 
   }
// ?ивeидивиди░?aид?им ?икидб┬?икии? ??aииид?иииж ии ?ид??a
   int CDev=0;
   int CSt=0;
   int Mass[]; 
   int C=0;  
   if (IntFromStr(Dev_Step_1,C, Mass)==1) 
      {
        Stp1=Mass[1];
        Dev1=Mass[0];
      }
   
   if (IntFromStr(Dev_Step_2,C, Mass)==1)
      {
        Stp2=Mass[1];
        Dev2=Mass[0];
      }      
   
   
   if (IntFromStr(Dev_Step_3,C, Mass)==1)
      {
        Stp3=Mass[1];
        Dev3=Mass[0];
      }      
   return(0); 
  } 

//+------------------------------------------------------------------+

void ObDeleteObjectsByPrefix(string Prefix)
{
   int L = StringLen(Prefix);
   int i = 0; 
   while(i < ObjectsTotal())
     {
       string ObjName = ObjectName(i);
       if(StringSubstr(ObjName, 0, L) != Prefix) 
         { 
           i++; 
           continue;
         }
       ObjectDelete(ObjName);
     }
}
    
//+------------------------------------------------------------------+
int deinit()
{
   Comment("") ;
       
   ObDeleteObjectsByPrefix(TAG);  
   
   TRO() ;
   
   return(0);
}

//+------------------------------------------------------------------+ 
int start() 
  { 
  

//+--------- TRO MODIFICATION ---------------------------------------+   
   if( Bars != OldBars ) { Trigger1 = True ; Trigger2 = True ; Trigger3 = True ;}
   
     
  /*  if (Period1>0) CountZZ(FP_BuferUp,FP_BuferDn,Period1,Dev1,Stp1);
   if (Period2>0) CountZZ(NP_BuferUp,NP_BuferDn,Period2,Dev2,Stp2);*/
   if (Period3>0) CountZZ(HP_BuferUp,HP_BuferDn,Period3,Dev3,Stp3);
   
   
//+--------- TRO MODIFICATION ---------------------------------------+  
      

      
      /*if ( Trigger1 ) 
      { 
        if( FP_BuferUp[0] != 0 ) { Trigger1 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 1 Lower "+ DoubleToStr(Close[0] ,digits));} }
        if( FP_BuferDn[0] != 0 ) { Trigger1 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 1 Upper "+ DoubleToStr(Close[0] ,digits)); } }
      }
      
      if ( Trigger2 ) 
      {
        if( NP_BuferUp[0] != 0 ) { Trigger2 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 2 Lower "+ DoubleToStr(Close[0] ,digits)); } }
        if( NP_BuferDn[0] != 0 ) { Trigger2 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 2 Upper "+ DoubleToStr(Close[0] ,digits)); } }
      }*/
      
      if ( Trigger3 ) 
      {     
        if( HP_BuferUp[0] != 0 ) { Trigger3 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 3 Lower "+ DoubleToStr(Close[0] ,digits));} if (Sound)PlaySound("trixcross.wav"); }
        if( HP_BuferDn[0] != 0 ) { Trigger3 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 3 Upper "+ DoubleToStr(Close[0] ,digits));} if (Sound)PlaySound("trixcross.wav"); }
      }

    
   if(Show.Comment)
   {
      k = 0 ;
      theMessage = "";
      for( i=0; i<26; i++ ) { Messages[i] = "" ; }
      
   for( j=myBars; j>=0; j-- )
   {   
      while(true)
      {
         if( HP_BuferUp[j] != 0 ) {DoRollMsg( TimeToStr(Time[j]) + " bot 3 " ) ; break ; }
         if( HP_BuferDn[j] != 0 ) {DoRollMsg( TimeToStr(Time[j]) + " top 3 " ) ; break ; }         
         
         if( NP_BuferUp[j] != 0 ) {DoRollMsg( TimeToStr(Time[j]) + " bot 2 " ) ; break ; }
         if( NP_BuferDn[j] != 0 ) {DoRollMsg( TimeToStr(Time[j]) + " top 2 " ) ; break ; }         
         
         if( FP_BuferUp[j] != 0 ) {DoRollMsg( TimeToStr(Time[j]) + " bot 1 " ) ; break ; }
         if( FP_BuferDn[j] != 0 ) {DoRollMsg( TimeToStr(Time[j]) + " top 1 " ) ; break ; }
         break ;
      } // while
   } // for j
   
         
      for( i=0; i<NumComments; i++ )
      {
         if(Messages[i] != "" )
         {
            theMessage = theMessage + "\n" +Messages[i] ;
         }
         else { break ; }
      } // for i

      Comment(theMessage) ;
   
   } // if



if(Show.Legend) { DoShowLegend () ; }
  

   if(Show.Trendlines)
   {
      tltop = 0 ; 
      tlbot = 0 ;
   
   for( j=0; j<1000; j++ )
   {   
      while(true)
      {
         if( HP_BuferUp[j] != 0 && tlbot < 2 ) {lowerTLtime[tlbot] = Time[j] ; lowerTL[tlbot] = HP_BuferUp[j] ; tlbot = tlbot + 1 ; break ; }
         if( HP_BuferDn[j] != 0 && tltop < 2 ) {upperTLtime[tltop] = Time[j] ; upperTL[tltop] = HP_BuferDn[j] ; tltop = tltop + 1 ; break ; }         
         
         if( NP_BuferUp[j] != 0 && tlbot < 2 ) {lowerTLtime[tlbot] = Time[j] ; lowerTL[tlbot] = NP_BuferUp[j] ; tlbot = tlbot + 1 ; break ; }
         if( NP_BuferDn[j] != 0 && tltop < 2 ) {upperTLtime[tltop] = Time[j] ; upperTL[tltop] = NP_BuferDn[j] ; tltop = tltop + 1 ; break ; }         
         
         if( FP_BuferUp[j] != 0 && tlbot < 2 ) {lowerTLtime[tlbot] = Time[j] ; lowerTL[tlbot] = FP_BuferUp[j] ; tlbot = tlbot + 1 ; break ; }
         if( FP_BuferDn[j] != 0 && tltop < 2 ) {upperTLtime[tltop] = Time[j] ; upperTL[tltop] = FP_BuferDn[j] ; tltop = tltop + 1 ; break ; }
         break ;
      } // while
      
      if( tlbot >=2 && tltop >= 2 ) { break ;  }
   } // for j   
      

   DrawPriceTrendLines(OBJ001, upperTLtime[1], upperTLtime[0], upperTL[1], 
                        upperTL[0], myUpperTrendLineColor, myUpperTrendLineStyle, myUpperTrendLineWidth) ;

   DrawPriceTrendLines(OBJ002, lowerTLtime[1], lowerTLtime[0], lowerTL[1], 
                        lowerTL[0], myLowerTrendLineColor, myLowerTrendLineStyle, myLowerTrendLineWidth) ;

   DrawPriceTrendLines(OBJ003, upperTLtime[0], Time[0], upperTL[0], 
                        upperTL[0], myUpperTrendLineColor, myUpperTrendLineStyle, myUpperTrendLineWidth) ;

   DrawPriceTrendLines(OBJ004, lowerTLtime[0], Time[0], lowerTL[0], 
                        lowerTL[0], myLowerTrendLineColor, myLowerTrendLineStyle, myLowerTrendLineWidth) ;

   if(Show.Retracelines)
   {
   UpperRetracePrice = upperTL[0] - xRetracePips ;
   LowerRetracePrice = lowerTL[0] + xRetracePips ;
   
//   if( upperTLtime[0] == Time[0] ) { upperStime = Time[1] ;  } else { upperStime = upperTLtime[0] ;  } 
   
   DrawPriceTrendLines(OBJ005, upperTLtime[0], Time[0], UpperRetracePrice, 
                        UpperRetracePrice, myRetraceLineColor, myRetraceLineStyle, myRetraceLineWidth) ;

   DrawPriceTrendLines(OBJ006, lowerTLtime[0], Time[0], LowerRetracePrice, 
                        LowerRetracePrice, myRetraceLineColor, myRetraceLineStyle, myRetraceLineWidth) ;
   }

   if(Show.Targetlines)
   {
   pUpperTargetPrice = UpperTargetPrice ;
   pLowerTargetPrice = LowerTargetPrice ;
   
   UpperTargetPrice = upperTL[0] + xTargetPips ;
   LowerTargetPrice = lowerTL[0] - xTargetPips ;
   
   DrawPriceTrendLines(OBJ007, upperTLtime[0], Time[0], pUpperTargetPrice, 
                        pUpperTargetPrice, myTargetLineColor, myTargetLineStyle, myTargetLineWidth) ;

   DrawPriceTrendLines(OBJ008, lowerTLtime[0], Time[0], pLowerTargetPrice, 
                        pLowerTargetPrice, myTargetLineColor, myTargetLineStyle, myTargetLineWidth) ;
   }

      UpperTrendLinePrice = ObjectGetValueByShift(OBJ001, 0);
      
      LowerTrendLinePrice = ObjectGetValueByShift(OBJ002, 0);
           
      UpperLimit = Ask + xThreshold ;
      LowerLimit = Bid - xThreshold ;


   if(Sound.Alert)
   {      
      if( UpperTrendLinePrice >= LowerLimit && UpperTrendLinePrice <= UpperLimit )
      {
         PlaySound(myUpperSoundFile);
      } 
      
      if( LowerTrendLinePrice >= LowerLimit && LowerTrendLinePrice <= UpperLimit )
      {
         PlaySound(myLowerSoundFile);
      } 

      if( upperTL[0] >= LowerLimit && upperTL[0] <= UpperLimit )
      {
         PlaySound(myUpperSoundFile);
      } 
      
      if( lowerTL[0] >= LowerLimit && lowerTL[0] <= UpperLimit )
      {
         PlaySound(myLowerSoundFile);
      } 
            
      
   } // if(Sound.Alert) 
   

   } // if 
    
    
   OldBars = Bars ;   

//+--------- TRO MODIFICATION ---------------------------------------+        

  

          
   return(0);
}

//+--------- TRO MODIFICATION ---------------------------------------+  

string TimeFrameToString(int tf)
{
   string tfs;
   switch(tf) {
      case PERIOD_M1:  tfs="M1"  ; break;
      case PERIOD_M5:  tfs="M5"  ; break;
      case PERIOD_M15: tfs="M15" ; break;
      case PERIOD_M30: tfs="M30" ; break;
      case PERIOD_H1:  tfs="H1"  ; break;
      case PERIOD_H4:  tfs="H4"  ; break;
      case PERIOD_D1:  tfs="D1"  ; break;
      case PERIOD_W1:  tfs="W1"  ; break;
      case PERIOD_MN1: tfs="MN";
   }
   return(tfs);
}

//+------------------------------------------------------------------+ 
// ?????икиии░??и╣ик?? ?иоики║?ииии
//int Take



//+------------------------------------------------------------------+ 
//| ?иоики║? ??eимииe?aидикии? ?ии??ид?ид                        | 
//+------------------------------------------------------------------+  
int CountZZ( double& ExtMapBuffer[], double& ExtMapBuffer2[], int ExtDepth, int ExtDeviation, int ExtBackstep )
  {
   int    shift, back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;

   for(shift=Bars-ExtDepth; shift>=0; shift--)
     {
      val=Low[Lowest(NULL,0,MODE_LOW,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else 
        { 
         lastlow=val; 
         if((Low[shift]-val)>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ExtMapBuffer[shift+back];
               if((res!=0)&&(res>val)) ExtMapBuffer[shift+back]=0.0; 
              }
           }
        } 
        
          ExtMapBuffer[shift]=val;
      //--- high
      val=High[Highest(NULL,0,MODE_HIGH,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else 
        {
         lasthigh=val;
         if((val-High[shift])>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ExtMapBuffer2[shift+back];
               if((res!=0)&&(res<val)) ExtMapBuffer2[shift+back]=0.0; 
              } 
           }
        }
      ExtMapBuffer2[shift]=val;
     }
   // final cutting 
   lasthigh=-1; lasthighpos=-1;
   lastlow=-1;  lastlowpos=-1;

   for(shift=Bars-ExtDepth; shift>=0; shift--)
     {
      curlow=ExtMapBuffer[shift];
      curhigh=ExtMapBuffer2[shift];
      if((curlow==0)&&(curhigh==0)) continue;
      //---
      if(curhigh!=0)
        {
         if(lasthigh>0) 
           {
            if(lasthigh<curhigh) ExtMapBuffer2[lasthighpos]=0;
            else ExtMapBuffer2[shift]=0;
           }
         //---
         if(lasthigh<curhigh || lasthigh<0)
           {
            lasthigh=curhigh;
            lasthighpos=shift;
           }
         lastlow=-1;
        }
      //----
      if(curlow!=0)
        {
         if(lastlow>0)
           {
            if(lastlow>curlow) ExtMapBuffer[lastlowpos]=0;
            else ExtMapBuffer[shift]=0;
           }
         //---
         if((curlow<lastlow)||(lastlow<0))
           {
            lastlow=curlow;
            lastlowpos=shift;
           } 
         lasthigh=-1;
        }
     }
  
   for(shift=Bars-1; shift>=0; shift--)
     {
      if(shift>=Bars-ExtDepth) ExtMapBuffer[shift]=0.0;
      else
        {
         res=ExtMapBuffer2[shift];
         if(res!=0.0) ExtMapBuffer2[shift]=res;
        }
     }
}

//+------------------------------------------------------------------+   
int Str2Massive(string VStr, int& M_Count, int& VMass[])
  {
    int val=StrToInteger( VStr);
    if (val>0)
       {
         M_Count++;
         int mc=ArrayResize(VMass,M_Count);
         if (mc==0)return(-1);
          VMass[M_Count-1]=val;
         return(1);
       }
    else return(0);    
  } 
  

//+------------------------------------------------------------------+   
int IntFromStr(string ValStr,int& M_Count, int& VMass[])
  {
    
    if (StringLen(ValStr)==0) return(-1);
    string SS=ValStr;
    int NP=0; 
    string CS;
    M_Count=0;
    ArrayResize(VMass,M_Count);
    while (StringLen(SS)>0)
      {
            NP=StringFind(SS,",");
            if (NP>0)
               {
                 CS=StringSubstr(SS,0,NP);
                 SS=StringSubstr(SS,NP+1,StringLen(SS));  
               }
               else
               {
                 if (StringLen(SS)>0)
                    {
                      CS=SS;
                      SS="";
                    }
               }
            if (Str2Massive(CS,M_Count,VMass)==0) 
               {
                 return(-2);
               }
      }
    return(1);    
  }
  



//+------------------------------------------------------------------+

string fFill(string filled, int f ) 
{
   string FILLED ;
   
   FILLED = StringSubstr(filled + "                                         ",0,f) ;
   
return(FILLED);
}

//+------------------------------------------------------------------+

void DoRollMsg( string msg ) 
{    

if(msg != "" )
{
   roll = true ;

   for( int m=23; m>=0 ; m-- )
   {
      Messages[m+1] = Messages[m];
   } // for
   
   Messages[0] = fFill(msg, 30 ) ;  
    
}// if

} // void
//+------------------------------------------------------------------+


void DrawPriceTrendLines(string objname, datetime x1, datetime x2, double y1, 
                        double y2, color lineColor, int style, int width)
  {
    
   ObjectDelete(objname);
   ObjectCreate(objname, OBJ_TREND, 0, x1, y1, x2, y2, 0, 0);
   ObjectSet(objname, OBJPROP_RAY, true);

   ObjectSet(objname, OBJPROP_COLOR, lineColor);
   ObjectSet(objname, OBJPROP_STYLE, style);
   ObjectSet(objname, OBJPROP_WIDTH, width);
  }

//+------------------------------------------------------------------+  
void DoShowLegend()
{ 
   int yInc = 50 ;

   setObject(TAG+"ut","Upper Target  " + DoubleToStr(pUpperTargetPrice, digits) ,30,yInc,myTargetLineColor); setObject(TAG+"ut1","l",10,yInc,myTargetLineColor     ,"Wingdings");
   setObject(TAG+"us","Upper Semafor " + DoubleToStr(upperTL[0], digits) ,30,yInc+20,myUpperTrendLineColor); setObject(TAG+"us1","l",10,yInc+20,myUpperTrendLineColor     ,"Wingdings");
   setObject(TAG+"ur","Upper Retrace " + DoubleToStr(UpperRetracePrice, digits) ,30,yInc+40,myRetraceLineColor); setObject(TAG+"ur1","l",10,yInc+40,myRetraceLineColor     ,"Wingdings");
   
   setObject(TAG+"lr","Lower Retrace " + DoubleToStr(LowerRetracePrice, digits) ,30,yInc+60,myRetraceLineColor); setObject(TAG+"lr1","l",10,yInc+60,myRetraceLineColor     ,"Wingdings");   
   setObject(TAG+"ls","Lower Semafor " + DoubleToStr(lowerTL[0], digits) ,30,yInc+80,myLowerTrendLineColor); setObject(TAG+"ls1","l",10,yInc+80,myLowerTrendLineColor     ,"Wingdings");
   setObject(TAG+"lt","Lower Target  " + DoubleToStr(pLowerTargetPrice, digits) ,30,yInc+100,myTargetLineColor); setObject(TAG+"lt1","l",10,yInc+100,myTargetLineColor     ,"Wingdings");           
      
     
}

//+------------------------------------------------------------------+  

void setObject(string labelName,string text,int x,int y,color theColor, string font = "Courier New",int size=10,int angle=0)
{

      
      if (ObjectFind(labelName) == -1)
          {
             ObjectCreate(labelName,OBJ_LABEL,0,0,0);
             ObjectSet(labelName,OBJPROP_CORNER,0);
             if (angle != 0)
                  ObjectSet(labelName,OBJPROP_ANGLE,angle);
          }               
       ObjectSet(labelName,OBJPROP_XDISTANCE,x);
       ObjectSet(labelName,OBJPROP_YDISTANCE,y);
       ObjectSetText(labelName,text,size,font,theColor);
}

//+------------------------------------------------------------------+
void TRO()
{   
   
   string tObjName03    = "TROTAG"  ;  
   ObjectCreate(tObjName03, OBJ_LABEL, 0, 0, 0);//HiLow LABEL
   ObjectSetText(tObjName03, CharToStr(78) , 12 ,  "Wingdings",  DimGray );
   ObjectSet(tObjName03, OBJPROP_CORNER, 3);
   ObjectSet(tObjName03, OBJPROP_XDISTANCE, 5 );
   ObjectSet(tObjName03, OBJPROP_YDISTANCE, 5 );  
}


//+------------------------------------------------------------------+   

/*



Comment(
"tltop " , tltop , "\n" , 
"tlbot " , tlbot , "\n" , 

"upperTLtime[0] " , TimeToStr( upperTLtime[0] ) , "\n" ,  
"upperTLtime[1] " , TimeToStr( upperTLtime[1] ) , "\n" ,  

"upperTL[0] " , DoubleToStr(  upperTL[0],Digits) , "\n" , 
"upperTL[1] " , DoubleToStr(  upperTL[1],Digits) , "\n" ,  
"") ; 
      if ( Trigger1 ) 
      { 
        if( FP_BuferUp[0] != 0 ) { DoRollMsg( "top 1" ) ; Trigger1 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 1 Lower "+ DoubleToStr(Close[0] ,digits));} }
        if( FP_BuferDn[0] != 0 ) { DoRollMsg( "bot 1" ) ; Trigger1 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 1 Upper "+ DoubleToStr(Close[0] ,digits)); } }
      }
      
      if ( Trigger2 ) 
      {
        if( NP_BuferUp[0] != 0 ) { DoRollMsg( "top 2" ) ; Trigger2 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 2 Lower "+ DoubleToStr(Close[0] ,digits)); } }
        if( NP_BuferDn[0] != 0 ) { DoRollMsg( "bot 2" ) ; Trigger2 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 2 Upper "+ DoubleToStr(Close[0] ,digits)); } }
      }
      
      if ( Trigger3 ) 
      {     
        if( HP_BuferUp[0] != 0 ) { DoRollMsg( "top 3" ) ; Trigger3 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 3 Lower "+ DoubleToStr(Close[0] ,digits)); } }
        if( HP_BuferDn[0] != 0 ) { DoRollMsg( "bot 3" ) ; Trigger3 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 3 Upper "+ DoubleToStr(Close[0] ,digits)); } }
      }



if(Symbol() == "GBPUSD" && Period() == 60)
{
Comment(
Symbol(), Period(),   "\n" ,  
"FP_BuferUp[0] " , DoubleToStr( FP_BuferUp[0] ,Digits) , "\n" ,   
"FP_BuferDn[0] " , DoubleToStr( FP_BuferDn[0] ,Digits) , "\n" , 

"NP_BuferUp[0] " , DoubleToStr( NP_BuferUp[0] ,Digits) , "\n" ,   
"NP_BuferDn[0] " , DoubleToStr( NP_BuferDn[0] ,Digits) , "\n" ,   

"HP_BuferUp[0] " , DoubleToStr( HP_BuferUp[0] ,Digits) , "\n" ,   
"HP_BuferDn[0] " , DoubleToStr( HP_BuferDn[0] ,Digits) , "\n" , 

"") ; 
}      
  
Comment(

"zzz = " , zzz , "\n" ,

"FP_BuferUp[zzz] " , DoubleToStr( FP_BuferUp[zzz] ,Digits) , "\n" ,   
"FP_BuferDn[zzz] " , DoubleToStr( FP_BuferDn[zzz] ,Digits) , "\n" , 

"NP_BuferUp[zzz] " , DoubleToStr( NP_BuferUp[zzz] ,Digits) , "\n" ,   
"NP_BuferDn[zzz] " , DoubleToStr( NP_BuferDn[zzz] ,Digits) , "\n" ,   

"HP_BuferUp[zzz] " , DoubleToStr( HP_BuferUp[zzz] ,Digits) , "\n" ,   
"HP_BuferDn[zzz] " , DoubleToStr( HP_BuferDn[zzz] ,Digits) , "\n" , 
  
"") ;


extern bool   Show.Targetlines  = true; 

extern color  myTargetLineColor = Orange; 
extern int    myTargetLineStyle = STYLE_DOT;
extern int    myTargetLineWidth = 1;

extern int    myTargetPips    = 20;

double UpperTargetPrice, LowerTargetPrice, xTargetPips ;

string OBJ007, OBJ008 ;  

   xTargetPips = myTargetPips * point ; 

   if(Show.Targetlines)
   {
   UpperTargetPrice = upperTL[0] - xTargetPips ;
   LowerTargetPrice = lowerTL[0] + xTargetPips ;
   
   DrawPriceTrendLines(OBJ007, upperTLtime[0], Time[0], UpperTargetPrice, 
                        UpperTargetPrice, myTargetLineColor, myTargetLineStyle, myTargetLineWidth) ;

   DrawPriceTrendLines(OBJ008, lowerTLtime[0], Time[0], LowerTargetPrice, 
                        LowerTargetPrice, myTargetLineColor, myTargetLineStyle, myTargetLineWidth) ;
   }
   
   
   
123╔∙╥Ї┤·┬ы--- TRO MODIFICATION ----


      if ( Trigger1 ) 
      { 
        if( FP_BuferUp[0] != 0 ) { Trigger1 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 1 Lower "+ DoubleToStr(Close[0] ,digits));} }
        if( FP_BuferDn[0] != 0 ) { Trigger1 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 1 Upper "+ DoubleToStr(Close[0] ,digits)); } }
      }
      
      if ( Trigger2 ) 
      {
        if( NP_BuferUp[0] != 0 ) { Trigger2 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 2 Lower "+ DoubleToStr(Close[0] ,digits)); } }
        if( NP_BuferDn[0] != 0 ) { Trigger2 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 2 Upper "+ DoubleToStr(Close[0] ,digits)); } }
      }
      
      if ( Trigger3 ) 
      {     
        if( HP_BuferUp[0] != 0 ) { Trigger3 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 3 Lower "+ DoubleToStr(Close[0] ,digits)); } }
        if( HP_BuferDn[0] != 0 ) { Trigger3 = False ; if(Sound.Alert) {Alert(symbol,"  ", tChartPeriod, " Level 3 Upper "+ DoubleToStr(Close[0] ,digits)); } }
      }
*/

