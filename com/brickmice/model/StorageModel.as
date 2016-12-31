package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class StorageModel
	{	
		public function upgradeStorage(type : String, callBack:Function) : void
		{
			var obj : Object = {"action":"upgradeStorage", "args":{"type":type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
