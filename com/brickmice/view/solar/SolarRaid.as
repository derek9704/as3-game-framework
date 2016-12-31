package com.brickmice.view.solar
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.boyhero.ModifyArm;
	import com.brickmice.view.boyhero.ModifyTroops;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCheckBox;
	import com.brickmice.view.component.BmInputBox;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.utils.FilterUtils;
	
	import flash.display.MovieClip;


	public class SolarRaid extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SolarRaid";
		
		private var _mc:MovieClip;
		
		private var _startBtn:BmButton;
		private var _autoBtn:BmButton;
		private var _startChallengeBtn:BmButton;
		private var _chooseHeroBtn:BmButton;
		private var _modifyTroopBtn:BmButton;
		private var _modifyArmBtn:BmButton;
		private var _level:int;
		private var _pid:int;
		private var _pName:String;
		private var _hid:int = 0;
		private var _challengeData:Object;
		private var _img : McImage;
		private var _myInfo:Object;
		
		public function SolarRaid(pid:int, pName:String, challengeData:Object = null)
		{
			_mc = new ResSolarRaidWindow;
			super(NAME, _mc);
			
			_mc._challengeInfo.visible = false;
			_mc._heroName.filters = [FilterUtils.createGlow(0x000000, 500)];
			
			_startBtn = new BmButton(_mc._startBtn, function():void{
				//控制下一些升级提示动画暂时停止，待这里动画完成再播放
				Main.self.uiLayer.effect.stopAnim();
				ControllerManager.yahuanController.stopYahuan();
				ModelManager.solarModel.startSolarBattle(_pid, _level, _hid, function():void{
					ControllerManager.battleController.showBattle({type:3, myInfo:_myInfo, rival:Data.data.solar.levelDetail, levelName:_mc._planetName.text, pid:_pid, pName:_pName});
				});
			});
			
			_startChallengeBtn = new BmButton(_mc._challengeInfo._startChallengeBtn, function():void{
				//控制下一些升级提示动画暂时停止，待这里动画完成再播放
				Main.self.uiLayer.effect.stopAnim();
				ControllerManager.yahuanController.stopYahuan();
				ModelManager.solarModel.startSolarChallengeBattle(_pid, _level, _hid, function():void{
					ControllerManager.battleController.showBattle({type:4, myInfo:_myInfo, rival:_challengeData, levelName:_mc._planetName.text, pid:_pid, pName:_pName});
				});
			});
			
			_chooseHeroBtn = new BmButton(_mc._chooseHeroBtn, function():void{
				if (ViewManager.hasView(SolarChooseBoyHero.NAME)) return;
				NewbieController.refreshNewBieBtn(4, 5);
				NewbieController.refreshNewBieBtn(5, 5);
				var win:BmWindow = new SolarChooseBoyHero(_hid, selectHero);
				addChildCenter(win);		
			});
			
			_modifyTroopBtn = new BmButton(_mc._modifyTroopsBtn, function():void{
				if (ViewManager.hasView(ModifyTroops.NAME)) return;
				NewbieController.refreshNewBieBtn(4, 8);
				var data:Object = Data.data.boyHero[_hid];
				var modifyTroopsWin:BmWindow = new ModifyTroops(data, function():void{
					selectHero(_hid);
				});
				addChildCenter(modifyTroopsWin);
			});
			
			_modifyArmBtn = new BmButton(_mc._modifyArmBtn, function():void{
				if (ViewManager.hasView(ModifyArm.NAME)) return;
				var data:Object = Data.data.boyHero[_hid];
				var modifyArmWin:BmWindow = new ModifyArm(data, function():void{
					selectHero(_hid);
				});
				addChildCenter(modifyArmWin);			
			});
			
			new BmInputBox(_mc._proxyNum, "1", -1, true, -1, 1);
			var checkBox:BmCheckBox = new BmCheckBox(_mc._checkbox);
			
			_autoBtn = new BmButton(_mc._autoBtn, function():void{	
				var proxyNum:int = _mc._proxyNum.text;
				var autoBuy:int = checkBox.select ? 1 : 0;
				ModelManager.solarModel.startSolarProxy(_pid, _level, _hid, proxyNum, autoBuy, function():void{
					var data:Object = Data.data.solar.battleResult;
					if (ViewManager.hasView(SolarProxyWin.NAME)) return;
					var win:BmWindow = new SolarProxyWin(data);
					addChildCenter(win);		
					selectHero(_hid);
				});
			});
			
			_mc._roundAnim.gotoAndStop(44);
			
			//头像
			_img = new McImage();
			
			_mc._my.gotoAndStop(1);
			_mc._my._role.addChild(_img);
			_mc._my.mouseEnabled = _mc._my.mouseChildren = false;
			
			setData(pid, pName, challengeData);
			
			//新手指引
			NewbieController.showNewBieBtn(4, 4, this, 236, 290, true, "打开选择噩梦鼠面板");
			NewbieController.showNewBieBtn(5, 4, this, 236, 290, true, "打开选择噩梦鼠面板");
		}
		
		public function setData(pid:int, pName:String, challengeData:Object = null):void
		{
			_challengeData = challengeData;
			_pid = pid;
			_pName = pName;
			_mc._heroName.htmlText = "";
			_mc._heroLevel.text = "";
			_mc._heroTroopNum.text = "";
			_mc._heroAtk.text = "";
			_mc._heroDef.text = "";
			
			_mc._enemy.visible = true;
			_mc._my.visible = true;
			
			_startBtn.visible = false;
			_autoBtn.enable = false;
			_startChallengeBtn.visible = false;
			_chooseHeroBtn.visible = true;
			_modifyTroopBtn.visible = false;
			_modifyArmBtn.visible = false;
			
			var data:Object;
			
			if(challengeData){
				data = challengeData;
				_mc._challengeInfo.visible = true;
				_mc._challengeInfo._challengeDesc.htmlText = data['describe'];
				var chineseNum:String;
				if(data['level'] == 1) chineseNum = '一';
				else if(data['level'] == 2) chineseNum = '二';
				else if(data['level'] == 3) chineseNum = '三';
				else if(data['level'] == 4) chineseNum = '四';
				else chineseNum = '五';
				_mc._planetName.text = pName + "挑战" + chineseNum;			
				//怪物显示
				if(data['level'] < 5) {
					if(pid <= 10) _mc._enemy._role.gotoAndStop(4);
					else _mc._enemy._role.gotoAndStop(2);
				}else{
					if(pid <= 10) _mc._enemy._role.gotoAndStop(3);
					else _mc._enemy._role.gotoAndStop(5);
				}
			}else{
				data = Data.data.solar.levelDetail;
				_mc._challengeInfo.visible = false;
				_mc._planetName.text = pName + "试炼场";
				//怪物显示
				if(data['level'] == 5 || data['level'] == 10) {
					if(pid <= 10) _mc._enemy._role.gotoAndStop(4);
					else _mc._enemy._role.gotoAndStop(2);
				}else if (data['level'] == 15){
					if(pid <= 10) _mc._enemy._role.gotoAndStop(3);
					else _mc._enemy._role.gotoAndStop(5);
				}else{
					_mc._enemy._role.gotoAndStop(1);
				}
			}
			_mc._enemy.gotoAndStop(1);
			
			_mc._level.text = data.level;
			_level = data.level;
			_mc._enemyLvl.text = data.houseLevel;
			_mc._enemyTroopNum.text = data.houseTroop;
			_mc._enemyAtk.text = data.houseAtk;
			_mc._enemyDef.text = data.houseDef;
			_mc._heroPrizeExp.text = data.heroExpReward;
			_mc._coinsPrize.text = data.coinsReward;
			
			var index:int = 1;
			for each (var equip:Object in data.dropEquip) 
			{
				_mc['_prize' + index].text = equip.name;
				index++;
			}
			for (var i:int = index; i <= 3; i++) 
			{
				_mc['_prize' + i].text = "";
			}
			//默认选中英雄
			if(_hid) selectHero(_hid);
		}
		
		private function selectHero(hid:int):void
		{
			_hid = hid;
			var data:Object = Data.data.boyHero[hid];
			_myInfo = data;
			_mc._heroName.htmlText = '<font color="' + Trans.heroQualityColor[data.quality] + '">' + data.name + '</font>';
			_mc._heroTroopNum.text = data.currentTroop;
			_mc._heroLevel.text = data.level;
			_mc._heroAtk.text = data.attack;
			_mc._heroDef.text = data.defense;
			_startBtn.visible = true;
			_autoBtn.enable = true;
			if(Data.data.solar.terminal != 1){
				if(_pid == Data.data.solar.openPlanet && _level == Data.data.solar.openLevel) {
					_autoBtn.enable = false;
				}	
			}
			_startChallengeBtn.visible = true;
			_modifyTroopBtn.visible = true;
			_modifyArmBtn.visible = true;
			_mc._chooseHeroBtn._avatar.alpha = 0;
			
			_img.reload(data.img + 'b');
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
					NewbieController.showNewBieBtn(4, 10, this, 381, 278, true, "开始试炼");
					NewbieController.showNewBieBtn(5, 7, this, 381, 278, true, "开始试炼");
					NewbieController.showNewBieBtn(4, 7, this, 690, 436, true, "打开调整兵力面板");
					break;
				default:
			}
		}	
	}
}