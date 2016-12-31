package com.brickmice.model
{
	import com.brickmice.data.GameService;

	public class EquipModel
	{	
		
		public function buyEquip(id:int) : void
		{
			var obj : Object = {"action":"buyEquip", "args":{'id':id}};
			GameService.request([obj]);
		}
		
		public function buyEquipPoint():void
		{
			var obj:Object = {"action":"buyEquipPoint", "args":{}};
			GameService.request([obj]);
		}
		
		public function intensifyEquip(type:String, hid:int, pos:int, callBack:Function) : void
		{
			var obj : Object = {"action":"intensifyEquip", "args":{'type':type, 'hid':hid, 'pos':pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
		public function combineEquip(type:String, hid:int, pos:int, index:int, isPay:int, callBack:Function) : void
		{
			var obj : Object = {"action":"combineEquip", "args":{'type':type, 'hid':hid, 'pos':pos, 'index':index, 'isPay':isPay}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
		
	}
}
