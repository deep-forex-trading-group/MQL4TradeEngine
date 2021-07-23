#include <ThirdPartyLib/MqlExtendLib/Utils/File.mqh>
#include <ThirdPartyLib/MqlExtendLib/Lang/Script.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/HashMap.mqh>

#include <ThirdPartyLib/AdvancedTradingSystemLib/ErrUtils.mqh>

class ReadConfigUtils {
    public:
        ReadConfigUtils() {}
        ~ReadConfigUtils() {
            delete &err_utils;
        }

    public:
        int ReadConfig(HashMap<string,string>& config_map_out);
    private:
        bool IsTitleString(const string line);
        string ProcessTitleString(const string line);
        bool IsFieldString(const string line);
        int ProcessFiledString(const string line, HashMap<string, string>& config_map_out);

    private:
        ErrUtils err_utils;
};

int ReadConfigUtils::ReadConfig(HashMap<string,string>& config_map_out) {
    TextFile txt("config.txt", FILE_READ);
    string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
    if (!txt.valid()) {
        Print("The config file is not valid.");
        PrintFormat("terminal_data_path: %s", terminal_data_path);
        err_utils.HandleLastError("Reads Config File Error");
        return -1;
    }

    if(txt.valid()) {
        int line_idx = 0;
        while(!txt.end() && !IsStopped()) {
            string line= txt.readLine();
            if (this.IsTitleString(line)) {
                PrintFormat("Line {%s} is title string", line);
                string title = this.ProcessTitleString(line);
                if (StringLen(title) == 0) {
                    PrintFormat("String in line <%d:%s> is empty string", line_idx+1, title);
                }
            } else if (this.IsFieldString(line)) {
                PrintFormat("Line {%s} is field string", line);
                if (this.ProcessFiledString(line, config_map_out) == 1) {
                    return -1;
                }
            }
            line_idx++;
        }
        return 0;
     }

    return -1;
}
bool ReadConfigUtils::IsTitleString(const string line) {
    return (StringFind(line, "[") != -1) && (StringFind(line, "]") != -1);
}
string ReadConfigUtils::ProcessTitleString(const string line) {
    string title = StringSubstr(line, StringFind(line, "[") + 1, StringFind(line, "]") - 1);
    return title;
}
bool ReadConfigUtils::IsFieldString(const string line) {
    return StringFind(line , ":") != -1;
}
int ReadConfigUtils::ProcessFiledString(const string line,
                                        HashMap<string, string>& config_map_out) {
    string words[];
    StringSplit(line,':',words);
    int len=ArraySize(words);
    if (len != 2) {
        string err_msg = StringFormat("The config file record length is %d which is not valid!", len);
        Print(err_msg);
        Alert(err_msg);
        return -1;
    }
    config_map_out.set(words[0], words[1]);
    return 0;
}





