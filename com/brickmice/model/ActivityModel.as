package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class ActivityModel
	{	
		public function finishExtraMoney(num:int, callBack:Function) : void
		{
			var obj : Object = {"action":"finishExtraMoney", "args":{num:num}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getLogonReward(callBack:Function) : void
		{
			var obj : Object = {"action":"getLogonReward", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getActivityData(callBack:Function) : void
		{
			var obj : Object = {"action":"getActivityData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getNotice(callBack:Function) : void
		{
			var obj : Object = {"action":"getNotice", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getShouChongData(callBack:Function) : void
		{
			var obj : Object = {"action":"getShouChongData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getShouChongReward(callBack:Function) : void
		{
			var obj : Object = {"action":"getShouChongReward", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getRenpinData(callBack:Function) : void
		{
			var obj : Object = {"action":"getRenpinData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function tryRenpin(type:int, callBack:Function) : void
		{
			var obj : Object = {"action":"tryRenpin", "args":{type:type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function renpinExchange(type:int, callBack:Function) : void
		{
			var obj : Object = {"action":"renpinExchange", "args":{type:type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getDailyGiftData(callBack:Function) : void
		{
			var obj : Object = {"action":"getDailyGiftData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getDailyChargeReward(type:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getDailyChargeReward", "args":{type:type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getDailyConsumeReward(type:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getDailyConsumeReward", "args":{type:type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getDailySocialReward(type:String, callBack:Function) : void
		{
			var obj : Object = {"action":"getDailySocialReward", "args":{type:type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function finishGuaji(callBack:Function) : void
		{
			var obj : Object = {"action":"finishGuaji"};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getGiftByCode(code:String) : void
		{
			var obj : Object = {"action":"getGiftByCode", "args":{"code":code}};
			GameService.request([obj], function():void{
			});
		}
	}
}
