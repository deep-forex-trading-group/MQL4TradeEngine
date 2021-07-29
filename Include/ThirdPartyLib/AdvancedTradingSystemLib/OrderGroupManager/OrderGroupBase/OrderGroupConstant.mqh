//+------------------------------------------------------------------+
//|                                           OrderGroupConstant.mqh |
//|                   Copyright 2009-2013, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+

// OrderGroupCenter: List<OrderGroup>
//                   ORDER_GROUP_MAGIC_BASE
// Every Time initializing a OrderGroupCenter,
//            move the ORDER_GROUP_CENTER_MAGIC_BASE forward 1 step
//            for MAX_ORDER_GROUPS_IN_CENTER number
//            to avoid conflicts in magic_number
// OrderGroup -> MagicNumber
#define ORDER_GROUP_CENTER_MAGIC_BASE                                    4096
#define MAX_ORDER_GROUPS_IN_CENTER                                   20000000
#define ORDER_GROUP_MAX_ORDERS                                          20000