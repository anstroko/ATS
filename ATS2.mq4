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

extern string ���������1="�������� ���������� �������";
extern bool BuyTrade=true;
extern bool SellTrade=true;
extern int filtr=5;
extern int BodySize=0;
extern int CandleSize=0;
extern int OrdersToZero=5;
extern int TP=10;
extern double Profits=10;
extern double BonusDollar=1;
extern int Magic_Number=3213;
extern double Percent=25;
extern double CoeffNull=7;
extern int Lok=3;
extern double CritLot=0.5;
extern double CriticalLotsInTrade=5;
extern int BB=3;
extern int SS=3;
//extern double K=1.5;
extern double DinamicDepo=10000;
//extern bool DinamicLot=true;
//extern double MM=35000;
extern string ���������2="������ �������� ����������� ������� Buy/Sell";
extern double Level=20;

extern string ���������3="������ ������� Buy/Sell";
extern double Lot1=0.01;
extern double Lot2=0.02;
extern double CoefLot=1.6;
int B,S;
double Koef;
string Comments;
int ss;
int bb; 
double TP1;
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
bool SellLimitInTrade;
bool BuyLimitInTrade;
double BuyLimitPrice;
double SellLimitPrice;
int ReCountBuy;
int ReCountSell;
double ReBuyLots;
double ReSellLots;
double BuyLots;
double SellLots;
bool CloseLokB;
bool CloseLokS;
bool BuyGoToZero;
bool SellGoToZero;
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
      Alert("�������� ����!");
      Sleep(6000);return(0);
     }*/
 ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
ObjectSetText("label_object1","���������� ������� Buy="+CountBuy+";��������� ���="+DoubleToStr(TotalBLt,2)+";�������� Sell="+SellGoToZero,12,"Arial",Red);


ObjectCreate("label_object2",OBJ_LABEL,0,0,0);
ObjectSet("label_object2",OBJPROP_CORNER,4);
ObjectSet("label_object2",OBJPROP_XDISTANCE,10);
ObjectSet("label_object2",OBJPROP_YDISTANCE,30);
ObjectSetText("label_object2","���������� ������� Sell="+CountSell+";��������� ���="+DoubleToStr(TotalSlt,2)+";�������� Buy="+BuyGoToZero,12,"Arial",Red);
  /* 
ObjectCreate("label_object3",OBJ_LABEL,0,0,0);
ObjectSet("label_object3",OBJPROP_CORNER,4);
ObjectSet("label_object3",OBJPROP_XDISTANCE,10);
ObjectSet("label_object3",OBJPROP_YDISTANCE,50);
ObjectSetText("label_object3","������ ����� Buy="+SecondBuySeries+"; ������ ����� Buy="+ThirdBuySeries,12,"Arial",Red);
      
   
ObjectCreate("label_object4",OBJ_LABEL,0,0,0);
ObjectSet("label_object4",OBJPROP_CORNER,4);
ObjectSet("label_object4",OBJPROP_XDISTANCE,10);
ObjectSet("label_object4",OBJPROP_YDISTANCE,70);
ObjectSetText("label_object4","������ ����� Sell="+SecondSellSeries+"; ������ ����� Sell="+ThirdSellSeries,12,"Arial",Red);
         */
   
   
   
   ReCountBuy=0;ReCountSell=0;ReBuyLots=0;ReSellLots=0;bb=0;ss=0;SellGoToZero=false;BuyGoToZero=false;bb=0;ss=0;
   OrderProfits=0;
   //if (SecondBuySeries==true){bb=1;}if (ThirdBuySeries==true){bb=2;}if (SecondSellSeries==true){ss=1;}if (ThirdSellSeries==true){ss=2;}
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
            if(OrderType()==OP_BUY){OrderProfits=OrderProfits+OrderProfit();ReCountBuy=ReCountBuy+1;ReBuyLots=ReBuyLots+OrderLots(); if(((ReCountBuy)>=OrdersToZero)){BuyGoToZero=true;}}
            if(OrderType()==OP_SELL){OrderProfits=OrderProfits+OrderProfit();ReCountSell=ReCountSell+1;ReSellLots=ReSellLots+OrderLots();if(((ReCountSell)>=OrdersToZero)){SellGoToZero=true;}}
           }
        }
     }
     
