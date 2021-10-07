class EAUtils {
    public:
        static bool IsEATesting() {
            return IsTesting();
        }
        static ENUM_TIMEFRAMES GetCurrentTimeFrame() {
            return (ENUM_TIMEFRAMES) Period();
        }
        static bool IsEARunOnDemoAccount() {
            return IsDemo();
        }
};