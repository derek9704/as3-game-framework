package com.brickmice.view.planet
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmInputBox;
	import com.brickmice.view.component.BmTabButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.utils.DateUtils;
	import com.framework.utils.KeyValue;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SellCheese extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SellCheese";
		
		private var _mc:MovieClip;
		private var _sellMax:TextField;
		private var _cheeseTab1:MovieClip;
		private var _cheeseTab2:MovieClip;
		private var _cheeseTab3:MovieClip;
		private var _unitPrice:TextField;
		private var _sellCount:TextField;
		private var _maxBtn:MovieClip;
		private var _stock:TextField;
		private var _totalIncome:TextField;
		private var _weight:TextField;
		private var _time:TextField;
		private var _yesBtn:MovieClip;
		
		private var _data:Object;
		private var _chooseCheeseId : int = 0;
		private var _tab : BmTabView;
		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _input:BmInputBox;
		
		private var _totalCost:int = 0;
		private var _totalWeight:int = 0;
		private var _selectTrain:Array = [];
		private var _sellCheese:Object = {};
		private var _pid:int;
		
		public function SellCheese(data : Object, pid:int, callback:Function)
		{
			_mc = new ResPlanetSellCheeseWindow;
			super(NAME, _mc);
			
			_sellMax = _mc._sellMax;
			_cheeseTab1 = _mc._cheeseTab1;
			_cheeseTab2 = _mc._cheeseTab2;
			_cheeseTab3 = _mc._cheeseTab3;
			_unitPrice = _mc._unitPrice;
			_sellCount = _mc._sellCount;
			_maxBtn = _mc._maxBtn;
			_stock = _mc._stock;
			_totalIncome = _mc._totalIncome;
			_weight = _mc._weight;
			_time = _mc._time;
			_yesBtn = _mc._yesBtn;
			
			_data = data;
			_pid = pid;
			
			//先排序
			var items:Array = [];
			for each(var k:Object in data) items.push(k);
			items.sortOn("level", Array.NUMERIC);
			
			_chooseCheeseId = items[0]['id'];
			
			//Tab
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs = new Vector.<KeyValue>();
			tabs.push(new KeyValue(items[0]['id'], _cheeseTab1), new KeyValue(items[1]['id'], _cheeseTab2), new KeyValue(items[2]['id'], _cheeseTab3));	
			_tab = new BmTabView(tabs, function(id : String) : void
			{
				_chooseCheeseId = int(id);
				changeTab();
			});
			
			var index:int = 0;
			for each(var one:Object in items) {
				var tab:BmTabButton = _tab.getIndexTab(index);
				tab.text = one.name;
				index++;
				_sellCheese[one.id] = 0;
			}
			
			// 列车面板
			_itemPanel = new McList(3, 1, 15, 0, 76, 95, true);
			addChildEx(_itemPanel, 50, 255);
			
			// 生成默认显示的列车ID
			var ids:Array = [];
//			var trains:Array = Data.data.railway.trains;
//			index = 0;
//			for (var i:int = 0; i < trains.length; i++){
//				if(index == 3) break;
//				if(trains[i].status != 'free') continue;
//				ids.push(i);
//				index++;
//			}
			setTrains(ids);
			
			//按钮
			new BmButton(_maxBtn, function():void{
				var data:Object = _data[_chooseCheeseId];
				_input.text = data.num > data.stock ? data.stock : data.num;
			});
			new BmButton(_yesBtn, function():void{
				if(!_totalCost) {
					TextMessage.showEffect('请选择奶酪！', 2);
					return;
				}
				if(!_selectTrain.length){
					TextMessage.showEffect('请选择列车！', 2);
					return;		
				}
				var cheese:Array = [];
				for (var sid:String in _sellCheese){
					if(!_sellCheese[sid]) continue;
					cheese.push({'id' : sid, 'num' : _sellCheese[sid]});
				}
				ModelManager.planetModel.sellPlanetCheese(_pid, cheese, _selectTrain, function():void{
					callback();
					closeWindow();
				});
			});
			
			_input = new BmInputBox(_sellCount, '0', -1, true, 0, 0);
			_input.onNumChange = setCount;
			
			_time.text = DateUtils.toTimeString(parseInt(Data.data.travelTime));
			
			changeTab();
			
			//新手指引
			NewbieController.showNewBieBtn(26, 4, this, 58, 294, true, "打开列车选择窗口");
		}
		
		private function setCount(count:int):void
		{
			_sellCheese[_chooseCheeseId] = count;
			_stock.text = (_data[_chooseCheeseId].stock - count).toString();
			calcValue();
		}
		
		private function calcValue():void
		{
			var tprice:int = 0;
			var tweight:int = 0;
			for each(var one:Object in _data){
				tprice += one.price * _sellCheese[one.id];
				tweight += one.weight * _sellCheese[one.id];
			}
			_totalCost = tprice;
			_totalWeight = tweight;
			_totalIncome.text = tprice.toString();
			_weight.text = tweight.toString();
		}	
		
		private function showSelectTrainWin(e:MouseEvent):void
		{
			NewbieController.refreshNewBieBtn(26, 5);
			if (ViewManager.hasView(ChooseTrain.NAME)) return;
			var win:BmWindow = new ChooseTrain(_selectTrain, _totalWeight, setTrains);
			addChildCenter(win);
		}
		
		public function setTrains(ids:Array):void
		{
			_selectTrain = ids;
			_selectTrain.sort();
			
			// 生成显示的物品列表
			_items = new Vector.<DisplayObject>;
			var trains:Array = Data.data.railway.trains;
			for (var i:int = 0; i < _selectTrain.length; i++){
				var train:Object = trains[_selectTrain[i]];
				var text:String = '载重:' + train.carry;
				var mc : McItem = new McItem(train.img, train.level, 0, true, text);
				mc.evts.addClick(showSelectTrainWin);
				_items.push(mc);
			}
			
			//处理一下为空
			if(!_items.length){
				var text2:String = '点击选择列车';
				var mc2 : McItem = new McItem('init', 0, 0, true, text2);
				mc2.evts.addClick(showSelectTrainWin);
				_items.push(mc2);		
			}
			
			_itemPanel.setItems(_items);	
		}
		
		private function changeTab():void
		{
			if(!_chooseCheeseId){
				closeWindow();
				return;
			}
			
			var data:Object = _data[_chooseCheeseId];
			
			_sellMax.text = data.num;
			_unitPrice.text = data.price;
			_stock.text = (data.stock - _sellCheese[_chooseCheeseId]).toString();
			_input.max = data.num > data.stock ? data.stock : data.num;
			_input.text = _sellCheese[_chooseCheeseId];
			//新手默认数字
			if(_chooseCheeseId == 11001 && NewbieController.newbieTaskId == 26){
				_input.text = "100";
				setCount(100);
			}
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
					NewbieController.showNewBieBtn(26, 7, this, 234, 376, true, "完成出售");
					break;
				default:
			}
		}		
	}
}