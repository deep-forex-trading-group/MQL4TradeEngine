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