package com.brickmice.view.bag
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author derek
	 */
	public class Bag extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Bag";
		public static const PLUS : String = 'plus';
		public static const EQUIP : String = 'equip';
		public static const PAGENUM : uint = 3;
		public static const PAGESIZE : uint = 18;

		private var _mc:MovieClip;
		private var _arrangBtn:MovieClip;
		private var _useBtn:MovieClip;
		private var _batchUseBtn:MovieClip;
		private var _othersTab:MovieClip;
		private var _prevBtn:MovieClip;
		private var _nextBtn:MovieClip;
		private var _closeBtn:MovieClip;
		private var _sellBtn:MovieClip;
		private var _equipmentTab:MovieClip;
		private var _title:TextField;
		
		private var _type:String;
		private var _chooseItemPos : int = -1;
		private var _itemPanel : McList;
		private var _tabView : BmTabView;
		private var _page : int = 1;	//当前页
		private var _items : Vector.<DisplayObject>;
		
		public function Bag(data : Object)
		{
			_type = data.type;
			
			_mc = new ResBagWindow;
			super(NAME, _mc);
			
			_arrangBtn = _mc._arrangBtn;
			_useBtn = _mc._useBtn;
			_batchUseBtn = _mc._batchUseBtn;
			_othersTab = _mc._othersTab;
			_prevBtn = _mc._prevBtn;
			_nextBtn = _mc._nextBtn;
			_closeBtn = _mc._closeBtn;
			_sellBtn = _mc._sellBtn;
			_equipmentTab = _mc._equipmentTab;
			_title = _mc._title;
			
			// 整理按钮
			new BmButton(_arrangBtn, function(event : MouseEvent) : void
			{
				ModelManager.bagModel.sortBag(_type, setData);
			});
			
			//使用按钮
			new BmButton(_useBtn, function(event : MouseEvent) : void
			{
				if (_chooseItemPos != -1)
				{				
					NewbieController.refreshNewBieBtn(6, 4);
					ConfirmMessage.callBack = setData;
					ModelManager.bagModel.useBagItem(_chooseItemPos, _type, 1, setData);
				}
				else
					TextMessage.showEffect("请选择物品", 2);
			});
			
			//使用按钮
			new BmButton(_batchUseBtn, function(event : MouseEvent) : void
			{
				if (_chooseItemPos != -1)
				{				
					if (ViewManager.hasView(BatchUse.NAME)) return;
					var batchUseWin:BmWindow = new BatchUse(_chooseItemPos, setData);
					addChildCenter(batchUseWin);
				}
				else
					TextMessage.showEffect("请选择物品", 2);
			});
			
			// 卖出按钮
			new BmButton(_sellBtn, function(event : MouseEvent) : void
			{	
				if (_chooseItemPos != -1)
				{
					var data:Object = {};
					data.msg = "确认要出售此物品？将无法找回！";
					data.action = "client";
					data.args = function():void{
						ModelManager.bagModel.sellBagItem(_type, _chooseItemPos, setData);
					}
					ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
				}
				else
					TextMessage.showEffect("请选择物品", 2);
			});
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue(PLUS, _othersTab), new KeyValue(EQUIP, _equipmentTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				_type = id;
				_page = 1;
				setData();
			});
			
			// 物品面板
			_itemPanel = new McList(6, 3, 9, 5, 72, 72, true);
			addChildEx(_itemPanel, 40, 106);
			
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
			
			setData();
			
			//新手指引
//			NewbieController.showNewBieBtn(29, 2, this, 32, 175, true, "选择小型资源包");
//			NewbieController.showNewBieBtn(34, 2, this, 32, 175, true, "选择小型军需包");
			NewbieController.showNewBieBtn(6, 2, this, 23, 139, true, "选择装备礼盒");
		}
			
		private function setData() : void
		{
			_chooseItemPos = -1;
			
			//按钮是否显示
			UiUtils.setButtonEnable(_useBtn, _type == PLUS);
			UiUtils.setButtonEnable(_batchUseBtn, _type == PLUS);
			
			UiUtils.setButtonEnable(_sellBtn, false);
			
			// 获取相应类型的物品列表
			var items:Array = Data.data.bag[_type];
			
			if (items == null)
				items = [];
			
			// 格子数量
			var len:int = items.length;
			
			// 起始物品位置
			var start:int = (_page - 1) * PAGESIZE;
			
			// 结束物品位置
			var max:int = start + PAGESIZE;
			
			UiUtils.setButtonEnable(_prevBtn, _page > 1);
			UiUtils.setButtonEnable(_nextBtn, _page < PAGENUM);

			// 生成显示的物品列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有物品
			for (var i : int = start; i < max; i++)
			{
				if (i < len)
				{
					setItem(items[i], i);
				}
				else
				{
					var mc : McItem = new McItem('unopen');
					mc.pos = i;
					mc.evts.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
					{
						ConfirmMessage.callBack = setData;
						ModelManager.bagModel.confirmUnlockBag(_type, (event.currentTarget as McItem).pos - len + 1);
					});
					mc.buttonMode = true;
					_items.push(mc);
				}
			}
			
			//为了拖拽能取到图片。延时加载
			var timeoutId:int = 0;
			timeoutId = setTimeout(function():void{
				clearTimeout(timeoutId);
				_itemPanel.setItems(_items);
			}, 100);
		}		
		
		private function setItem(item : Object, index : int = -1) : void
		{
			if (item == null)
			{
				var nullMc : McItem = new McItem();
				nullMc.dragInfo.setPlace(1, null, function(item : Object) : void
				{
					ModelManager.bagModel.splitBagItem(_type, item.num, item.pos, index, setData);
				});
				_items.push(nullMc);
				return;
			}
			
			item.pos = index;
			var mc : McItem = new McItem(item.img, item.intensifyLevel? item.intensifyLevel : 0, item.num, true, null, 1, item);
			
			var doubleClick : Boolean = false;
			mc.evts.addEventListener(MouseEvent.MOUSE_MOVE, function(event : MouseEvent) : void
			{
				doubleClick = false;
			});
			mc.evts.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{	
//				if(item.id == 33002) NewbieController.refreshNewBieBtn(29, 3);
//				if(item.id == 33007) NewbieController.refreshNewBieBtn(34, 3);
				if(item.id == 33012) NewbieController.refreshNewBieBtn(6, 3);
				UiUtils.setButtonEnable(_sellBtn, item.saleprice > 0);
				
				if (_type == PLUS)
				{
					if (doubleClick)
					{
						if(item.id == 33012) NewbieController.refreshNewBieBtn(6, 4);
						ConfirmMessage.callBack = setData;
						ModelManager.bagModel.useBagItem(_chooseItemPos, _type, 1, setData);
					}
				}
				_chooseItemPos = item.pos;
				doubleClick = true;
				
				for each (var everyItem:DisplayObject in _items)
				{
					(everyItem as McItem).borderLight = false;
				}
				mc.borderLight = true;
			});
			mc.buttonMode = true;
			
			_items.push(mc);
			
			// 设置tip
			TipHelper.setTip(mc, Trans.transTips(item));
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
//					NewbieController.showNewBieBtn(29, 3, this, 485, 375, true, "打开小型资源包");
//					NewbieController.showNewBieBtn(34, 3, this, 485, 375, true, "打开小型军需包");
					NewbieController.showNewBieBtn(6, 3, this, 485, 375, true, "使用装备礼盒");
					break;
				default:
			}
		}	
	}
}
