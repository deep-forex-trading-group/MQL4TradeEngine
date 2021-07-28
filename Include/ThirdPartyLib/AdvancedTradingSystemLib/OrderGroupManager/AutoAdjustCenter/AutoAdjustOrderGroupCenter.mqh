#include "../OrderGroupCenterBase/all.mqh"
class AutoAdjustOrderGroupCenter : public OrderGroupCenter {
    public:
        AutoAdjustOrderGroupCenter(string name) : OrderGroupCenter(name) {};
        ~AutoAdjustOrderGroupCenter() {};
};