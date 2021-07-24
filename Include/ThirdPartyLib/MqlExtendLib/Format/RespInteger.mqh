//+------------------------------------------------------------------+
//| Module: Format/RespInteger.mqh                                   |
//+------------------------------------------------------------------+
#property strict
#include "RespValue.mqh"
//+------------------------------------------------------------------+
//| RespInteger                                                      |
//+------------------------------------------------------------------+
class RespInteger: public RespValue
  {
private:
   long              m_value;
public:
   RespType          getType() const {return RespTypeInteger;}
   string            toString() const {return IntegerToString(m_value);}

   int               encode(uchar &a[],int index) const
     {
      char buf[20];
      int length=IntegerToCharArray(m_value,buf);
      if(ArraySize(a)<index+3+length)
        {
         ArrayResize(a,index+3+length);
        }
      int currentIndex=index;
      a[currentIndex++]=':';
      currentIndex+=ArrayCopy(a,buf,currentIndex,20-length);
      a[currentIndex++]='\r';
      a[currentIndex++]='\n';
      return currentIndex-index;
     }
                     RespInteger(const long value):m_value(value){}
   //--- RespInteger specific
   long              getValue() const {return m_value;}
  };
//+------------------------------------------------------------------+
