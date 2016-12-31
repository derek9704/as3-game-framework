package com.brickmice.view.railway
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
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
	import com.framework.utils.KeyValue;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Railway extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Railway";
		public static const RAILWAY : String = 'railway';
		public static const TRAIN : String = 'train';
		public static const TRAFFIC : String = 'traffic';
		public static const PAGESIZE : uint = 5;
		
		private var _mc:MovieClip;
		private var _upgrade:MovieClip;
		private var _railwayDetail:MovieClip;
		private var _nextBtn:MovieClip;
		private var _prevBtn:MovieClip;
		private var _railwayTab:MovieClip;
		private var _closeBtn:MovieClip;
		private var _trainTab:MovieClip;
		private var _trafficTab:MovieClip;
		private var _trafficDetail:MovieClip;
		private var _count:TextField;
		
		private var _techLv:TextField;
		private var _coins:TextField;
		private var _iron:TextField;
		private var _moonStone:TextField;
		private var _lifeStone:TextField;
		private var _nightStone:TextField;
		private var _unitPoint:TextField;
		private var _checkBox1:MovieClip;
		private var _checkBox2:MovieClip;
		private var _checkBox3:MovieClip;
		private var _checkBox4:MovieClip;
		private var _checkBox5:MovieClip;
		private var _checkBox6:MovieClip;
		private var _checkBox7:MovieClip;
		
		private var _pageNum:int = 0;
		private var _type:String;
		private var _chooseItemPos : int = -1;
		private var _itemPanel : McList;
		private var _tabView : BmTabView;
		private var _page : int = 1;	//当前页
		private var _items : Vector.<DisplayObject>;
		private var _trafficPanel : McList;
		
		public function Railway(data : Object)
		{
			_type = data.type;
			
			_mc = new ResRailwayWindow;
			super(NAME, _mc);
			
			_upgrade = _mc._upgrade;
			_railwayDetail = _mc._railwayDetail;
			_nextBtn = _mc._nextBtn;
			_prevBtn = _mc._prevBtn;
			_railwayTab = _mc._railwayTab;
			_closeBtn = _mc._closeBtn;
			_trainTab = _mc._trainTab;
			_trafficTab = _mc._trafficTab;
			_trafficDetail = _mc._trafficDetail;
			_count = _mc._count;
			_techLv = _mc._upgrade._techLv;
			_coins = _mc._upgrade._coins;
			_iron = _mc._upgrade._iron;
			_moonStone = _mc._upgrade._moonStone;
			_lifeStone = _mc._upgrade._lifeStone;
			_nightStone = _mc._upgrade._nightStone;
			_unitPoint = _mc._upgrade._unitPoint;	
			_checkBox1 = _mc._upgrade._checkBox1;
			_checkBox2 = _mc._upgrade._checkBox2;
			_checkBox3 = _mc._upgrade._checkBox3;
			_checkBox4 = _mc._upgrade._checkBox4;
			_checkBox5 = _mc._upgrade._checkBox5;
			_checkBox6 = _mc._upgrade._checkBox6;
			_checkBox7 = _mc._upgrade._checkBox7;
			
			new BmButton(_mc._upgrade._upgradeBtn, function(event : MouseEvent) : void
			{
				if(_type == RAILWAY) {
					ModelManager.railwayModel.upgradeRailway(function():void
					{
						setData();
						ViewManager.sendMessage(ViewMessage.UPGRADE_RAILWAY);
					});
				}else{
					if (_chooseItemPos != -1)
					{
						ModelManager.railwayModel.upgradeRailwayTrain(_chooseItemPos, function():void
						{
							setData(null, _chooseItemPos);
						});
					}
					else
						TextMessage.showEffect("请先选择一辆列车", 2);
				}
			});
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue(TRAIN, _trainTab), new KeyValue(RAILWAY, _railwayTab), new KeyValue(TRAFFIC, _trafficTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
//				if(id == TRAIN) NewbieController.refreshNewBieBtn(27, 2);
//				if(id == TRAFFIC) NewbieController.refreshNewBieBtn(32, 3);
				_type = id;
				_page = 1;
				setData();
			});
			
			_mc._freeTime.text = (Data.data.railway.freeSpeedUpTime / 60);
			
			// 火车面板
			_itemPanel = new McList(5, 1, 4, 0, 80, 103, true);
			addChildEx(_itemPanel, 81, 129);
			
			//交通面板
			_trafficPanel = new McList(1, 10, 0, 1, 446, 19, false);
			addChildEx(_trafficPanel, 61, 141);
			
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
			
			_tabView.selectId = _type;
			
			setFreeTrainCount();
			setData();
			
			//新手指引
			NewbieController.showNewBieBtn(21, 2, this, 88, 166, true, "购买一辆银河列车");
