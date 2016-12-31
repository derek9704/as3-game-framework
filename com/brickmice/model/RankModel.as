package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class RankModel
	{	
		public function getRankData(type:int, page:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getRankData", "args":{type:type, page:page}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getMyRankData(type:int, callBack:Function) : void
		{
			var obj : Object = {"action":"getMyRankData", "args":{type:type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
