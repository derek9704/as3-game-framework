package com.brickmice.view.planet
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

	public class PlanetChooseBoyHero extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "PlanetChooseBoyHero";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _heroPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _hid:int = 0;
		private var _fromPid:int = 0;
		private var _toPid:int = 0;
		private var _fromHome:int = 0;
		private var _toHome:int = 0;
		
		public function PlanetChooseBoyHero(hid:int, fromPid:int, toPid:int, fromHome:int, toHome:int, callback:Function)
		{
			_mc = new ResPlanetChooseHeroWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			
			_hid = hid;
			_fromPid = fromPid;
			_toPid = toPid;
			_fromHome = fromHome;
			_toHome = toHome;
			
			// 员工面板
			_heroPanel = new McList(5, 2, 8, 11, 77, 118, true);
			addChildEx(_heroPanel, 49, 71);
			
			new BmButton(_yesBtn, function():void{
				if(!_hid) {
					closeWindow();
					return;
				}
				
				ModelManager.planetModel.getPlanetTravelTime(_fromPid, _toPid, _fromHome, _toHome, _hid, function():void{
					NewbieController.refreshNewBieBtn(22, 12);
					callback(_hid, Data.data.travelTime);
					closeWindow();
				});
			});
			
			// 生成显示的员工列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有员工
			var data:Object = Data.data.boyHero;
			var heroArr:Array = [];
			for(var k:String in data) heroArr.push(data[k]);
			heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
			for each(var one:Object in heroArr) {
				if(one.planet.id == _toPid) continue;
				var enabled:Boolean = (one.status == 'free' || one.status == 'house');
				var selected:Boolean = one.id == _hid;
				if(selected){
					if(one.planet.id){
						_fromPid = one.planet.id;
						_fromHome = 0;
					}else{
						_fromHome = 1;
					}
				}
				var mc : McHeroSelect = new McHeroSelect(one.img, one.level, one.name, one.quality, selected, enabled, true);
				if(enabled) addClickHeroEvent(mc, one);
				_items.push(mc);
			}
			_heroPanel.setItems(_items);
			
			//新手指引
			NewbieController.showNewBieBtn(22, 10, this, 133, 176, true, "选择空闲的噩梦鼠");
		}
		
		private function addClickHeroEvent(mc:McHeroSelect, oh:Object):void
		{
			mc.evts.addClick(function():void{
				NewbieController.refreshNewBieBtn(22, 11);
				//先将其他设为不选
				for each (var item:McHeroSelect in _items) 
				{
					item.selected = false;
				}
				mc.selected = true;
				
				_hid = oh.id;
				if(oh.planet.id){
					_fromPid = oh.planet.id;
					_fromHome = 0;
				}else{
					_fromHome = 1;
				}
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
					NewbieController.showNewBieBtn(22, 11, this, 388, 355, true, "确定选择");
					break;
				default:
			}
		}	
	}
}