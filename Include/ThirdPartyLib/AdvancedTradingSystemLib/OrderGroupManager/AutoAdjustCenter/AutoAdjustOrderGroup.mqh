#include "../OrderGroupCenterBase/all.mqh"
#include "AutoAdjustOrderGroupCenter.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/OrderInMarket.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>

class AutoAdjustOrderGroup : public OrderGroup {
    public:
        AutoAdjustOrderGroup(string name, AutoAdjustOrderGroupCenter *order_group_center_ptr)
                                : name_(name), OrderGroup(order_group_center_ptr){
            this.config_file_ = new ConfigFile("Config", "adjust_config.txt");
        };
        ~AutoAdjustOrderGroup() {
            SaveDeletePtr(this.config_file_);
        };

    private:
        string name_;
        ConfigFile* config_file_;
};
