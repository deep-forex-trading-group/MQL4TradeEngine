//+------------------------------------------------------------------+
//| Module: Format/RespBytes.mqh                                     |
//+------------------------------------------------------------------+
#property strict
#include "RespValue.mqh"
//+------------------------------------------------------------------+
//| RespBytes (Binary safe bulk string)                              |
//+------------------------------------------------------------------+
class RespBytes: public RespValue
  {
private:
   char              m_array[];
public:
                     RespBytes(const char &value[],int pos=0,int count=WHOLE_ARRAY)
     {
      ArrayCopy(m_array,value,0,pos,count);
     }
                     RespBytes(const string value)
     {
      StringToUtf8(value,m_array,false);
     }

   RespType          getType() const {return RespTypeBytes;}
   string            toString() const
     {
      string result="b\"";
      result+=StringRepr(m_array);
      result+="\"";
      return result;
     }

   int               encode(uchar &a[],int index) const
     {
      char buf[20];
      int length=ArraySize(m_array);
      int lengthSize=IntegerToCharArray(length,buf);
      // prefix + size + "\r\n"
      int lengthPrefixSize=lengthSize+3;
      int totalSize=lengthPrefixSize+length+2;
      int currentIndex=index;
      if(ArraySize(a)<currentIndex+totalSize)
        {
         ArrayResize(a,currentIndex+totalSize,100);
        }

      a[currentIndex++]='$';
      currentIndex+=ArrayCopy(a,buf,currentIndex,20-lengthSize);
      a[currentIndex++]='\r';
      a[currentIndex++]='\n';
      currentIndex+=ArrayCopy(a,m_array,currentIndex);
      a[currentIndex++]='\r';
      a[currentIndex++]='\n';
      return currentIndex-index;
     }

   //--- bytes specific
   string            getValueAsString() const {return StringFromUtf8(m_array);}
   int               getValueAsArray(char &a[]) const {return ArrayCopy(a,m_array);}
  };
//+------------------------------------------------------------------+
//| RespNil (Bulk string with length -1)                             |
//+------------------------------------------------------------------+
class RespNil: public RespValue
  {
private:
   static const char NilArray[5];
   static RespNil   *m_instance;
                     RespNil() {}
public:
   RespType          getType() const {return RespTypeNil;}
   string            toString() const {return "Nil";}

   int               encode(uchar &a[],int index) const
     {
      static const int size=ArraySize(NilArray);
      if(ArraySize(a)<index+size)
        {
         ArrayResize(a,index+size);
        }
      ArrayCopy(a,NilArray,index);
      return size;
     }
   static RespNil   *getInstance() {if(m_instance==NULL)m_instance=new RespNil;return m_instance;}
  };
static const char RespNil::NilArray[5]={'$','-','1','\r','\n'};
static RespNil *RespNil::m_instance=NULL;
const RespNil *Nil=RespNil::getInstance();
EnsureDelete ensureDeleteNil(Nil);
//+------------------------------------------------------------------+
