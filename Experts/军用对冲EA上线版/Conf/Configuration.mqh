struct Configuration
{
   // Magic Numbers
   int MagicNumberBuy;   
   int MagicNumberSell;

   Configuration() {
      MagicNumberBuy = 123456789;
      MagicNumberSell = 987654321;
   }

   ~Configuration() {}
};