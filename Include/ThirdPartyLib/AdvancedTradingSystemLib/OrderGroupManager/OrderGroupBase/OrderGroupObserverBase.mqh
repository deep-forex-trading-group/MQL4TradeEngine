class OrderGroupObserver {
    public:
        virtual ~OrderGroupObserver() {};
        virtual void update(string message) {};
        virtual void printInfo() = 0;
};