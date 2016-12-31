package com.brickmice.model
{
	import com.brickmice.data.GameService;

	/**
	 * 口袋数据提供模块
	 *
	 * @author derek
	 */
	public class BagModel
	{

		public function sortBag(type:String, callBack:Function):void
		{
			var obj:Object = {"action":"sortBag", "args":{type:type}};
			GameService.request([obj], function():void{
				callBack();
			});
		}

		public function useBagItem(pos:int, type:String, num:int, callBack:Function):void
		{
			var obj:Object = {"action":"useBagItem", "args":{pos:pos, type:type, num:num, flag:1}};
			GameService.request([obj], function():void{
				callBack();
			});
		}

		public function confirmUnlockBag(type:String, num:int):void
		{
			var obj:Object = {"action":"confirmUnlockBag", "args":{type:type, num:num}};
			GameService.request([obj]);
		}
		
		public function sellBagItem(type:String, pos:int, callBack:Function):void
		{
			var obj:Object = {"action":"sellBagItem", "args":{type:type, pos:pos}};
			GameService.request([obj], function():void{
				callBack();
			});
		}

		public function splitBagItem(type:String, num:int, from:int, to:int, callBack:Function):void
		{
			var obj:Object = {"action":"splitBagItem", "args":{type:type, num:num, from:from, to:to}};
			GameService.request([obj], function():void{
				callBack();
			});
		}
	}
}
