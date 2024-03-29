//+------------------------------------------------------------------+
//| Module: Format/RespParser.mqh                                    |
//+------------------------------------------------------------------+
#property strict
//+------------------------------------------------------------------+
//| The basic common interface for a RespParser                      |
//+------------------------------------------------------------------+
interface RespParser
  {
   RespParseError    getError() const;
  };
//+------------------------------------------------------------------+
