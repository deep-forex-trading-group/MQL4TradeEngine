#include <ThirdPartyLib/MqlExtendLib/Utils/File.mqh>
#include <ThirdPartyLib/MqlExtendLib/Lang/Script.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashMap.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/ErrUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "ConfigSection.mqh"
#include "ConfigDataStructureConstant.mqh"

class ConfigFile {
    public:
        ConfigFile(string file_path_in) {
            PrintFormat("Initializing the ConfigFile(file_path_in=%s, CONFIG_DIR_PATH=%s)", 
                         file_path_in, CONFIG_DIR_PATH);
            StringAdd(this.file_path_, CONFIG_DIR_PATH);
            StringAdd(this.file_path_, "/");
            StringAdd(this.file_path_, file_path_in);
            this.config_titles_map_ = new HashMap<string, ConfigSection*>;
            this.RefreshConfigFile();
        }
        ConfigFile(string config_dir, string file_path_in) {
            PrintFormat("Initializing the ConfigFile(file_path_in=%s, CONFIG_DIR_PATH=%s)",
                         file_path_in, CONFIG_DIR_PATH);
            StringAdd(this.file_path_, config_dir);
            StringAdd(this.file_path_, "/");
            StringAdd(this.file_path_, file_path_in);
            this.config_titles_map_ = new HashMap<string, ConfigSection*>;
            this.RefreshConfigFile();
        }
        ~ConfigFile() {
            this.DeleteConfigMap();
            delete &err_utils;
        }

    public:
        int RefreshConfigFile();
        string GetConfigFieldByTitleAndFieldName(string title, string field_name);
        void PrintAllConfigItems();
    private:
        bool IsTitleString(const string line);
        string ProcessTitleString(const string line);
        bool IsFieldString(const string line);
        KVPair ProcessFiledString(const string line);
        void DeleteConfigMap();

    private:
        string file_path_;
        HashMap<string, ConfigSection*>* config_titles_map_;
        ErrUtils err_utils;
};

int ConfigFile::RefreshConfigFile() {
    TextFile txt(this.file_path_, FILE_READ);
    string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
    if (!txt.valid()) {
        Print("The config file is not valid.");
        PrintFormat("terminal_data_path: %s", terminal_data_path);
        err_utils.HandleLastError("Reads Config File Error");
        return -1;
    }

    // Reinitialize the config_titles_map_
    this.DeleteConfigMap();
    this.config_titles_map_ = new HashMap<string, ConfigSection*>;

    int line_idx = 0;
    string cur_title;
    while(!txt.end() && !IsStopped()) {
        string line= txt.readLine();
        // If the blank or invalid line, reset all ConfigSection settings.
        if (!this.IsTitleString(line) && !this.IsFieldString(line)) {
            cur_title = "";
        }
        // If current line is a valid title string, set the ConfigSection setting
        if (this.IsTitleString(line)) {
            cur_title = this.ProcessTitleString(line);
            ConfigSection* config_section = new ConfigSection(cur_title);
            config_titles_map_.set(cur_title, config_section);
        }
        if (config_titles_map_.contains(cur_title) && this.IsFieldString(line)) {

            KVPair kv_pair = this.ProcessFiledString(line);
            config_titles_map_[cur_title].AddConfigField(kv_pair.key, kv_pair.value);
        }
        line_idx++;
    }

    return 0;
}
string ConfigFile::GetConfigFieldByTitleAndFieldName(string title, string field_name) {
    if (!this.config_titles_map_.contains(title)) {
        PrintFormat("title %s is not in config_titles_map_", title);
        return "";
    }
    ConfigSection* c_sec = this.config_titles_map_[title];
    string field_value = c_sec.GetConfigField(field_name);
    if (field_value == "") {
        PrintFormat("title %s, field_name: %s is not in the config_section_map_.", title, field_name);
        return "";
    }
    return field_value;
}
void ConfigFile::PrintAllConfigItems() {
    Print("---------------------- Config Section Map Start -------------------------");
    foreachm(string, title, ConfigSection*, c_sec, this.config_titles_map_) {
        PrintFormat("<ConfigSection>: config_section For Title: %s Start", title);
        c_sec.PrintAllParams();
        PrintFormat("</ConfigSection>: config_section For Title: %s End", title);
    }
    Print("---------------------- Config Section Map End -------------------------\n");
}

bool ConfigFile::IsTitleString(const string line) {
    return (StringFind(line, "[") != -1) && (StringFind(line, "]") != -1) &&
            // Except the case "[]" with empty title
            (StringFind(line, "]") != 1);
}
string ConfigFile::ProcessTitleString(const string line) {
    string title = StringSubstr(line, StringFind(line, "[") + 1, StringFind(line, "]") - 1);
    return title;
}
bool ConfigFile::IsFieldString(const string line) {
    return StringFind(line , ":") != -1;
}
KVPair ConfigFile::ProcessFiledString(const string line) {
    KVPair kv_pair;
    string words[];
    StringSplit(line,':',words);
    int len=ArraySize(words);
    if (len != 2) {
        string err_msg = StringFormat("The config file record length is %d which is not valid!", len);
        Print(err_msg);
        Alert(err_msg);
        return kv_pair;
    }

    kv_pair.key = words[0];
    kv_pair.value = words[1];
    return kv_pair;
}
void ConfigFile::DeleteConfigMap() {
    foreachm(string, title, ConfigSection*, c_sec, config_titles_map_) {
        delete c_sec;
    }
    delete this.config_titles_map_;
}