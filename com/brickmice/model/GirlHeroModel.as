package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class GirlHeroModel
	{	
		public function fireGirlHero(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"fireGirlHero", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function inheritGirlHero(hid1:int, hid2:int, isPay:int, callBack:Function) : void
		{
			var obj : Object = {"action":"inheritGirlHero", "args":{"hid1":hid1, "hid2":hid2, "isPay":isPay}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function viewInheritGirlHero(hid1:int, hid2:int, isPay:int, callBack:Function) : void
		{
			var obj : Object = {"action":"viewInheritGirlHero", "args":{"hid1":hid1, "hid2":hid2, "isPay":isPay}};
			GameService.request([obj], function():void{
				callBack();
			});
		}

		public function learnGirlHeroLesson(hid:int, cid:int, pos:int, callBack:Function) : void
		{
			var obj : Object = {"action":"learnGirlHeroLesson", "args":{"hid":hid, "cid":cid, "pos":pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function removeGirlHeroLesson(hid:int, pos:int, callBack:Function) : void
		{
			var obj : Object = {"action":"removeGirlHeroLesson", "args":{"hid":hid, "pos":pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function replaceGirlHeroTalent(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"replaceGirlHeroTalent", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}	
		
		public function girlHeroInfo(hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"girlHeroInfo", "args":{"hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}	
		
		public function exchangeGirlTalent(type:int, hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"exchangeGirlTalent", "args":{"type":type, "hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}

		public function changeGirlHeroName(hid:int, name:String, callBack:Function) : void
		{
			var obj : Object = {"action":"changeGirlHeroName", "args":{"hid":hid, "name":name}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
