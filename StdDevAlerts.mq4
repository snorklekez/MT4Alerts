//+------------------------------------------------------------------+
//|                                                 StdDevAlerts.mq4 |
//|                                                       Nasty Nate |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Nasty Nate"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int StdDevPeriods=7;
input double StdDevValue = 0.0005; // checking above/below value
input int AlertTimer = 60; //time between alerts in seconds
input bool isUsingCrossover = false; //only send alerts if ADXValue crossed over
input bool isSendingNotes=false; //Send phone notifications

datetime TimeOne;
datetime TimeTwo;
double PriceOne;
double PriceTwo;
bool isHighLineCreated;
bool isLowLineCreated;
double low=99;
double high = 0;
datetime lastNote;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }

//+------------------------------------------------------------------+
//| Helper Functions                                                 |
//+------------------------------------------------------------------+

//this is br0ke
   void IdentifyConsolidations()
   {
      
      //Print("running function");
      int total=StdDevPeriods+1;
      int i = 1;
      double low = 99;
      double high = 0;
      datetime time1;
      datetime time2;
      double sD;
      //ObjectCreate(ChartID(),"Bottom "+ Time[i]),OBJ_ARROW_UP,0,Time[i],(Low[i]-0.001));
      for(int i;i<total;i++)
        {
         sD= iStdDev(NULL,0,StdDevPeriods,0,MODE_EMA,PRICE_CLOSE,i+1);
         //Print("stddev:" + sD);
         if(sD<=StdDevValue)
           {
            total++;
            time1 = Time[i];
            //Print(low + " vs " + Low[i]);
            if(Low[i+1]<low)
              {
              
               low = Low[i+1];
               Print(low);
               
              }
            if(High[i]>high)
              {
               high = High[i+1];
               
              }
              
           }
        }
        time2 = Time[1];
        if(!ObjectCreate(ChartID(),"Rectangle " + TimeToString(Time[i]),OBJ_RECTANGLE,0,time1,low,time2,high))
         {
         Print(GetLastError());
         }

        
        
   }
  

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      double curSd= iStdDev(NULL,0,StdDevPeriods,0,MODE_EMA,PRICE_CLOSE,1);
      double prevSd= iStdDev(NULL,0,StdDevPeriods,0,MODE_EMA,PRICE_CLOSE,2);
      //bool isFirstAnchorSet;
      //bool isSecondAnchorSet;
//---
      if(isUsingCrossover == true)
       {
       
        if(Time[1]!=lastNote && curSd>StdDevValue && prevSd<StdDevValue)
        {
         Alert("StdDev= " + NormalizeDouble(curSd,5));
         if(isSendingNotes==true)SendNotification("StdDev of prev close= " + NormalizeDouble(curSd,5));
         lastNote=Time[1];                
        }
         if(Time[1]!=lastNote && curSd<StdDevValue)
         {
            ObjectCreate(ChartID(),"Arrow "+ TimeToString(Time[1]),OBJ_ARROW_UP,0,Time[1],(Low[1]-0.001));            
            //Print("possible contraction sending alert");
            Alert("Consolidation. StdDev= " + NormalizeDouble(curSd,5));
            if(isSendingNotes==true)SendNotification("StdDev= " + NormalizeDouble(curSd,5));
            lastNote=Time[1];
         }
         
              
       }
       
     else if(Time[1]!=lastNote && curSd<StdDevValue)
     {
         Print("possible contraction sending alert");
         Alert("StdDev= " + NormalizeDouble(curSd,5));
         if(isSendingNotes==true)SendNotification("ADX= " + NormalizeDouble(curSd,5));
         lastNote=Time[1];
     }

   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
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
  }
   
  
//+------------------------------------------------------------------+
