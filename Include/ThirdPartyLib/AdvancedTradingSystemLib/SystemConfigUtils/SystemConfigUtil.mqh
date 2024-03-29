#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

class SystemConfigUtil {
    public:
        static void SwitchSystemMode(ConfigFile* sys_mode_config, SYSTEM_MODE& sys_mode_out[]) {

            if (!sys_mode_config.CheckConfigFieldExistByTitleAndFieldName("system", "system_mode")) {
                PrintFormat("Config for setting Sytem Running Mode does not exist.");
            } else {
                PrintFormat("System Mode is setting to {%s} by system_mode_config.txt file",
                            sys_mode_config.GetConfigFieldByTitleAndFieldName("system", "system_mode"));
                string system_mode_input = sys_mode_config.GetConfigFieldByTitleAndFieldName("system", "system_mode");
                if (system_mode_input == "TestMode") {
                    sys_mode_out[0] = TEST_MODE;
                } else if (system_mode_input == "ProductionMode") {
                    sys_mode_out[0] = PRODUCTION_MODE;
                }
            }
        }
};