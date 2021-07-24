#include "../Lang/Hash.mqh"
#include "EqualityComparer.mqh"
#property strict
//+------------------------------------------------------------------+
//| Sort comparer is useful for sorted sets, arrays etc.       |
//+------------------------------------------------------------------+
template<typename T>
class SortComparer: public EqualityComparer<T>
  {
   // Sort comparison:
   //    >0 if left>right
   //    <0 if left<right
   //   ==0 if left==right
public:
   virtual int       compare(const T left,const T right) const=0;
   virtual bool      equals(const T left,const T right) const override {return compare(left,right)==0;}
  };
//+------------------------------------------------------------------+
//| Generic sort comparer for conventional comparable types          |
//+------------------------------------------------------------------+
template<typename T>
class GenericSortComparer: public SortComparer<T>
  {
public:
   virtual int       compare(const T left,const T right) const override {return left<right?-1:left>right;}
   virtual int       hash(const T value) const override {return Hash(value);}
  };
//+------------------------------------------------------------------+
