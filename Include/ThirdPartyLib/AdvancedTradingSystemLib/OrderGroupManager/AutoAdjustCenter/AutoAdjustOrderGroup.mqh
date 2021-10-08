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

        bool UpdateMagicNumbersAll() {
            if (this.CheckPosMNValid(1)) {
                PrintFormat("Updates pos mn failed, insufficient!");
                return false;
            }
            if (this.CheckNegMNValid(2)) {
                PrintFormat("Updates neg mn failed, insufficient!");
                return false;
            }
            int updated_mn = this.UpdateMagicNumber(this.group_auto_mn_, POS_MN);
            if (updated_mn == INVALID_GRP_MN) {
                PrintFormat("Updates group_auto_mn_[%d] failed!", this.group_auto_mn_);
                return false;
            }
            this.group_auto_mn_ = updated_mn;

            updated_mn = this.UpdateMagicNumber(this.group_sig_mn_, NEG_MN);
            if (updated_mn == INVALID_GRP_MN) {
                PrintFormat("Updates group_sig_mn_[%d] failed!", this.group_sig_mn_);
                return false;
            }
            this.group_sig_mn_ = updated_mn;

            updated_mn = this.UpdateMagicNumber(this.group_manul_mn_, NEG_MN);
            if (updated_mn == INVALID_GRP_MN) {
                PrintFormat("Updates group_sig_mn_[%d] failed!", this.group_manul_mn_);
                return false;
            }
            this.group_manul_mn_ = updated_mn;

            return true;
        }
        string GetGroupComment() {
            return this.GetGroupBaseComment();
        }

    private:
        int UpdateMagicNumber(int mn_to_update, MN_DIR mn_dir) {
            int allocated_mn = INVALID_GRP_MN;
            if (OrderGetUtils::GetNumOfAllOrdersInTrades(mn_to_update) != 0) {
                PrintFormat("Updates_mn_failed for num of orders is not 0!");
                return allocated_mn;
            }
            allocated_mn = this.AllocateGroupMN(POS_MN);
            if (allocated_mn == INVALID_GRP_MN) {
                PrintFormat("Updates_mn_failed for allocated failed!");
                return allocated_mn;
            }
            this.whole_order_magic_number_set_.remove(mn_to_update);
            this.whole_order_magic_number_set_.add(allocated_mn);
            return allocated_mn;
        }
    private:
        int group_auto_mn_;
        int group_sig_mn_;
        int group_manul_mn_;

    private:
        ConfigFile* config_file_;

};
