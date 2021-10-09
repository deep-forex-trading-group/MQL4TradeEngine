#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

class ArrayTransformUtils {
    public:
        static int TransformStringToDouble(string& src[], double& target[]) {
            int total_num = ArraySize(src);
            ArrayResize(target, total_num);
            for (int i = 0; i < total_num; i++) {
                target[i] = StringToDouble(src[i]);
            }
            return SUCCEEDED;
        }
};