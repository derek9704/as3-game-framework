package com.brickmice.view.planet
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCountDown;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McPanel;
	import com.brickmice.view.component.McTip;
	import com.framework.core.ViewManager;
	import com.framework.utils.DateUtils;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Planet extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Planet";
		public static const MYTROOP : String = "myTroop";
		public static const ALLTROOP : String = "allTroop";
		public static const PAGESIZE : uint = 5; //驻军显示个数
		
		private var _mc:MovieClip;
		private var _exp:MovieClip;
		private var _trade:MovieClip;
		private var _planetName:TextField;
		private var _host:TextField;
		private var _lvl:TextField;
		private var _saveTime:TextField;
		private var _peaceHost:MovieClip;
		private var _peaceGuest:MovieClip;
		private var _war:MovieClip;
		
		private var _protectTime:BmCountDown;
		private var _max : int;
		private var _pid:int;
		private var _pUnion:int;
		private var _warLeftInfo:McPanel;
		private var _warRightInfo:McPanel;
		//用户显示驻军
		private var _allPageNum:int = 0;
		private var _allPage : int;	//当前页
		private var _myPageNum:int = 0;
		private var _myPage : int;	//当前页		
		private var _currentType:String;
		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _tabView : BmTabView;
		private var _selectedHero:int;
		
		public function Planet(data : Object)
		{
			_mc = new ResPlanetWindow;
			super(NAME, _mc);
			
			_exp = _mc._exp;
			_trade = _mc._trade;
			_lvl = _mc._lvl;
			_host = _mc._host;
			_planetName = _mc._planetName;
			_saveTime = _mc._trade._saveTime;
			_peaceHost = _mc._peaceHost;
			_peaceGuest = _mc._peaceGuest;
			_war = _mc._war;
			
			TipHelper.setTip(_mc._levelTxt, new McTip('决定出售奶酪价格及探索收益。在星球上驻扎部队和进行贸易都会提升繁荣度，打仗会降低繁荣度。'));
			
			_warLeftInfo = new McPanel('', 228, 161, true, true);
			addChildEx(_warLeftInfo, 113, 182);
			
			_warRightInfo = new McPanel('', 167, 161, true, true);
			addChildEx(_warRightInfo, 357, 182);
			
			//经验条
			_max = _exp.width;
			_mc._expDetailed.visible = false;
			_mc._expDetailed.mouseEnabled = _mc._exp.mouseEnabled = false;
			_mc._expBox.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_mc._expDetailed.visible = true;
			});
			_mc._expBox.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_mc._expDetailed.visible = false;
			});
			
			new BmButton(_mc._shop, function():void{
				ControllerManager.blueSunController.showBlueSun();
			});
			
			new BmButton(_trade._warDetail, function():void{
				if (ViewManager.hasView(WarInfo.NAME)) return;
				var data:Object = Data.data.planet[_pid].war;
				var warInfoWin:BmWindow = new WarInfo(data);
				addChildCenter(warInfoWin);
			});
			
			new BmButton(_trade._buyResBtn, function():void{
				if (ViewManager.hasView(BuyStone.NAME)) return;
				ModelManager.planetModel.getPlanetTravelTime(_pid, 0, 0, 1, 0, function():void{
//					NewbieController.refreshNewBieBtn(33, 4);
					var data:Object = Data.data.planet[_pid].stone;
					var buyStoneWin:BmWindow = new BuyStone(data, _pid, function():void{
						UiUtils.setButtonEnable(_trade._buyResBtn, false);
					});
					addChildCenter(buyStoneWin);
				});
			});
			
			new BmButton(_trade._sellCheeseBtn, function():void{
				if (ViewManager.hasView(SellCheese.NAME)) return;
				ModelManager.planetModel.getPlanetTravelTime(_pid, 0, 0, 1, 0, function():void{
					NewbieController.refreshNewBieBtn(26, 4);
					var data:Object = Data.data.planet[_pid].cheese;
					var sellCheeseWin:BmWindow = new SellCheese(data, _pid, function():void{
						UiUtils.setButtonEnable(_trade._sellCheeseBtn, false);
					});
					addChildCenter(sellCheeseWin);
				});
			});
			
			// 驻军面板
			_itemPanel = new McList(5, 1, 2, 0, 81, 119, true);
			addChildEx(_itemPanel, 109, 233);
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue(MYTROOP, _peaceHost._myTroop), new KeyValue(ALLTROOP, _peaceHost._allTroop));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				_currentType = id;
				setHouseData();
			});
			
			new BmButton(_peaceHost._houseBtn, function():void{
				if (ViewManager.hasView(TroopAction.NAME)) return;
				NewbieController.refreshNewBieBtn(22, 9);
				var troopActionWin:BmWindow = new TroopAction(TroopAction.HOUSE, _pid);
				addChildCenter(troopActionWin);
			});		
			
			new BmButton(_peaceHost._retreatBtn, function():void{
				if (!_selectedHero) return;
				ModelManager.warModel.retreatWar(_pid, _selectedHero, setHouseData);
			});	
			
			new BmButton(_peaceGuest._fightBtn, function():void{
				if (ViewManager.hasView(TroopAction.NAME)) return;
				var troopActionWin:BmWindow = new TroopAction(TroopAction.STARTWAR, _pid);
				addChildCenter(troopActionWin);
			});		
			
			new BmButton(_war._reinforceBtn, function():void{
				if (ViewManager.hasView(TroopAction.NAME)) return;
				if(_pUnion >= 3){
					var troopType:String = _pUnion == 4 ? TroopAction.HOUSE : TroopAction.REINFORCE;
				}else{
					troopType = _pUnion == Data.data.user.union ? TroopAction.HOUSE : TroopAction.REINFORCE;
				}
				var troopActionWin:BmWindow = new TroopAction(troopType, _pid, {'arriveTime' : 0, 'id' : 0});
				addChildCenter(troopActionWin);
			});	
			
			new BmButton(_war._seekHelpBtn, function():void{
				if (ViewManager.hasView(BlueSunHelp.NAME)) return;
				var helpWin:BmWindow = new BlueSunHelp(_pid, Data.data.planet[_pid].war.blueSun, function():void{
					ModelManager.planetModel.getPlanetData(_pid, function():void{
						setData(_pid);
					});
				});
				addChildCenter(helpWin);
			});		
			
			TipHelper.setTip(_war._seekHelpBtn, new McTip("召唤NPC帮忙，将获5倍荣誉值"));
			
			new BmButton(_peaceHost._leftNext, function():void{
				if(_currentType == MYTROOP){
					_myPage--;
					setHouseData();
				}else{
					_allPage--;
					ModelManager.planetModel.getHouseHeroInfo(_pid, _allPage, setHouseData);						
				}
			});		
			
			new BmButton(_peaceHost._Next, function():void{
				if(_currentType == MYTROOP){
					_myPage++;
					setHouseData();
				}else{
					_allPage++;
					ModelManager.planetModel.getHouseHeroInfo(_pid, _allPage, setHouseData);						
				}
			});		
			
			new BmButton(_peaceGuest._spyBtn1, function():void{
				ModelManager.planetModel.detectPlanet(_pid, 1, function():void{
					UiUtils.setButtonEnable(_peaceGuest._spyBtn1, false);
					var troopCount:String = Data.data.planet[_pid].houseInfo.troopCount
					if(!troopCount) troopCount = '0';
					_peaceGuest._Troops.text = troopCount;
				});
			});		
			
			new BmButton(_peaceGuest._spyBtn2, function():void{
				ModelManager.planetModel.detectPlanet(_pid, 2, function():void{
					UiUtils.setButtonEnable(_peaceGuest._spyBtn2, false);
					var totalAttack:String = Data.data.planet[_pid].houseInfo.totalAttack
					if(!totalAttack) totalAttack = '0';
					_peaceGuest._dps.text = totalAttack;
				});
			});		
			
			new BmButton(_peaceGuest._spyBtn3, function():void{
				ModelManager.planetModel.detectPlanet(_pid, 3, function():void{
					UiUtils.setButtonEnable(_peaceGuest._spyBtn3, false);
					var totalMouse:String = Data.data.planet[_pid].houseInfo.totalMouse
					if(!totalMouse) totalMouse = '0';
					_peaceGuest._Defense.text = totalMouse;
				});
			});		
			
			_peaceGuest._spyCost1.text = "1";
			_peaceGuest._spyCost2.text = "10";
			_peaceGuest._spyCost3.text = "20";
			
			setData(data.pid);
			
			//新手指引
			NewbieController.showNewBieBtn(26, 3, this, 472, 197, true, "打开奶酪的出售窗口");
			NewbieController.showNewBieBtn(22, 8, this, 444, 384, true, "打开驻扎军队面板");
