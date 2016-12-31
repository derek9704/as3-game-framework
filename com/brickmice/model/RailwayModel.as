package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class RailwayModel
	{	
		public function upgradeRailway(callBack:Function) : void
		{
			var obj : Object = {"action":"upgradeRailway", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function upgradeRailwayTrain(pos : int, callBack:Function) : void
		{
			var obj : Object = {"action":"upgradeRailwayTrain", "args":{"pos":pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function confirmBuyRailwayTrain(num : int) : void
		{
			var obj : Object = {"action":"confirmBuyRailwayTrain", "args":{"num":num}};
			GameService.request([obj]);
		}
		
		public function getRailwayTraffic(callBack:Function) : void
		{
			var obj : Object = {"action":"getRailwayTraffic", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function confirmRailwayTeleport(id : int, type : String,  callBack:Function) : void
		{
			var obj : Object = {"action":"confirmRailwayTeleport", "args":{"type":type, "id":id}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
