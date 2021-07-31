#include <stdlib.mqh>; 
#include "CommonConstant.mqh"

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

#define ShowDeinitReason(reason_code) \
string text = ""; \
switch(reason_code)  { \
    case REASON_ACCOUNT: \
        text="Account was changed";break; \
    case REASON_CHARTCHANGE: \
        text="Symbol or timeframe was changed";break; \
    case REASON_CHARTCLOSE: \
        text="Chart was closed";break; \
    case REASON_PARAMETERS: \
        text="Input-parameter was changed";break; \
    case REASON_RECOMPILE: \
        text="Program "+__FILE__+" was recompiled";break; \
    case REASON_REMOVE: \
        text="Program "+__FILE__+" was removed from chart";break; \
    case REASON_TEMPLATE: \
        text="New template was applied to chart";break; \
    default: \
        text="Another reason"; \
} \
PrintFormat("The Deinit Reason is [%s], Reason Code is {%d}", text, reason_code);

#define MakeSureArraySize(arr) \
if (ArraySize(arr) <= ARR_DEFAULT_SIZE) { \
    ArrayResize(arr, ARR_DEFAULT_SIZE); \
}

#define ClearAndMakeSureArraySize(arr) \
ArrayFree(arr); \
if (ArraySize(arr) <= ARR_DEFAULT_SIZE) { \
    ArrayResize(arr, ARR_DEFAULT_SIZE); \
}

enum SYSTEM_MODE {
    TEST_MODE,
    PRODUCTION_MODE
};
#define TESTING_CODE_ST(system_mode) \
if (system_mode == TEST_MODE) {
#define TESTING_CODE_END(system_mode) \
}