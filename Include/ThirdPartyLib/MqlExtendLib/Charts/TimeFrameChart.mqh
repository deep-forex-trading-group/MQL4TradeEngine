//+------------------------------------------------------------------+
//| Module: Charts/TimeFrameChart.mqh                                |
//+------------------------------------------------------------------+
#property strict

#include "../History/TimeFrame.mqh"
#include "../Utils/HistoryFile.mqh"
//+------------------------------------------------------------------+
//| TimeFrame chart for saving to history file (offline charts)      |
//| Used to create arbituary time frame charts                       |
//+------------------------------------------------------------------+
class TimeFrameChart: public TimeFrame
  {
private:
   HistoryFile       m_file;
public:
                     TimeFrameChart(string symbol,int period)
   :TimeFrame(symbol,period),m_file(symbol,period)
     {
      if(m_file.truncate() && m_file.open())
         m_file.writeHeader();
      else
         Alert(StringFormat(">>> Error opening the history data for symbol %s and period %d",symbol,period));
     }

   static void       FillRate(MqlRates &rate,int i,const datetime &time[],
                              double const &open[],double const &high[],
                              double const &low[],double const &close[],
                              long const &tickVolume[],const long &realVolume[],
                              const int &spread[])
     {
      rate.time=time[i];
      rate.open=open[i];
      rate.high=high[i];
      rate.low=low[i];
      rate.close=close[i];
      rate.tick_volume=tickVolume[i];
      rate.real_volume=realVolume[i];
      rate.spread=spread[i];
     }

   void              onNewBar(int total,int newBars,const datetime &time[],
                              double const &open[],double const &high[],
                              double const &low[],double const &close[],
                              long const &tickVolume[],const long &realVolume[],
                              const int &spread[])
     {
      MqlRates rate;
      if(newBars==0)
        {
         FillRate(rate,total-1,time,open,high,low,close,tickVolume,realVolume,spread);
         m_file.updateRecord(rate);
        }
      else
        {
         for(int i=total-newBars;i<total;i++)
           {
            FillRate(rate,i,time,open,high,low,close,tickVolume,realVolume,spread);
            m_file.writeRecord(rate);
           }
        }
      m_file.flush();
     }
  };
//+------------------------------------------------------------------+
