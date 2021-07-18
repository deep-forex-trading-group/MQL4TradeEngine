#include <ThirdPartyLib/Utils/File.mqh>
#include <ThirdPartyLib/Lang/Script.mqh>
#include <ThirdPartyLib/Collection/HashMap.mqh>

class ReadConfigUtils {
    public:
        ReadConfigUtils() {}
        ~ReadConfigUtils() {}

    public:
        int ReadConfigUtils::ReadConfig();
};

int ReadConfigUtils::ReadConfig() {
    TextFile txt("config.txt", FILE_READ);

    if(txt.valid()) {
        HashMap<string,string> configMap;
        while(!txt.end() && !IsStopped()) {
            string line= txt.readLine();
            string words[];
            StringSplit(line,':',words);
            int len=ArraySize(words);
            if (len != 2) {
                PrintFormat("The config file record length is %d, not valid!", len);
                return -1;
            }
            configMap.set(words[0], words[1]);
        }
        foreachm(string, key, string, value, configMap) {
            PrintFormat("%s : %s", key, value);
        }

        return 0;
     }
    return -1;
}





