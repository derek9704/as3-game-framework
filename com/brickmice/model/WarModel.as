package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class WarModel
	{	
		
		public function getWarAlarmData(callBack:Function) : void
		{
			var obj : Object = {"action":"getWarAlarmData", "args":{}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function houseWar(pid:int, hid:int, train:Array, callBack:Function) : void
		{
			var obj : Object = {"action":"houseWar", "args":{"pid":pid, "hid":hid, "train":train}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function retreatWar(pid:int, hid:int, callBack:Function) : void
		{
			var obj : Object = {"action":"retreatWar", "args":{"pid":pid, "hid":hid}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function sendStartWarTroop(pid:int, hid:int, delay:int, train:Array, callBack:Function) : void
		{
			var obj : Object = {"action":"sendStartWarTroop", "args":{"pid":pid, "hid":hid, "delay":delay, "train":train}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function sendReinforceWarTroop(pid:int, hid:int, gid:int, train:Array, callBack:Function) : void
		{
			var obj : Object = {"action":"sendReinforceWarTroop", "args":{"pid":pid, "hid":hid, "gid":gid, "train":train}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function aimWarByBlueSun(pid:int, type:int, callBack:Function) : void
		{
			var obj : Object = {"action":"aimWarByBlueSun", "args":{"pid":pid, "type":type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
