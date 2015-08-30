         //+------------------------------------------------------------------+
//|                                             SunExpert ver0.1.mq4 |
//|                                                Alexander Strokov |
//|                                    strokovalexander.fx@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Alexander Strokov"
#property link      "strokovalexander.fx@gmail.com"
#property version   "2.0"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

extern string Параметры1="Основные переменные ордеров";
extern bool BuyTrade=true;
extern bool SellTrade=true;
extern int TP=10;
extern double Profits=10;
extern int Magic_Number=3213;
extern double CritLot=0.5;
extern int TradeCountInDay=3;
extern double DinamicDepo=10000;
extern double Level=20;
extern double Lot1=0.01;
extern double CoefLot=1.6;
extern int SizeCandle=5;
int B,S;
double Koef;
string Comments;
int ss;
int bb; 
int k;
double StartLot;
double Lot;
double LastBuyLot;
double LastSellLot;
double GoGoBuy=1;
double GoGoSell=1;
bool StartBuyOrders;
bool StartSellOrders;
int CountBuy;
int CountSell;
double TotalSlt;
double TotalBLt;
double OrderSwaps;
double LastBuyPrice;
double LastSellPrice;
double TPB;
double TPS;
int total;
int ReCountBuy;
int ReCountSell;
double ReBuyLots;
double ReSellLots;
double BuyLots;
double SellLots;
double BuyOrdersProfit;
double SellOrdersProfit;
int NumSLimOrders;
int NumBLimOrders;
double FirstBuyOrderProfit;
double SecondBuyOrderProfit;
double FirstSellOrderProfit;
double SecondSellOrderProfit;
double FirstBuyPrice;
double FirstSellPrice;
bool NoDeleteBuyProfit;
bool NoDeleteSellProfit;
bool TradeWithTPB=false;
bool TradeWithTPS=false;
bool SecondSellSeries;
bool SecondBuySeries;
bool ThirdSellSeries;
bool ThirdBuySeries;
int Ticket;
int Ticket2;
bool ZeroS1;
bool ZeroS2;
bool ZeroB1;
bool ZeroB2;
bool OnlyToZeroBuy;
bool OnlyToZeroSell;
int DeGreeBuy;
int DeGreeSell;
double Tp;
double OrderProfits;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {

   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {

   ObjectDelete("label_object1");
   ObjectDelete("label_object2");
   ObjectDelete("label_object3");
   ObjectDelete("label_object4");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
 /*  if(IsDemo()==false) 
     {
      Alert("Неверный счет!");
      Sleep(6000);return(0);
     }*/
 ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
ObjectSetText("label_object1","Количество ордеров Buy="+CountBuy+";Торгуемый лот="+DoubleToStr(TotalBLt,2),12,"Arial",Red);


ObjectCreate("label_object2",OBJ_LABEL,0,0,0);
ObjectSet("label_object2",OBJPROP_CORNER,4);
ObjectSet("label_object2",OBJPROP_XDISTANCE,10);
ObjectSet("label_object2",OBJPROP_YDISTANCE,30);
ObjectSetText("label_object2","Количество ордеров Sell="+CountSell+";Торгуемый лот="+DoubleToStr(TotalSlt,2),12,"Arial",Red);
  /* 
ObjectCreate("label_object3",OBJ_LABEL,0,0,0);
ObjectSet("label_object3",OBJPROP_CORNER,4);
ObjectSet("label_object3",OBJPROP_XDISTANCE,10);
ObjectSet("label_object3",OBJPROP_YDISTANCE,50);
ObjectSetText("label_object3","Вторая серия Buy="+SecondBuySeries+"; Третья серия Buy="+ThirdBuySeries,12,"Arial",Red);
      
   
ObjectCreate("label_object4",OBJ_LABEL,0,0,0);
ObjectSet("label_object4",OBJPROP_CORNER,4);
ObjectSet("label_object4",OBJPROP_XDISTANCE,10);
ObjectSet("label_object4",OBJPROP_YDISTANCE,70);
ObjectSetText("label_object4","Вторая серия Sell="+SecondSellSeries+"; Третья серия Sell="+ThirdSellSeries,12,"Arial",Red);
         */
   
   
   
   ReCountBuy=0;ReCountSell=0;ReBuyLots=0;ReSellLots=0;
   OrderProfits=0;
   //if (SecondBuySeries==true){bb=1;}if (ThirdBuySeries==true){bb=2;}if (SecondSellSeries==true){ss=1;}if (ThirdSellSeries==true){ss=2;}
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
            if(OrderType()==OP_BUY){OrderProfits=OrderProfits+OrderProfit();ReCountBuy=ReCountBuy+1;ReBuyLots=ReBuyLots+OrderLots(); }
            if(OrderType()==OP_SELL){OrderProfits=OrderProfits+OrderProfit();ReCountSell=ReCountSell+1;ReSellLots=ReSellLots+OrderLots();}
           }
        }
     }
     
