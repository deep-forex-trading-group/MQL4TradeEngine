#include "OrderGroupObserverBase.mqh"
class OrderGroupSubject {
    public:
        virtual ~OrderGroupSubject() {};
        virtual int Register(OrderGroupObserver *observer) = 0;
        virtual void UnRegister(OrderGroupObserver *observer) = 0;
        // Notify the changes to the observer
        virtual void Notify() = 0;
        virtual void PrintInfo() = 0;
};