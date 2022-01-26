class CommonUtils {
    public:
        CommonUtils();
        ~CommonUtils();
    public:
        static datetime GetDatetimeFromString(string str_input) {
            StringReplace(str_input, "-", ".");
            str_input = StringSubstr(str_input, 0, StringLen(str_input)-3);
            datetime dt = StrToTime(str_input);
            return dt;
        }
};