class OrderGroupObserver {
    public:
        virtual ~OrderGroupObserver() {};
        virtual void update(string message) {};
        virtual void printInfo() = 0;
};

class OrderGroupSubject {
    public:
        virtual ~OrderGroupSubject() {};
        virtual int register(OrderGroupObserver *observer) = 0;
        virtual void unRegister(OrderGroupObserver *observer) = 0;
        // notify the changes to the observer
        virtual void notify() = 0;
        virtual void printInfo() = 0;
};