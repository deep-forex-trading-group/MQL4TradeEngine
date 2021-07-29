#include "all.mqh"

template<typename ElementType>
class ArrayAdvancedUtils {
    protected:
        ArrayAdvancedUtils() {};

        static ArrayAdvancedUtils* array_advanced_utils_singleton_;
    public:
        static ArrayAdvancedUtils* GetInstance();

    public:
        static void ArrayAdvancedUtils::CopyArray(ElementType& src[], ElementType& dst[]);
        static string ArrayAdvancedUtils::PrintArrayElements(ElementType& arr[]);
};

template<typename ElementType>
ArrayAdvancedUtils* ArrayAdvancedUtils::array_advanced_utils_singleton_ = NULL;

template<typename ElementType>
ArrayAdvancedUtils* ArrayAdvancedUtils::GetInstance() {
    if (CheckPointer(array_advanced_utils_singleton_) == POINTER_INVALID) {
        array_advanced_utils_singleton_ = new ArrayAdvancedUtils();
    }
    return array_advanced_utils_singleton_;
}

template<typename ElementType>
string ArrayAdvancedUtils::PrintArrayElements(ElementType& arr[]) {
    int arr_print_size = ArraySize(arr);
    string res_str = "";
    for (int arr_print_i = 0; arr_print_i < arr_print_size; arr_print_i++) {
        StringAdd(res_str, (string)arr[arr_print_i]);
        if (arr_print_i < arr_print_size - 1) StringAdd(res_str, ",");
    }
    res_str = StringConcatenate("{", res_str, "}");
    PrintFormat(res_str);
    return res_str;
}

template<typename ElementType>
void ArrayAdvancedUtils::CopyArray(ElementType& src[], ElementType& dst[]) {
    ArrayFree(dst);
    // TODO: to check and replace the hard code part
    // TODO: because the include conflicts to cause some parts not compiled
    if (ArraySize(dst) <= 500) {
        ArrayResize(dst, 500);
    }
    int copy_len = ArrayCopy(dst, src, 0, 0, WHOLE_ARRAY);
    ArrayResize(dst, copy_len);
}
