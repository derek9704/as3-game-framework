package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class ChurchModel
	{	
		public function upgradeChurch(callBack:Function) : void
		{
			var obj : Object = {"action":"upgradeChurch", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getChurchData(callBack:Function) : void
		{
			var obj : Object = {"action":"getChurchData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function confirmChurchGoldenRevival(pos : int) : void
		{
			var obj : Object = {"action":"confirmChurchGoldenRevival", "args":{"pos":pos}};
			GameService.request([obj]);
		}
	}
}
