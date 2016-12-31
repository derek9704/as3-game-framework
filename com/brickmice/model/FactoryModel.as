package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class FactoryModel
	{	
		public function upgradeFactory(type : String, callBack:Function) : void
		{
			var obj : Object = {"action":"upgradeFactory", "args":{"type":type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getFactoryData(type : String, callBack:Function) : void
		{
			var obj : Object = {"action":"getFactoryData", "args":{"type":type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startFactoryProduce(type:String, formulaId : int, formulaNum : int, callBack:Function) : void
		{
			var obj : Object = {"action":"startFactoryProduce", "args":{"type":type, "formulaId":formulaId, "formulaNum":formulaNum}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function confirmSpeedFactoryProduce(type : String) : void
		{
			var obj : Object = {"action":"confirmSpeedFactoryProduce", "args":{"type":type}};
			GameService.request([obj]);
		}
	}
}
