#include "../ConfigBase/all.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/HashMap.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/Copy.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

class ConfigSection : public ConfigSectionBase {
    public:
        ConfigSection(string config_title) : config_title_(config_title) {
            this.config_section_map_ = new HashMap<string, string>();
            this.collection_copy_utils = CollectionCopyUtils<string, string>::GetInstance();
        };
        ~ConfigSection() {
            delete config_section_map_;
            delete collection_copy_utils;
        };

    private:
        string config_title_;
        HashMap<string, string>* config_section_map_;
        CollectionCopyUtils<string, string>* collection_copy_utils;
    public:
        string GetConfigTitle();
        void AddConfigField(string key, string value);
        bool IsConfigFieldExist(string key);
        string GetConfigField(string key);
        void CopyConfigMap(HashMap<string, string>& config_section_map_out);
        void PrintAllParams();
};