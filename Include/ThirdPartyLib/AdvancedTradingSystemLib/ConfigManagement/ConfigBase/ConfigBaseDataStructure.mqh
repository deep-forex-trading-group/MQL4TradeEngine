class ConfigSectionBase {
    public:
        virtual ~ConfigSectionBase() {};
    public:
        virtual void printAllParams();
};

class ConfigFileBase {
    public:
        virtual ~ConfigFileBase() {};
    public:
        int RefreshConfigFile();
        void PrintAllConfigItems();
};