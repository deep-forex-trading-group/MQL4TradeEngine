#include "../Lang/Hash.mqh"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
interface EqualityComparer
  {
   bool      equals(const T left,const T right) const;
   int       hash(const T value) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
class GenericEqualityComparer: public EqualityComparer<T>
  {
public:
   virtual bool       equals(const T left,const T right) const override {return left==right;}
   virtual int        hash(const T value) const override {return Hash(value);}
  };
//+------------------------------------------------------------------+
