#property strict

#include "Vector.mqh"
#include "Set.mqh"
//+------------------------------------------------------------------+
//| Simple Set implementation using an vector (no repeated elements) |
//+------------------------------------------------------------------+
template<typename T>
class ArraySet: public Set<T>
  {
private:
   Vector<T>m_vector;
public:
                     ArraySet(bool owned=false,EqualityComparer<T>*comparer=NULL):Set<T>(owned,comparer),m_vector(owned,10,comparer){}
                    ~ArraySet() {}

   // CosntIterator interface
   ConstIterator<T>*constIterator() const {return m_vector.constIterator();}
   // Iterator interface
   Iterator<T>*iterator() {return new ArraySetIterator<T>(GetPointer(m_vector),m_owned);}

   // Collection interface
   void              clear() {m_vector.clear();}
   int               size() const {return m_vector.size();}
   bool              add(T value)
     {
      if(m_vector.contains(value)) return false;
      else return m_vector.add(value);
     }
   bool              remove(const T value) {return m_vector.remove(value);}
   bool              contains(const T value) const {return m_vector.contains(value);}
  };
//+------------------------------------------------------------------+
//| Iterator implementation for ArraySet                             |
//| Overrides VectorIterator<T>.add: ensure no repeated elements can |
//| be added to the ArraySet                                         |
//+------------------------------------------------------------------+
template<typename T>
class ArraySetIterator: public VectorIterator<T>
  {
public:
                     ArraySetIterator(Vector<T>*v,bool owned):VectorIterator<T>(v,owned) {}
   // you can not set a value during Set iteration
   virtual bool      set(T value) {return false;}
  };
//+------------------------------------------------------------------+
