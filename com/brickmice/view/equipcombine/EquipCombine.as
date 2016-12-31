package com.brickmice.view.equipcombine
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.boyhero.BoyHero;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCheckBox;
	import com.brickmice.view.component.BmTabButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.prompt.NoticeMessage;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.FilterUtils;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class EquipCombine extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "EquipCombine";
		public static const PAGESIZE : uint = 8;
		
		private var _mc:MovieClip;
		private var _centrifuge:TextField;
		private var _equippedTab:MovieClip;
		private var _notEquippedTab:MovieClip;
		private var _successProb:TextField;
		private var _successGoldenCost:TextField;
		private var _checkbox:MovieClip;
		private var _combineBtn:MovieClip;
		private var _combineCoinsCost:TextField;
		private var _nextBtn:MovieClip;
		private var _prevBtn:MovieClip;
		private var _fiterType:MovieClip;
		
		private var _hid : int = 0;
		private var _pos : int = 0;
		private var _mainId : int = 0;
		private var _index : int = 0;
		private var _isPay : int = 0;
		private var _selType : String = '';
		
		private var _noPayRate:int = 0;
		private var _isMain:Boolean = true; //主位标识
		private var _type : String = 'hero';
		private var _page : int = 1;	//当前页
		private var _pageNum : int = 1; //页面数量
		private var _equippedPanel : McList;
		private var _notEquippedPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _heroTab : BmTabView;
		private var _heros : Vector.<DisplayObject>;
		private var _tabView : BmTabView;
		private var _selectItem1:McItem;
		private var _selectItem2:McItem;
		private var _checkBox:BmCheckBox;
		private var _checkBox1:BmCheckBox;
		private var _checkBox2:BmCheckBox;
		private var _checkBox3:BmCheckBox;
		
		
		public function EquipCombine(data : Object)
		{
			_mc = new ResEquipCombineWindow;
			super(NAME, _mc);
			
			_centrifuge = _mc._centrifuge;
			_equippedTab = _mc._equippedTab;
			_notEquippedTab = _mc._notEquippedTab;
			_successProb = _mc._successProb;
			_successGoldenCost = _mc._successGoldenCost;
			_checkbox = _mc._checkbox;
			_combineBtn = _mc._combineBtn;
			_combineCoinsCost = _mc._combineCoinsCost;
			_nextBtn = _mc._nextBtn;
			_prevBtn = _mc._prevBtn;
			_fiterType = _mc._fiterType;
			
			_selectItem1 = new McItem();
			addChildEx(_selectItem1, 483, 131);
			_selectItem1.delFunc = function():void{
				//清空主位
				_selectItem1.resetImage('init');
				_selectItem1.num1 = 0;
				TipHelper.clear(_selectItem1);
				_selType = '';
				_pos = 0;
				_mainId = 0;
				_noPayRate = 0;
				_successProb.text = '';
				_successGoldenCost.text = '';
				_combineCoinsCost.text = '';	
				_isMain = true;
				//清空副位
				_selectItem2.resetImage('init');
				_selectItem2.num1 = 0;	
				TipHelper.clear(_selectItem2);
				_index = 0;
				UiUtils.setButtonEnable(_combineBtn, false);
			};
			
			_selectItem2 = new McItem();
			addChildEx(_selectItem2, 483, 228);
			_selectItem2.delFunc = function():void{
				//清空副位
				_selectItem2.resetImage('init');
				_selectItem2.num1 = 0;	
				TipHelper.clear(_selectItem2);
				_index = 0;
				UiUtils.setButtonEnable(_combineBtn, false);
			};
			
			//checkbox
			_checkBox = new BmCheckBox(_checkbox, function(selected : Boolean):void{
				if(selected){
					_isPay = 1;
					_successProb.text = '100%';
				}else{
					_isPay = 0;
					_successProb.text = _noPayRate + '%';		
				}
			});
			
			_checkBox1 = new BmCheckBox(_fiterType._checkBox1, function(selected : Boolean):void{
				setData();
			}, true);
			_checkBox2 = new BmCheckBox(_fiterType._checkBox2, function(selected : Boolean):void{
				setData();
			}, true);
			_checkBox3 = new BmCheckBox(_fiterType._checkBox3, function(selected : Boolean):void{
				setData();
			}, true);
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue('hero', _equippedTab), new KeyValue('bag', _notEquippedTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				_type = id;
				setData();
			});
			
			//HerosTab
			tabs = new Vector.<KeyValue>();
			for(var i:int = 1; i <= 10; i++){
				tabs.push(new KeyValue('init', _mc["_boyHeroTab" + i]));	
			}
			_heroTab = new BmTabView(tabs, function(id : String) : void
			{
				_hid = int(id);
				changeHero();
			});
			
			new BmButton(_combineBtn, function(event : MouseEvent) : void
			{
				ModelManager.equipModel.combineEquip(_selType, _hid, _pos, _index, _isPay, function():void{
					setData();
					//更新主位
					var item:Object;
					if(_selType == 'hero'){
						item = Data.data.boyHero[_hid].equip[_pos];
					}else{
						item = Data.data.bag.equip[_pos]
					}
					//有可能装备直接弹回箱子
					if(item == null){
						_selectItem1.resetImage('init');
						_selectItem1.num1 = 0;
						TipHelper.clear(_selectItem1);
						_selType = '';
						_pos = 0;
						_mainId = 0;
						_noPayRate = 0;
						_successProb.text = '';
						_successGoldenCost.text = '';
						_combineCoinsCost.text = '';	
						_isMain = true;
					}else{
						_selectItem1.num1 = item.intensifyLevel;
						_selectItem1.resetImage(item.img);
						TipHelper.setTip(_selectItem1, Trans.transTips(item));					
						_noPayRate = item.combinerate;
						_successProb.text = item.combinerate + '%';
						_successGoldenCost.text = item.combinegold;
						_combineCoinsCost.text = item.combinecoin;	
						_mainId = item.id;
					}
					//清空副位
					_selectItem2.resetImage('init');
					_selectItem2.num1 = 0;	
					TipHelper.clear(_selectItem2);
					_index = 0;
					UiUtils.setButtonEnable(_combineBtn, false);
					//去掉勾
					_isPay = 0;
					_checkBox.select = false;
				});
			});
			UiUtils.setButtonEnable(_combineBtn, false);
			
			new BmButton(_prevBtn, function(event : MouseEvent) : void
			{
				_page--;
				setData();
			});
			
			new BmButton(_nextBtn, function(event : MouseEvent) : void
			{
				_page++;
				setData();
			});		
			
			new BmButton(_mc._explainBtn, function(event : MouseEvent) : void
			{
				var msg:String = "- 只有飞行器，权杖，芯片可进行分子重组<br>"
										+ "<br>"
										+ "- 分子重组需要使用两件相同的装备<br>"
										+ "<br>"
										+ "- 两件装备的强化等级相同时会发生些什么...<br>"
										+ "<br>"
										+ "- 重组失败时，副位的装备会消失<br>";
				var title:String = "重组说明";
				ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, {msg:msg, title:title}, false, 0, 0, 0, false));
			});				
			
			_equippedPanel = new McList(3, 2, 19, 37, 72, 72, true);
			addChildEx(_equippedPanel, 181, 129);
			
			_notEquippedPanel = new McList(4, 2, 18, 19, 72, 72, true);
			addChildEx(_notEquippedPanel, 92, 146);		
			
			setData();
			
			//新手指引
