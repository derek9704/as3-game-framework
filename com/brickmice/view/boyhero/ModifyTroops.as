package com.brickmice.view.boyhero
{
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmInputBox;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.Message;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ModifyTroops extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "ModifyTroops";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _def:TextField;
		private var _maxBtn:MovieClip;
		private var _carry:TextField;
		private var _storageCount:TextField;
		private var _count:TextField;
		private var _closeBtn:MovieClip;
		private var _atk:TextField;
		private var _weight:TextField;
		private var _minBtn:MovieClip;
		private var _max:int;
		
		
		public function ModifyTroops(data : Object, callback:Function)
		{
			_mc = new ResBoyHeroModifyTroopsWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			_def = _mc._def;
			_carry = _mc._carry;
			_maxBtn = _mc._maxBtn;
			_storageCount = _mc._storageCount;
			_count = _mc._count;
			_closeBtn = _mc._closeBtn;
			_atk = _mc._atk;
			_weight = _mc._weight;
			_minBtn = _mc._minBtn;
			
			var storageCount:int;
			if(Data.data.storage.mouse.items)
				storageCount = Data.data.storage.mouse.items[Consts.ID_MOUSE].num;
			else
				storageCount = 0;
			var count:int = data.currentTroop;
			_max = storageCount+count;
			
			_storageCount.text = storageCount.toString();
			
			var input:BmInputBox = new BmInputBox(_count, count.toString(), -1, true, data.troopMax < _max ? data.troopMax : _max, 0);
			input.onNumChange = function(num:int):void{
//				NewbieController.refreshNewBieBtn(21, 4);
				setCount(num);
			};
			Main.self.stage.focus = _count;
			_count.setSelection(count.toString().length, count.toString().length);	
			
			setCount(count);
			
			new BmButton(_yesBtn, function() : void
			{
				ModelManager.boyHeroModel.modifyBoyHeroTroop(data.id, int(_count.text), function():void{
					NewbieController.refreshNewBieBtn(22, 6);
					NewbieController.refreshNewBieBtn(2, 8);
					NewbieController.refreshNewBieBtn(4, 10, true);
					callback();
					closeWindow();
				});
			});
			
			new BmButton(_minBtn, function() : void
			{
				setCount(0);
			});
			
			new BmButton(_maxBtn, function() : void
			{
//				NewbieController.refreshNewBieBtn(21, 4);
				NewbieController.refreshNewBieBtn(2, 7);
				NewbieController.refreshNewBieBtn(4, 9, true);
				NewbieController.refreshNewBieBtn(22, 5);
//				NewbieController.refreshNewBieBtn(39, 12, true);
				setCount(data.troopMax < _max ? data.troopMax : _max);
			});
			
//			NewbieController.showNewBieBtn(21, 3, this, 178, 142, false, "输入数字或直接最大");
			NewbieController.showNewBieBtn(2, 6, this, 178, 142, false, "将兵力调至最大");
			NewbieController.showNewBieBtn(4, 8, this, 178, 142, false, "将兵力调至最大");
			NewbieController.showNewBieBtn(22, 4, this, 178, 142, false, "将兵力调至最大");
//			NewbieController.showNewBieBtn(39, 11, this, 178, 142, false, "将兵力调至最大");
		}
		
		private function setCount(count:int):void
		{
			_count.text = count.toString();
			_storageCount.text = (_max - count).toString();
			
			if(Data.data.storage.mouse.items){
				var data:Object = Data.data.storage.mouse.items[Consts.ID_MOUSE];
				_atk.text = (data.attack * count).toString();
				_weight.text = (data.weight * count).toString();
				_def.text = (data.defense * count).toString();
				_carry.text = ((data.carry - Consts.mouseWeight) * count).toString();
			}
			else{
				_atk.text = "0";
				_weight.text = "0";
				_def.text = "0";
				_carry.text = "0";
			}
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
//					NewbieController.showNewBieBtn(21, 4, this, 120, 186, true, "完成配兵");
					NewbieController.showNewBieBtn(2, 7, this, 120, 186, true, "确认操作");
					NewbieController.showNewBieBtn(4, 9, this, 120, 186, true, "确认操作");
					NewbieController.showNewBieBtn(22, 5, this, 120, 186, true, "确认操作");
					break;
				default:
			}
		}	
	}
}