//			NewbieController.showNewBieBtn(33, 3, this, 472, 150, true, "打开购买矿石窗口");
		}
		
		private function setMyHero(mc : HouseSlot, data:Object):void
		{
			mc.evts.addClick(function():void{
				UiUtils.setButtonEnable(_peaceHost._retreatBtn, true);
				_selectedHero = data.hid;
				
				for each (var everyItem:DisplayObject in _items)
				{
					(everyItem as HouseSlot).borderLight = false;
				}
				mc.borderLight = true;
			});
		}
		
		// 生成显示的驻军列表
		public function setHouseData():void
		{
			UiUtils.setButtonEnable(_peaceHost._retreatBtn, false);
			_items = new Vector.<DisplayObject>;
			
			if(_currentType == MYTROOP){
				UiUtils.setButtonEnable(_peaceHost._leftNext, _myPage > 1);
				UiUtils.setButtonEnable(_peaceHost._Next, _myPage < _myPageNum);
				
				var items:Array = Data.data.planet[_pid].troop;
				
				//长度
				var len:int = items.length;
				// 起始物品位置
				var start:int = (_myPage - 1) * PAGESIZE;
				// 结束物品位置
				var max:int = start + PAGESIZE;
				// 遍历所有物品
				for (var i : int = start; i < max; i++)
				{
					if (i < len)
					{
						var mc : HouseSlot = new HouseSlot(items[i]);
						setMyHero(mc, items[i]);
						_items.push(mc);
					}
				}		
			}else{
				UiUtils.setButtonEnable(_peaceHost._leftNext, _allPage > 1);
				UiUtils.setButtonEnable(_peaceHost._Next, _allPage < _allPageNum);		
				for each(var one:Object in Data.data.planet[_pid].houseInfo.detail){
					var mc2 : HouseSlot = new HouseSlot(one, true);
					_items.push(mc2);
				}
			}
			
			_itemPanel.setItems(_items);	
		}
		
		public function setData(pid:int) : void
		{
			//关闭子窗口
			if (ViewManager.hasView(WarInfo.NAME)) (ViewManager.retrieveView(WarInfo.NAME) as WarInfo).closeWindow();
			if (ViewManager.hasView(BuyStone.NAME)) (ViewManager.retrieveView(BuyStone.NAME) as BuyStone).closeWindow();
			if (ViewManager.hasView(SellCheese.NAME)) (ViewManager.retrieveView(SellCheese.NAME) as SellCheese).closeWindow();
			if (ViewManager.hasView(TroopAction.NAME)) (ViewManager.retrieveView(TroopAction.NAME) as TroopAction).closeWindow();
			
			_pid = pid;
			var data:Object = Data.data.planet[_pid];
			_planetName.text = data.name;
			_host.text = data.unionName;
			_pUnion = data.union;
			_lvl.text = data.level;
			
			_exp.width = data.exp / data.upgradeExp * _max;
			var msg:String = data.exp + ' / ' + data.upgradeExp + '  (' + (int(data.exp) * 100 / int(data.upgradeExp)).toFixed(2).toString()  + '%)';
			_mc._expDetailed.text = msg;
			
			_saveTime.text = "--:--:--";
			_protectTime = new BmCountDown(_saveTime, data.protectCD.leftTime, function():void{
				UiUtils.setButtonEnable(_peaceGuest._fightBtn, true);
			});
			_protectTime.startTimer();
			
			if(data.id < 3000){
				_mc._shop.visible = false;
			}
			
			//判断显示模式
			if(data.status == 'free'){
				//和平期
				_trade.visible = true;
				_war.visible = false;
				_warLeftInfo.visible = false;
				_warRightInfo.visible = false;
				TipHelper.clear(_trade._buyResBtn);
				TipHelper.clear(_trade._sellCheeseBtn);
				//战争详情按钮
				UiUtils.setButtonEnable(_trade._warDetail, data.war != null);
				//排序矿石
				var items:Array = [];
				for each(var k:Object in data.stone) items.push(k);
				items.sortOn("level", Array.NUMERIC);
				//显示矿石
				_trade._res1.text = items[0]['name'];
				_trade._resCoinsCost1.text = items[0]['price'];
				_trade._res2.text = items[1]['name'];
				_trade._resCoinsCost2.text = items[1]['price'];
				_trade._res3.text = items[2]['name'];
				_trade._resCoinsCost3.text = items[2]['price'];
				//排序奶酪
				items = [];
				for each(var k2:Object in data.cheese) items.push(k2);
				items.sortOn("level", Array.NUMERIC);
				//显示奶酪
				_trade._cheese1.text = items[0]['name'];
				_trade._cheesePrice1.text = items[0]['price'];
				_trade._cheese2.text = items[1]['name'];
				_trade._cheesePrice2.text = items[1]['price'];
				_trade._cheese3.text = items[2]['name'];
				_trade._cheesePrice3.text = items[2]['price'];
				
				if(Data.data.user.union == data.union || data.union == 4){
					//我方
					if(data.buyCD.leftTime){
						var txt1:String = "购买冷却剩余时间：" + DateUtils.toTimeString(parseInt(data.buyCD.leftTime));
						TipHelper.setTip(_trade._buyResBtn, new McTip(txt1));
						UiUtils.setButtonEnable(_trade._buyResBtn, false);
					}else {
						UiUtils.setButtonEnable(_trade._buyResBtn, true);
					}
					if(data.sellCD.leftTime){
						var txt3:String = "出售冷却剩余时间：" + DateUtils.toTimeString(parseInt(data.sellCD.leftTime));
						TipHelper.setTip(_trade._sellCheeseBtn, new McTip(txt3));
						UiUtils.setButtonEnable(_trade._sellCheeseBtn, false);
					}else {
						UiUtils.setButtonEnable(_trade._sellCheeseBtn, true);
					}
					
					UiUtils.setButtonEnable(_peaceHost._retreatBtn, false);
					_peaceGuest.visible = false;
					_peaceHost.visible = true;
					_itemPanel.visible = true;
					
					_allPageNum = Math.ceil(data.houseInfo.troopCount / PAGESIZE);
					_myPageNum = Math.ceil(data.troop.length / PAGESIZE);
					_myPage = _allPage = 1;
					
					//默认TAB
					_tabView.selectId = MYTROOP;
					_currentType = MYTROOP;
					// 生成显示的驻军列表
					setHouseData();
					
				}else{
					//他方
					UiUtils.setButtonEnable(_trade._buyResBtn, false);
					UiUtils.setButtonEnable(_trade._sellCheeseBtn, false);
					//判断已发起过战争的，则不能再次发起
					if(data.startFightFlag == 1){
						UiUtils.setButtonEnable(_peaceGuest._fightBtn, false);
						TipHelper.setTip(	_peaceGuest._fightBtn, new McTip('一个玩家对一个星球同时只能主动发起一次攻击，如需增援，请打开战争预警面板。'));	
					}else{
						UiUtils.setButtonEnable(_peaceGuest._fightBtn, true);
						TipHelper.clear(_peaceGuest._fightBtn);
					}
					if(data.protectCD.leftTime)
						UiUtils.setButtonEnable(_peaceGuest._fightBtn, false);

					_peaceGuest.visible = true;
					_peaceHost.visible = false;
					_itemPanel.visible = false;
					
					_peaceGuest._Troops.text = '';
					_peaceGuest._dps.text = '';
					_peaceGuest._Defense.text = '';
					
					var detectInfo:Object = data.detect;
					for (var i:int = 1; i <= 3; i++) 
					{
						var spyBtn:MovieClip = _peaceGuest['_spyBtn' + i.toString()];
						TipHelper.clear(spyBtn);
						if(!detectInfo[i] || detectInfo[i]['leftTime'] == 0) 
							UiUtils.setButtonEnable(spyBtn, true);
						else {
							UiUtils.setButtonEnable(spyBtn, false);
							var txt2:String = "剩余可用刺探时间：" + DateUtils.toTimeString(parseInt(detectInfo[i]['leftTime']));
							TipHelper.setTip(spyBtn, new McTip(txt2));
							switch(i)
							{
								case 1:
								{
									if(!data.houseInfo.troopCount) data.houseInfo.troopCount = 0;
									_peaceGuest._Troops.text = data.houseInfo.troopCount;
									break;
								}
								case 2:
								{
									if(!data.houseInfo.totalAttack) data.houseInfo.totalAttack = 0;
									_peaceGuest._dps.text = data.houseInfo.totalAttack;
									break;
								}
								case 3:
								{
									if(!data.houseInfo.totalMouse) data.houseInfo.totalMouse = 0;
									_peaceGuest._Defense.text = data.houseInfo.totalMouse;
									break;
								}
							}
						}			
					}
				}
			}else{
				//战争期
				_war.visible = true;
				_warLeftInfo.visible = true;
				_warRightInfo.visible = true;
				_trade.visible = false;
				_peaceHost.visible = false;
				_peaceGuest.visible = false;
				_itemPanel.visible = false;
				
				var bmCd:BmCountDown = new BmCountDown(_war._countDown, data.war.leftTime, function():void{
					ModelManager.planetModel.getPlanetData(_pid, function():void{
						setData(_pid);
					});
				});
				bmCd.startTimer();
				
				if(Data.data.user.union == data.union || data.union == 4){
					_war._ourTroops.text = data.war.defLeftMouse;
					_war._enemyForces.text = data.war.atkLeftMouse;
				}else{
					_war._ourTroops.text = data.war.atkLeftMouse;
					_war._enemyForces.text = data.war.defLeftMouse;			
				}
				_war._round.text = data.war.round;
				
				var tf : TextFormat = new TextFormat();
				tf.size = 12;
				tf.color = 0x000000;
				tf.leading = 2;
				tf.font = 'SimSun';
				
				var leftTxt:TextField = new TextField;
				leftTxt.defaultTextFormat = tf;
				leftTxt.autoSize = TextFieldAutoSize.LEFT;
				leftTxt.mouseEnabled = false;
				leftTxt.multiline = true;
				
				var detail:Array = data.war.detail;
				detail.reverse();
				for each (var battle:Object in detail) 
				{
					leftTxt.htmlText += "回合" + battle.round 
						+ "<br>攻击方：" + data.war.attacker + " 损失" + battle.atkMouseLose + "兵力<br>攻击力：" 
						+ battle.atkOutputAttack + "<br>防御力：" + battle.atkOutputDefense
						+ "<br>参战兵力：" + battle.atkTotalMouse +  "<br>参战部队：" + battle.atkTotalTroop
						+ "<br>防御方：" + data.war.defenser + " 损失" 
						+ battle.defMouseLose + "兵力<br>攻击力：" + battle.defOutputAttack + "<br>防御力：" + battle.defOutputDefense
						+ "<br>参战兵力：" + battle.defTotalMouse +  "<br>参战部队：" + battle.defTotalTroop
						+ "<br>-----------------------------------<br>";
				}
				_warLeftInfo.panel.removeAllChildren();
				_warLeftInfo.addItem(leftTxt);
				
				var rightTxt:TextField = new TextField;
				rightTxt.defaultTextFormat = tf;
				rightTxt.autoSize = TextFieldAutoSize.LEFT;
				rightTxt.mouseEnabled = false;
				rightTxt.multiline = true;
				
				var now:int = Math.floor(DateUtils.nowDateTimeByGap(Consts.timeGap));
				
				for each (var troop:Object in data.troop) 
				{
					rightTxt.htmlText += "<font color='#FF0000'>我的" + troop.heroName + "<br>兵力：" + troop.leftMouse + " / " + troop.mouseCount + "<br>攻" 
						+ troop.leftAttack + " 防" + troop.leftDefense;
					if(troop.arriveTime - now > 0){
						rightTxt.htmlText += "到达时间：" + DateUtils.toTimeString(troop.arriveTime - now);
					}
					rightTxt.htmlText += "</font>-------------------------<br>";
				}
				for each (troop in data.war.unionTroop) 
				{
					rightTxt.htmlText += "<font color='#000000'>" + troop.username + "的" + troop.heroName + "<br>兵力：" + troop.leftMouse + " / " + troop.mouseCount + "<br>攻" 
						+ troop.leftAttack + " 防" + troop.leftDefense;
					if(troop.arriveTime - now > 0){
						rightTxt.htmlText += "到达时间：" + DateUtils.toTimeString(troop.arriveTime - now);
					}
					rightTxt.htmlText += "</font>-------------------------<br>";
				}
				_warRightInfo.panel.removeAllChildren();
				_warRightInfo.addItem(rightTxt);
			}
		}
	}
}