//			NewbieController.showNewBieBtn(46, 2, this, 185, 165, true, "选择一个装备");
		}
		
		private function changeHero():void
		{
			if(!_hid){
				return;
			}
			// 生成显示的装备面板
			_items = new Vector.<DisplayObject>;
			var equipArr : Array = Data.data.boyHero[_hid].equip;
			for (var i:int = 0; i < 3; i++) 
			{
				var one:Object = equipArr[i];
				var mc:McItem;
				if(one) {
					mc = new McItem(one.img, one.intensifyLevel);
					one.index = i;
					setItem(mc, one, 'hero');
					_items.push(mc);
					mc.buttonMode = true;
					// 设置tip
					TipHelper.setTip(mc, Trans.transTips(one));
				}
			}
			_equippedPanel.setItems(_items);		
		}
		
		public function setData() : void
		{
			//隐藏标签
			_heroTab.hideAllTab();
			_prevBtn.visible = _nextBtn.visible = false;
			_equippedPanel.visible = _notEquippedPanel.visible = false;
			_fiterType.visible = false;
			
			_centrifuge.text = Data.data.equip.centrifuge;
			
			if(_type == 'hero'){
				_equippedPanel.visible = true;
				
				var data:Object = Data.data.boyHero;
				var heroArr:Array = [];
				for(var k:String in data) {
					// 排除不在内城的噩梦鼠
					var index2:int = BoyHero.INCITY.indexOf(data[k]['status']);
					if(index2 >= 0){
						heroArr.push(data[k]);
					}
				}
				heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
				
				var index:int = 0;
				for each(var one:Object in heroArr) {
					if(_hid == 0) _hid = one.id;
					var tab:BmTabButton = _heroTab.getIndexTab(index);
					tab.id = one.id;
					tab.filter = [FilterUtils.createGlow(0x000000, 500)];
					tab.text = '<font color="' + Trans.heroQualityColor[one.quality] + '">' + one.name + '</font>';
					tab.visible = true;
					index++;
				}
				if(_hid) _heroTab.selectId = _hid.toString();
				changeHero();
			}else{
				_notEquippedPanel.visible = true;
				_fiterType.visible = true;
				_prevBtn.visible = _nextBtn.visible = true;
				// 获取相应类型的物品列表
				var items:Array = Data.data.bag.equip;
				var _itemArr:Array = [];
				for (var key : String in items)
				{
					if(!items[key]) continue;
					if((items[key].subtype == 'rod' && _checkBox2.select) || (items[key].subtype == 'fly' && _checkBox3.select) || (items[key].subtype == 'chip' && _checkBox1.select)){
						items[key]['index'] = key;
						_itemArr.push(items[key]);
					}
				}
				_pageNum = Math.ceil(_itemArr.length / PAGESIZE);
				// 格子数量
				var count:int = _itemArr.length;
				// 起始物品位置
				var start:int = (_page - 1) * PAGESIZE;
				// 结束物品位置
				var max:int = start + PAGESIZE > count ? count : start + PAGESIZE;
				
				UiUtils.setButtonEnable(_mc._prevBtn, _page > 1);
				UiUtils.setButtonEnable(_mc._nextBtn, _page < _pageNum);
				
				// 生成显示的物品列表
				_items = new Vector.<DisplayObject>;
				
				// 遍历所有物品
				for (var i : int = start; i < max; i++)
				{
					var one2:Object = _itemArr[i];
					var mc : McItem = new McItem(one2.img, one2.intensifyLevel);
					setItem(mc, one2, 'bag');
					mc.buttonMode = true;
					// 设置tip
					TipHelper.setTip(mc, Trans.transTips(one2));
					_items.push(mc);
				}	
				_notEquippedPanel.setItems(_items);
			}
		}
		
		private function setItem(mc:McItem, item:Object, type:String):void
		{
			mc.evts.addClick(function(event : MouseEvent) : void{
				if(_isMain){ //主位
//					NewbieController.refreshNewBieBtn(46, 3);
					_selectItem1.resetImage(item.img);
					_selectItem1.num1 = item.intensifyLevel;
					// 设置tip
					TipHelper.setTip(_selectItem1, Trans.transTips(item));
					_selType = type;
					_pos = item.index;
					_mainId = item.id;
					
					_noPayRate = item.combinerate;
					_successProb.text = item.combinerate + '%';
					_successGoldenCost.text = item.combinegold;
					_combineCoinsCost.text = item.combinecoin;	
					_isMain = false;
					//切换到箱子TAB
					if(_type != 'bag'){
						_tabView.selectId = 'bag';
						_type = 'bag';
						setData();	
					}
				}else{ //副位
					if(_selType == type && _pos == item.index){
						return;
					}
					if(item.id != _mainId){
						TextMessage.showEffect("请选择相同的装备", 2);
						return;
					}
					if(type == 'hero'){
						TextMessage.showEffect("请在未装备标签中选择重组副位", 2);
						return;
					}				
//					NewbieController.refreshNewBieBtn(46, 4);
					_selectItem2.resetImage(item.img);
					_selectItem2.num1 = item.intensifyLevel;	
					// 设置tip
					TipHelper.setTip(_selectItem2, Trans.transTips(item));
					_index = item.index;
					UiUtils.setButtonEnable(_combineBtn, true);
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
//					NewbieController.showNewBieBtn(46, 3, this, 93, 224, true, "再选择一个相同装备");
//					NewbieController.showNewBieBtn(46, 4, this, 506, 346, true, "点击完成重组");
					break;
				default:
			}
		}	
	}
}