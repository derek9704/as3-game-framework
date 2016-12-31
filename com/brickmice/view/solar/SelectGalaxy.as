package com.brickmice.view.solar
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McHeroSelect;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.framework.utils.FilterUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class SelectGalaxy extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SelectGalaxy";
		
		private var _mc:MovieClip;
		private var _closeBtn:MovieClip;
		private var _enterBtn:MovieClip;
		
		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _gid:int = 0;
		
		public function SelectGalaxy(gid:int, callback:Function)
		{
			_mc = new ResSolarSelectGalaxyWindow;
			super(NAME, _mc);
			
			_gid = gid;
			
			_enterBtn = _mc._enterBtn;
			new BmButton(_enterBtn, function():void{
				ModelManager.solarModel.getSolarData(_gid, function():void
				{
					callback(_gid);
					closeWindow();
				});
			});
			
			// 物品面板
			_itemPanel = new McList(5, 2, 8, 11, 77, 118, true);
			addChildEx(_itemPanel, 49, 71);
			
			setData();
		}
		
		public function setData() : void
		{
			var data:Object = Data.data.solar.galaxy;
			var openPlanet:int = Data.data.solar.openPlanet;
			var openGalaxy:int = Math.floor((openPlanet - 1) / 10) + 1;
			// 遍历所有星系
			_items = new Vector.<DisplayObject>;
			for (var i:int = 1; i <= 4; i++) 
			{
				var enabled:Boolean = i <= openGalaxy;
				var selected:Boolean = i == _gid;
				var mc : McHeroSelect = new McHeroSelect(data[i].img, 0, data[i].name, 0, selected, enabled, true);
				if(enabled) addClickGalaxyEvent(mc, i);
				_items.push(mc);
			}
			_itemPanel.setItems(_items);
		}
		
		private function addClickGalaxyEvent(mc:McHeroSelect, gid:int):void
		{
			mc.evts.addClick(function():void{
				//先将其他设为不选
				for each (var item:McHeroSelect in _items) 
				{
					item.selected = false;
				}
				mc.selected = true;
				
				_gid = gid;
			});
		}
		
	}
}