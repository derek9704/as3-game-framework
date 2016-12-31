package com.brickmice.view.planet
{
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McTrainSelect;
	import com.framework.core.Message;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ChooseTrain extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "ChooseTrain";
		
		private var _mc:ResPlanetChooseTrainWindow;
		private var _yesBtn:MovieClip;
		private var _totalCarry:TextField;
		private var _totalWeight:TextField;
		
		private var _tweight:int;
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _ids:Array = [];
		
		public function ChooseTrain(selectTrains:Array, totalWeight:int, callback:Function)
		{
			_ids = selectTrains;
			
			_mc = new ResPlanetChooseTrainWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			_totalCarry = _mc._totalCarry;
			_totalWeight = _mc._totalWeight;
			
			_tweight = totalWeight;
			_totalWeight.text = totalWeight.toString();
			
			// 面板
			_panel = new McList(5, 2, 11, 8, 75, 114, true);
			addChildEx(_panel, 50, 93);
			
			new BmButton(_yesBtn, function():void{
				callback(_ids);
				NewbieController.refreshNewBieBtn(26, 7);
//				NewbieController.refreshNewBieBtn(33, 7);
				closeWindow();
			});
			
			// 生成显示的列车列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历
			var trainArr:Array = Data.data.railway.trains;
			for (var index:String in trainArr) {
				var one:Object = trainArr[index];
				one.id = index;
				var enabled:Boolean = (one.status == 'free');
				var bool:Boolean = _ids.indexOf(parseInt(one.id)) >= 0;
				var selected:Boolean = bool;
				var mc : McTrainSelect = new McTrainSelect(one.img, one.level, one.carry, selected, enabled);
				if(enabled) addClickEvent(mc, one);
				_items.push(mc);
			}
			_panel.setItems(_items);
			
			calcValue();
			
			//新手指引
			NewbieController.showNewBieBtn(26, 5, this, 62, 196, true, "选择合适的列车");
//			NewbieController.showNewBieBtn(33, 5, this, 62, 196, true, "选择合适的列车");
		}
		
		private function addClickEvent(mc:McTrainSelect, one:Object):void
		{
			mc.evts.addClick(function():void{
				NewbieController.refreshNewBieBtn(26, 6);
//				NewbieController.refreshNewBieBtn(33, 6);
				if(!mc.selected){
					// 获取位置
					var index:int = _ids.indexOf(parseInt(one.id));
					// 如果在队列中.则移除之
					if (index >= 0)
						_ids.splice(index, 1);
				}else{
					_ids.push(parseInt(one.id));
				}
				calcValue();
			});
		}
		
		private function calcValue():void
		{
			var tcarry:int = 0;
			for each(var id:int in _ids){
				var one:Object = Data.data.railway.trains[id];
				tcarry += parseInt(one.carry);
			}
			_totalCarry.textColor = tcarry >= _tweight ? 0x89DC74 : 0xFF0000;
			_totalCarry.text = tcarry.toString();
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
					NewbieController.showNewBieBtn(26, 6, this, 393, 357, true, "确认所选的列车");
//					NewbieController.showNewBieBtn(33, 6, this, 393, 357, true, "确认选择");
					break;
				default:
			}
		}		
	}
}