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

	public class BuyStone extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BuyStone";
		
		private var _mc:MovieClip;
		private var _buyMax:TextField;
		private var _oreTab1:MovieClip;
		private var _oreTab2:MovieClip;
		private var _oreTab3:MovieClip;
		private var _unitPrice:TextField;
		private var _buyCount:TextField;
		private var _ironMaxBtn:MovieClip;
		private var _storageLeft:TextField;
		private var _coinsCost:TextField;
		private var _weight:TextField;
		private var _time:TextField;
		private var _yesBtn:MovieClip;
		
		private var _data:Object;
		private var _chooseStoneId : int = 0;
		private var _tab : BmTabView;
		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _input:BmInputBox;
		
		private var _totalCost:int = 0;
		private var _totalWeight:int = 0;
		private var _selectTrain:Array = [];
		private var _buyStone:Object = {};
		private var _pid:int;
		
		public function BuyStone(data : Object, pid:int, callback:Function)
		{
			_mc = new ResPlanetBuyStoneWindow;
			super(NAME, _mc);
			
			_buyMax = _mc._buyMax;
			_oreTab1 = _mc._oreTab1;
			_oreTab2 = _mc._oreTab2;
			_oreTab3 = _mc._oreTab3;
			_unitPrice = _mc._unitPrice;
			_buyCount = _mc._buyCount;
			_ironMaxBtn = _mc._ironMaxBtn;
			_storageLeft = _mc._storageLeft;
			_coinsCost = _mc._coinsCost;
			_weight = _mc._weight;
			_time = _mc._time;
			_yesBtn = _mc._yesBtn;
			
			_data = data;
			_pid = pid;
			
			//先排序
			var items:Array = [];
			for each(var k:Object in data) items.push(k);
			items.sortOn("level", Array.NUMERIC);
			
			_chooseStoneId = items[0]['id'];
			
			//Tab
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs = new Vector.<KeyValue>();
			tabs.push(new KeyValue(items[0]['id'], _oreTab1), new KeyValue(items[1]['id'], _oreTab2), new KeyValue(items[2]['id'], _oreTab3));	
			_tab = new BmTabView(tabs, function(id : String) : void
			{
				_chooseStoneId = int(id);
				changeTab();
			});
			
			var index:int = 0;
			for each(var one:Object in items) {
				var tab:BmTabButton = _tab.getIndexTab(index);
				tab.text = one.name;
				index++;
				_buyStone[one.id] = 0;
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
			new BmButton(_ironMaxBtn, function():void{
				var data:Object = _data[_chooseStoneId];
				_input.text = data.num > data.volume ? data.volume : data.num;
			});
			new BmButton(_yesBtn, function():void{
				if(!_totalCost) {
					TextMessage.showEffect('请选择矿石！', 2);
					return;
				}
				if(!_selectTrain.length){
					TextMessage.showEffect('请选择列车！', 2);
					return;		
				}
				var stone:Array = [];
				for (var sid:String in _buyStone){
					if(!_buyStone[sid]) continue;
					stone.push({'id' : sid, 'num' : _buyStone[sid]});
				}
				ModelManager.planetModel.buyPlanetStone(_pid, stone, _selectTrain, function():void{
					callback();
					closeWindow();
				});
			});
			
			_input = new BmInputBox(_buyCount, '0', -1, true, 0, 0);
			_input.onNumChange = setCount;
			
			_time.text = DateUtils.toTimeString(parseInt(Data.data.travelTime));
			
			changeTab();
			
			//新手指引
//			NewbieController.showNewBieBtn(33, 4, this, 58, 294, true, "打开选择列车窗口");
		}
		
		private function setCount(count:int):void
		{
			_buyStone[_chooseStoneId] = count;
			_storageLeft.text = (_data[_chooseStoneId].volume - count).toString();
			calcValue();
		}
	
		private function calcValue():void
		{
			var tprice:int = 0;
			var tweight:int = 0;
			for each(var one:Object in _data){
				tprice += one.price * _buyStone[one.id];
				tweight += one.weight * _buyStone[one.id];
			}
			_totalCost = tprice;
			_totalWeight = tweight;
			_coinsCost.text = tprice.toString();
			_weight.text = tweight.toString();
		}	
		
		private function showSelectTrainWin(e:MouseEvent):void
		{
			if (ViewManager.hasView(ChooseTrain.NAME)) return;
//			NewbieController.refreshNewBieBtn(33, 5);
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
			if(!_chooseStoneId){
				closeWindow();
				return;
			}
			
			var data:Object = _data[_chooseStoneId];
			
			_buyMax.text = data.num;
			_unitPrice.text = data.price;
			_storageLeft.text = (data.volume - _buyStone[_chooseStoneId]).toString();
			_input.max = data.num > data.volume ? data.volume : data.num;
			_input.text = _buyStone[_chooseStoneId];
			//新手默认数字
//			if(_chooseStoneId == 22001 && NewbieController.newbieTaskId == 33){
//				_input.text = "2500";
//				setCount(2500);
//			}
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
//					NewbieController.showNewBieBtn(33, 7, this, 234, 376, true, "确认购买");
					break;
				default:
			}
		}	
	}
}