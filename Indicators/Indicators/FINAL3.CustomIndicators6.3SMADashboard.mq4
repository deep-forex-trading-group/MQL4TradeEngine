
#property indicator_chart_window

extern int cor = 0;
extern color ColorDown = Red;
extern color ColorUp = LimeGreen;
extern color ColorNeutral = Silver;
extern int FontSize = 9;
extern int XDifference = 30;
extern int YDifference = 20;
extern int No_CrossOver30_50 = 50;
extern int No_CrossOver50_100 = 20;
extern int No_100_Touch = 40;
int gi_116 = 100;
int gi_120 = 30;
int gi_124 = 20;
int gi_128 = 60;

int init() {
   ObjectsDeleteAll();
   return (0);
}

int deinit() {
   ObjectsDeleteAll();
   return (0);
}

int start() {
   int li_20;
   int li_24;
   int li_28;
   int li_32;
   double ld_44;
   double ld_52;
   double ld_60;
   double ld_68;
   double ld_76;
   double ld_84;
   double l_iclose_92;
   bool li_100;
   bool li_104;
   int l_timeframe_148;
   string l_symbol_152;
   string l_name_160;
   int l_x_176;
   color l_color_184;
   string l_text_188;
   string ls_208;
   string l_text_216;
   string ls_236;
   string l_text_244;
   int li_unused_40 = 0;
   int lia_108[6] = {5, 15, 30, 60, 240, 1440};
   string lsa_112[28] = {"EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD","USDCHF", "USDJPY", "EURJPY", "GBPJPY", "CHFJPY", "CADJPY", "AUDJPY",  "AUDCAD", "EURCAD", "EURCHF","GBPCHF", "EURGBP", "EURAUD", "AUDNZD", "NZDCAD", "NZDJPY", "NZDCHF", "EURNZD", "GBPNZD", "CADCHF", "AUDCHF", "GBPCADm"};
   string lsa_116[8] = {"M5", "M15", "M30", "H", "H4", "D"};
   int l_x_120 = gi_116;
   int l_y_124 = gi_120;
   for (int l_index_128 = 0; l_index_128 <= 7; l_index_128++) {
      ObjectDelete("A" + DoubleToStr(l_index_128, 0));
      ObjectCreate("A" + DoubleToStr(l_index_128, 0), OBJ_LABEL, 0, 0, 0);
      ObjectSetText("A" + DoubleToStr(l_index_128, 0), lsa_116[l_index_128], FontSize, "Arial Bold", Navy);
      ObjectSet("A" + DoubleToStr(l_index_128, 0), OBJPROP_CORNER, cor);
      ObjectSet("A" + DoubleToStr(l_index_128, 0), OBJPROP_XDISTANCE, l_x_120);
      ObjectSet("A" + DoubleToStr(l_index_128, 0), OBJPROP_YDISTANCE, l_y_124);
      l_x_120 += XDifference;
   }
   int l_x_132 = gi_124;
   int l_y_136 = gi_128;
   for (int l_index_140 = 0; l_index_140 <= 27; l_index_140++) {
      ObjectDelete("B" + DoubleToStr(l_index_140, 0));
      ObjectCreate("B" + DoubleToStr(l_index_140, 0), OBJ_LABEL, 0, 0, 0);
      ObjectSetText("B" + DoubleToStr(l_index_140, 0), lsa_112[l_index_140], FontSize, "Arial Bold", Navy);
      ObjectSet("B" + DoubleToStr(l_index_140, 0), OBJPROP_CORNER, cor);
      ObjectSet("B" + DoubleToStr(l_index_140, 0), OBJPROP_XDISTANCE, l_x_132);
      ObjectSet("B" + DoubleToStr(l_index_140, 0), OBJPROP_YDISTANCE, l_y_136);
      l_y_136 += YDifference;
   }
   int l_y_144 = gi_128;
   string lsa_168[6] = {"M5B", "M15B", "M30B", "H1B", "H4B", "D1B"};
   for (int l_index_172 = 0; l_index_172 <= 27; l_index_172++) {
      l_x_176 = gi_116;
      for (int l_index_180 = 0; l_index_180 <= 5; l_index_180++) {
         l_timeframe_148 = lia_108[l_index_180];
         l_symbol_152 = lsa_112[l_index_172];
         l_name_160 = lsa_112[l_index_172] + lsa_168[l_index_180];
         ld_44 = func_1(l_symbol_152, l_timeframe_148, 30);
         ld_52 = func_1(l_symbol_152, l_timeframe_148, 50);
         ld_60 = func_1(l_symbol_152, l_timeframe_148, 100);
         ld_68 = func_2(l_symbol_152, l_timeframe_148, 30);
         ld_76 = func_2(l_symbol_152, l_timeframe_148, 50);
         ld_84 = func_2(l_symbol_152, l_timeframe_148, 100);
         li_24 = func_3(l_symbol_152, l_timeframe_148);
         li_20 = func_4(l_symbol_152, l_timeframe_148);
         li_28 = func_5(l_symbol_152, l_timeframe_148);
         li_32 = func_6(l_symbol_152, l_timeframe_148);
         li_100 = func_7(l_symbol_152, l_timeframe_148);
         li_104 = func_8(l_symbol_152, l_timeframe_148);
         l_iclose_92 = iClose(l_symbol_152, l_timeframe_148, 1);
         l_color_184 = ColorNeutral;
         l_text_188 = "n";
         if (ld_68 > ld_76 && ld_76 > ld_84 && l_iclose_92 > ld_76 && ld_44 > 0.0 && ld_52 > 0.0 && ld_60 > 0.0 && li_24 < 1 && li_28 < 1) {
            l_color_184 = ColorUp;
            if (li_100) l_text_188 = "n";
         }
         if (ld_68 < ld_76 && ld_76 < ld_84 && l_iclose_92 < ld_76 && ld_44 < 0.0 && ld_52 < 0.0 && ld_60 < 0.0 && li_20 < 1 && li_32 < 1) {
            l_color_184 = ColorDown;
            if (li_104) l_text_188 = "n";
         }
         ObjectCreate(l_name_160, OBJ_LABEL, 0, 0, 0);
         ObjectSetText(l_name_160, l_text_188, FontSize, "Wingdings", l_color_184);
         ObjectSet(l_name_160, OBJPROP_CORNER, cor);
         ObjectSet(l_name_160, OBJPROP_XDISTANCE, l_x_176);
         ObjectSet(l_name_160, OBJPROP_YDISTANCE, l_y_144);
         l_x_176 += XDifference;
      }
      l_y_144 += YDifference;
   }
   int l_y_196 = gi_128;
   int l_x_200 = gi_116 + 6 * XDifference;
   for (int l_index_204 = 0; l_index_204 <= 27; l_index_204++) {
      ls_208 = lsa_112[l_index_204];
      
      ObjectDelete("D" + DoubleToStr(l_index_204, 0));
      ObjectCreate("D" + DoubleToStr(l_index_204, 0), OBJ_LABEL, 0, 0, 0);
      ObjectSetText("D" + DoubleToStr(l_index_204, 0), l_text_216, FontSize, "Arial Bold", Black);
      ObjectSet("D" + DoubleToStr(l_index_204, 0), OBJPROP_CORNER, cor);
      ObjectSet("D" + DoubleToStr(l_index_204, 0), OBJPROP_XDISTANCE, l_x_200);
      ObjectSet("D" + DoubleToStr(l_index_204, 0), OBJPROP_YDISTANCE, l_y_196);
      l_y_196 += YDifference;
   }
   int l_y_224 = gi_128;
   int l_x_228 = gi_116 + 7 * XDifference;
   for (int l_index_232 = 0; l_index_232 <= 27; l_index_232++) {
      ls_236 = lsa_112[l_index_232];
     
      ObjectDelete("E" + DoubleToStr(l_index_232, 0));
      ObjectCreate("E" + DoubleToStr(l_index_232, 0), OBJ_LABEL, 0, 0, 0);
      ObjectSetText("E" + DoubleToStr(l_index_232, 0), l_text_244, FontSize, "Arial Bold", Black);
      ObjectSet("E" + DoubleToStr(l_index_232, 0), OBJPROP_CORNER, cor);
      ObjectSet("E" + DoubleToStr(l_index_232, 0), OBJPROP_XDISTANCE, l_x_228);
      ObjectSet("E" + DoubleToStr(l_index_232, 0), OBJPROP_YDISTANCE, l_y_224);
      l_y_224 += YDifference;
   }
   return (0);
}

