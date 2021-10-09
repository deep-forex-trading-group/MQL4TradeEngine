#include <ThirdPartyLib/MqlExtendLib/Utils/File.mqh>
#include <ThirdPartyLib/MqlExtendLib/Lang/Script.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashMap.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/ArrayAdvancedUtils.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "ConfigSection.mqh"
#include "ConfigDataStructureConstant.mqh"

#include "ConfigFile.mqh"

int ConfigFile::RefreshConfigFile() {
    TextFile txt(this.file_path_, FILE_READ);
    string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
    if (!txt.valid()) {
        Print("The config file is not valid.");
        PrintFormat("terminal_data_path: %s", terminal_data_path);
        HandleLastError("Reads Config File Error");
        return -1;
    }

    // Reinitialize the config_titles_map_
    MapDeleteUtils<string, ConfigSection*>::SafeFreeHashMap(this.config_titles_map_);
    this.config_titles_map_ = new HashMap<string, ConfigSection*>;

    int line_idx = 0;
    string cur_title;
    while(!txt.end() && !IsStopped()) {
        string line= txt.readLine();
        // If the blank or invalid line, reset all ConfigSection settings.
        if (!this.IsTitleString(line) && !this.IsFieldString(line)) {
            continue;
        }
        // If current line is a valid title string, set the ConfigSection setting
        if (this.IsTitleString(line)) {
            cur_title = this.ProcessTitleString(line);
            ConfigSection* config_section = new ConfigSection(cur_title);
            config_titles_map_.set(cur_title, config_section);
        }
        if (config_titles_map_.contains(cur_title) && this.IsFieldString(line)) {

            KVPair kv_pair = this.ProcessFieldString(line);
            config_titles_map_[cur_title].AddConfigField(kv_pair.key, kv_pair.value);
        }
        line_idx++;
    }

    return 0;
}
bool ConfigFile::CheckConfigFieldExistByTitleAndFieldName(string title, string field_name) {
    if (!this.config_titles_map_.contains(title)) {
        PrintFormat("title %s is not in config_titles_map_", title);
        return false;
    }
    ConfigSection* c_sec = this.config_titles_map_[title];
    string field_value = c_sec.GetConfigField(field_name);
    if (field_value == "") {
        PrintFormat("title %s, field_name: %s is not in the config_section_map_.", title, field_name);
        return false;
    }
    return true;
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
int ConfigFile::GetConfigFieldByTitleAndFieldName(string title, string field_name, string& res_out[]) {
    string field_value = this.GetConfigFieldByTitleAndFieldName(title, field_name);
    string field_value_arr[];
    StringSplit(field_value, ',', field_value_arr);
    ArrayAdvancedUtils<string>::CopyArray(field_value_arr, res_out);
    return SUCCEEDED;
}
void ConfigFile::PrintAllConfigItems() {
    Print("---------------------- Config Section Map Start -------------------------");
    foreachm(string, title, ConfigSection*, c_sec, this.config_titles_map_) {
        PrintFormat("<ConfigSection {%s}>", title);
        c_sec.PrintAllParams();
        PrintFormat("</ConfigSection {%s}>", title);
    }
    Print("---------------------- Config Section Map End -------------------------\n");
}
bool ConfigFile::IsCommentString(const string line) {
    return (StringFind(line, "##") == 0);
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
KVPair ConfigFile::ProcessFieldString(const string line) {
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