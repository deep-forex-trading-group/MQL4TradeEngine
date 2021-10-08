#include "../OrderGroupCenterBase/all.mqh"
#include "AutoAdjustOrderGroupCenter.mqh"
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/OrderManageUtils/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>

class AutoAdjustOrderGroup : public OrderGroup {
    public:
        AutoAdjustOrderGroup(string name, AutoAdjustOrderGroupCenter *order_group_center_ptr)
                                : OrderGroup(name, order_group_center_ptr){
            this.config_file_ = new ConfigFile("Config", "adjust_config.txt");
            // Assigns and Initializes the magic number for Auto, Sig and Manul
            this.UpdateMagicNumbersAll();
            PrintFormat("%d", this.whole_order_magic_number_set_.size());
        };
        ~AutoAdjustOrderGroup() {
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

    public:
        bool UpdateMagicNumbersAll() {
            int allocated_mn = this.AllocateGroupMN(POS_MN);
            if (allocated_mn == INVALID_GRP_MN) {
                PrintFormat("Updates group_auto_mn_[%d,%d] failed!", this.group_auto_mn_, allocated_mn);
                return false;
            }
            this.whole_order_magic_number_set_.remove(this.group_auto_mn_);
            this.group_auto_mn_ = allocated_mn;
            this.whole_order_magic_number_set_.add(this.group_auto_mn_);

            allocated_mn = this.AllocateGroupMN(NEG_MN);
            if (allocated_mn == INVALID_GRP_MN) {
                PrintFormat("Updates group_sig_mn_[%d,%d] failed!", this.group_sig_mn_, allocated_mn);
                return false;
            }
            this.whole_order_magic_number_set_.remove(this.group_sig_mn_);
            this.group_sig_mn_ = allocated_mn;
            this.whole_order_magic_number_set_.add(this.group_sig_mn_);

            allocated_mn = this.AllocateGroupMN(NEG_MN);
            if (allocated_mn == INVALID_GRP_MN) {
                PrintFormat("Updates group_manul_mn_[%d,%d] failed!", this.group_manul_mn_, allocated_mn);
                return false;
            }
            this.whole_order_magic_number_set_.remove(this.group_manul_mn_);
            this.group_manul_mn_ = allocated_mn;
            this.whole_order_magic_number_set_.add(this.group_manul_mn_);

            return true;
        }
        string GetGroupComment() {
            return this.GetGroupBaseComment();
        }

    private:
        int group_auto_mn_;
        int group_sig_mn_;
        int group_manul_mn_;

    private:
        ConfigFile* config_file_;

};
