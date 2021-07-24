#include "../ConfigBase/all.mqh"
#include <ThirdPartyLib/MqlExtendLib/Collection/HashMap.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/Map.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/Copy.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

class ConfigSection : public ConfigSectionBase {
    public:
        ConfigSection(string config_title) : config_title_(config_title) {
            this.config_map_ = new HashMap<string, string>();
            this.collection_copy_utils = CollectionCopyUtils<string, string>::GetInstance();
        };
        ~ConfigSection() {
            delete config_map_;
            delete collection_copy_utils;
        };

    private:
        string config_title_;
        HashMap<string, string>* config_map_;
        CollectionCopyUtils<string, string>* collection_copy_utils;

    public:
        string GetConfigTitle();
        HashMap<string, string>* GetConfigMap();
        void AddConfigField(string key, string value);
        void CopyConfigMap(HashMap<string, string>& config_map_out);
        void PrintAllParams();
};

void ConfigSection::PrintAllParams() {
    foreachm(string, key, string, val, this.config_map_) {
        PrintFormat("config_item_<%s : %s>", key, val);
    }
}
string ConfigSection::GetConfigTitle() {
    return this.config_title_;
}
HashMap<string, string>* ConfigSection::GetConfigMap() {
    return this.config_map_;
}
void ConfigSection::CopyConfigMap(HashMap<string, string>& config_map_out) {
    this.collection_copy_utils.CopyMap(this.config_map_, config_map_out);
}
void ConfigSection::AddConfigField(string key, string value) {
    this.config_map_.set(key, value);
}




