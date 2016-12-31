package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class SchoolModel
	{	
		public function upgradeSchool(callBack:Function) : void
		{
			var obj : Object = {"action":"upgradeSchool", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function getSchoolData(callBack:Function) : void
		{
			var obj : Object = {"action":"getSchoolData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startSchoolTraining(ids:Array, callBack:Function) : void
		{
			var obj : Object = {"action":"startSchoolTraining", "args":{"ids":ids}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function finishSchoolTraining(pos : int, hid : int, callBack:Function) : void
		{
			var obj : Object = {"action":"finishSchoolTraining", "args":{"pos":pos, "hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function confirmSchoolGoldenTraining(pos : int) : void
		{
			var obj : Object = {"action":"confirmSchoolGoldenTraining", "args":{"pos":pos}};
			GameService.request([obj]);
		}
	}
}
