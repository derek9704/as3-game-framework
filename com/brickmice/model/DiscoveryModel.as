package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class DiscoveryModel
	{	
		
		public function getDiscoveryData(callBack:Function) : void
		{
			var obj : Object = {"action":"getDiscoveryData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function finishDiscovery(hid : int, callBack:Function) : void
		{
			var obj : Object = {"action":"finishDiscovery", "args":{"hid" : hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
