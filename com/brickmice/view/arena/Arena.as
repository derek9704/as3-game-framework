package com.brickmice.view.arena
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.boyhero.ModifyArm;
	import com.brickmice.view.boyhero.ModifyTroops;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCountDown;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McTip;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.utils.DateUtils;
	import com.framework.utils.FilterUtils;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class Arena extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Arena";
		
		private static var TYPE:int = 1;
		
		private var _mc:MovieClip;
		private var _deathAnim1:MovieClip;
		private var _deathAnim2:MovieClip;
		private var _deathAnim21:MovieClip;
		private var _deathAnim22:MovieClip;
		
		private var _startBtn:BmButton;
		private var _nextRivalBtn:BmButton;
		private var _clearCDBtn:BmButton;
		private var _chooseHeroBtn:BmButton;
		private var _modifyTroopBtn:BmButton;
		private var _modifyArmBtn:BmButton;
		private var _gotoSoloBtn:BmButton;
		private var _gotoTeamBtn:BmButton;

		private var _hid:int = 0;
		private var _step:int = 0;
		private var _timeoutId:int = 0;
		private var _img : McImage;
		private var _img2 : McImage;
		private var _countDown:BmCountDown
		
		private var _myTeam:Array;
		private var _enemyTeam:Array;
		private var _myIndex:int;
		private var _enemyIndex:int;
		private var _myTeamImg:Array = [];
		private var _enemyTeamImg:Array = [];
		private var _rivalInfo:Object;
		private var _myInfo:Object;
		
		public function Arena(data : Object)
		{
			_mc = new ResArenaWindow;
			super(NAME, _mc);
			
			_mc._myHeroName.filters = [FilterUtils.createGlow(0x000000, 500)];
			_mc._enemyHeroName.filters = [FilterUtils.createGlow(0x000000, 500)];
			
			_mc._openScene.gotoAndStop(1);
			_mc._openScene.scrollRect = new Rectangle(0, 0, 764, 397);
			_mc._openScene.addFrameScript(7, function():void{
				_mc._openScene.stop();
				_mc._openScene.visible = false;
				_step = 0;
				timerHandler();
			});
			
			_startBtn = new BmButton(_mc._startBtn, function():void{
				//控制下一些升级提示动画暂时停止，待这里动画完成再播放
				Main.self.uiLayer.effect.stopAnim();
				ControllerManager.yahuanController.stopYahuan();
				if(TYPE == 1){
					ModelManager.arenaModel.startArenaBattle(_hid, function():void{
						NewbieController.hideNewBieBtn();
						ControllerManager.battleController.showBattle({type:1, myInfo:_myInfo, rival:_rivalInfo});
					});	
				}else{
					ModelManager.arenaModel.startTeamArenaBattle(function():void{
						_mc._openScene.gotoAndPlay(1);	
						_startBtn.visible = false;
						_nextRivalBtn.enable = false;
						_clearCDBtn.enable = false;
						_gotoSoloBtn.enable = false;
					});	
				}
			});
			
			_gotoTeamBtn = new BmButton(_mc._gotoTeamBtn, function():void{
				TYPE = 2;
				setData();
			});
			
			_gotoSoloBtn = new BmButton(_mc._gotoSoloBtn, function():void{
				TYPE = 1;
				setData();
			});
			
			_chooseHeroBtn = new BmButton(_mc._chooseHeroBtn, function():void{
				if (ViewManager.hasView(ArenaChooseBoyHero.NAME)) return;
				NewbieController.refreshNewBieBtn(2, 3);
				var win:BmWindow = new ArenaChooseBoyHero(_hid, selectHero);
				addChildCenter(win);		
			});
			
			_modifyTroopBtn = new BmButton(_mc._modifyTroopsBtn, function():void{
				if (ViewManager.hasView(ModifyTroops.NAME)) return;
				NewbieController.refreshNewBieBtn(2, 6);
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
			
			_nextRivalBtn = new BmButton(_mc._nextRival, function():void{
				if(TYPE == 1)
					ModelManager.arenaModel.nextArenaRival(setData);
				else
					ModelManager.arenaModel.nextTeamArenaRival(setData);
			});
			
			_clearCDBtn = new BmButton(_mc._clearCD, function():void{
				ConfirmMessage.callBack = setData;
				ModelManager.arenaModel.confirmClearArenaCD();
			});
			
			_countDown = new BmCountDown(_mc._cdTime, 0, function():void{
				_clearCDBtn.enable = false;
			});
			_countDown.everyTimeHandler = function():void{
				if(_countDown.nowTime > 3600) _countDown.textColor = 0xa40000;
				else _countDown.textColor = 0x22ac38;
			};
			
			this.evts.removedFromStage(function():void{
				if (_timeoutId)
					clearTimeout(_timeoutId);
				//允许播放升级提示动画
				Main.self.uiLayer.effect.playAnim();
				ControllerManager.yahuanController.continueYahuan();
			});
			
			_deathAnim1 = new ResArenaDeathAnim;
			_deathAnim1.gotoAndStop(28);
			addChildEx(_deathAnim1, 692, 182);
			
			_deathAnim2 = new ResArenaDeathAnim;
			_deathAnim2.gotoAndStop(28);
			addChildEx(_deathAnim2, 142, 182);
			
			_deathAnim21 = new ResArenaDeathAnim2;
			_deathAnim21.gotoAndStop(28);
			addChildEx(_deathAnim21, 842, 210);
			
			_deathAnim22 = new ResArenaDeathAnim2;
			_deathAnim22.gotoAndStop(28);
			addChildEx(_deathAnim22, 275, 210);
			
			_mc._roundAnim.gotoAndStop(44);
			
			//头像
			_img = new McImage();
			_img2 = new McImage();
			
			_mc._my.gotoAndStop(1);
			_mc._my._role.addChild(_img);
			_mc._my.mouseEnabled = _mc._my.mouseChildren = false;
			
			_mc._enemy.gotoAndStop(1);
			_mc._enemy._role.addChild(_img2);
			_mc._enemy.mouseEnabled = _mc._enemy.mouseChildren = false;
			
			//我的信息
			_mc._myName.text = Data.data.user.name;
			_mc._myUnion.gotoAndStop(Data.data.user.union);
			
			//团战头像
			var imageLayer:Array = [8, 4, 10, 3, 6, 1, 2, 9, 7, 5];
			for each (var i:int in imageLayer) 
			{
				var img:McImage = new McImage();
				var img2:McImage = new McImage();
				switch(i)
				{
					case 1:
					{
						img.x = 189.5;
						img.y = 85.05;
						break;
					}
					case 2:
					{
						img.x = 120.5;
						img.y = 119.05;
						break;
					}
					case 3:
					{
						img.x = 129.55;
						img.y = 27.95;
						break;
					}
					case 4:
					{
						img.x = 210.6;
						img.y = 24.1;
						break;
					}
					case 5:
					{
						img.x = 156.5;
						img.y = 175.1;
						break;
					}
					case 6:
					{
						img.x = 42.5;
						img.y = 89.1;
						break;
					}
					case 7:
					{
						img.x = 53.5;
						img.y = 193.55;
						break;
					}
					case 8:
					{
						img.x = 57.05;
						img.y = 0;
						break;
					}
					case 9:
					{
						img.x = 9;
						img.y = 151.8;
						break;
					}
					case 10:
					{
						img.x = 0;
						img.y = 33.9;
						break;
					}
				}
				_mc._openScene._myTeam.addChild(img);
				_myTeamImg[i - 1] = img;
				
				img2.x = img.x;
				img2.y = img.y;
				_mc._openScene._enemyTeam.addChild(img2);
				_enemyTeamImg[i - 1] = img2;
			}
			
			
			setData();
			
			//新手指引
			NewbieController.showNewBieBtn(2, 2, this, 236, 290, true, "打开选择噩梦鼠面板");
		}
		
		public function setData():void
		{
			if (ViewManager.hasView(ArenaChooseBoyHero.NAME)) {
				(ViewManager.retrieveView(ArenaChooseBoyHero.NAME) as ArenaChooseBoyHero).closeWindow();
			}
			var data:Object = Data.data.arena;
			var info:Object = data['myInfo'];
			var enemyInfo:Object;
			_mc._myHeroName.htmlText = "";
			_mc._myHeroCrit.text = "";
			_mc._myHeroTroop.text = "";
			_mc._myHeroAtk.text = "";
			_mc._myHeroDef.text = "";
			
			if(TYPE == 1){
				_mc._openScene.visible = false;
				_gotoSoloBtn.visible = false;
				_gotoTeamBtn.visible = true;				
				_chooseHeroBtn.visible = true;
				_gotoTeamBtn.enable = true;
				if(Data.data.user.honorLevel < 5){
					_gotoTeamBtn.enable = false;
					TipHelper.setTip(_mc._gotoTeamBtn, new McTip("荣誉等级5级开启"));
				}
				_modifyTroopBtn.enable = false;
				_modifyArmBtn.enable = false;
				_modifyTroopBtn.visible = true;
				_modifyArmBtn.visible = true;
				_mc._bg.gotoAndStop(1);
				
				_rivalInfo = enemyInfo = data['rivalInfo'];
				_mc._enemyHeroName.htmlText = '<font color="' + Trans.heroQualityColor[enemyInfo.heroQuality] + '">' + enemyInfo.heroName + '</font>';
				_mc._enemyHeroCrit.text = enemyInfo.heroCrit + '%';
				_mc._enemyHeroTroop.text = enemyInfo.heroTroop;
				_mc._enemyHeroAtk.text = enemyInfo.heroAtk;
				_mc._enemyHeroDef.text = enemyInfo.heroDef;
				_img2.reload(enemyInfo.heroImg + 'b');
				
				_mc._myRate.text = '';
				_startBtn.visible = false;
				_img.reload('init');
				
				if(int(enemyInfo.winnum) + int(enemyInfo.losenum) == 0){
					var winrate:String = '0.0%';
				}else{
					winrate = (int(enemyInfo.winnum) / (int(enemyInfo.winnum) + int(enemyInfo.losenum)) * 100).toFixed(1).toString() + '%';
				}
				_mc._enemyRate.text = winrate;
			}else{
				_gotoSoloBtn.visible = true;
				_gotoTeamBtn.visible = false;	
				_chooseHeroBtn.visible = false;
				_modifyTroopBtn.visible = false;
				_modifyArmBtn.visible = false;
				_nextRivalBtn.enable = true;
				_gotoSoloBtn.enable = true;
				_mc._bg.gotoAndStop(2);
				_mc._openScene.gotoAndStop(1);
				_mc._openScene.visible = true;
				
				_myIndex = _enemyIndex = 0;
				_mc._myRate.text = info.rank;
				
				_rivalInfo = enemyInfo = data['teamRivalInfo'];
				_enemyTeam = enemyInfo['heroArr'];
				var single:Object = _enemyTeam[0];
				_mc._enemyHeroName.htmlText = '<font color="' + Trans.heroQualityColor[single.heroQuality] + '">' + single.heroName + '</font>';
				_mc._enemyHeroCrit.text = single.heroCrit + '%';
				_mc._enemyHeroTroop.text = single.heroTroop;
				_mc._enemyHeroAtk.text = single.heroAtk;
				_mc._enemyHeroDef.text = single.heroDef;
				_mc._enemyRate.text = enemyInfo.rank;
				_img2.reload(single.heroImg + 'b');
				for (var i:int = 0; i < _enemyTeamImg.length; i++) 
				{
					if(i < _enemyTeam.length){
						data = _enemyTeam[i];
						_enemyTeamImg[i].reload(data.heroImg + 'b');
						TipHelper.setTip(_enemyTeamImg[i], new McTip('<font color="' + Trans.heroQualityColor[data.heroQuality] + '">' + data.heroName + '</font><br>暴击：' + data.heroCrit + '%<br>兵力：' + data.heroTroop + '<br>攻击：' + data.heroAtk + '<br>防御：' + data.heroDef));
					}else{
						_enemyTeamImg[i].reload('init');
						TipHelper.clear(_enemyTeamImg[i]);
					}
				}
				
				//放入自己的噩梦鼠
				data = Data.data.boyHero;
				_myTeam = [];
				var heroArr:Array = [];
				for(var k:String in data) heroArr.push(data[k]);
				heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
				for each(var one:Object in heroArr) {
					if(one.status != 'free') continue;
					if(one.currentTroop == 0) continue;
					_myTeam.push(one);
				}
				_startBtn.visible = true;
				if(_myTeam.length > 0) {
					data = _myTeam[0];
					_mc._myHeroName.htmlText = '<font color="' + Trans.heroQualityColor[data.quality] + '">' + data.name + '</font>';
					_mc._myHeroTroop.text = data.currentTroop;
					_mc._myHeroCrit.text = data.crit + '%';
					_mc._myHeroAtk.text = data.attack;
					_mc._myHeroDef.text = data.defense;
					_img.reload(data.img + 'b');	
					for (i = 0; i < _myTeamImg.length; i++) 
					{
						if(i < _myTeam.length){
							data = _myTeam[i];
							_myTeamImg[i].reload(data.img + 'b');
							TipHelper.setTip(_myTeamImg[i], new McTip('<font color="' + Trans.heroQualityColor[data.quality] + '">' + data.name + '</font><br>暴击：' + data.crit + '%<br>兵力：' + data.currentTroop + '<br>攻击：' + data.attack + '<br>防御：' + data.defense));
						}else{
							_myTeamImg[i].reload('init');
							TipHelper.clear(_myTeamImg[i]);
						}
					}
				}else{
					_img.reload('init');
				}
			}
			
			_mc._enemy.visible = true;
			_mc._my.visible = true;
			
			if (_timeoutId)
				clearTimeout(_timeoutId);

			_mc._coins.text = info.nextRivalCost;
			
			var leftTime:int = info.cdTime - Math.floor(DateUtils.nowDateTimeByGap(Consts.timeGap));
			if(leftTime < 0) {
				leftTime = 0;
				_clearCDBtn.enable = false;
			}else{
				_clearCDBtn.enable = true;
			}
			_countDown.setTime(leftTime);
			_countDown.startTimer();
			
			_mc._enemyName.text = enemyInfo.userName;
			_mc._enemyUnion.gotoAndStop(enemyInfo.union);

			_mc._honorReward.text = enemyInfo.honorReward;
			_mc._heroExpReward.text = enemyInfo.heroExpReward;

			//默认选中英雄
			if(_hid && TYPE == 1) selectHero(_hid);
		}
		
		private function selectHero(hid:int):void
		{
			_hid = hid;
			var data:Object = Data.data.boyHero[hid];
			_myInfo = data;
			_mc._myHeroName.htmlText = '<font color="' + Trans.heroQualityColor[data.quality] + '">' + data.name + '</font>';
			_mc._myHeroTroop.text = data.currentTroop;
			_mc._myHeroCrit.text = data.crit + '%';
			_mc._myHeroAtk.text = data.attack;
			_mc._myHeroDef.text = data.defense;
			_startBtn.visible = true;
			_modifyTroopBtn.enable = true;
			_modifyArmBtn.enable = true;
			_nextRivalBtn.enable = true;
			_mc._chooseHeroBtn._avatar.alpha = 0;
			_img.reload(data.img + 'b');
			
			var info:Object = Data.data.arena.heroInfo;
			if(int(info.winnum) + int(info.losenum) == 0){
				var winrate:String = '0.0%';
			}else{
				winrate = (int(info.winnum) / (int(info.winnum) + int(info.losenum)) * 100).toFixed(1).toString() + '%';
			}
			_mc._myRate.text = winrate;
		}
		
		private function timerHandler() : void
		{
			var data:Object = Data.data.arena.battleResult;
			var length:int = data.detail.length;
			if(_step == length) {
				if(data.result == 1){
					_mc._enemy.visible = false;
				}else{
					_mc._my.visible = false;
				}
				_timeoutId = setTimeout(gameOver, 350);
				return;
			}
			
			var heroData:Object;
			if(TYPE == 2){
				var battle:Object = Data.data.arena.battleResult.detail[_step];
				if(battle['atkHeroIndex'] != _myIndex){
					_myIndex = battle['atkHeroIndex'];
					heroData = _myTeam[battle['atkHeroIndex']];
					_mc._myHeroName.htmlText = '<font color="' + Trans.heroQualityColor[heroData.quality] + '">' + heroData.name + '</font>';
					_mc._myHeroTroop.text = heroData.currentTroop;
					_mc._myHeroCrit.text = heroData.crit + '%';
					_mc._myHeroAtk.text = heroData.attack;
					_mc._myHeroDef.text = heroData.defense;
					_img.reload(heroData.img + 'b');	
				}
				if(battle['defHeroIndex'] != _enemyIndex){
					_enemyIndex = battle['defHeroIndex'];
					heroData = _enemyTeam[battle['defHeroIndex']];
					_mc._enemyHeroName.htmlText = '<font color="' + Trans.heroQualityColor[heroData.heroQuality] + '">' + heroData.heroName + '</font>';
					_mc._enemyHeroTroop.text = heroData.heroTroop;
					_mc._enemyHeroCrit.text = heroData.heroCrit + '%';
					_mc._enemyHeroAtk.text = heroData.heroAtk;
					_mc._enemyHeroDef.text = heroData.heroDef;
					_img2.reload(heroData.heroImg + 'b');	
				}	
			}
			
			_mc._roundAnim.gotoAndStop(1);
			_mc._roundAnim._anim._round.text = (_step + 1).toString();
			_mc._roundAnim.play();
			
			_timeoutId = setTimeout(timerHandler2, 400);
		}
		
		private function timerHandler2() : void
		{	
			
			var one:Object = Data.data.arena.battleResult.detail[_step];
			
			//动画
			if(one.atkIsCrit == 1){
				_deathAnim21._bg._count.text = one.defMouseLose;
				_deathAnim21.gotoAndPlay(1);
			}else{
				_deathAnim1._bg._count.text = one.defMouseLose;
				_deathAnim1.gotoAndPlay(1);
			}
			if(one.defIsCrit == 1){
				_deathAnim22._bg._count.text = one.atkMouseLose;
				_deathAnim22.gotoAndPlay(1);		
			}else{
				_deathAnim2._bg._count.text = one.atkMouseLose;
				_deathAnim2.gotoAndPlay(1);			
			}
			
			_mc._enemyHeroTroop.text = one.defLeftMouse;
			_mc._enemyHeroAtk.text = one.defLeftAttack;
			_mc._enemyHeroDef.text = one.defLeftDefense;
			_mc._myHeroTroop.text = one.atkLeftMouse;
			_mc._myHeroAtk.text = one.atkLeftAttack;
			_mc._myHeroDef.text = one.atkLeftDefense;
						
			_mc._my.play();
			_mc._enemy.play();
			
			_step++;
			
			_timeoutId = setTimeout(timerHandler, 600);
		}
		
		private function gameOver():void
		{
			var data:Object = Data.data.arena.battleResult;
			if (_timeoutId)
				clearTimeout(_timeoutId);
			//通知玩家
			if(data.result == 1){
				if (ViewManager.hasView(ArenaWin.NAME)) return;
				var win:BmWindow = new ArenaWin(data);
				addChildCenter(win);		
			}else{
				if (ViewManager.hasView(ArenaLose.NAME)) return;
				var win2:BmWindow = new ArenaLose(data);
				addChildCenter(win2);
				var msg2:Array = [
					"失败了，别气馁~试着强化一下装备吧~",
					"对手太强大了~不如《换一个对手》试试？",
					"你的噩梦鼠不够强大哦~配上高级军需试试？"
				];
				var num:int = Math.round(Math.random() * (msg2.length - 1));
				ControllerManager.yahuanController.showYahuan(msg2[num], 2);
			}
			//允许播放升级提示动画
			Main.self.uiLayer.effect.playAnim();
			ControllerManager.yahuanController.continueYahuan();
			return;
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
					NewbieController.showNewBieBtn(2, 5, this, 690, 436, true, "打开调整兵力面板");
					NewbieController.showNewBieBtn(2, 8, this, 381, 278, true, "开始挑战");
					break;
				default:
			}
		}	
	}
}