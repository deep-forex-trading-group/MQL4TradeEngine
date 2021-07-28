#include <stdlib.mqh>; 

#define IsPtrInvalid(ptr) \
(CheckPointer(ptr) == POINTER_INVALID)

#define CheckPtrType(ptr, ptr_symbol) \
if (CheckPointer(ptr) == POINTER_DYNAMIC) { \
    PrintFormat("%s: POINTER_DYNAMIC", ptr_symbol); \
} else if (CheckPointer(ptr) == POINTER_INVALID) { \
    PrintFormat("%s: POINTER_INVALID", ptr_symbol); \
} else if (CheckPointer(ptr) == POINTER_AUTOMATIC) { \
    PrintFormat("%s: POINTER_AUTOMATIC", ptr_symbol); \
}

#define BoolStr(bool_val) (bool_val ? "true" : "false")

#define SaveDeletePtr(ptr) \
if (!IsPtrInvalid(ptr)) { delete ptr; }

#define HandleLastError(err_prefix_msg) \
int ErrCode = GetLastError(); \
string ErrDesc = ErrorDescription(ErrCode); \
string ErrMsg = StringConcatenate(err_prefix_msg, ": ", IntegerToString(ErrCode), " : ", ErrDesc); \
Alert(ErrMsg); \
Print(ErrMsg);