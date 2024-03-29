#include <ThirdPartyLib/MqlExtendLib/Utils/File.mqh>
#include <ThirdPartyLib/MqlExtendLib/Lang/Script.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashMap.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "ConfigSection.mqh"
#include "ConfigDataStructureConstant.mqh"

class ConfigFile : public ConfigFileBase {
    public:
        ConfigFile(string config_file_name) {
            PrintFormat("Initialize the ConfigFile(config_file_name=%s, CONFIG_DIR_PATH=%s)",
                         config_file_name, CONFIG_DIR_PATH);
            StringAdd(this.file_path_, CONFIG_DIR_PATH);
            StringAdd(this.file_path_, "/");
            StringAdd(this.file_path_, config_file_name);
            this.config_titles_map_ = new HashMap<string, ConfigSection*>;
            if (this.RefreshConfigFile() != 0) {
                PrintFormat("Failed initializeing the ConfigFile(config_file_name=%s, CONFIG_DIR_PATH=%s)",
                            config_file_name, CONFIG_DIR_PATH);
            }
        }
        ConfigFile(string config_dir, string config_file_name) {
            PrintFormat("Initialize the ConfigFile(config_file_name=%s, CONFIG_DIR_PATH=%s)",
                         config_file_name, CONFIG_DIR_PATH);
            StringAdd(this.file_path_, config_dir);
            StringAdd(this.file_path_, "/");
            StringAdd(this.file_path_, config_file_name);
            this.config_titles_map_ = new HashMap<string, ConfigSection*>;
            this.RefreshConfigFile();
        }
        ~ConfigFile() {
            MapDeleteUtils<string, ConfigSection*>::SafeFreeHashMap(this.config_titles_map_);
        }

    public:
        bool CheckConfigFileValid() { TextFile txt(this.file_path_, FILE_READ); return txt.valid(); }
        int RefreshConfigFile();
        // Returns the field string
        bool CheckConfigFieldExistByTitleAndFieldName(string title, string field_name);
        string GetConfigFieldByTitleAndFieldName(string title, string field_name);
        // Returns whether success and wrap the output array with multi-values results
        int GetConfigFieldByTitleAndFieldName(string title, string field_name, string& res_out[]);
        void PrintAllConfigItems();
    private:
        bool IsTitleString(const string line);
        string ProcessTitleString(const string line);
        bool IsFieldString(const string line);
        KVPair ProcessFiledString(const string line);
    private:
        string file_path_;
        HashMap<string, ConfigSection*>* config_titles_map_;
};