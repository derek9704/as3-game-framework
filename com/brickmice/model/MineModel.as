package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class MineModel
	{	
		public function upgradeMine(type : String, callBack:Function) : void
		{
			var obj : Object = {"action":"upgradeMine", "args":{"type":type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
