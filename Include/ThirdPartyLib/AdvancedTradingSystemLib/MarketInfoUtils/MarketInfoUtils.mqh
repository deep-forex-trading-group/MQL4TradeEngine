class MarketInfoUtils {
    public:
        MarketInfoUtils() {};
        ~MarketInfoUtils() {};
    public:
        static double NormalizeLotsDown (double pips_in) {
            double pips_in_digit_3 = NormalizeDouble(pips_in, 3);
            // Handles 0.01 to 0.10 cases
            if (NormalizeDouble(pips_in_digit_3, 1) == 0) {
                return NormalizeDouble(pips_in_digit_3, 2) - 0.01;
            }
            return pips_in;
        }
        static double NormalizeLotsUp (double pips_in) {
            return NormalizeDouble(pips_in, 2);
        }
        static string GetSymbol() {
            return Symbol();
        }
        static int GetEURPointFactor() {
            return 10;
        }
        static int GetDigits() {
            return (int) MarketInfo(Symbol(), MODE_DIGITS);
        };
        static double GetPoints() {
            if (Symbol() == "EURUSD") {
               return MarketInfoUtils::GetEURPointFactor() * MarketInfo(Symbol(), MODE_POINT);
            }
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
            PrintFormat("[MarketInfo] Symbol: %s", MarketInfoUtils::GetSymbol());
            PrintFormat("[MarketInfo] Digits: %s", DoubleToString(MarketInfoUtils::GetDigits()));
            PrintFormat("[MarketInfo] Point: %s", DoubleToString(MarketInfoUtils::GetPoints()));
            PrintFormat("[MarketInfo] LotsStep: %s", DoubleToString(MarketInfoUtils::GetLotsStep()));
            PrintFormat("[MarketInfo] NormLotsStep: %s", DoubleToString(MarketInfoUtils::GetNormLotsStep()));
            PrintFormat("[MarketInfo] MinPermitLots: %s", DoubleToString(MarketInfoUtils::GetMinPermitLots()));
            PrintFormat("[MarketInfo] MaxPermitLots: %s", DoubleToString(MarketInfoUtils::GetMaxPermitLots()));
            PrintFormat("----------------- Ends Print Market Info ----------------------");

        }
};