//			NewbieController.showNewBieBtn(26, 2, this, 166, 166, true, "购买一辆银河列车");
			NewbieController.showNewBieBtn(22, 14, this, 478, 151, false, "选择立即到达");
		}
		
		public function setData(changeType:String = null, index:int = 0) : void
		{
			var unitData:Object;
			
			if(changeType != null) {
				_type = changeType;
				_tabView.selectId = _type;
				_page = 1;
			}
			
			if(_type == RAILWAY) {
				_railwayDetail.visible = true;
				_upgrade.visible = true;
				_prevBtn.visible = _nextBtn.visible = _itemPanel.visible = _trafficDetail.visible = _trafficPanel.visible = false;
				unitData = Data.data.railway;
				_railwayDetail._Lvl.text = unitData.level;
				_railwayDetail._speed.text = unitData.speed;
				_railwayDetail._nextLvlSpeed.text = unitData.nextSpeed == null ? "--" : unitData.nextSpeed;
				upgradeUpdate(unitData);
			}else if(_type == TRAIN){
				_chooseItemPos = -1;
				_railwayDetail.visible = _trafficDetail.visible = _trafficPanel.visible = false;
				_upgrade.visible = true;
				_prevBtn.visible = _nextBtn.visible = _itemPanel.visible = true;
				
				_items = new Vector.<DisplayObject>;
				
				var items:Array = Data.data.railway.trains;
				
				// 购买的列车数量
				var len:int = items.length;
				
				//开启的格子数量
				var count:int = Data.data.railway.slotNum;
				
				_pageNum = count > PAGESIZE ? 2 : 1;
				
				// 起始物品位置
				var start:int = (_page - 1) * PAGESIZE;
				
				// 结束物品位置
				var max:int = start + PAGESIZE > count ? count : start + PAGESIZE;
				
				UiUtils.setButtonEnable(_prevBtn, _page > 1);
				UiUtils.setButtonEnable(_nextBtn, _page < _pageNum);
				
				// 生成显示的物品列表
				_items = new Vector.<DisplayObject>;
				
				// 遍历所有物品
				for (var i : int = start; i < max; i++)
				{
					var mc : McItem;
					if(items[i]){
						var train:Object = items[i];
						var text:String = '等级：' + train.level + '<br>载重：' + train.carry;
						mc = new McItem(train.img, 0, 0, true, text);
						mc.pos = i;
						//行驶标记
						if(train.status == 'run'){
							var flag:MovieClip = new ResTrainRunFlag;
							mc.addChildH(flag, 42);
						}
						mc.evts.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
						{
							clickTrain(event.currentTarget as McItem);
						});
						mc.buttonMode = true;
						//选择指定格
						if(index && i == index){
							_chooseItemPos = i;
							mc.borderLight = true;
							upgradeUpdate(items[i]);						
						}
						//默认选择第一格
						if(!index && i == start){
							_chooseItemPos = i;
							mc.borderLight = true;
							upgradeUpdate(items[i]);
						}
					}
					else{
						var text2:String = '点击购买';
						mc = new McItem('init', 0, 0, true, text2);
						mc.pos = i;
						mc.buttonMode = true;
						buyTrain(mc, i, len);
					}
					_items.push(mc);
				}
				
				_itemPanel.setItems(_items);
				
				if (_chooseItemPos == -1){
					_upgrade.visible = false;
				}
			}else{
				_trafficDetail.visible = true;
				_trafficPanel.visible = true;
				_prevBtn.visible = _nextBtn.visible = _itemPanel.visible = _railwayDetail.visible = _upgrade.visible = false;
				
				// 生成显示的面板
				var trafficItems:Vector.<DisplayObject> = new Vector.<DisplayObject>;
				for each(var one:Object in Data.data.railway.traffic){
					var trafficItem : TrafficListItem = new TrafficListItem(one);
					trafficItems.push(trafficItem);
				}
				_trafficPanel.setItems(trafficItems);
			}
		}
		
		private function clickTrain(item:McItem):void
		{
			for each (var everyItem:DisplayObject in _items)
			{
				(everyItem as McItem).borderLight = false;
			}
			item.borderLight = true;
			_chooseItemPos = item.pos;
			upgradeUpdate(Data.data.railway.trains[item.pos]);
		}
		
		private function buyTrain(item:McItem, i:int, len:int):void
		{
			item.evts.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{
				NewbieController.refreshNewBieBtn(21, 3);
//				NewbieController.refreshNewBieBtn(26, 3);
				ConfirmMessage.callBack = function():void{
					setData(null, i);
				};
				ModelManager.railwayModel.confirmBuyRailwayTrain(i - len + 1);
			});
		}
		
		private function upgradeUpdate(unitData:Object):void
		{
			_techLv.text = unitData.updateRequire.techLevel;
			if(Data.data.user.techLevel >= unitData.updateRequire.techLevel)
				_checkBox1.gotoAndStop(2);
			else
				_checkBox1.gotoAndStop(1);
			
			_coins.text = unitData.updateRequire.coins ;
			if(Data.data.user.coins  >= unitData.updateRequire.coins)
				_checkBox2.gotoAndStop(2);
			else
				_checkBox2.gotoAndStop(1);
			
			_iron.text = unitData.updateRequire.iron;
			if(unitData.updateRequire.iron == 0 || Data.data.storage.material.items[Consts.ID_IRON]["num"]  >= unitData.updateRequire.iron)
				_checkBox3.gotoAndStop(2);
			else
				_checkBox3.gotoAndStop(1);
			
			_moonStone.text = unitData.updateRequire.moonStone;
			if(unitData.updateRequire.moonStone == 0 || Data.data.storage.material.items[Consts.ID_MOONSTONE]["num"]  >= unitData.updateRequire.moonStone)
				_checkBox4.gotoAndStop(2);
			else
				_checkBox4.gotoAndStop(1);
			
			_lifeStone.text = unitData.updateRequire.lifeStone ;
			if(unitData.updateRequire.lifeStone == 0 || Data.data.storage.material.items[Consts.ID_LIFESTONE]["num"]  >= unitData.updateRequire.lifeStone)
				_checkBox5.gotoAndStop(2);
			else
				_checkBox5.gotoAndStop(1);
			
			_nightStone.text = unitData.updateRequire.nightStone ;
			if(unitData.updateRequire.nightStone == 0 || Data.data.storage.material.items[Consts.ID_NIGHTSTONE]["num"]  >= unitData.updateRequire.nightStone)
				_checkBox6.gotoAndStop(2);
			else
				_checkBox6.gotoAndStop(1);
			
			_unitPoint.text = unitData.updateRequire.unitPoint ;
			if(Data.data.unit.point   >= unitData.updateRequire.unitPoint)
				_checkBox7.gotoAndStop(2);
			else
				_checkBox7.gotoAndStop(1);		
		}
		
		private function setFreeTrainCount():void
		{
			var trains:Array = Data.data.railway.trains;
			var trainCount:int = trains.length;
			var freeTrainCount:int = 0;
			for each (var train:Object in trains) 
			{
				if(train['status'] == 'free') freeTrainCount++;
			}
			_count.text = freeTrainCount.toString();
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_RAILWAY, ViewMessage.REFRESH_NEWBIE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_RAILWAY:
					setFreeTrainCount();
					break;
				case ViewMessage.REFRESH_NEWBIE:
//					NewbieController.showNewBieBtn(27, 1, this, 43, 82, true, "切换到银河列车页面");
//					NewbieController.showNewBieBtn(27, 2, this, 166, 166, true, "购买一辆银河列车");
//					NewbieController.showNewBieBtn(27, 4, this, 445, 343, true, "升级这辆银河列车");
//					NewbieController.showNewBieBtn(32, 3, this, 508, 151, false, "选小于3分钟的列车");
					break;
				default:
			}
		}	
	}	
}