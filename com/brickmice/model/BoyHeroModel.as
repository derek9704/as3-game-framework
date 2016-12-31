package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class BoyHeroModel
	{	
		public function fireBoyHero(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"fireBoyHero", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function regenBoyHero(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"regenBoyHero", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function modifyBoyHeroTroop(hid:int, troop:int, callBack:Function) : void
		{
			var obj : Object = {"action":"modifyBoyHeroTroop", "args":{"hid":hid, "troop":troop}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function modifyBoyHeroArm(hid:int, arm:Array, callBack:Function) : void
		{
			var obj : Object = {"action":"modifyBoyHeroArm", "args":{"hid":hid, "arm":arm}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function changeBoyHeroEquip(hid:int, index:int, callBack:Function) : void
		{
			var obj : Object = {"action":"changeBoyHeroEquip", "args":{"hid":hid, "index":index}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function removeBoyHeroEquip(hid:int, pos:int, callBack:Function) : void
		{
			var obj : Object = {"action":"removeBoyHeroEquip", "args":{"hid":hid, "pos":pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function girlAimBoyHero(hid:int, gid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"girlAimBoyHero", "args":{"hid":hid, "gid":gid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function replaceBoyHeroTalent(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"replaceBoyHeroTalent", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function boyHeroInfo(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"boyHeroInfo", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}	
		
		
		public function addStarExp(hid:int) : void
		{
			var obj : Object = {"action":"addStarExp", "args":{"hid":hid}};
			GameService.request([obj], function():void{
			});
		}
		
		public function changeBoyHeroName(hid:int, name:String, callBack:Function) : void
		{
			var obj : Object = {"action":"changeBoyHeroName", "args":{"hid":hid, "name":name}};
			GameService.request([obj], function():void{
				callBack();
			});
		}

	}
}
