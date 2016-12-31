package com.brickmice.view.boyhero
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McHeroSelect;
	import com.brickmice.view.component.McList;
	import com.framework.core.Message;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class BoyHeroChooseEquip extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BoyHeroChooseEquip";
		public static const PAGESIZE : uint = 10;
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _hid:int = 0;
		private var _index:int = -1;
		private var _pageCount:int = 1;
		private var _page : int = 1;	//当前页
		private var _itemArr:Array = [];
		
		public function BoyHeroChooseEquip(hid:int, type:String, callback:Function)
		{
			_mc = new ResBoyHeroChooseEquipWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			
			_hid = hid;
			_mc._way.mouseEnabled = true;
			
			switch(type)
			{
				case 'rod':
				{
					_mc._title.text = "选择权杖";
					_mc._way.htmlText = "<a href='event:#'>太阳的试炼</a>";
					_mc._way.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
						ControllerManager.solarController.showSolar();
					});
					break;
				}
				case 'chip':
				{
					_mc._title.text = "选择芯片";
					_mc._way.htmlText = "<a href='event:#'>太阳的试炼</a>";
					_mc._way.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
						ControllerManager.solarController.showSolar();
					});
					break;
				}
				case 'fly':
				{
					_mc._title.text = "选择飞行器";
					_mc._way.htmlText = "<a href='event:#'>太阳的试炼</a>";
					_mc._way.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
						ControllerManager.solarController.showSolar();
					});
					break;
				}
				case 'emblem':
				{
					_mc._title.text = "选择纹章";
					_mc._way.htmlText = "<a href='event:#'>星际联盟处购买</a>";
					_mc._way.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
						ControllerManager.guildController.showGuild('shop');
					});
					break;
				}
				case 'flag':
				{
					_mc._title.text = "选择战旗";
					_mc._way.htmlText = "<a href='event:#'>蓝色太阳教贸易基地里购买</a>";
					_mc._way.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
						ControllerManager.blueSunController.showBlueSun();
					});
					break;
				}
				case 'symbol':
				{
					_mc._title.text = "选择信物";
					_mc._way.htmlText = "<a href='event:#'>探索星际棋盘上的星球</a>";
					_mc._way.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
						ControllerManager.discoveryController.showDiscovery();
					});
					break;
				}
			}
			
			// 面板
			_panel = new McList(5, 2, 6, 8, 77, 118, true);
			addChildEx(_panel, 54, 78);
			
			new BmButton(_yesBtn, function():void{
				if(_index == -1) {
					closeWindow();
					return;
				}
				
				ModelManager.boyHeroModel.changeBoyHeroEquip(_hid, _index, function():void{
					NewbieController.refreshNewBieBtn(6, 8, true);
					NewbieController.refreshNewBieBtn(6, 11, true);
					callback();
					closeWindow();
				});
			});
			
			// 前页按钮
			new BmButton(_mc._prevBtn, function(event : MouseEvent) : void
			{
				_page--;
				setData();
			});
			
			//后页按钮
			new BmButton(_mc._nextBtn, function(event : MouseEvent) : void
			{
				_page++;
				setData();
			});
			
			// 获取相应类型的物品列表
			var items:Array = Data.data.bag.equip;
			for (var key : String in items)
			{
				if(!items[key]) continue;
				if(items[key].subtype == type){
					items[key]['index'] = key;
					_itemArr.push(items[key]);
				}
			}
			//按等级排下序
			_itemArr.sortOn("level", Array.DESCENDING | Array.NUMERIC);
			
			_pageCount = Math.ceil(_itemArr.length / PAGESIZE);
			
			setData();
			
			//新手指引
			NewbieController.showNewBieBtn(6, 6, this, 56, 184, true, "选择一把权杖");
			NewbieController.showNewBieBtn(6, 9, this, 56, 184, true, "选择一块芯片");
			NewbieController.showNewBieBtn(6, 12, this, 56, 184, true, "选择一架飞行器");
		}
		
		private function setData() : void
		{
			_index = -1;			
			// 格子数量
			var count:int = _itemArr.length;
			// 起始物品位置
			var start:int = (_page - 1) * PAGESIZE;
			// 结束物品位置
			var max:int = start + PAGESIZE > count ? count : start + PAGESIZE;
			
			UiUtils.setButtonEnable(_mc._prevBtn, _page > 1);
			UiUtils.setButtonEnable(_mc._nextBtn, _page < _pageCount);
			
			// 生成显示的物品列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有物品
			for (var i : int = start; i < max; i++)
			{
				var one:Object = _itemArr[i];
				var mc : McHeroSelect = new McHeroSelect(one.img, one.intensifyLevel, one.name, 0, false, true, true);
				// 设置tip
				TipHelper.setTip(mc, Trans.transTips(one));
				addClickEvent(mc, one);
				_items.push(mc);
			}
			
			_panel.setItems(_items);
		}	
		
		private function addClickEvent(mc:McHeroSelect, one:Object):void
		{
			mc.evts.addClick(function():void{
				NewbieController.refreshNewBieBtn(6, 7, true);
				NewbieController.refreshNewBieBtn(6, 10, true);
				NewbieController.refreshNewBieBtn(6, 13, true);
				//先将其他设为不选
				for each (var item:McHeroSelect in _items) 
				{
					item.selected = false;
				}
				mc.selected = true;
				
				_index = one.index;
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
					NewbieController.showNewBieBtn(6, 7, this, 389, 357, true, "确定装备");
					NewbieController.showNewBieBtn(6, 10, this, 389, 357, true, "确定装备");
					NewbieController.showNewBieBtn(6, 13, this, 389, 357, true, "确定装备");
					break;
				default:
			}
		}
	}
}