#include "../OrderGroupCenterBase/all.mqh"
#include "HedgeAutoOrderGroupCenter.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>

class HedgeAutoOrderGroup : public OrderGroup {
    public:
        HedgeAutoOrderGroup(string name,
                            HedgeAutoOrderGroupCenter *order_group_center_ptr)
                            : OrderGroup(name, order_group_center_ptr) {
            this.config_file_ = new ConfigFile("Config", "hedge_auto_config.txt");
            this.UpdateMagicNumbersAll();
            PrintFormat("%d", this.whole_order_magic_number_set_.size());
        }
        ~HedgeAutoOrderGroup() {
            SafeDeletePtr(this.config_file_);
        };
     public:
// Magic Number Getters
        int GetGroupAutoMagicNumber() { return this.group_auto_mn_; }
        int GetGroupSigMagicNumber() { return this.group_sig_mn_; }
        int GetGroupManualMagicNumber() { return this.group_manul_mn_; }

// Create Order Functions
        bool CreateManulBuyOrder(double lots) { return this.CreateManulBuyOrder(lots, ""); }
        bool CreateManulBuyOrder(double lots, string comment);
        bool CreateManulSellOrder(double lots) { return this.CreateManulSellOrder(lots, ""); }
        bool CreateManulSellOrder(double lots, string comment);

        bool CreateSigBuyOrder(double lots) { return this.CreateSigBuyOrder(lots, ""); }
        bool CreateSigBuyOrder(double lots, string comment);
        bool CreateSigSellOrder(double lots) { return this.CreateSigSellOrder(lots, ""); }
        bool CreateSigSellOrder(double lots, string comment);

        bool AddOneOrderByStepPipReverse(int buy_or_sell, double pip_step, double lots) {
            return this.AddOneOrderByStepPipReverse(buy_or_sell, pip_step, lots, "");
        }
        bool AddOneOrderByStepPipReverse(int buy_or_sell, double pip_step, double lots, string comment) {
            string comm_grp = this.GetGroupComment();
            string comm = StringFormat("%s#sa#%s", comm_grp, comment);
            bool is_success = OrderSendUtils::AddOneOrderByStepPipReverse(this.whole_order_magic_number_set_,
                                                                          this.group_auto_mn_,
                                                                          buy_or_sell, pip_step, lots,
                                                                          comm);
            return is_success;
        }
// Group Info Getters
        int GetNumOfAutoOrdersInTrades() { return OrderGetUtils::GetNumOfAllOrdersInTrades(this.group_auto_mn_);}
// Close Order Functions
        bool ClosePartOrders(double prop_factor) {
            HashSet<int>* mn_set = new HashSet<int>();
            mn_set.add(this.group_manul_mn_);
            mn_set.add(this.group_auto_mn_);
            mn_set.add(this.group_sig_mn_);
            bool is_success = OrderCloseUtils::ClosePartOrders(mn_set, prop_factor, NORM_LOTS_UP);
            SafeDeletePtr(mn_set);
            return is_success;
        }
        bool UpdateMagicNumbersAll();
        string GetGroupComment() {
            return this.GetGroupBaseComment();
        }

    private:
        int UpdateMagicNumber(int mn_to_update, MN_DIR mn_dir);
    private:
        int group_auto_mn_;
        int group_sig_mn_;
        int group_manul_mn_;

    private:
        ConfigFile* config_file_;
};