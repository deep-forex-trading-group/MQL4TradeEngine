#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/DataStructure.mqh>

struct GroupMNRanges {
    int neg_left;
    int neg_right;
    int pos_left;
    int pos_right;
};

class OrderGroupInfo {
public:
    int group_id;
    GroupMNRanges g_mn_ranges;
};