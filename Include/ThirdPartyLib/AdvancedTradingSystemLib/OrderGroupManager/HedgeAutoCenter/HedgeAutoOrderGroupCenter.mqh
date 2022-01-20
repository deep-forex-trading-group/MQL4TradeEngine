#include "../OrderGroupCenterBase/all.mqh"
class HedgeAutoOrderGroupCenter : public OrderGroupCenter {
    public:
        HedgeAutoOrderGroupCenter(string name) : OrderGroupCenter(name) {};
        ~HedgeAutoOrderGroupCenter() {};
};