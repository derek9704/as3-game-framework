package com.brickmice.view.solar
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McHeroSelect;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class SolarChooseBoyHero extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SolarChooseBoyHero";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _heroPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _hid:int = 0;
		
		public function SolarChooseBoyHero(hid:int, callback:Function)
		{
			_mc = new ResSolarChooseHeroWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			
			_hid = hid;
			
			// 员工面板
			_heroPanel = new McList(5, 2, 8, 11, 77, 118, true);
			addChildEx(_heroPanel, 49, 71);
			
			new BmButton(_yesBtn, function():void{
				if(!_hid) {
					closeWindow();
					return;
				}
				NewbieController.refreshNewBieBtn(4, 7);
				NewbieController.refreshNewBieBtn(5, 7);
				callback(_hid);
				closeWindow();
			});
			
			// 生成显示的员工列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有员工
			var data:Object = Data.data.boyHero;
			var heroArr:Array = [];
			for(var k:String in data) heroArr.push(data[k]);
			heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
			for each(var one:Object in heroArr) {
				var enabled:Boolean = (one.status == 'free');
				var selected:Boolean = one.id == _hid;
				var mc : McHeroSelect = new McHeroSelect(one.img, one.level, one.name, one.quality, selected, enabled, true);
				if(enabled) addClickHeroEvent(mc, one);
				_items.push(mc);
			}
			_heroPanel.setItems(_items);
			
			NewbieController.showNewBieBtn(4, 5, this, 57, 177, true, "选择试炼的噩梦鼠");
			NewbieController.showNewBieBtn(5, 5, this, 57, 177, true, "选择试炼的噩梦鼠");
		}
		
		private function addClickHeroEvent(mc:McHeroSelect, oh:Object):void
		{
			mc.evts.addClick(function():void{
				NewbieController.refreshNewBieBtn(4, 6);
				NewbieController.refreshNewBieBtn(5, 6);
				//先将其他设为不选
				for each (var item:McHeroSelect in _items) 
				{
					item.selected = false;
				}
				mc.selected = true;
				
				_hid = oh.id;
			});
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
					NewbieController.showNewBieBtn(4, 6, this, 391, 360, true, "确定选择");
					NewbieController.showNewBieBtn(5, 6, this, 391, 360, true, "确定选择");
					break;
				default:
			}
		}	
	}
}