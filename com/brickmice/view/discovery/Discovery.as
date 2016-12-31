package com.brickmice.view.discovery
{
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Discovery extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Discovery";
		
		private var _mc:MovieClip;
		
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		
		public function Discovery(data : Object)
		{
			_mc = new ResDiscoveryWindow;
			super(NAME, _mc);
			
			setData();
			
			//新手指引
			NewbieController.showNewBieBtn(23, 2, this, 302, 94, false, "探索该星球");
		}
		
		public function setData() : void
		{
			// 面板
			_panel = new McList(1, 8, 0, 1, 256, 34, false);
			addChildEx(_panel, 40, 78);
			
			// 生成显示的面板
			_items = new Vector.<DisplayObject>;
			for each(var one:Object in Data.data.discovery){
				var mc : DiscoveryListItem = new DiscoveryListItem(one);
				_items.push(mc);
			}
			_panel.setItems(_items);
		}
	}
}