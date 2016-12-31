package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class ArenaModel
	{			
		
		public function getArenaData(callBack:Function) : void
		{
			var obj : Object = {"action":"getArenaData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function nextArenaRival(callBack:Function) : void
		{
			var obj : Object = {"action":"nextArenaRival", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function nextTeamArenaRival(callBack:Function) : void
		{
			var obj : Object = {"action":"nextTeamArenaRival", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startArenaBattle(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"startArenaBattle", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startTeamArenaBattle(callBack:Function) : void
		{
			var obj : Object = {"action":"startTeamArenaBattle", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getArenaHeroInfo(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getArenaHeroInfo", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function confirmClearArenaCD() : void
		{
			var obj : Object = {"action":"confirmClearArenaCD", "args":{}};
			GameService.request([obj], function():void{
			});
		}
	}
}
