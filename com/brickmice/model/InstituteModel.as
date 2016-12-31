package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class InstituteModel
	{			
		public function getInstituteData(callBack:Function) : void
		{
			var obj : Object = {"action":"getInstituteData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startInstituteStudy(type:int, callBack:Function) : void
		{
			var obj : Object = {"action":"startInstituteStudy", "args":{"type":type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function stopInstituteStudy(callBack:Function) : void
		{
			var obj : Object = {"action":"stopInstituteStudy", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function joinInstitute(ids:Array, callBack:Function) : void
		{
			var obj : Object = {"action":"joinInstitute", "args":{"ids":ids}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function quitInstitute(pos : int, callBack:Function) : void
		{
			var obj : Object = {"action":"quitInstitute", "args":{"pos":pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function startInstituteResearch(type:String, cid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"startInstituteResearch", "args":{"type":type, "cid":cid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function executeInstituteResearch(index : int, point:int, callBack:Function) : void
		{
			var obj : Object = {"action":"executeInstituteResearch", "args":{"index":index, "point":point}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
