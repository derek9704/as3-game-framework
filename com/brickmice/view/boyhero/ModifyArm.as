package com.brickmice.view.boyhero
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.framework.core.Message;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.ByteArray;

	public class ModifyArm extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "ModifyArm";
		
		private var _mc:MovieClip;
		private var _totalCarry:TextField;
		private var _totalWeight:TextField;
		private var _yesBtn:MovieClip;
		
		private var _armPanel : McList;
		private var _armItems : Vector.<DisplayObject>;
		private var _storagePanel : McList;
		private var _storageItems : Vector.<DisplayObject>;
		
		public function ModifyArm(data : Object, callback:Function)
		{
			_mc = new ResBoyHeroArmWindow;
			super(NAME, _mc);
			
			_totalCarry = _mc._totalCarry;
			_totalWeight = _mc._totalWeight;
			_yesBtn = _mc._yesBtn;
			
			new BmButton(_yesBtn, function() : void
			{
				var armArr:Array = [];
				for each(var o:ArmListItem in _armItems){
					armArr.push({'id': o.id, 'num':o.countNow});
				}
				ModelManager.boyHeroModel.modifyBoyHeroArm(data.id, armArr, function():void{
					callback();
					closeWindow();
				});
			});
			
			_totalCarry.text = (int(data.carry) - Consts.mouseWeight * data.currentTroop).toString();
			_totalWeight.text = (int(data.weight) - Consts.mouseWeight * data.currentTroop).toString();
			
			// 军需面板
			_armPanel = new McList(1, 6, 0, 2, 500, 19, false);
			addChildEx(_armPanel, 53, 89);
			// 仓库面板
			_storagePanel = new McList(1, 4, 0, 2, 484, 19, false);
			addChildEx(_storagePanel, 53, 250);
			
			// 生成显示的军需面板
			var items:Array = [];
			for each(var k:Object in data.arm) items.push(k);
			//按照物品等级排序
			items.sortOn("level", Array.NUMERIC|Array.DESCENDING);
			//生成条目
			_armItems = new Vector.<DisplayObject>;
			for each(var one:Object in items){
				var mc : ArmListItem = new ArmListItem(one, Data.data.storage.arm.items[one.id].num, delFunc, changeNumFunc, getLeftVolumn);
				_armItems.push(mc);
			}
			_armPanel.setItems(_armItems);
			
			// 生成显示的仓库面板
			items = [];
			//这里要用深复制，后面会修改里面数值
			var ba:ByteArray=new ByteArray();
			ba.writeObject(Data.data.storage.arm.items);
			ba.position=0;
			
			for each(var k2:Object in ba.readObject()) items.push(k2);
			//按照物品数量排序
			items.sortOn("num", Array.NUMERIC|Array.DESCENDING);
			//生成条目
			_storageItems = new Vector.<DisplayObject>;
			for each(var one2:Object in items){
				var mc2 : StorageArmListItem = new StorageArmListItem(one2, loadFunc);
				_storageItems.push(mc2);
			}
			_storagePanel.setItems(_storageItems);
			
			//新手指引
//			NewbieController.showNewBieBtn(35, 3, this, 521, 261, false, "添加一种军需");
		}
		
		public function delFunc(id:int):void
		{
			for (var i:int = 0; i<_armItems.length;  i++){
				if((_armItems[i] as ArmListItem).id == id) {
					_armItems.splice(i, 1);
					break;
				}
			}
			_armPanel.setItems(_armItems);
		}
		
		public function loadFunc(info:Object):void
		{
//			NewbieController.refreshNewBieBtn(35, 4);
			var count:int = 0;
			for each(var o:ArmListItem in _armItems){
				if(o.id == info.id) return;
				count++;
			}
			if(count >= 6) return;
			var sNum:int = info.num;
			info.num = 0;
			var mc : ArmListItem = new ArmListItem(info, sNum, delFunc, changeNumFunc, getLeftVolumn);
			_armItems.push(mc);
			_armPanel.setItems(_armItems);
		}
		
		public function changeNumFunc(id:int, count:int):void
		{
//			NewbieController.refreshNewBieBtn(35, 5);
			var weight:int = 0;
			for each(var o:ArmListItem in _armItems){
				weight += o.weight * o.countNow;
			}
			_totalWeight.text = weight.toString();
			//修改仓库数量
			for each(var o2:StorageArmListItem in _storageItems){
				if(o2.id == id) {
					o2.changeCount(count);
					return;
				}
			}
		}
		
		public function getLeftVolumn():int
		{
			return int(_totalCarry.text) - int(_totalWeight.text);
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_NEWBIE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_NEWBIE:
//					NewbieController.showNewBieBtn(35, 4, this, 515, 100, false, "输入数量或直接最大");
//					NewbieController.showNewBieBtn(35, 5, this, 491, 358, true, "确定后完成军需配备");
					break;
				default:
			}
		}	
	}
}