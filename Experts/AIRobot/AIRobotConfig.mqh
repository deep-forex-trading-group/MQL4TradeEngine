#include <ThirdPartyLib/UsedUtils/ReadConfigUtils.mqh>
#include <ThirdPartyLib/Collection/HashMap.mqh>

struct AIRobotConfigParams {
    int pips_factor;
    int act_factor;
    bool is_config_exist;
};

class AIRobotConfig {
    public:
        AIRobotConfig() {
            // Gives the parameters with initial values(most impossible values)
            this.ai_robot_config_params.pips_factor = -10000;
            this.ai_robot_config_params.act_factor = -10000;
            this.ai_robot_config_params.is_config_exist = false;

            // Refreshes the config params firstly
            this.refreshConfig();
        }
        ~AIRobotConfig() {}
    private:
        ReadConfigUtils read_config_utils;
        AIRobotConfigParams ai_robot_config_params;

    public:
        AIRobotConfigParams getConfig();
        int refreshConfig();
        void printConfig();
        
};

AIRobotConfigParams AIRobotConfig::getConfig() {
    if (!this.ai_robot_config_params.is_config_exist) {
        Print("AIRobotConfig does not exist! ");
    }
    return this.ai_robot_config_params;
}

int AIRobotConfig::refreshConfig() {
    HashMap<string,string> config_map;
    int is_success = read_config_utils.ReadConfig(config_map);
    if (is_success != 0) {
        Print("Refreshes the config params failed!");
        this.ai_robot_config_params.is_config_exist = false;
        return -1;
    }

    foreachm(string, key, string, value, config_map) {
        if (key == "pips_factor") {
            int pips_factor_val = int(value);
            this.ai_robot_config_params.pips_factor = pips_factor_val;
        }
        if (key == "act_factor") {
            int act_factor_val = int(value);
            this.ai_robot_config_params.act_factor = act_factor_val;
        }
    }
    this.ai_robot_config_params.is_config_exist = true;
    return 0;
}

void AIRobotConfig::printConfig() {
    if (!this.ai_robot_config_params.is_config_exist) {
        Print("AIRobotConfig does not exist! ");
    }
    Print("---------------- Printing config map as following ---------------");
    PrintFormat("pips_factor: %d", this.ai_robot_config_params.pips_factor);
    PrintFormat("act_factor: %d", this.ai_robot_config_params.act_factor);
}

