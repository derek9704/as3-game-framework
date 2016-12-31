package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class TaskModel
	{	
		public function finishTask(id:int, callBack:Function) : void
		{
			var obj : Object = {"action":"finishTask", "args":{'id':id}};
			GameService.request([obj], callBack, callBack);
		}
	}
}
