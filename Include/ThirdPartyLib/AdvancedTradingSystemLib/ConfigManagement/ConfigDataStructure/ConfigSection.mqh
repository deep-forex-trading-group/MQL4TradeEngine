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
        string GetConfigField(string key);
        void CopyConfigMap(HashMap<string, string>& config_section_map_out);
        void PrintAllParams();
};

void ConfigSection::PrintAllParams() {
    PrintFormat("config_title : <%s>", this.config_title_);
    foreachm(string, key, string, val, this.config_section_map_) {
        PrintFormat("config_item_<%s : %s>", key, val);
    }
}
string ConfigSection::GetConfigTitle() {
    return this.config_title_;
}
void ConfigSection::CopyConfigMap(HashMap<string, string>& config_section_map_out) {
    this.collection_copy_utils.CopyMap(this.config_section_map_, config_section_map_out);
}
void ConfigSection::AddConfigField(string key, string value) {
    this.config_section_map_.set(key, value);
}
string ConfigSection::GetConfigField(string key) {
    if (!this.config_section_map_.contains(key)) {
        PrintFormat("config_section_map_ does not contain the key: <%s>", key);
        return "";
    }
    return this.config_section_map_[key];
}