//if ((ReCountBuy==0)&&(CountBuy!=0)){B=0;}    
//if ((ReCountSell==0)&&(CountSell!=0)){S=0;}   
if ((OrderProfits)>Profits*(AccountEquity()/DinamicDepo))
{        CloseAll();}
//�������� ������� ������� � 0
//if((ReCountBuy>Lok)&&((ReBuyLots<BuyLots) || (ReBuyLots>BuyLots))){Print("��������� ��������� � ������� buy,����������� �� � 0");CalculateTotalBuyTP();}
//if((ReCountSell>Lok)&&((ReSellLots<SellLots) || (ReSellLots>SellLots))){Print("��������� ��������� � ������� sell,����������� �� � 0");CalculateTotalSellTP();}


 SellOrdersProfit=0; BuyOrdersProfit=0; FirstBuyOrderProfit=0; FirstSellOrderProfit=0;SecondBuyOrderProfit=0; SecondSellOrderProfit=0;

/*
if (BuyGoToZero==true){


if (ReCountSell>1) {SearchFirstBuyOrder(); SearchLokSellOrdersProfit(); OrderSelect(Ticket, SELECT_BY_TICKET);FirstBuyOrderProfit=OrderProfit();if(FirstBuyOrderProfit!=0){
  if(OrderLots()*CoeffNull<ReSellLots){  if((SellOrdersProfit+FirstBuyOrderProfit)>BonusDollar*100){Print("��������� ������ ����� �� ������� � ������ �� �������");CloseFirstBuySellOrders();}}
  else {if((SellOrdersProfit+FirstBuyOrderProfit/2)>BonusDollar*100){Print("��������� �������� ������� ������ �� ������� � ������ �� �������");CloseMidFirstBuySellOrders();}}}
  }
  

}

                      
SellOrdersProfit=0; BuyOrdersProfit=0; FirstBuyOrderProfit=0; FirstSellOrderProfit=0;SecondBuyOrderProfit=0; SecondSellOrderProfit=0;                      
if (SellGoToZero==true){


if (ReCountBuy>1) {SearchFirstSellOrder();SearchLokBuyOrdersProfit();OrderSelect(Ticket, SELECT_BY_TICKET);FirstSellOrderProfit=OrderProfit();if(FirstSellOrderProfit!=0){
  if(OrderLots()*CoeffNull<ReBuyLots){ if((BuyOrdersProfit+FirstSellOrderProfit)>BonusDollar*100){Print("��������� ������ ����� �� ������� � ������ �� �������");CloseFirstSellBuyOrders();}}
  else{if((BuyOrdersProfit+FirstSellOrderProfit/2)>BonusDollar*100){Print("��������� ������ ����� �� ������� � ������ �� �������");CloseMidFirstSellBuyOrders();}}
  }}




}
 */
   CountBuy=0;CountSell=0;TotalSlt=0;TotalBLt=0;OrderSwaps=0;total=OrdersTotal();LastBuyPrice=0;LastSellPrice=0;BuyLots=0;SellLots=0;CloseLokB=false;CloseLokS=false;
   for(int i=0;i<total;i++)
     {
     
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(OrderSymbol()==Symbol()) 
           {
            if(OrderType()==OP_BUY){CountBuy=CountBuy+1;TotalBLt=TotalBLt+OrderLots();BuyLots=BuyLots+OrderLots();if((CountBuy>=OrdersToZero)){CloseLokB=true;}}
            if(OrderType()==OP_SELL){CountSell=CountSell+1;TotalSlt=TotalSlt+OrderLots();SellLots=SellLots+OrderLots();if((CountSell>=OrdersToZero)){CloseLokS=true;}}
            if((OrderType()==OP_SELL) || (OrderType()==OP_BUY)){OrderSwaps=OrderSwaps+OrderSwap();}
           }
        }
     }

