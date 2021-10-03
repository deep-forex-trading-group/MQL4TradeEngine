class MarketInfoUtils {
    public:
        MarketInfoUtils() {};
        ~MarketInfoUtils() {};
    public:
        static int GetDigits() {
            return (int) MarketInfo(Symbol(), MODE_DIGITS);
        };
        static double GetPoints() {
            return MarketInfo(Symbol(), MODE_POINT);
        }
        static double GetLotsStep() {
            return MarketInfo(Symbol(), MODE_LOTSTEP) ;
        }
        static double GetNormLotsStep() {
            return MathLog(MarketInfoUtils::GetLotsStep()) / (-2.302585092994);
        }
        static double GetMinPermitLots() {
            return MarketInfo(Symbol(), MODE_MINLOT);
        }
        static double GetMaxPermitLots() {
            return MarketInfo(Symbol(), MODE_MAXLOT);
        }
        static void PrintMarketInfo() {
            PrintFormat("----------------- Starts Print Market Info ----------------------");
            PrintFormat("[MarketInfo] Digits: %s", DoubleToString(MarketInfoUtils::GetDigits()));
            PrintFormat("[MarketInfo] Point: %s", DoubleToString(MarketInfoUtils::GetPoints()));
            PrintFormat("[MarketInfo] LotsStep: %s", DoubleToString(MarketInfoUtils::GetLotsStep()));
            PrintFormat("[MarketInfo] NormLotsStep: %s", DoubleToString(MarketInfoUtils::GetNormLotsStep()));
            PrintFormat("[MarketInfo] MinPermitLots: %s", DoubleToString(MarketInfoUtils::GetMinPermitLots()));
            PrintFormat("[MarketInfo] MaxPermitLots: %s", DoubleToString(MarketInfoUtils::GetMaxPermitLots()));
            PrintFormat("----------------- Ends Print Market Info ----------------------");

        }
};