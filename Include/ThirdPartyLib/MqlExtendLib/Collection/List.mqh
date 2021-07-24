#property strict

#include "Collection.mqh"
//+------------------------------------------------------------------+
//| Generic abstract base class for List like collections            |
//+------------------------------------------------------------------+
template<typename T>
class List: public Collection<T>
  {
public:
                     List(bool owned,EqualityComparer<T>*comparer):Collection<T>(owned,comparer) {}
   //--- Iterator interface
   virtual           ConstIterator<T>*constIterator() const=0;
   virtual           Iterator<T>*iterator()=0;

   //--- Collection interface
   virtual void      clear()=0;
   virtual int       size() const=0;
   virtual bool      add(T value)=0;
   virtual bool      remove(const T value)=0;   // remove the element and if owned, the element will be destructed

   //--- Sequence interface
   virtual void      insertAt(int i,T val)=0;   // insert element at position i
   virtual T         removeAt(int i)=0;         // remove element at position i; no need to destruct the object
   virtual T         get(int i) const=0;
   virtual void      set(int i,T val)=0;        // the original object will not be destructed!!!

   //--- Stack and Queue interface: alias for Sequence interface
   // subclasses may have more efficient implemenations
   virtual void      push(T val) {insertAt(size(),val);}
   virtual T         pop() {return removeAt(size()-1);}
   virtual T         peek() const {return get(size()-1);}
   virtual void      unshift(T val) {insertAt(0,val);}
   virtual T         shift() {return removeAt(0);}
  };
//+------------------------------------------------------------------+
