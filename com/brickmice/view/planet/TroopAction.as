package com.brickmice.view.planet
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCountDown;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
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

	public class TroopAction extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "TroopAction";
		public static const REINFORCE : String = "reinforce";
		public static const STARTWAR : String = "startWar";
		public static const HOUSE : String = "house";
		
		private var _mc:ResPlanetTroopActionWindow;
		private var _totalWeight:TextField;
		private var _totalCarry:TextField;
		private var _targetPlanet:TextField;
		private var _detail:TextField;
		private var _time:TextField;
		private var _name:TextField;
		private var _box:MovieClip;
		private var _guildHeroBtn:MovieClip;
		private var _myHeroBtn:MovieClip;
		private var _reinforce:MovieClip;
		private var _startWar:MovieClip;
		private var _station:MovieClip;
		
		private var _dropDownList:PlanetDropDownList;
		private var _heroImg:McItem;
		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _selectTrain:Array = [];
		private var _pid:int;
		private var _hid:int = 0;
		private var _gid:int = 0;
		private var _delay:int = 0;
		private var _type:String;

		
		public function TroopAction(type:String, pid:int, data:Object = null)
		{
			_mc = new ResPlanetTroopActionWindow;
			super(NAME, _mc);
			
			_detail = _mc._detail;
			_startWar = _mc._startWar;
			_reinforce = _mc._reinforce;
			_time = _mc._time;
			_totalCarry = _mc._totalCarry;
			_targetPlanet = _mc._targetPlanet;
			_totalWeight = _mc._totalWeight;
			_station = _mc._station;
			_guildHeroBtn = _mc._guildHeroBtn;
			_myHeroBtn = _mc._myHeroBtn;
			_guildHeroBtn = _mc._guildHeroBtn;
			_name = _mc._name;
			_box = _mc._box;
			
			_guildHeroBtn.visible = false;
			
			_targetPlanet.text = Data.data.planet[pid].name;
			_pid = pid;
			_type = type;
			
			_detail.htmlText = "等级：<br>天赋：<br>军队：<br>负重：<br>军队攻击力：<br>军队防御力：";
			_time.text = "00:00:00";
			_name.text = "";
			_totalCarry.text = "";
			_totalWeight.text = "";
			_box.gotoAndStop(2);
			//头像
			_heroImg = new McItem();
			addChildEx(_heroImg, 73, 99);
			_heroImg.evts.addClick(showSelectBoyHeroWin);
			
			new BmButton(_myHeroBtn, showSelectBoyHeroWin);
			
			//初始化增援
			new BmButton(_reinforce._sentTroopsBtn, function():void{
				if(!_hid) {
					TextMessage.showEffect('请选择噩梦鼠！', 2);
					return;
				}
				if(!_selectTrain.length){
					TextMessage.showEffect('请选择列车！', 2);
					return;		
				}
				ModelManager.warModel.sendReinforceWarTroop(_pid, _hid, _gid, _selectTrain, closeWindow);
			});
			var countDown:BmCountDown = new BmCountDown(_reinforce._battleTime, 0, null, '已开战');
			
			//初始化驻扎
			new BmButton(_station._sentTroopsBtn, function():void{
				if(!_hid) {
					TextMessage.showEffect('请选择噩梦鼠！', 2);
					return;
				}
				if(!_selectTrain.length){
					TextMessage.showEffect('请选择列车！', 2);
					return;		
				}
				ModelManager.warModel.houseWar(_pid, _hid, _selectTrain, function():void{
					NewbieController.refreshNewBieBtn(22, 13);
					closeWindow();
				});
			});
			
			//初始化开战
			new BmButton(_startWar._sentTroopsBtn, function():void{
				if(!_hid) {
					TextMessage.showEffect('请选择噩梦鼠！', 2);
					return;
				}
				if(!_selectTrain.length){
					TextMessage.showEffect('请选择列车！', 2);
					return;		
				}
				ModelManager.warModel.sendStartWarTroop(_pid, _hid, _delay, _selectTrain, closeWindow);
			});
			//下拉框
			_dropDownList = new PlanetDropDownList([], function(delayTime:String):void{
				_delay = parseInt(delayTime);
			});
			
			// 列车面板
			_itemPanel = new McList(4, 1, 15, 0, 76, 95, true);
			addChildEx(_itemPanel, 53, 212);
			
			// 生成默认显示的列车ID
			var ids:Array = [];
//			var trains:Array = Data.data.railway.trains;
//			var index:int = 0;
//			for (var i:int = 0; i < trains.length; i++){
//				if(index == 4) break;
//				if(trains[i].status != 'free') continue;
//				ids.push(i);
//				index++;
//			}
			setTrains(ids);
			
			switch(type)
			{
				case REINFORCE:
				{
					_startWar.visible = false;
					_reinforce.visible = true;
					_station.visible = false;
					
					var leftTime:int = data.arriveTime - Math.floor(DateUtils.nowDateTimeByGap(Consts.timeGap));
					_gid = data.id;
					if(leftTime < 0) leftTime = 0;
					countDown.setTime(leftTime);
					countDown.startTimer();
					
					break;
				}
				case STARTWAR:
				{
					_startWar.visible = true;
					_reinforce.visible = false;
					_station.visible = false;
					
					addChildEx(_dropDownList, 209, 339);
					break;
				}	
				case HOUSE:
				{
					_startWar.visible = false;
					_reinforce.visible = false;
					_station.visible = true;
					break;
				}	
			}
			
			//新手指引
			NewbieController.showNewBieBtn(22, 9, this, 358, 180, true, "打开噩梦鼠选择面板");
		}
		
		private function showSelectTrainWin(e:MouseEvent):void
		{
			if (ViewManager.hasView(ChooseTrain.NAME)) return;
			var win:BmWindow = new ChooseTrain(_selectTrain, parseInt(_totalWeight.text), setTrains);
			addChildCenter(win);
		}
		
		private function showSelectBoyHeroWin(e:MouseEvent):void
		{
			if (ViewManager.hasView(PlanetChooseBoyHero.NAME)) return;
			var win:BmWindow;
			switch(_type)
			{
				case REINFORCE:
				{
					win = new PlanetChooseBoyHero(_hid, 0, _pid, 0, 0, setHero);
					break;
				}
				case HOUSE:
				{
					NewbieController.refreshNewBieBtn(22, 10);
					win = new PlanetChooseBoyHero(_hid, 0, _pid, 0, 0, setHero);
					break;
				}
				case STARTWAR:
				{
					win = new PlanetChooseBoyHero(_hid, 0, _pid, 0, 0, setHero);
					break;
				}
			}
			addChildCenter(win);
		}
		
		public function setHero(id:int, marchTime:int):void
		{
			_hid = id;
			var data:Object = Data.data.boyHero[id];
			_detail.htmlText = "等级：" + data.level + "<br>天赋：" + (data.talent ? data.talent.name : "无") + "<br>军队：" + data.currentTroop + "<br>负重：" + (int(data.carry) - Consts.mouseWeight * data.currentTroop).toString()
				+ "<br>军队攻击力：" + data.attack + "<br>军队防御力：" + data.defense;
			_time.text = DateUtils.toTimeString(marchTime);
			if(_type == STARTWAR){
				var delay:Array = [new KeyValue('0', "到达时间")];
				for (var i:int = 0; i < 5;) 
				{
					i += 1;
					if(i * 3600 <= marchTime) continue;
					var stime:String = i.toString();
					delay.push(new KeyValue(stime, stime + "小时后"));
				}
				_dropDownList.resetList(delay);
				_dropDownList.index = 0;
			}
			_name.text = data.name;
			_heroImg.resetImage(data.img);
			_totalWeight.text = data.weight;
			_box.gotoAndStop(1);
			//智能选择列车
			var trainArr:Array = Data.data.railway.trains;
			var ids:Array = [];
			var totalWeight:int = data.weight;
			var nowWeight:int = 0;
			for (var index:String in trainArr) {
				var one:Object = trainArr[index];
				if(one.status != 'free') continue;
				nowWeight += one.carry;
				ids.push(parseInt(index));
				if(nowWeight >= totalWeight) break;
			}
			setTrains(ids);
		}
		
		public function setTrains(ids:Array):void
		{
			_selectTrain = ids;
			_selectTrain.sort();
			
			// 生成显示的物品列表
			_items = new Vector.<DisplayObject>;
			var trains:Array = Data.data.railway.trains;
			var tcarry:int = 0;
			for (var i:int = 0; i < _selectTrain.length; i++){
				var train:Object = trains[_selectTrain[i]];
				var text:String = '载重:' + train.carry;
				var mc : McItem = new McItem(train.img, train.level, 0, true, text);
				mc.evts.addClick(showSelectTrainWin);
				tcarry += parseInt(train.carry);
				_items.push(mc);
			}
			_totalCarry.text = tcarry.toString();
			
			//处理一下为空
			if(!_items.length){
				var text2:String = '点击选择列车';
				var mc2 : McItem = new McItem('init', 0, 0, true, text2);
				mc2.evts.addClick(showSelectTrainWin);
				_items.push(mc2);		
			}
			
			_itemPanel.setItems(_items);	
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
					NewbieController.showNewBieBtn(22, 12, this, 291, 348, true, "确认发兵");
					break;
				default:
			}
		}	
	}
}