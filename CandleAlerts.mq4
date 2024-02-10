//+------------------------------------------------------------------+
//|                                                 CandleAlerts.mq4 |
//|                                                       Nasty Nate |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Nasty Nate"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int BearLookback=4;
input int BullLookback=4;
//input int AlertTimer = 60; //time between alerts in seconds
input double DoujiTolerance = 10;
input bool isSendingNotes=false;
double low=9999;
double high = 0;
datetime lastNote;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   //EventSetTimer(60);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   //EventKillTimer();
   
  }

//+------------------------------------------------------------------+
//| Helper Functions                                                 |
//+------------------------------------------------------------------+

   bool isBullCandles(int lookBack)
   {
      int cnt;
      for(int i=0;i<lookBack;i++)
        {
         if(High[i+1]>High[i+2])
           {
            cnt++;
           }          
        }
        if(cnt == lookBack)
            {
            return true;
            }
        else return false;
   }
  
   bool isBearCandles(int lookBack)
   {
      int cnt;
      for(int i=0;i<lookBack;i++)
        {
         if(Low[i+1]<Low[i+2])
           {
            cnt++;
           }
         
        }
        if(cnt == lookBack)
          {
           return true;
          }
          else return false;
   }


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      double lastOpen = Open[1];
      double lastClose= Close[1];
      
      //bool isFirstAnchorSet;
      //bool isSecondAnchorSet;
//---
  if(isBullCandles(BullLookback))
            {
            if(Time[1]!=lastNote && MathAbs(lastOpen-lastClose)<=DoujiTolerance*Point)
               {
               Alert("Douji after BULL trend");
               if(isSendingNotes==true)SendNotification("Douji after bull trend");
               ObjectCreate(ChartID(),"Arrow "+ TimeToString(Time[1]),OBJ_ARROW_UP,0,Time[1],(Low[1]-0.001)); 
               lastNote=Time[1];                              
               }
            }

   if(isBearCandles(BearLookback))
   {
               if(Time[1]!=lastNote && MathAbs(lastOpen-lastClose)<=DoujiTolerance*Point)
                {
                Alert("Douji after BEAR trend");
                if(isSendingNotes==true)SendNotification("Douji after BEAR trend");
                ObjectCreate(ChartID(),"Arrow "+ TimeToString(Time[1]),OBJ_ARROW_DOWN,0,Time[1],(High[1]+0.001)); 
                lastNote=Time[1];                              
                }
      
   }

   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
/*void OnTimer()
  {
      double curSd= iStdDev(NULL,0,StdDevPeriods,0,MODE_EMA,PRICE_CLOSE,0);
      double prevSd= iStdDev(NULL,0,StdDevPeriods,0,MODE_EMA,PRICE_CLOSE,1);
//---
      if(isUsingCrossover == true)
       {
        if(curSd>StdDevValue && prevSd<StdDevValue)
        {
         Print("possible contraction breakout sending alert");
         Alert("StdDev= " + NormalizeDouble(curSd,5));
         //SendNotification("ADX= " + NormalizeDouble(CurADX,5));
         if(curSd<StdDevValue)
         {
         Print("possible contraction sending alert");
         Alert("StdDev= " + NormalizeDouble(curSd,5));
         //SendNotification("ADX= " + NormalizeDouble(CurADX,5));
         ObjectCreate(ChartID(),"resistance " + DoubleToString(Time[0],8),OBJ_ARROW_CHECK,0,Time[0],Low[0]);
         }
        }
       }
     else if(curSd<StdDevValue)
     {
         Print("possible contraction sending alert");
         Alert("StdDev= " + NormalizeDouble(curSd,5));
         ObjectCreate(ChartID(),"resistance " + DoubleToString(Time[0],8),OBJ_ARROW_CHECK,0,Time[0],Low[0]);
         //SendNotification("ADX= " + NormalizeDouble(CurADX,5));
     }
  }*/
   
  