double func_1(string a_symbol_0, int a_timeframe_8, int a_period_12) {
   double ld_ret_16 = iMA(a_symbol_0, a_timeframe_8, a_period_12, 0, MODE_SMA, PRICE_CLOSE, 0) - iMA(a_symbol_0, a_timeframe_8, a_period_12, 0, MODE_SMA, PRICE_CLOSE, 10);
   return (ld_ret_16);
}

double func_2(string a_symbol_0, int a_timeframe_8, int a_period_12) {
   double l_ima_16;
   l_ima_16 = iMA(a_symbol_0, a_timeframe_8, a_period_12, 0, MODE_SMA, PRICE_CLOSE, 0);
   return (l_ima_16);
}

int func_3(string a_symbol_0, int a_timeframe_8) {
   for (int li_12 = 1; li_12 <= No_CrossOver30_50; li_12++)
      if (iMA(a_symbol_0, a_timeframe_8, 30, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1) - iMA(a_symbol_0, a_timeframe_8, 50, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1) <= 0.0) return (1);
   for (li_12 = 1; li_12 <= No_CrossOver50_100; li_12++)
      if (iMA(a_symbol_0, a_timeframe_8, 50, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1) - iMA(a_symbol_0, a_timeframe_8, 100, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1) <= 0.0) return (1);
   return (0);
}

