package com.brickmice.view.bluesun
{
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.framework.utils.KeyValue;
	import com.framework.utils.UiUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BlueSun extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BlueSun";
		public static const PAGESIZE : uint = 5;
		
		private var _mc:MovieClip;
		private var _prevBtn:MovieClip;
		private var _nextBtn:MovieClip;
		private var _num:TextField;
		private var _buyFlagTab:MovieClip;
		private var _buyArmTab:MovieClip;
		
		private var _item1:BlueSunSlot;
		private var _item2:BlueSunSlot;
		private var _item3:BlueSunSlot;
		private var _item4:BlueSunSlot;
		private var _item5:BlueSunSlot;
		private var _tabView : BmTabView;
		private var _page : int = 1;	//当前页
		private var _type:String = 'flag';
		
		public function BlueSun(data : Object)
		{
			_mc = new ResBlueSunWindow;
			super(NAME, _mc);
			
			_prevBtn = _mc._prevBtn;
			_nextBtn = _mc._nextBtn;
			_num = _mc._num;
			_buyFlagTab = _mc._buyFlagTab;
			_buyArmTab = _mc._buyArmTab;
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue('flag', _buyFlagTab), new KeyValue('arm', _buyArmTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				_type = id;
				_page = 1;
				setData();
			});
			
			_buyArmTab.visible = false;
			
			// 前页按钮
			new BmButton(_prevBtn, function(event : MouseEvent) : void
			{
				_page--;
				setData();
			});
			
			//后页按钮
			new BmButton(_nextBtn, function(event : MouseEvent) : void
			{
				_page++;
				setData();
			});
			
			_item1 = new BlueSunSlot;
			addChildEx(_item1, 44, 99);
			_item2 = new BlueSunSlot;
			addChildEx(_item2, 132, 99);
			_item3 = new BlueSunSlot;
			addChildEx(_item3, 220, 99);
			_item4 = new BlueSunSlot;
			addChildEx(_item4, 307, 99);
			_item5 = new BlueSunSlot;
			addChildEx(_item5, 395, 99);
			
			setData();
		}
		
		public function setData() : void
		{
			if(_type == 'flag'){
				var items:Array = Data.data.equipShop;
				// 格子数量
				var len:int = items.length;
				//页数
				var pageNum:int = Math.ceil(len / PAGESIZE);
				if(!pageNum) pageNum = 1;
				// 起始物品位置
				var start:int = (_page - 1) * PAGESIZE;
				
				// 结束物品位置
				var max:int = start + PAGESIZE;
				
				UiUtils.setButtonEnable(_prevBtn, _page > 1);
				UiUtils.setButtonEnable(_nextBtn, _page < pageNum);
				_num.text = _page + " / " + pageNum;
				
				var index:int = 1;
				// 遍历所有物品
				for (var i : int = start; i < max; i++)
				{
					if (i < len)
					{
						this['_item' + index].setItem(items[i]);
						this['_item' + index].visible = true;
					}
					else
					{
						this['_item' + index].visible = false;
					}
					index++;
				}
			}
		}
	}
}