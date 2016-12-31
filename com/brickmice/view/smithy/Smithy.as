package com.brickmice.view.smithy
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.boyhero.BoyHero;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McTip;
	import com.framework.core.Message;
	import com.framework.utils.FilterUtils;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Smithy extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Smithy";
		public static const PAGESIZE : uint = 12;
		
		private var _mc:MovieClip;
		private var _equippedTab:MovieClip;
		private var _targetEquip:MovieClip;
		private var _coolDownTime:TextField;
		private var _notEquippedTab:MovieClip;
		private var _nextBtn:MovieClip;
		private var _prevBtn:MovieClip;
		private var _closeBtn:MovieClip;
		private var _addTimeBtn:MovieClip;
		private var _enhanceBtn:MovieClip;
		
		private var _hid : int = 0;
		private var _pos : int = -1;
		private var _type : String = 'hero';
		private var _selType : String = '';
		private var _page : int = 1;	//当前页
		private var _pageNum : int = 1; //页面数量
		private var _equippedPanel : McList;
		private var _notEquippedPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _heroTab : BmTabView;
		private var _heros : Vector.<DisplayObject>;
		private var _tabView : BmTabView;
		private var _selectItem:McItem;
		
		
		public function Smithy(data : Object)
		{
			_mc = new ResSmithyWindow;
			super(NAME, _mc);
			
			_equippedTab = _mc._equippedTab;
			_targetEquip = _mc._targetEquip;
			_coolDownTime = _mc._coolDownTime;
			_notEquippedTab = _mc._notEquippedTab;
			_nextBtn = _mc._nextBtn;
			_prevBtn = _mc._prevBtn;
			_closeBtn = _mc._closeBtn;
			_addTimeBtn = _mc._addTimeBtn;
			_enhanceBtn = _mc._enhanceBtn;
			
			_selectItem = new McItem();
			addChildEx(_selectItem, 489, 117);
			_targetEquip.visible = false;
			
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
				tabs.push(new KeyValue('init', _mc["_tab" + i]));	
			}
			_heroTab = new BmTabView(tabs, function(id : String) : void
			{
				_hid = int(id);
				changeHero();
			});
			
			new BmButton(_enhanceBtn, function(event : MouseEvent) : void
			{
				ModelManager.equipModel.intensifyEquip(_selType, _hid, _pos, setData);
			});
			UiUtils.setButtonEnable(_enhanceBtn, false);
			
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
			
			new BmButton(_addTimeBtn, function():void{
				ModelManager.equipModel.buyEquipPoint();
			});
			
			var tip:String = '强化点会随荣誉等级提升<br>';
			tip += "恢复间隔：" + Data.data.equip.recoverPointInterval + "秒<br>";
			tip += "每天0点恢复" + Data.data.equip.dailyRecoverPoint + "点<br>";
			tip += "花费" + Data.data.equip.buyPointCost + "宇宙钻购买" + Data.data.equip.buyPointCount + "强化点";
			TipHelper.setTip(_addTimeBtn, new McTip(tip));
			_coolDownTime.text = Data.data.equip.point + " / " + Data.data.equip.maxPoint;
			
			_equippedPanel = new McList(3, 2, 19, 37, 72, 72, true);
			addChildEx(_equippedPanel, 176, 127);
			
			_notEquippedPanel = new McList(4, 3, 15, 4, 72, 72, true);
			addChildEx(_notEquippedPanel, 92, 118);		
			
			setData();
			
			//新手指引
			NewbieController.showNewBieBtn(7, 2, this, 175, 164, true, "选择一件装备");
		}
		
		private function changeHero():void
		{
			if(!_hid){
				return;
			}
			// 生成显示的装备面板
			_items = new Vector.<DisplayObject>;
			var equipArr : Array = Data.data.boyHero[_hid].equip;
			for (var i:int = 0; i < 6; i++) 
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
				
				_prevBtn.visible = _nextBtn.visible = true;
				// 获取相应类型的物品列表
				var items:Array = Data.data.bag.equip;
				var _itemArr:Array = [];
				for (var key : String in items)
				{
					if(!items[key]) continue;
					items[key]['index'] = key;
					_itemArr.push(items[key]);
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
			
			if(_pos != -1){
				var item:Object;
				if(_selType == 'hero'){
					item = Data.data.boyHero[_hid].equip[_pos];
				}else{
					item = Data.data.bag.equip[_pos]
				}
				setSelTxt(item);
			}
		}
		
		private function setSelTxt(item:Object):void
		{
			// 设置tip
			TipHelper.setTip(_selectItem, Trans.transTips(item));
			_selectItem.num1 = item.intensifyLevel;
			_targetEquip._cost.text = item.intensifyCost;
			_targetEquip._point.text = Math.floor(item.intensifyLevel / 2) + 1;
			var propText:String = "";
			if(item.attack != 0){
				propText += "统率力：" + item.attack + "<br>";
				propText += "<font color='#A20000'>强化后：" + (int(item.n_attack) + int(item.attack)) + "</font><br>";
			}
			if(item.defense != 0){
				propText += "意志力：" + item.defense + "<br>";
				propText += "<font color='#A20000'>强化后：" + (int(item.n_defense) + int(item.defense)) + "</font><br>";
			}
			if(item.carry != 0){
				propText += "带兵数：" + item.carry + "<br>";
				propText += "<font color='#A20000'>强化后：" + (int(item.n_carry) + int(item.carry)) + "</font><br>";
			}
			if(item.scamper != 0){
				propText += "行动力：" + item.scamper + "<br>";
				propText += "<font color='#A20000'>强化后：" + (int(item.n_scamper) + int(item.scamper)) + "</font>";
			}
			_targetEquip._property.htmlText = propText ;
		}
		
		private function setItem(mc:McItem, item:Object, type:String):void
		{
			mc.evts.addClick(function(event : MouseEvent) : void{
				for each (var everyItem:DisplayObject in _items)
				{
					(everyItem as McItem).borderLight = false;
				}
				mc.borderLight = true;
				NewbieController.refreshNewBieBtn(7, 3);
				_targetEquip.visible = true;
				_selectItem.resetImage(item.img);
				UiUtils.setButtonEnable(_enhanceBtn, true);
				_selType = type;
				_pos = item.index;
				setSelTxt(item);
			});
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_EQUIPPOINT, ViewMessage.REFRESH_NEWBIE];
		}
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_EQUIPPOINT:
					var tip:String = '强化点会随荣誉等级提升<br>';
					tip += "恢复间隔：" + Data.data.equip.recoverPointInterval + "秒<br>";
					tip += "每天0点恢复" + Data.data.equip.dailyRecoverPoint + "点<br>";
					tip += "花费" + Data.data.equip.buyPointCost + "宇宙钻购买" + Data.data.equip.buyPointCount + "强化点";
					TipHelper.setTip(_addTimeBtn, new McTip(tip));
					_coolDownTime.text = Data.data.equip.point + " / " + Data.data.equip.maxPoint;
					break;
				case ViewMessage.REFRESH_NEWBIE:
					NewbieController.showNewBieBtn(7, 3, this, 505, 333, true, "开始强化");
					break;
				default:
			}
		}	
	}
}