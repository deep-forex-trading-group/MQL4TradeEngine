#include <ThirdPartyLib/Utils/File.mqh>
#include <ThirdPartyLib/Lang/Script.mqh>
#include <ThirdPartyLib/Collection/HashMap.mqh>

// Testing Mode and Production Mode switch
// if Production Mode, comments the code snippets
//#ifndef TestMode
//   #define TestMode
//#endif

class ReadConfigUtils {
    public:
        ReadConfigUtils() {}
        ~ReadConfigUtils() {}

    public:
        int ReadConfigUtils::ReadConfig(HashMap<string,string>& config_map_out);
};

int ReadConfigUtils::ReadConfig(HashMap<string,string>& config_map_out) {
#ifdef TestMode
    string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
    Print("terminal_data_path: %s", terminal_data_path);
#endif
    TextFile txt("config.txt", FILE_READ);

    if(txt.valid()) {
        while(!txt.end() && !IsStopped()) {
            string line= txt.readLine();
            string words[];
            StringSplit(line,':',words);
            int len=ArraySize(words);
            if (len != 2) {
                PrintFormat("The config file record length is %d, not valid!", len);
                return -1;
            }
            config_map_out.set(words[0], words[1]);
        }
        return 0;
     }
    return -1;
}