//if ((ReCountBuy==0)&&(CountBuy!=0)){B=0;}    
//if ((ReCountSell==0)&&(CountSell!=0)){S=0;}   
if ((OrderProfits)>Profits*(AccountEquity()/DinamicDepo))
{  Print ("Достигли общего профита = "+Profits*(AccountEquity()/DinamicDepo)+"; Закрываем все сделки");      CloseAll();}



   CountBuy=0;CountSell=0;TotalSlt=0;TotalBLt=0;OrderSwaps=0;total=OrdersTotal();LastBuyPrice=0;LastSellPrice=0;BuyLots=0;SellLots=0;
   for(int i=0;i<total;i++)
     {
     
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number)) 
           {
            if(OrderType()==OP_BUY){CountBuy=CountBuy+1;TotalBLt=TotalBLt+OrderLots();BuyLots=BuyLots+OrderLots();}
            if(OrderType()==OP_SELL){CountSell=CountSell+1;TotalSlt=TotalSlt+OrderLots();SellLots=SellLots+OrderLots();}
            if((OrderType()==OP_SELL) || (OrderType()==OP_BUY)){OrderSwaps=OrderSwaps+OrderSwap();}
           }
        }
     }




        
 if(!isNewBar())return(0);
 if ((Minute()==15)&&(Hour()==0))
 {B=0;S=0;}
//#Открытие первого ордера buy
   if( (BuyTrade==true)&&(CountBuy==0))
     {   NoDeleteBuyProfit=false; GoGoBuy=1;ZeroB1=false;ZeroB2=false;
    // if(SellGoToZero==true){ GoGoBuy=SellLots*Percent/100/Lot1/Lot1;NormalizeDouble(GoGoBuy,2); }    
               //if(SellGoToZero==false){NoDeleteBuyProfit=true;}
 Print("Размещение первого ордера на покупку "+Symbol());
//Tp=High[1]+filtr*k*Point+TP*k*Point;Comments="11";
 //if (CountSell>=Lok){Koef=TotalSlt*Percent/100/Lot1;} else {Koef=1;}
        StartMyLot();
            if (StartLot<=0.01){StartLot=0.01;}
      if(IsTradeAllowed()) 
        {
if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,StartLot,Ask,3*k,NULL,NULL,Comments,Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()); }}
      }
        

     } 
