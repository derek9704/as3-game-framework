package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class BossModel
	{			
		
		public function getBossData(callBack:Function) : void
		{
			var obj : Object = {"action":"getBossData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startBossBattle(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"startBossBattle", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function confirmClearBossCD() : void
		{
			var obj : Object = {"action":"confirmClearBossCD", "args":{}};
			GameService.request([obj], function():void{
			});
		}
	}
}
