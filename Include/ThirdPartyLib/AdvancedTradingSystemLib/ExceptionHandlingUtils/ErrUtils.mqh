#include <stdlib.mqh>

class ErrUtils {
    public:
        ErrUtils() {}
        ~ErrUtils() {}
    public:
        void HandleLastError(string err_prefix_msg);
};

void ErrUtils::HandleLastError(string err_prefix_msg) {
    int ErrCode = GetLastError();
    string ErrDesc = ErrorDescription(ErrCode);
    string ErrMsg = StringConcatenate(err_prefix_msg, ": ", ErrCode, " : ", ErrDesc);
    Alert(ErrMsg);
    Print(ErrMsg);
}