int func_4(string a_symbol_0, int a_timeframe_8) {
   for (int li_12 = 1; li_12 <= No_CrossOver30_50; li_12++)
      if (iMA(a_symbol_0, a_timeframe_8, 50, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1) - iMA(a_symbol_0, a_timeframe_8, 30, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1) <= 0.0) return (1);
   for (li_12 = 1; li_12 <= No_CrossOver50_100; li_12++)
      if (iMA(a_symbol_0, a_timeframe_8, 100, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1) - iMA(a_symbol_0, a_timeframe_8, 50, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1) <= 0.0) return (1);
   return (0);
}

int func_5(string a_symbol_0, int a_timeframe_8) {
   for (int li_12 = 1; li_12 <= No_100_Touch; li_12++)
      if (iLow(a_symbol_0, a_timeframe_8, li_12 - 1) <= iMA(a_symbol_0, a_timeframe_8, 100, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1)) return (1);
   return (0);
}

int func_6(string a_symbol_0, int a_timeframe_8) {
   for (int li_12 = 1; li_12 <= No_100_Touch; li_12++)
      if (iHigh(a_symbol_0, a_timeframe_8, li_12 - 1) >= iMA(a_symbol_0, a_timeframe_8, 100, 0, MODE_SMA, PRICE_CLOSE, li_12 - 1)) return (1);
   return (0);
}

int func_7(string a_symbol_0, int a_timeframe_8) {
   if (iLow(a_symbol_0, a_timeframe_8, 0) < iMA(a_symbol_0, a_timeframe_8, 50, 0, MODE_SMA, PRICE_CLOSE, 0)) return (1);
   return (0);
}

int func_8(string a_symbol_0, int a_timeframe_8) {
   if (iHigh(a_symbol_0, a_timeframe_8, 0) > iMA(a_symbol_0, a_timeframe_8, 50, 0, MODE_SMA, PRICE_CLOSE, 0)) return (1);
   return (0);
}

