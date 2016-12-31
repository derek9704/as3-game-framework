package com.brickmice.view.boss
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.boyhero.ModifyArm;
	import com.brickmice.view.boyhero.ModifyTroops;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCountDown;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.core.ViewManager;
	import com.framework.utils.DateUtils;
	import com.framework.utils.FilterUtils;
	
	import flash.display.MovieClip;

	public class Boss extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Boss";
		
		private var _mc:MovieClip;
		
		private var _startBtn:BmButton;
		private var _clearCDBtn:BmButton;
		private var _chooseHeroBtn:BmButton;
		private var _modifyTroopBtn:BmButton;
		private var _modifyArmBtn:BmButton;

		private var _hid:int = 0;
		private var _img : McImage;
		private var _img2 : McImage;
		private var _countDown:BmCountDown

		private var _rivalInfo:Object;
		private var _myInfo:Object;
		
		public function Boss(data : Object)
		{
			_mc = new ResBossWindow;
			super(NAME, _mc);
			
			_mc._myHeroName.filters = [FilterUtils.createGlow(0x000000, 500)];
			_mc._enemyHeroName.filters = [FilterUtils.createGlow(0x000000, 500)];

			_startBtn = new BmButton(_mc._startBtn, function():void{
				//控制下一些升级提示动画暂时停止，待这里动画完成再播放
				Main.self.uiLayer.effect.stopAnim();
				ControllerManager.yahuanController.stopYahuan();
				ModelManager.bossModel.startBossBattle(_hid, function():void{
					ControllerManager.battleController.showBattle({type:5, myInfo:_myInfo, rival:_rivalInfo});
				});	
			});
			
			_chooseHeroBtn = new BmButton(_mc._chooseHeroBtn, function():void{
				if (ViewManager.hasView(BossChooseBoyHero.NAME)) return;
				var win:BmWindow = new BossChooseBoyHero(_hid, selectHero);
				addChildCenter(win);		
			});
			
			_modifyTroopBtn = new BmButton(_mc._modifyTroopsBtn, function():void{
				if (ViewManager.hasView(ModifyTroops.NAME)) return;
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
			
			_clearCDBtn = new BmButton(_mc._clearCD, function():void{
				ConfirmMessage.callBack = setData;
				ModelManager.bossModel.confirmClearBossCD();
			});
			
			_countDown = new BmCountDown(_mc._cdTime, 0, function():void{
				_clearCDBtn.enable = false;
			});
			_countDown.everyTimeHandler = function():void{
				if(_countDown.nowTime > 3600) _countDown.textColor = 0xa40000;
				else _countDown.textColor = 0x22ac38;
			};
			
			//头像
			_img = new McImage();
			_img2 = new McImage();
			_img2.scaleX = _img2.scaleY = 2;
			_img2.x = -100;
			_img2.y = -50;
			
			_mc._my.gotoAndStop(1);
			_mc._my._role.addChild(_img);
			_mc._my.mouseEnabled = _mc._my.mouseChildren = false;
			
			_mc._enemy.gotoAndStop(1);
			_mc._enemy._role.addChild(_img2);
			_mc._enemy.mouseEnabled = _mc._enemy.mouseChildren = false;
			
			//我的信息
			_mc._myName.text = Data.data.user.name;
			_mc._myUnion.gotoAndStop(Data.data.user.union);
			
			setData();
		}
		
		public function setData():void
		{
			if (ViewManager.hasView(BossChooseBoyHero.NAME)) {
				(ViewManager.retrieveView(BossChooseBoyHero.NAME) as BossChooseBoyHero).closeWindow();
			}
			var data:Object = Data.data.boss;
			var enemyInfo:Object;
			_mc._myHeroName.htmlText = "";
			_mc._myHeroCrit.text = "";
			_mc._myHeroTroop.text = "";
			_mc._myHeroAtk.text = "";
			_mc._myHeroDef.text = "";
			
			_chooseHeroBtn.visible = true;
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
			
			_startBtn.visible = false;
			_img.reload('init');

			
			_mc._enemy.visible = true;
			_mc._my.visible = true;
			
			var leftTime:int = Data.data.user.bossCD - Math.floor(DateUtils.nowDateTimeByGap(Consts.timeGap));
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
			
			_mc._msg.text = enemyInfo.msg;

			//默认选中英雄
			if(_hid) selectHero(_hid);
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
			_mc._chooseHeroBtn._avatar.alpha = 0;
			_img.reload(data.img + 'b');
		}	
	}
}