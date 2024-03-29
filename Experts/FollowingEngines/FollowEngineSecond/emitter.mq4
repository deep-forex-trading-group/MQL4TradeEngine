string eaname,srcfile,l_time2str_8;

int OnInit() 
 {

   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}
 
int deinit() 
 {
    delObj(); 
  
   return (0);
}


void OnTimer()
 {    
   delObj();
   while (true && !IsStopped()) 
   {
      Sleep(10);
     eaname=AccountNumber();
     srcfile=eaname+".csv"; 
    int l_file_0 = FileOpen(srcfile, FILE_CSV|FILE_COMMON|FILE_WRITE, ',');
   if (l_file_0 > 0) 
       {
         FileWrite(l_file_0, OrdersTotal() + "#"); 
         for (int l_pos_4 = OrdersTotal() - 1; l_pos_4 >= 0; l_pos_4--) 
            {
               if(OrderSelect(l_pos_4, SELECT_BY_POS, MODE_TRADES)==true)                    
                FileWrite(l_file_0, OrderType(), OrderSymbol(), OrderOpenPrice(),
                   OrderTakeProfit(), OrderStopLoss(), OrderLots(), OrderOpenTime(), OrderTicket());                     
            }
      FileClose(l_file_0);
   } else Print("file write error");
    l_time2str_8 = TimeToStr(TimeCurrent(), TIME_MINUTES|TIME_SECONDS);
    writetext("logo2",  "["+l_time2str_8+"]"+"正在运行喊单", 250, 5, clrYellow, 10);
  }
}


void writetext(string a_name_0, string a_text_8, int a_x_16, int a_y_20, color a_color_24, int a_fontsize_28) 
 {
   ObjectDelete(a_name_0);
   ObjectCreate(a_name_0, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(a_name_0, a_text_8, a_fontsize_28, "Arial", a_color_24);
   ObjectSet(a_name_0, OBJPROP_CORNER, 0);
   ObjectSet(a_name_0, OBJPROP_XDISTANCE, a_x_16);
   ObjectSet(a_name_0, OBJPROP_YDISTANCE, a_y_20);
}

void delObj() 
 {
  ObjectsDeleteAll(0, OBJ_LABEL);
   
}