#include "StrategyDataStructure.mqh"

class Strategy {
    public:
        virtual ~Strategy() {};
        virtual int executeStrategy(StrategyParams& params) const = 0;
};