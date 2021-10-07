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
            // Assigns and Initializes the magic number for Auto and Sig
            this.group_auto_nm_ = this.pos_nm_range_.left + 1;
            this.group_sig_nm_ = this.neg_nm_range_.left - 1;
            this.whole_order_magic_number_set_.add(this.group_auto_nm_);
            this.whole_order_magic_number_set_.add(this.group_sig_nm_);
        };
        ~AutoAdjustOrderGroup() {
            SafeDeletePtr(this.config_file_);
        };
    public:
        int GetGroupAutoMagicNumber() { return this.group_auto_nm_; }
        int GetGroupSigMagicNumber() { return this.group_sig_nm_; }

// Create Order Functions
        bool CreateAutoBuyOrder(double pip) { return this.CreateAutoBuyOrder(pip, ""); }
        bool CreateAutoBuyOrder(double pip, string comment);
        bool CreateAutoSellOrder(double pip) { return this.CreateAutoSellOrder(pip, ""); }
        bool CreateAutoSellOrder(double pip, string comment);
        bool CreateSigBuyOrder(double pip) { return this.CreateSigBuyOrder(pip, ""); }
        bool CreateSigBuyOrder(double pip, string comment);
        bool CreateSigSellOrder(double pip) { return this.CreateSigSellOrder(pip, ""); }
        bool CreateSigSellOrder(double pip, string comment);

        bool AddOneOrderByStepPipReverse(int buy_or_sell, double pip_step, double lots) {
            bool is_success = OrderSendUtils::AddOneOrderByStepPipReverse(this.whole_order_magic_number_set_,
                                                                          this.group_auto_nm_,
                                                                          buy_or_sell, pip_step, lots,
                                                                          this.GetGroupComment());
            return is_success;
        }
// Magic Number Operations
        bool UpdateAutoMN() {
            if (OrderGetUtils::GetNumOfAllOrdersInTrades(this.group_auto_nm_) == 0) {
                if (!this.UpdateMagicNumber()) {
                    PrintFormat("RefreshOrderGroupState() failed for UpdateMagicNumber() failed");
                    return false;
                }
            }
            return true;
        }
        bool UpdateSigMN() {
            if (OrderGetUtils::GetNumOfAllOrdersInTrades(this.group_sig_nm_) == 0) {
                if (!this.UpdateMagicNumber()) {
                    PrintFormat("RefreshOrderGroupState() failed for UpdateMagicNumber() failed");
                    return false;
                }
            }
            return true;
        }

    private:
        bool UpdateMagicNumber();
        string GetGroupComment() {
            string comm_base = this.GetGroupBaseComment();
            string comm_for_group = StringFormat("%s#%s#%s", comm_base,
                                                IntegerToString(this.group_auto_nm_),
                                                IntegerToString(this.group_sig_nm_));
            return comm_for_group;
        }

    private:
        int group_auto_nm_;
        int group_sig_nm_;

    private:
        ConfigFile* config_file_;

};
