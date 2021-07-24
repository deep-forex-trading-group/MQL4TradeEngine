//+------------------------------------------------------------------+
//| Module: Format/RespParseError.mqh                                |
//+------------------------------------------------------------------+
#property strict
//+------------------------------------------------------------------+
//| Parse errors                                                     |
//+------------------------------------------------------------------+
enum RespParseError
  {
   RespParseErrorNone,                // No error
   RespParseErrorNeedMoreInput,       // buffer is incomplete, needs more input
   RespParseErrorInvalidPrefix,       // type prefix is not one of '+' '-' ':' '$' '*'
   RespParseErrorNewlineMalformed,    // Newline is not "\r\n" or '\r' is not followed by '\n'
   RespParseErrorInvalidInteger,      // Integer is not valid
   RespParseErrorArrayLengthNotValid, // Array length is not a positive integer
   RespParseErrorBytesLengthNotValid  // Bytes (bulk string) length is not a positive integer or -1
  };
//+------------------------------------------------------------------+