//#�������� �������� �������
   if(CountBuy==0)
     {
      for(int iDel=OrdersTotal()-1; iDel>=0; iDel--)
        {
         if(!OrderSelect(iDel,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()==OP_BUYLIMIT) && (OrderMagicNumber()==Magic_Number)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("�������� ��������� ������",GetLastError());
              }
           }
        }
     }
   if(CountSell==0)
     {
      for(int iDelS=OrdersTotal()-1; iDelS>=0; iDelS--)
        {
         if(!OrderSelect(iDelS,SELECT_BY_POS,MODE_TRADES)) break;
         if((OrderType()==OP_SELLLIMIT) && (OrderMagicNumber()==Magic_Number)) if(IsTradeAllowed()) 
           {
            if(OrderDelete(OrderTicket())<0)
              {
               Alert("�������� ��������� ������",GetLastError());
              }
           }
        }
     }

        
 if(!isNewBar())return(0);
 if ((Minute()==15)&&(Hour()==0))
 {B=0;S=0;}

 //#���������� 2-��� buy
      if((CountBuy==1) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
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
            Print("��������� 2-� ����� Buy");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"12",Magic_Number,0,Blue)<0)
                 {Alert("�������� ������ � ",GetLastError()); }
                 if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
               
              }
           }
        }


      //#���������� 2-��� sell
      if((CountSell==1) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
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
            Print("��������� 2-� ����� Sell");
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"22",Magic_Number,0,Red)<0)
                 {Alert("�������� ������ � ",GetLastError()); }
                      if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }


           //#���������� 3-��� buy
      if((CountBuy==2) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
        
            Print("��������� 3-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
       
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"13",Magic_Number,0,Blue)<0)
                 {Alert("�������� ������ � ",GetLastError()); }
                 if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


     //#���������� 3-��� sell
      if((CountSell==2) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 3-� ����� Sell");
                 if (CountSell<=Lok){ Tp=Low[1]-filtr*k*Point-TP*k*Point;} else {Tp=NULL;}
                                if (CountBuy>=Lok){Koef=TotalBLt*Percent/100/Lot1;} else {Koef=1;}
        SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"23",Magic_Number,0,Red)<0)
                 {Alert("�������� ������ � ",GetLastError()); }
                     if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }

   //#���������� 4-��� buy
      if((CountBuy==3) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
           
            Print("��������� 4-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"14",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
  if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 4-���  sell
      if((CountSell==3) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
            
            Print("��������� 4-� ����� Sell");
    SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"24",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                      if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }


   //#���������� 5-��� buy
      if((CountBuy==4) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 5-� ����� Buy");
                SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"15",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
             if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


      //#���������� 5-���  sell
      if((CountSell==4) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         ;
            Print("��������� 5-� ����� Sell");
           SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
              if (CountSell<=Lok){ Tp=Low[1]-filtr*k*Point-TP*k*Point;} else {Tp=NULL;}
                             if (CountBuy>=Lok){Koef=TotalBLt*Percent/100/Lot1;} else {Koef=1;}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"25",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                   if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }

    //#���������� 6-��� buy
      if((CountBuy==5) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
        
            Print("��������� 6-� ����� Buy");
                  SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"16",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


     //#���������� 6-���  sell
      if((CountSell==5) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
            
            Print("��������� 6-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
                  
            
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"26",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                        if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }
    //#���������� 7-��� buy
      if((CountBuy==6) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            Print("��������� 7-� ����� Buy");
                 
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"17",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


   //#���������� 7-���  sell
      if((CountSell==6) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
           
            Print("��������� 7-� ����� Sell");
           SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
          
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"27",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                        if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }


     //#���������� 8-��� buy
      if((CountBuy==7) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
           
            Print("��������� 8-� ����� Buy");
               
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"18",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                 if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 8-��� sell
      if((CountSell==7) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
            
            Print("��������� 8-� ����� Sell");
            SearchLastSellLot();Lot=LastSellLot*CoefLot;
     
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"28",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                       if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }


//#���������� 9-��� buy
      if((CountBuy==8) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
           
            Print("��������� 9-� ����� Buy");
                    SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"19",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 9-��� sell
      if((CountSell==8) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
            
            Print("��������� 9-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"29",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                       if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
           }
        }

//#���������� 10-��� buy
      if((CountBuy==9) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 10-��� sell
      if((CountSell==9) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 10-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"210",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                      if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
         
         
         
         
     //#���������� 11-��� buy
      if((CountBuy==10) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==10) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                       if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
             
         
         
         
         
     //#���������� 11-��� buy
      if((CountBuy==11) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==11) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                      if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
             
             
                   
         
     //#���������� 11-��� buy
      if((CountBuy==12) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==12) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                        if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
             
                   
         
     //#���������� 11-��� buy
      if((CountBuy==13) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==13) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
                      if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
             
                   
         
     //#���������� 11-��� buy
      if((CountBuy==14) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==14) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                   
         
      //#���������� 11-��� buy
      if((CountBuy==15) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==15) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                 
                 
                      //#���������� 11-��� buy
      if((CountBuy==16) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==16) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                 
                      //#���������� 11-��� buy
      if((CountBuy==17) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==17) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                 
                      //#���������� 11-��� buy
      if((CountBuy==18) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==18) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                 
                      //#���������� 11-��� buy
      if((CountBuy==19) && (BuyTrade==true)&&(B<BB)&&((Close[1]-Open[1])>0))
        {
         SearchLastBuyPrice();

         if(Ask<(LastBuyPrice-Level*k*Point))
           {
            
            Print("��������� 10-� ����� Buy");
          SearchLastBuyLot();Lot=NormalizeDouble(LastBuyLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,"110",Magic_Number,0,Blue)<0)
                 {Alert("������ � ",GetLastError()); }
                if (CountBuy>=CountSell){CloseAllSell(); OpenFirstSellOrder();} B=B+1;
              }
           }
        }


//#���������� 11-��� sell
      if((CountSell==19) && (BuyTrade==true)&&(S<SS)&&((Open[1]-Close[1])>0))
        {
         SearchLastSellPrice();

         if(Bid>(LastSellPrice+Level*k*Point))
           {
         
            Print("��������� 11-� ����� Sell");
      SearchLastSellLot();Lot=NormalizeDouble(LastSellLot*CoefLot,2); if (Lot>(CritLot*(AccountBalance()/DinamicDepo))){Lot=CritLot*(AccountBalance()/DinamicDepo); NormalizeDouble(Lot,2);}
      
            if(IsTradeAllowed()) 
              {
               if(OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,"211",Magic_Number,0,Red)<0)
                 {Alert("������ � ",GetLastError()); }
               if (CountBuy<=CountSell){CloseAllBuy(); OpenFirstBuyOrder();} S=S+1;
              }
         }  }        
                         
         
         
         
         
         
//#�������� ������� ������ buy
   if( (BuyTrade==true)&&(CountBuy==0))
     {   NoDeleteBuyProfit=false; GoGoBuy=1;ZeroB1=false;ZeroB2=false;
    // if(SellGoToZero==true){ GoGoBuy=SellLots*Percent/100/Lot1/Lot1;NormalizeDouble(GoGoBuy,2); }    
               //if(SellGoToZero==false){NoDeleteBuyProfit=true;}
 Print("���������� ������� ������ �� ������� ");
//Tp=High[1]+filtr*k*Point+TP*k*Point;Comments="11";
 //if (CountSell>=Lok){Koef=TotalSlt*Percent/100/Lot1;} else {Koef=1;}
        StartMyLot();
            if (StartLot<=0.01){StartLot=0.01;}
      if(IsTradeAllowed()) 
        {
if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,StartLot,Ask,3*k,NULL,NULL,Comments,Magic_Number,0,Blue) < 0) 
      {Alert("������ �������� ������� � ", GetLastError()); }}
      }
        

     } 
//#�������� ������� ������ sell
   if( (SellTrade==true)&&(CountSell==0))
     {
      SearchLastSellPrice();

        NoDeleteSellProfit=false;
   //  if(BuyGoToZero==true){  GoGoSell=BuyLots*Percent/100/Lot1/Lot1;NormalizeDouble(GoGoSell,2); }    
               
     //    if(BuyGoToZero==false){NoDeleteSellProfit=true;}
Tp=Low[1]-filtr*k*Point-TP*k*Point;Comments="21";  
      Print("���������� ������� ������ �� �������");
      
         
                             if (CountBuy>=Lok){Koef=TotalBLt*Percent/100/Lot1;} else {Koef=1;}
                             Print (NormalizeDouble(Lot1*Koef,2));
                             StartMyLot();    if (StartLot<=0.01){StartLot=0.01;}
                           
      if(IsTradeAllowed()) 
        {
        
         if(OrderSend(Symbol(),OP_SELL,StartLot,Bid,3*k,NULL,NULL,Comments,Magic_Number,0,Red) < 0)
           {Alert("��������� ������",GetLastError()); }
        }
     }

   return(0);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
//#��簽簽繩繡簷 癡簷簾瓊簾璽簾瓊簾 簿簸簾繫癡簷� 簾簸瓣疇簸簾璽 穩� 簿簾礙籀簿礙籀

//#��簽簽繩繡簷 癡簷簾瓊簾璽簾瓊簾 簿簸簾繫癡簷� 簾簸瓣疇簸簾璽 穩� 簿簾礙籀簿礙籀
double CalculateTotalBuyTP()
  {
TPB=0;
   double BuyLots=0;
   double PriceB=0;
   int CountB=0;
   for(int ibuy2Result=0;ibuy2Result<OrdersTotal();ibuy2Result++)
     {
   
      if(OrderSelect(ibuy2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {PriceB=PriceB+OrderOpenPrice()*OrderLots();BuyLots=BuyLots+OrderLots();CountB=CountB+1;}
        }
     }
   if(CountB>0)
     {
      TPB=PriceB/BuyLots+TP*Point*k;
      for(int ibuy3Result=0;ibuy3Result<OrdersTotal();ibuy3Result++)
        { 
         if(OrderSelect(ibuy3Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
              {
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPB,0,Orange); 
              }
           }
        }
     }
   return(TPB);
  }  

double CalculateTotalBuyTPToZero()
  {
TPB=0;
   double BuyLots=0;
   double PriceB=0;
   int CountB=0;
   for(int ibuy2Result=0;ibuy2Result<OrdersTotal();ibuy2Result++)
     {
   
      if(OrderSelect(ibuy2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {PriceB=PriceB+OrderOpenPrice()*OrderLots();BuyLots=BuyLots+OrderLots();CountB=CountB+1;}
        }
     }
   if(CountB>0)
     {
      TPB=PriceB/BuyLots;
      for(int ibuy3Result=0;ibuy3Result<OrdersTotal();ibuy3Result++)
        { 
         if(OrderSelect(ibuy3Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) 
              {
               RefreshRates();
                    if ((CountB==1)&&(OrderTakeProfit()!=NULL)){break;}
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPB,0,Orange); 
              }
           }
        }
     }
   return(TPB);
  }

  

  
 double CalculateTotalSellTP()
  {
   TPS=0;
   int CountS=0;
   double PriceS=0;
   SellLots=0;
   for(int isell2Result=0;isell2Result<OrdersTotal();isell2Result++)
     {
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
      if(OrderSelect(isell2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {CountS=CountS+1;PriceS=PriceS+OrderOpenPrice()*OrderLots();SellLots=SellLots+OrderLots();}
        }
     }
   if(CountS>0)
     {
      TPS=PriceS/SellLots-TP*Point*k;
      for(int isell4Result=0;isell4Result<OrdersTotal();isell4Result++)
        { 
         if(OrderSelect(isell4Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) 
              {
               RefreshRates();
               if ((CountS==1)&&(OrderTakeProfit()!=NULL)){break;}
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPS,0,Orange); 
              }
           }
        }
     }
   return(TPS);
  } 


double CalculateTotalSellTPToZero()
  {
   TPS=0;
   int CountS=0;
   double PriceS=0;
   SellLots=0;
   for(int isell2Result=0;isell2Result<OrdersTotal();isell2Result++)
     {
     
      if(OrderSelect(isell2Result,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {CountS=CountS+1;PriceS=PriceS+OrderOpenPrice()*OrderLots();SellLots=SellLots+OrderLots();}
        }
     }
   if(CountS>0)
     {
      TPS=PriceS/SellLots;
      for(int isell4Result=0;isell4Result<OrdersTotal();isell4Result++)
        {
         if(OrderSelect(isell4Result,SELECT_BY_POS)==true)
           {
            if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) 
              {
               RefreshRates();
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),TPS,0,Orange); 
              }
           }
        }
     }
   return(TPS);
  } 
  

double SearchLastBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch=0;ibuySearch<OrdersTotal();ibuySearch++)
     {
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
      if(OrderSelect(ibuySearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY))
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
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
      if(OrderSelect(ibuySearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY))
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
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
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
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();LastSellLot=OrderLots();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();LastSellLot=OrderLots();}
           }
        }
     }
   return(LastSellLot);
  }


