package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class StockModel
	{	
		
		public function getStockData(callBack:Function) : void
		{
			var obj : Object = {"action":"getStockData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function buyStock(id:int, price:int, num:int, callBack:Function) : void
		{
			var obj : Object = {"action":"buyStock", "args":{"id":id, "price":price, "num":num}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function sellStock(id:int, price:int, num:int, callBack:Function) : void
		{
			var obj : Object = {"action":"sellStock", "args":{"id":id, "price":price, "num":num}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
	}
}
