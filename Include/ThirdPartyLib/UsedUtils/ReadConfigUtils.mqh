#include <ThirdPartyLib/Utils/File.mqh>
#include <ThirdPartyLib/Lang/Script.mqh>
#include <ThirdPartyLib/Collection/HashMap.mqh>

#include <ThirdPartyLib/UsedUtils/ErrUtils.mqh>

class ReadConfigUtils {
    public:
        ReadConfigUtils() {}
        ~ReadConfigUtils() {}

    public:
        int ReadConfigUtils::ReadConfig(HashMap<string,string>& config_map_out);

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
        while(!txt.end() && !IsStopped()) {
            string line= txt.readLine();
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
        }
        return 0;
     }

    return -1;
}