double SearchLastLimBuyPrice()
  {
   LastBuyPrice=0;
   for(int ibuySearch1=0;ibuySearch1<OrdersTotal();ibuySearch1++)
     {
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
      if(OrderSelect(ibuySearch1,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUYLIMIT))
           {
            if(LastBuyPrice==0){LastBuyPrice=OrderOpenPrice();}
            if(LastBuyPrice>OrderOpenPrice()){LastBuyPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastBuyPrice);
  }
//#�簾癡簽礙 簿簾簽禱疇瓣穩疇瓊簾 禱癡穫癡簷穩簾瓊簾 簾簸瓣疇簸� 穩� 簿簸簾瓣�疆籀
double SearchLastLimSellPrice()
  {
   LastSellPrice=0;
   
   for(int isellSearch1=0;isellSearch1<OrdersTotal();isellSearch1++)
     {
      // 簸疇癟籀禱羹簷�簷 璽羶獺簾簸� 簿簸簾璽疇簸礙癡, 簷�礙 礙�礙 簾簸瓣疇簸 穫簾疆疇簷 獺羶簷羹 癟�礙簸羶簷 癡禱癡 籀瓣�禱疇穩 璽 羸簷簾 璽簸疇穫藩!
      if(OrderSelect(isellSearch1,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELLLIMIT))
           {
            if(LastSellPrice==0){LastSellPrice=OrderOpenPrice();}
            if(LastSellPrice<OrderOpenPrice()){LastSellPrice=OrderOpenPrice();}
           }
        }
     }
   return(LastSellPrice);
  }
  double SearchFirstBuyOrder() {
   Ticket=0;
   FirstBuyPrice=0;
   for(int iFBSearch=0;iFBSearch<OrdersTotal();iFBSearch++)
     {
      if(OrderSelect(iFBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
            if(FirstBuyPrice==0){FirstBuyPrice=OrderOpenPrice();Ticket=OrderTicket();}
            if(FirstBuyPrice<OrderOpenPrice()){FirstBuyPrice=OrderOpenPrice();Ticket=OrderTicket();}
           }
        }
     }
   return(Ticket);
  }
    double SearchSecondBuyOrder() {
  
   double SecondBuyPrice=0;
   SearchFirstBuyOrder();
   OrderSelect(Ticket, SELECT_BY_TICKET); 
   FirstBuyPrice=OrderOpenPrice();
   for(int iFBSearch=0;iFBSearch<OrdersTotal();iFBSearch++)
     {
      if(OrderSelect(iFBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
            if((FirstBuyPrice>OrderOpenPrice())&&((SecondBuyPrice<OrderOpenPrice())||(SecondBuyPrice==0))){SecondBuyPrice=OrderOpenPrice();Ticket2=OrderTicket();}
     
           }
        }
     }
   return(Ticket2);
  }
    double SearchFirstSellOrder() {
   Ticket=0;
   FirstSellPrice=0;
   for(int iFSSearch=0;iFSSearch<OrdersTotal();iFSSearch++)
     {
      if(OrderSelect(iFSSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
            if(FirstSellPrice==0){FirstSellPrice=OrderOpenPrice();Ticket=OrderTicket();}
            if(FirstSellPrice>OrderOpenPrice()){FirstSellPrice=OrderOpenPrice();Ticket=OrderTicket();}
           }
        }
     }
   
   return(Ticket);
  }
  
double SearchSecondSellOrder() {
  
   double SecondSellPrice=0;
   SearchFirstSellOrder();
   OrderSelect(Ticket, SELECT_BY_TICKET); 
   FirstSellPrice=OrderOpenPrice();
   for(int iFBSearch=0;iFBSearch<OrdersTotal();iFBSearch++)
     {
      if(OrderSelect(iFBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
            if((FirstSellPrice<OrderOpenPrice())&&((SecondSellPrice>OrderOpenPrice())||(SecondSellPrice==0))){SecondSellPrice=OrderOpenPrice();Ticket2=OrderTicket();}
     
           }
        }
     }
   return(Ticket2);
  }
  
  
  
  double SearchLokBuyOrdersProfit() {
  BuyOrdersProfit=0;
  for(int iFBBSearch=0;iFBBSearch<OrdersTotal();iFBBSearch++)
     {
      if(OrderSelect(iFBBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
           BuyOrdersProfit=BuyOrdersProfit+OrderProfit();
           }
           }
        }
      return(BuyOrdersProfit);
  }
  
   double SearchLokSellOrdersProfit() {
  SellOrdersProfit=0;
  for(int iFBBSearch=0;iFBBSearch<OrdersTotal();iFBBSearch++)
     {
      if(OrderSelect(iFBBSearch,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (Magic_Number==OrderMagicNumber()))
           {
           SellOrdersProfit=SellOrdersProfit+OrderProfit();
           }
           }
        }
    
      return(SellOrdersProfit);
  } 
 double CloseFirstBuySellOrders()
  {
   SearchFirstBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET);   OrderClose(Ticket,OrderLots(),Bid,3*k,Black);
       
     for(int S=OrdersTotal();S>0;S--)
     {
    if(OrderSelect(S,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (Magic_Number==OrderMagicNumber())&&(OrderType()==OP_SELL))
           {
           OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
             
           }
        }
        }
        CalculateTotalBuyTP();
      return(0);
  } 
  
   double CloseMidFirstBuySellOrders()
  {
   SearchFirstBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET); double j=OrderLots()/2;  OrderClose(Ticket,j,Bid,3*k,Black);
       
     for(int S=OrdersTotal();S>0;S--)
     {
    if(OrderSelect(S,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (Magic_Number==OrderMagicNumber())&&(OrderType()==OP_SELL))
           {
           OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
             
           }
        }
        }
        CalculateTotalBuyTP();
      return(0);
  } 
 double CloseFirstSecondBuySellOrders()
  {
         SearchFirstBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET);   
         OrderClose(Ticket,OrderLots(),Bid,3*k,Black);
         SearchSecondBuyOrder();
         OrderSelect(Ticket, SELECT_BY_TICKET);   
         OrderClose(Ticket,OrderLots(),Bid,3*k,Black);     
     for(int S=OrdersTotal();S>0;S--)
     {
    if(OrderSelect(S,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (Magic_Number==OrderMagicNumber())&&(OrderType()==OP_SELL))
           {
           OrderClose(OrderTicket(),OrderLots(),Ask,3*k,Black);
             
           }
        }
        }
        CalculateTotalBuyTP();
      return(0);
  } 

   double CloseFirstSellBuyOrders()
  {
        SearchFirstSellOrder();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      OrderClose(Ticket,OrderLots(),Ask,3*k,Black);
    for(int SS=OrdersTotal();SS>0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);
           }
        }
        }

      CalculateTotalSellTP();
      return(0);
  } 
     double CloseMidFirstSellBuyOrders()
  {
        SearchFirstSellOrder();
      OrderSelect(Ticket, SELECT_BY_TICKET); double t=OrderLots()/2;
      OrderClose(Ticket,t,Ask,3*k,Black);
    for(int SS=OrdersTotal();SS>0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);
           }
        }
        }

      CalculateTotalSellTP();
      return(0);
  } 
   double CloseFirstSecondSellBuyOrders()
  {
        SearchFirstSellOrder();
      OrderSelect(Ticket, SELECT_BY_TICKET); 
      OrderClose(Ticket,OrderLots(),Ask,3*k,Black);
        SearchSecondSellOrder();
      OrderSelect(Ticket2, SELECT_BY_TICKET); 
      OrderClose(Ticket2,OrderLots(),Ask,3*k,Black);
    for(int SS=OrdersTotal();SS>0;SS--)
     {
      if(OrderSelect(SS,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (Magic_Number==OrderMagicNumber()))
           {
        OrderClose(OrderTicket(),OrderLots(),Bid,3*k,Black);
           }
        }
        }

      CalculateTotalSellTP();
      return(0);
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
        OrderClose(OrderTicket(),OrderLots(),Bid,10*k,Black);
           }
        }
        }
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
        OrderClose(OrderTicket(),OrderLots(),Bid,10*k,Black);
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
        OrderClose(OrderTicket(),OrderLots(),Bid,10*k,Black);
           }
        }
        
        }S=0;
      return(0);
  }
  
  
  double DeleteAllStopOrders (){
  

  for (int i=OrdersTotal()-1; i>=0; i--)
   {
      if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_BUY  )&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("������ �������� ������ � ", GetLastError()); 
      }  
            }
      if ((OrderType()==OP_SELL )&&(OrderMagicNumber() == Magic_Number )) if (IsTradeAllowed()){if (OrderDelete(OrderTicket())<0)
           { 
        Alert("������ �������� ������ � ", GetLastError()); 
      } 
      }
         } 
         return(0);}
  double BuySTOPDel()
{for (int iDel1=OrdersTotal()-1; iDel1>=0; iDel1--)
   {
      if (!OrderSelect(iDel1,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_BUY)&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("������ �������� ������ � ", GetLastError()); 
      }  
            }
} return(0);}