//#Открытие первого ордера sell
   if( (SellTrade==true)&&(CountSell==0))
     {
      SearchLastSellPrice();

        NoDeleteSellProfit=false;
   //  if(BuyGoToZero==true){  GoGoSell=BuyLots*Percent/100/Lot1/Lot1;NormalizeDouble(GoGoSell,2); }    
               
     //    if(BuyGoToZero==false){NoDeleteSellProfit=true;}
Comments="21";  
      Print("Размещение первого ордера на продажу "+Symbol());
      
         
                         
                         
                             StartMyLot();    if (StartLot<=0.01){StartLot=0.01;}
                           
      if(IsTradeAllowed()) 
        {
        
         if(OrderSend(Symbol(),OP_SELL,StartLot,Bid,3*k,NULL,NULL,Comments,Magic_Number,0,Red) < 0)
           {Alert("Произошла ошибка",GetLastError()); }
        }
     }
 //#Размещение 2-ого buy
      if((CountBuy==1) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         for(int ibuy=0;ibuy<OrdersTotal();ibuy++)
           {
         
            if(OrderSelect(ibuy,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
                 {
                  LastBuyPrice=OrderOpenPrice();
                 }
              }
           }
         if(Ask<(LastBuyPrice-Level*k*Point))
           {
           
 
           SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            Print("Открываем 2-й ордер Buy "+Symbol());
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"12",Magic_Number,0,Blue)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
                 if (CountBuy>=CountSell){Print("Закрываем все ордера Sell"+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
               
              }
           }
        }


      //#Размещение 2-ого sell
      if((CountSell==1) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         for(int isell=0;isell<OrdersTotal();isell++)
           {
           
            if(OrderSelect(isell,SELECT_BY_POS)==true)
              {
               if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
                 {LastSellPrice=OrderOpenPrice();}
              }
           }
         if(Bid>(LastSellPrice+Level*k*Point))
           {
              SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            Print("Открываем 2-й ордер Sell "+Symbol());
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"22",Magic_Number,0,Red)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
                      if (CountBuy<=CountSell){Print("Закрываем все ордера Buy"+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }


           //#Размещение 3-ого buy
      if((CountBuy==2) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
        
            Print("Открываем 3-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
       
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"13",Magic_Number,0,Blue)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
                 if (CountBuy>=CountSell){Print("Закрываем все ордера Sell"+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


     //#Размещение 3-ого sell
      if((CountSell==2) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 3-й ордер Sell "+Symbol());
            
                                
        SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"23",Magic_Number,0,Red)<0)
                 {Alert("Возникла ошибка № ",GetLastError()); }
                     if (CountBuy<=CountSell){Print("Закрываем все ордера Buy"+Symbol());Print("Закрываем все ордера Buy"+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }

   //#Размещение 4-ого buy
      if((CountBuy==3) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
           
            Print("Открываем 4-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"14",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
  if (CountBuy>=CountSell){Print("Закрываем все ордера Sell"+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 4-ого  sell
      if((CountSell==3) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
            
            Print("Открываем 4-й ордер Sell "+Symbol());
    SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"24",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                      if (CountBuy<=CountSell){Print("Закрываем все ордера Buy"+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }


   //#Размещение 5-ого buy
      if((CountBuy==4) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 5-й ордер Buy "+Symbol());
                SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"15",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
             if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


      //#Размещение 5-ого  sell
      if((CountSell==4) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         ;
            Print("Открываем 5-й ордер Sell "+Symbol());
           SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
             
                         
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"25",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                   if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }

    //#Размещение 6-ого buy
      if((CountBuy==5) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
        
            Print("Открываем 6-й ордер Buy "+Symbol());
                  SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"16",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


     //#Размещение 6-ого  sell
      if((CountSell==5) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
            
            Print("Открываем 6-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
                  
            
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"26",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                        if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }
    //#Размещение 7-ого buy
      if((CountBuy==6) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            Print("Открываем 7-й ордер Buy "+Symbol());
                 
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"17",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


   //#Размещение 7-ого  sell
      if((CountSell==6) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
           
            Print("Открываем 7-й ордер Sell "+Symbol());
           SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
          
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"27",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                        if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }


     //#Размещение 8-ого buy
      if((CountBuy==7) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
           
            Print("Открываем 8-й ордер Buy "+Symbol());
               
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"18",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                 if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 8-ого sell
      if((CountSell==7) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
            
            Print("Открываем 8-й ордер Sell "+Symbol());
            SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
     
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"28",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                       if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }


//#Размещение 9-ого buy
      if((CountBuy==8) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
           
            Print("Открываем 9-й ордер Buy "+Symbol());
                    SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"19",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 9-ого sell
      if((CountSell==8) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
            
            Print("Открываем 9-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"29",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                       if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }

//#Размещение 10-ого buy
      if((CountBuy==9) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 10-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 10-ого sell
      if((CountSell==9) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 10-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"210",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                      if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
         
         
         
         
     //#Размещение 11-ого buy
      if((CountBuy==10) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 11-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 11-ого sell
      if((CountSell==10) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 11-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                       if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
             
         
         
         
         
     //#Размещение 12-ого buy
      if((CountBuy==11) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 12-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 12-ого sell
      if((CountSell==11) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 12-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                      if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
             
             
                   
         
     //#Размещение 13-ого buy
      if((CountBuy==12) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 13-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 13-ого sell
      if((CountSell==12) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 13-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                        if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
             
                   
         
     //#Размещение 14-ого buy
      if((CountBuy==13) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 14-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 14-ого sell
      if((CountSell==13) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 14-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                      if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
             
                   
         
     //#Размещение 15-ого buy
      if((CountBuy==14) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 15-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 15-ого sell
      if((CountSell==14) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 15-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                   
         
      //#Размещение 16-ого buy
      if((CountBuy==15) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 16-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 16-ого sell
      if((CountSell==15) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 16-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                 
                 
                      //#Размещение 17-ого buy
      if((CountBuy==16) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 17-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 17-ого sell
      if((CountSell==16) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 17-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                 
                      //#Размещение 18-ого buy
      if((CountBuy==17) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 18-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 18-ого sell
      if((CountSell==17) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 18-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                 
                      //#Размещение 19-ого buy
      if((CountBuy==18) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 19-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 19-ого sell
      if((CountSell==18) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 19-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                 
                      //#Размещение 20-ого buy
      if((CountBuy==19) && (BuyTrade==true)&&(B<TradeCountInDay)&&((Close[1]-Open[1])>SizeCandle*k*Point))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("Открываем 20-й ордер Buy "+Symbol());
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("Ошибка № ",GetLastError()); }
                if (CountBuy>=CountSell){Print("Закрываем все ордера Sell "+Symbol());CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#Размещение 20-ого sell
      if((CountSell==19) && (BuyTrade==true)&&(S<TradeCountInDay)&&((Open[1]-Close[1])>SizeCandle*k*Point))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("Открываем 20-й ордер Sell "+Symbol());
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("Ошибка № ",GetLastError()); }
               if (CountBuy<=CountSell){Print("Закрываем все ордера Buy "+Symbol());CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                  

   return(0);
  }
  
double SearchLastBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // з°ёз–‡з™џз±Ђз¦±зѕ№з°·пїЅз°· з’Ѕзѕ¶зЌєз°ѕз°ёпїЅ з°їз°ёз°ѕз’Ѕз–‡з°ёз¤™з™Ў, з°·пїЅз¤™ з¤™пїЅз¤™ з°ѕз°ёз“Јз–‡з°ё з©«з°ѕз–†з–‡з°· зЌєзѕ¶з°·зѕ№ з™џпїЅз¤™з°ёзѕ¶з°· з™Ўз¦±з™Ў з±Ђз“ЈпїЅз¦±з–‡з©© з’Ѕ зѕёз°·з°ѕ з’Ѕз°ёз–‡з©«и—©!
      if(OrderSelect(ibuySearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) && (OrderType()==OP_BUY))
           {
            if(LastBuyPrice==0){LastBuyPrice=OrderOpenPrice();}
            if(LastBuyPrice>OrderOpenPrice()){LastBuyPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastBuyPrice);
  }
  
  double SearchLastBuyLot()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // з°ёз–‡з™џз±Ђз¦±зѕ№з°·пїЅз°· з’Ѕзѕ¶зЌєз°ѕз°ёпїЅ з°їз°ёз°ѕз’Ѕз–‡з°ёз¤™з™Ў, з°·пїЅз¤™ з¤™пїЅз¤™ з°ѕз°ёз“Јз–‡з°ё з©«з°ѕз–†з–‡з°· зЌєзѕ¶з°·зѕ№ з™џпїЅз¤™з°ёзѕ¶з°· з™Ўз¦±з™Ў з±Ђз“ЈпїЅз¦±з–‡з©© з’Ѕ зѕёз°·з°ѕ з’Ѕз°ёз–‡з©«и—©!
      if(OrderSelect(ibuySearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number)&& (OrderType()==OP_BUY))
           {
            if(LastBuyPrice==0){LastBuyPrice=OrderOpenPrice();LastBuyLot=OrderLots();}
            if(LastBuyPrice>OrderOpenPrice()){LastBuyPrice=OrderOpenPrice();LastBuyLot=OrderLots();}
           }
        }
     }
   return(LastBuyLot);
  }
  
  
  
  

double SearchLastSellPrice()
  {
   LastSellPrice=0;
   for(int isellSearch=0;isellSearch<OrdersTotal();isellSearch++)
     {
      if(OrderSelect(isellSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) && (OrderType()==OP_SELL))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastSellPrice);
  }

double SearchLastSellLot()
  {
   LastSellPrice=0;
   for(int isellSearch=0;isellSearch<OrdersTotal();isellSearch++)
     {
      if(OrderSelect(isellSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) && (OrderType()==OP_SELL))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();LastSellLot=OrderLots();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();LastSellLot=OrderLots();}
           }
        }
     }
   return(LastSellLot);
  }



  

  
  double StartMyLot(){
  
    StartLot=AccountEquity()/DinamicDepo*Lot1;
    
    return(StartLot);
    }
  
  double CloseAll()
  {
       
    for(int SS1=OrdersTotal();SS1>=0;SS1--)
     {
      if(OrderSelect(SS1,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&& (Magic_Number==OrderMagicNumber()))
           {
           if (OrderType()==OP_BUY){   if (OrderClose(OrderTicket(),OrderLots(),Bid,10*k,Black)<0){CloseAll();}}
           if (OrderType()==OP_SELL){   if (OrderClose(OrderTicket(),OrderLots(),Ask,10*k,Black)<0){CloseAll();}}
     
           }
        }
        }S=0;B=0;
      return(0);
  }
  
  
    double CloseAllBuy()
  {
       
    for(int SS1=OrdersTotal();SS1>=0;SS1--)
     {
      if(OrderSelect(SS1,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&&( OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
        if (OrderClose(OrderTicket(),OrderLots(),Bid,10*k,Black)<0) {Sleep (2000);CloseAllBuy();}
           }
        }
        }B=0;
      return(0);
  }
  
      double CloseAllSell()
  {
       
    for(int SS1=OrdersTotal();SS1>=0;SS1--)
     {
      if(OrderSelect(SS1,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol())&&( OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
        if (OrderClose(OrderTicket(),OrderLots(),Ask,10*k,Black)<0){Sleep (2000);CloseAllSell();}
           }
        }
        
        }S=0;
      return(0);
  }
  

  
  double OpenFirstBuyOrder(){
    StartMyLot();
    if (StartLot<=0.01){StartLot=0.01;}
   if(IsTradeAllowed()) 
        {
        
    
if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,NormalizeDouble(StartLot,2),Ask,3*k,NULL,NULL,Comments,Magic_Number,0,Blue) < 0) 
      {Alert("Ошибка открытия позиции № ", GetLastError()); }}
      }
        


  return(0);}



 double OpenFirstSellOrder(){
    StartMyLot();
        if (StartLot<=0.01){StartLot=0.01;}
      if(IsTradeAllowed()) 
        {    
         if(OrderSend(Symbol(),OP_SELL,NormalizeDouble(StartLot,2),Bid,3*k,NULL,NULL,Comments,Magic_Number,0,Red) < 0)
           {Alert("Произошла ошибка",GetLastError()); }
        }
    return(0); }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar()
  {
   static datetime BarTime;
   bool res=false;

   if(BarTime!=Time[0])
     {
      BarTime=Time[0];
      res=true;
     }
   return(res);
  }
//---- пїЅз°ѕз™џз’Ѕз°ёпїЅзѕ…пїЅз–‡з°· з¤™з°ѕз¦±з™Ўз№©з–‡з°Ѕз°·з’Ѕз°ѕ з°ѕз°ёз“Јз–‡з°ёз°ѕз’Ѕ з±Ђз¤™пїЅз™џпїЅз©©з©©з°ѕз“Љз°ѕ з°·з™Ўз°їпїЅ з°ѕз°ёз“Јз–‡з°ёз°ѕз’Ѕ ----//
int Orders_Total_by_type(int type,int mn,string sym)
  {
   int num_orders=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber()==mn && type==OrderType() && sym==OrderSymbol())
         num_orders++;
     }
   return(num_orders);
  }
//+------------------------------------------------------------------+
