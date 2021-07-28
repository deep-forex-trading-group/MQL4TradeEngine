class OrderGroupObserver {
    public:
        virtual ~OrderGroupObserver() {};
        virtual void Update(string message) {};
        virtual void PrintInfo() = 0;
};