double SellSTOPDel()
{for (int iDel2=OrdersTotal()-1; iDel2>=0; iDel2--)
   {
      if (!OrderSelect(iDel2,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_SELL)&&(OrderMagicNumber() == Magic_Number ))    if (IsTradeAllowed()) { if (OrderDelete(OrderTicket())<0) 
            { 
        Alert("������ �������� ������ � ", GetLastError()); 
      }  
            }
} return(0);}


    double DeleteBuyTakeProfit() {

   for(int ibb=0;ibb<OrdersTotal();ibb++)
     {
      if(OrderSelect(ibb,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)&& (OrderTakeProfit()!=NULL)&& (Magic_Number==OrderMagicNumber()))
           {
          Print("������� ������ ������� ������");   OrderModify(OrderTicket(),OrderOpenPrice(),NULL,NULL,0,Orange); 
           }
        }
     }
   
   return(0);
  }

    double DeleteSellTakeProfit() {

   for(int iss=0;iss<OrdersTotal();iss++)
     {
      if(OrderSelect(iss,SELECT_BY_POS)==true)
        {
         if(( OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)&& (OrderTakeProfit()!=NULL)&& (Magic_Number==OrderMagicNumber()))
           {
            Print("������� ������ ������� ������");   OrderModify(OrderTicket(),OrderOpenPrice(),NULL,NULL,0,Orange); 
           }
        }
     }
   
   return(0);
  }
  
  double OpenFirstBuyOrder(){
    StartMyLot();
    if (StartLot<=0.01){StartLot=0.01;}
   if(IsTradeAllowed()) 
        {
        
        Lot=TotalSlt*Percent/100;
if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,NormalizeDouble(StartLot,2),Ask,3*k,NULL,NULL,Comments,Magic_Number,0,Blue) < 0) 
      {Alert("������ �������� ������� � ", GetLastError()); }}
      }
        


  return(0);}



 double OpenFirstSellOrder(){
    StartMyLot();
        if (StartLot<=0.01){StartLot=0.01;}
      if(IsTradeAllowed()) 
        {     Lot=TotalBLt*Percent/100;
         if(OrderSend(Symbol(),OP_SELL,NormalizeDouble(StartLot,2),Bid,3*k,NULL,NULL,Comments,Magic_Number,0,Red) < 0)
           {Alert("��������� ������",GetLastError()); }
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
//---- �簾癟璽簸�羅�疇簷 礙簾禱癡繩疇簽簷璽簾 簾簸瓣疇簸簾璽 籀礙�癟�穩穩簾瓊簾 簷癡簿� 簾簸瓣疇簸簾璽 ----//
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
