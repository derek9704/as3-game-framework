package com.brickmice.view.boyhero
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McHeroSelect;
	import com.brickmice.view.component.McList;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class BoyHeroChooseGirl extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BoyHeroChooseGirl";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _heroPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _gid:int = 0;
		
		public function BoyHeroChooseGirl(gid:int, hid:int, callback:Function)
		{
			_mc = new ResBoyHeroChooseGirlWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			
			_gid = gid;
			
			// 员工面板
			_heroPanel = new McList(5, 2, 8, 11, 77, 118, true);
			addChildEx(_heroPanel, 49, 71);
			
			new BmButton(_yesBtn, function():void{
				if(!_gid || _gid == gid) {
					closeWindow();
					return;
				}
				ModelManager.boyHeroModel.girlAimBoyHero(hid, _gid, function():void{
					callback();
					closeWindow();
				});
			});
			
			// 生成显示的员工列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有员工
			var data:Object = Data.data.girlHero;
			var heroArr:Array = [];
			for(var k:String in data) heroArr.push(data[k]);
			heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
			for each(var one:Object in heroArr) {
				var enabled:Boolean = one.status == 'free' || one.boyHero == hid;
				var selected:Boolean = one.id == _gid;
				var mc : McHeroSelect = new McHeroSelect(one.img, one.level, one.name, one.quality, selected, enabled, true);
				if(enabled) addClickHeroEvent(mc, one);
				_items.push(mc);
			}
			_heroPanel.setItems(_items);
		}
		
		private function addClickHeroEvent(mc:McHeroSelect, oh:Object):void
		{
			mc.evts.addClick(function():void{
				//先将其他设为不选
				for each (var item:McHeroSelect in _items) 
				{
					item.selected = false;
				}
				mc.selected = true;
				_gid = oh.id;
			});
		}
	}
}