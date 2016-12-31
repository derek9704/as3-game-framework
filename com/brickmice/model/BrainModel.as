package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class BrainModel
	{	
		public function receiveBrain(pos : int, callBack:Function) : void
		{
			var obj : Object = {"action":"receiveBrain", "args":{"pos":pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function transBrain(pos : int, callBack:Function) : void
		{
			var obj : Object = {"action":"transBrain", "args":{"pos":pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function transAllBrain(callBack:Function) : void
		{
			var obj : Object = {"action":"transAllBrain", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getBrainData(callBack:Function) : void
		{
			var obj : Object = {"action":"getBrainData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function confirmRefreshBrain(type : int) : void
		{
			var obj : Object = {"action":"confirmRefreshBrain", "args":{"type":type}};
			GameService.request([obj]);
		}
		
		public function refreshBrain(type : int, callBack:Function) : void
		{
			var obj : Object = {"action":"refreshBrain", "args":{"type":type, "isPay":0}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
