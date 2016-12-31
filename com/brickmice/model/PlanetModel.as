package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class PlanetModel
	{	
		
		public function getPlanetData(pid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getPlanetData", "args":{"pid":pid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getPlanetTipsData(pid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getPlanetTipsData", "args":{"pid":pid}};
			GameService.request([obj], function():void{
				callBack();
			}, null, false);
		}
		
		public function getPlanetTravelTime(fromPid:int, toPid:int, fromHome:int, toHome:int, hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getPlanetTravelTime", "args":{"fromPid":fromPid, "toPid":toPid, "fromHome":fromHome, "toHome":toHome, "hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getHouseHeroInfo(pid:int, page:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getHouseHeroInfo", "args":{"pid":pid, "page":page}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function buyPlanetStone(pid:int, stone:Array, train:Array, callBack:Function) : void
		{
			var obj : Object = {"action":"buyPlanetStone", "args":{"pid":pid, "stone":stone, "train":train}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function sellPlanetCheese(pid:int, cheese:Array, train:Array, callBack:Function) : void
		{
			var obj : Object = {"action":"sellPlanetCheese", "args":{"pid":pid, "cheese":cheese, "train":train}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function detectPlanet(pid:int, level:int, callBack:Function) : void
		{
			var obj : Object = {"action":"detectPlanet", "args":{"pid":pid, "level":level}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		
	}
}
