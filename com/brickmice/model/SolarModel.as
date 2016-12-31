package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class SolarModel
	{			
		
		public function buySolarPoint() : void
		{
			var obj : Object = {"action":"buySolarPoint", "args":{}};
			GameService.request([obj]);
		}
		
		public function getSolarDailyPrize() : void
		{
			var obj : Object = {"action":"getSolarDailyPrize", "args":{}};
			GameService.request([obj]);
		}
		
		public function getSolarData(gid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getSolarData", "args":{"gid":gid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getSolarLevelData(pid:int, level:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getSolarLevelData", "args":{"pid":pid, "level":level}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startSolarBattle(pid:int, level:int, hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"startSolarBattle", "args":{"pid":pid, "level":level, "hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getSolarChallengeData(pid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getSolarChallengeData", "args":{"pid":pid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startSolarChallengeBattle(pid:int, level:int, hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"startSolarChallengeBattle", "args":{"pid":pid, "level":level, "hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startSolarProxy(pid:int, level:int, hid:int, num:int, autoBuy:int, callBack:Function) : void
		{
			var obj : Object = {"action":"startSolarProxy", "args":{"pid":pid, "level":level, "hid":hid, "num":num, "aotoBuy":autoBuy}};
			GameService.request([obj], function():void{
				callBack();
			});
		}	
		
		public function exchangeSolarTalent(type:int, hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"exchangeSolarTalent", "args":{"type":type, "hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		
		
	}
}
