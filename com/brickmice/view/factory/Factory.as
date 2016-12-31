package com.brickmice.view.factory
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmInputBox;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McCountDown;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McTip;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.utils.DateUtils;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Factory extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Factory";
		
		public static const CHEESE : String = "cheese";
		public static const ARM : String = "arm";
		public static const MOUSE : String = "mouse";
		public static const PAGESIZE : uint = 6;
		
		private var _mc:MovieClip;
		private var _making:MovieClip;
		private var _lvl:TextField;
		private var _productMake:MovieClip;
		private var _upgrade:MovieClip;
		private var _prevBtn:MovieClip;
		private var _nextBtn:MovieClip;
		private var _title:TextField;
		private var _num:TextField;
		private var _closeBtn:MovieClip;
		
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
		
		private var _type:String;
		private var _itemPanel : McList;
		private var _page : int = 1;	//当前页
		private var _pageNum : int = 1; //页面数量
		private var _selectedId:int;
		private var _selectedMaxNum:int;
		private var _selectedSpeed:Number;
		private var _selectedNeedGoods:Array;
		private var _makeNum:int;
		private var _makingItem:McItem;
		private var _makingTime:McCountDown;
		private var _input:BmInputBox;
		private var _items : Vector.<DisplayObject>;
		
		public function Factory(data : Object)
		{
			_mc = new ResFactoryWindow;
			super(NAME, _mc);
			
			_making = _mc._making;
			_lvl = _mc._lvl;
			_productMake = _mc._productMake;
			_upgrade = _mc._upgrade;
			_prevBtn = _mc._prevBtn;
			_nextBtn = _mc._nextBtn;
			_title = _mc._title;
			_num = _mc._num;
			_closeBtn = _mc._closeBtn;
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
			
			_type = data.type;
			
			new BmButton(_mc._upgrade._upgradeBtn, function(event : MouseEvent) : void
			{
				ModelManager.factoryModel.upgradeFactory(_type, function():void
				{
					setData();
					ViewManager.sendMessage(ViewMessage.UPGRADE_FACTORY, _type);
				});
			});
			TipHelper.setTip(_mc._upgrade._upgradeBtn, new McTip("升级同时会清除冷却时间"));
			
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
			
			_itemPanel = new McList(3, 2, 10, 9, 72, 90, true);
			addChildEx(_itemPanel, 165, 118);
			
			new BmButton(_making._moneyCompleteBtn, function(event : MouseEvent) : void
			{
				ConfirmMessage.callBack = setData;
				ModelManager.factoryModel.confirmSpeedFactoryProduce(_type);
			});				
			
			new BmButton(_productMake._makeBtn, function(event : MouseEvent) : void
			{
				if(_makeNum <= 0){
					TextMessage.showEffect("请输入生产数量", 2);
				}
				else {
					ModelManager.factoryModel.startFactoryProduce(_type, _selectedId, _makeNum, function():void{
						setData();
					});
				}
			});			
			
			_input = new BmInputBox(_productMake._num, '0', -1, true, 0, 0);
			_input.onNumChange = function (count:int):void{
				_makeNum = count;
				setProductMake();
			};
			
			new BmButton(_productMake._minusBtn, function(event : MouseEvent) : void
			{
				_makeNum --;
				if(_makeNum < 0) _makeNum = 0;
				_input.text = _makeNum.toString();
				setProductMake();
			});	
			
			new BmButton(_productMake._addBtn, function(event : MouseEvent) : void
			{
				_makeNum ++;
				if(_makeNum > _selectedMaxNum) _makeNum = _selectedMaxNum;
				_input.text = _makeNum.toString();
				setProductMake();
			});	
			
			_makingItem = new McItem();
			addChildEx(_makingItem, 427, 125);
			
			_makingTime = new McCountDown(0, 0x000000, 80, function():void{
				ModelManager.factoryModel.getFactoryData(_type, setData);
			}, "left", "--:--:--", 14);
			addChildEx(_makingTime, 416, 225);
			
			setData();	
			
			//新手指引
			if(_type == CHEESE) NewbieController.showNewBieBtn(25, 2, this, 178, 155, true, "选择一个品种的奶酪");
//			if(_type == CHEESE) NewbieController.showNewBieBtn(18, 3, this, -8, 355, true, "升级奶酪工厂");
			if(_type == MOUSE) NewbieController.showNewBieBtn(15, 2, this, 178, 155, true, "选择发条鼠");
//			if(_type == MOUSE) NewbieController.showNewBieBtn(31, 2, this, -8, 355, true, "升级发条鼠工厂");
//			if(_type == ARM) NewbieController.showNewBieBtn(44, 2, this, 168, 155, true, "选择2B铅笔");
		}
		
		public function setData(changeType:String = null) : void
		{
			_productMake._time.text = "";
			_productMake._formula.text = "";
			_productMake._num.text = "";
			_selectedId = 0;
			_selectedMaxNum = 0;
			_selectedSpeed = 0;
			_selectedNeedGoods = [];
			_makeNum = 0;
			_nextBtn.visible = _prevBtn.visible = _num.visible = true;
			
			if(changeType != null) {
				_type = changeType;
				_page = 1;
			}
			var title:String;
			switch(_type)
			{
				case "cheese":
				{
					title = "奶酪工厂";
					_nextBtn.visible = _prevBtn.visible = _num.visible = false;
					break;
				}
				case "arm":
				{
					title = "军需工厂";
					break;
				}
				case "mouse":
				{
					title = "发条鼠工厂";
					_nextBtn.visible = _prevBtn.visible = _num.visible = false;
					break;
				}
			}
			var unitData:Object = Data.data.factory[_type];
			_title.text = title;
			_lvl.text = unitData.level;
			_mc.produceBonus.text = ((1000 - int(unitData.produceBonus))/10).toString() + "%";
			_mc.nextProduceBonus.text = unitData.nextProduceBonus == null ? "--" : ((1000 - int(unitData.nextProduceBonus))/10).toString() + "%";
			
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
			
			// 获取相应类型的物品列表
			var items:Array = [];
			for(var k:String in unitData.formulaArr) items.push(unitData.formulaArr[k]);
			
			//按照物品等级排序
			items.sortOn("level", Array.NUMERIC);
			
			// 格子数量
			var len:int = items.length;
			
			// 起始物品位置
			var start:int = (_page - 1) * PAGESIZE;
			
			// 结束物品位置
			var max:int = start + PAGESIZE;
			
			//最大页数
			_pageNum = Math.ceil(len/PAGESIZE);
			
			_num.text = _page + " / " + _pageNum;
			
			UiUtils.setButtonEnable(_prevBtn, _page > 1);
			UiUtils.setButtonEnable(_nextBtn, _page < _pageNum);
			
			// 生成显示的物品列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有物品
			for (var i : int = start; i < max; i++)
			{
				if (i < len)
				{
					var item:Object = items[i];
					item.pos = i;
					var text:String = "MAX：" + item.produceNum;
					var mc : McItem = new McItem(item.getGoodsOb.img, 0, 0, true, text);
					setItem(mc, item, int(unitData.produceBonus));
					_items.push(mc);
					// 设置tip
					TipHelper.setTip(mc, Trans.transTips(item.getGoodsOb));
				}
			}			
			_itemPanel.setItems(_items);
			
			//生产和加速面板
			if(unitData.produceInfo.leftTime){
				_productMake.visible = false;
				_making.visible = true;
				_making._makingName.text = unitData.produceInfo.goods.name;
				_making._makingQuantity.text = unitData.produceInfo.num;
				_makingItem.resetImage(unitData.produceInfo.goods.img);
				// 设置tip
				TipHelper.setTip(_makingItem, Trans.transTips(unitData.produceInfo.goods));
				_makingItem.visible = true;
				_makingTime.setTime(int(unitData.produceInfo.leftTime));
				_makingTime.startTimer();
				_makingTime.visible = true;
			}
			else{
				_productMake.visible = true;
				_making.visible = false;
				_makingItem.visible = false;
				_makingTime.visible = false;
			}
		}	
		
		private function setItem(mc:McItem, item:Object, produceBonus:int):void
		{
			mc.evts.addClick(function(event : MouseEvent) : void{
				for each (var everyItem:DisplayObject in _items)
				{
					(everyItem as McItem).borderLight = false;
				}
				mc.borderLight = true;
				
				NewbieController.refreshNewBieBtn(25, 3);
				NewbieController.refreshNewBieBtn(15, 3);
//				NewbieController.refreshNewBieBtn(44, 3);
				_selectedId = item.id;
				_selectedMaxNum = item.produceNum;
				_selectedSpeed = int(item.allTime) * produceBonus / 1000;
				_selectedNeedGoods = item.needGoods;
				
				if(_type == ARM || _type == MOUSE){
					var iniNum:int = 80 + Data.data.user.techLevel * 20;
					if(iniNum > item.produceNum) iniNum = item.produceNum;
				}else{
					iniNum = item.produceNum;
				}
				_makeNum = iniNum;
				_input.text = iniNum.toString();
				//新手默认数字
				if(item.id == 52001 && NewbieController.newbieTaskId == 15){
					_makeNum = 100;
					_input.text = "100";
				}else if(item.id == 51001 && NewbieController.newbieTaskId == 25){
					_makeNum = 100;
					_input.text = "100";
				}
//				if(item.id == 51001 && NewbieController.newbieTaskId == 15){
//					_makeNum = 100;
//					_input.text = "100";
//				}else if(item.id == 52001 && NewbieController.newbieTaskId == 20){
//					_makeNum = 20;
//					_input.text = "20";
//				}else if(item.id == 53001 && NewbieController.newbieTaskId == 44){
//					_makeNum = 100;
//					_input.text = "100";
//				}
				
				_input.max = item.produceNum;
				
				setProductMake();
			});
		}
		
		private function setProductMake():void
		{
			var pTime:int = Math.floor(_selectedSpeed * _makeNum);
			_productMake._time.text = DateUtils.toTimeString(pTime);
			var formulaText:String = "";
			for each(var j : Object in _selectedNeedGoods) {
				formulaText += j.name + "\n" + j.num * _makeNum + "\n";
			}
			_productMake._formula.text =formulaText ;
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
					NewbieController.showNewBieBtn(25, 3, this, 431, 349, true, "开始生产吧");
					NewbieController.showNewBieBtn(15, 3, this, 431, 349, true, "开始生产吧");
//					NewbieController.showNewBieBtn(44, 3, this, 431, 349, true, "开始生产吧");
					break;
				default:
			}
		}		
		
	}
}