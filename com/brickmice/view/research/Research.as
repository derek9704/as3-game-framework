package com.brickmice.view.research
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCheckBox;
	import com.brickmice.view.component.prompt.NoticeMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.layer.CLayer;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.FilterUtils;
	import com.framework.utils.UiUtils;
	import com.framework.utils.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	/**
	 * 攻关
	 *
	 * @author derek
	 */
	public class Research extends CSprite
	{

		/**
		 * 名字.
		 */
		public static const NAME : String = "Research";
		/**
		 * 美人站位坐标
		 */		
		private static const GIRLPOS : Array = [
			[508, 447],
			[438, 519],
			[322, 520],
			[389, 480],
			[438, 447],
			[352, 447]
		];
		/**
		 * 美人站位顺序
		 */		
		private static const GIRLSEQ : Array = [0, 4, 5, 3, 2, 1];		
		/**
		 * 美人行为 (这里1~5是指美人品质)
		 */
		private static const GIRLACTION : Object = {
			'1' : {'attackBegin' : 126, 'normalAtk' : 149, 'normalAtkIns' : 157, 'criAtk' : 176, 'criAtkIns' : 182, 'sFlash' : 204, 'sFlashGo' : 241, 'sFlashIns' : 221, 'bFlash' : 244, 'bFlashGo' : 272, 'bFlashIns' : 268},
			'2' : {'attackBegin' : 126, 'normalAtk' : 149, 'normalAtkIns' : 157, 'criAtk' : 176, 'criAtkIns' : 182, 'sFlash' : 204, 'sFlashGo' : 241, 'sFlashIns' : 221, 'bFlash' : 244, 'bFlashGo' : 272, 'bFlashIns' : 268},
			'3' : {'attackBegin' : 126, 'normalAtk' : 149, 'normalAtkIns' : 157, 'criAtk' : 176, 'criAtkIns' : 182, 'sFlash' : 204, 'sFlashGo' : 241, 'sFlashIns' : 221, 'bFlash' : 244, 'bFlashGo' : 272, 'bFlashIns' : 268},
			'4' : {'attackBegin' : 126, 'normalAtk' : 148, 'normalAtkIns' : 156, 'criAtk' : 168, 'criAtkIns' : 174, 'sFlash' : 186, 'sFlashGo' : 212, 'sFlashIns' : 210, 'bFlash' : 223, 'bFlashGo' : 251, 'bFlashIns' : 246},
			'5' : {'attackBegin' : 126, 'normalAtk' : 148, 'normalAtkIns' : 156, 'criAtk' : 168, 'criAtkIns' : 174, 'sFlash' : 186, 'sFlashGo' : 212, 'sFlashIns' : 210, 'bFlash' : 223, 'bFlashGo' : 251, 'bFlashIns' : 246}
		};
		/**
		 * 敌人站位 
		 */		
		private static const ENEMYPOS : Array = [1031, 378];
		/**
		 * 敌人行为 (这里1~4是指状态)
		 */
		private static const ENEMYACTION : Object = {
			'1' : {'beated' : 97, 'out' : 106},
			'2' : {'beated' : 219, 'in' : 136, 'out' : 229},
			'3' : {'beated' : 338, 'in' : 260, 'out' : 348},
			'4' : {'in' : 379}
		};
		/**
		 * 起始HP坐标X 
		 */
		private static const HPSTARTPOSX:int = 7;
		/**
		 * 扣血总时长 
		 */
		private static const HPREDUCESEC:int = 2;
		
		private var _window:*;
		private var _uiLayer:CLayer;
		
		private var _geniusAnim:MovieClip;
		private var _cirHitCombo:MovieClip;
		private var _criHitAnim:MovieClip;
		private var _readyGoAnim:MovieClip;
		private var _turn:MovieClip;
		private var _exit:MovieClip;
		private var _puzzleName:TextField;
		private var _hp:MovieClip;
		private var _winAnim:MovieClip;
		private var _heartbeatLight:MovieClip;
		private var _bad:MovieClip;
		private var _portraitAnim:MovieClip;
		private var _namecard:MovieClip;
		private var _hpReduceAnim:MovieClip;
		private var _heartbeatEnd:MovieClip;
		private var _hpHurtNum:MovieClip;
		private var _bg:MovieClip;
		
		private var _heartbeat1:MovieClip;
		private var _heartbeat2:MovieClip;
		private var _heartbeat3:MovieClip;
		private var _heartbeat4:MovieClip;
		private var _heartbeat5:MovieClip;
		private var _heartbeat6:MovieClip;
		private var _heartbeat7:MovieClip;
		private var _heartbeat8:MovieClip;
		private var _heartbeat9:MovieClip;
		private var _heartbeat10:MovieClip;
		private var _heartbeat11:MovieClip;
		private var _heartbeat12:MovieClip;
		
		private var _bigEff0:MovieClip;
		private var _bigEff1:MovieClip;
		private var _bigEff2:MovieClip;
		private var _bigEff3:MovieClip;
		
		private var _enemy:MovieClip;
		private var _girlsRes:Array = [];
		private var _currentPortrait:MovieClip;
		private var _currentIndex:int;
		private var _researchBtn:BmButton;
		private var _classLife:int;
		private var _nowLife:int;
		private var _badFlag:Boolean = false;
		private var _lastLv:int;
		private var _nowLv:int;
		private var _skipAnim:Boolean = false;
		
		public function Research()
		{
			// 初始化并加入资源
			_window = new ResResearchWindow();
			super(NAME, 1281, 690);
			(_window as MovieClip).scrollRect = new Rectangle(0, 0, 1281, 690);
			addChildEx(_window);
			
			_bg = _window._bg;
			
			_puzzleName = _window._puzzleName;
			_hp = _window._hp;
			_hp.gotoAndStop(1);
			
			_heartbeatLight = _window._heartbeatGroup._heartbeatLight;
			_heartbeatLight.visible = false;
			_heartbeatLight.gotoAndStop(1);
			
			_winAnim = _window._winAnim;
			_winAnim.gotoAndStop(47);
			
			_geniusAnim = _window._geniusAnim;
			_geniusAnim.gotoAndStop(12);
			
			_cirHitCombo = _window._cirHitCombo;
			_cirHitCombo.gotoAndStop(14);
			
			_criHitAnim = _window._criHitAnim;
			_criHitAnim.gotoAndStop(10);
			
			_readyGoAnim = _window._readyGoAnim;
			_readyGoAnim.gotoAndStop(1);
			
			_turn = _window._turn;
			_turn.visible = false;
			_turn._totalNumber.gotoAndStop(1);
			_turn._turnNumber.gotoAndStop(1);
	
			_exit = _window._exit;
			_exit.visible = false;
			
			_bad = _window._namecard._bad;
			_bad.gotoAndStop(1);
			_bad._anim.gotoAndStop(15);
			
			_portraitAnim = _window._namecard._portraitAnim;
			_portraitAnim.gotoAndStop(4);
			
			_namecard = _window._namecard;
			_namecard._girlName.text = '';
			_namecard._girlQuality.text = '';
			_namecard.cHeight = 65; //这里是为了uilayer调整时不出错设置
			
			_hpReduceAnim = _window._hp._hpReduceAnim;
			_hpReduceAnim._1.gotoAndStop(21);
			_hpReduceAnim._2.gotoAndStop(21);
			_hpReduceAnim._3.gotoAndStop(21);
			
			_heartbeatEnd = _window._heartbeatGroup._heartbeatEnd;
			_heartbeatEnd.gotoAndStop(1);
			_heartbeatEnd.visible = false;
			
			_hpHurtNum =  _window._hpHurtNum;
			_hpHurtNum.gotoAndStop(28);
			
			_heartbeat1 = _window._heartbeatGroup._heartbeat1;
			_heartbeat2 = _window._heartbeatGroup._heartbeat2;
			_heartbeat3 = _window._heartbeatGroup._heartbeat3;
			_heartbeat4 = _window._heartbeatGroup._heartbeat4;
			_heartbeat5 = _window._heartbeatGroup._heartbeat5;
			_heartbeat6 = _window._heartbeatGroup._heartbeat6;
			_heartbeat7 = _window._heartbeatGroup._heartbeat7;
			_heartbeat8 = _window._heartbeatGroup._heartbeat8;
			_heartbeat9 = _window._heartbeatGroup._heartbeat9;
			_heartbeat10 = _window._heartbeatGroup._heartbeat10;
			_heartbeat11 = _window._heartbeatGroup._heartbeat11;
			_heartbeat12 = _window._heartbeatGroup._heartbeat12;
			
			_bigEff0 = _window._bigEff0; //一击 一下就DIE
			_bigEff1 = _window._bigEff1; //眼睛 1转2
			_bigEff2 = _window._bigEff2; //大头 2转3
			_bigEff3 = _window._bigEff3; //转圈 DIE
			_bigEff0.gotoAndStop(1);
			_bigEff1.gotoAndStop(1);
			_bigEff2.gotoAndStop(1);
			_bigEff3.gotoAndStop(1);
			_bigEff0.visible = _bigEff1.visible = _bigEff2.visible = _bigEff3.visible = false;
			//光晕
			for (var i3:int = 0; i3 <= 5; i3++) 
			{
				_bigEff3['_halo' + i3].gotoAndStop(1);
			}
			
			_researchBtn = new BmButton(_window._researchBtn, function():void{
				_researchBtn.enable = false;
				NewbieController.refreshNewBieBtn(11, 4);
				NewbieController.hideNewBieBtn();
				_heartbeatLight.stop();
				var blockIndex:int = _heartbeatLight.currentFrame;
				if(blockIndex > 48){
					blockIndex =96 - blockIndex + 1;
				}
				blockIndex -= 1;
				//控制下一些升级提示动画暂时停止，待这里动画完成再播放
				Main.self.uiLayer.effect.stopAnim();
				ControllerManager.yahuanController.stopYahuan();
				ModelManager.instituteModel.executeInstituteResearch(blockIndex / 4, blockIndex % 4, attackEnemy);
			});
			_researchBtn.enable = false;
			NewbieController.hideNewBieBtn();
			
			new BmButton(_exit, function():void{quit();});
			
			new BmCheckBox(_window._skip._checkBox, function():void{
				_skipAnim = Data.data.user.skipResearchAnim == 0;
				ModelManager.userModel.skipResearchAnim();
			}, Data.data.user.skipResearchAnim == 1);
			_skipAnim = Data.data.user.skipResearchAnim == 1;
			
			//子弹
			for (var i:int = 1; i <= 6; i++) 
			{
				_window['_bulletGolden' + i].gotoAndStop(12);
				_window['_bulletGolden' + i].addFrameScript(2, enemyBeated);
				_window['_bulletCriGolden' + i].gotoAndStop(12);
				_window['_bulletCriGolden' + i].addFrameScript(2, enemyBeated);
				_window['_bulletBlue' + i].gotoAndStop(13);
				_window['_bulletBlue' + i].addFrameScript(2, enemyBeated);
				_window['_bulletCriBlue' + i].gotoAndStop(13);
				_window['_bulletCriBlue' + i].addFrameScript(2, enemyBeated);
			}
		}
		
		private function quit():void
		{
			ControllerManager.cityController.enterCity();
			//允许播放升级提示动画
			Main.self.uiLayer.effect.playAnim();
			ControllerManager.yahuanController.continueYahuan();
		}
		
		public function setData(uiLayer:CLayer):void
		{
			_uiLayer = uiLayer;
			//1281 690
			_uiLayer.addChildEx(_turn, 11.65, 17.95);
			_uiLayer.addChildEx(_exit, 8, 107.45);
			_uiLayer.addChildEx(_hp, 85.55, 5.95, CCanvas.rt);
			_uiLayer.addChildEx(_window._topBar, 179.3, 596.7, CCanvas.rt);
			_uiLayer.addChildEx(_puzzleName, 94.45, 53.3, CCanvas.rt);
			_window._heartbeatGroup.cHeight = 92;
			_uiLayer.addChildEx(_window._heartbeatGroup, 35, 0, CCanvas.bottom, true);
			_uiLayer.addChildEx(_namecard, -0.35, 0, CCanvas.lb);
			_uiLayer.addChildEx(_window._researchBtn, -2, -2, CCanvas.rb);
			
			var skipBtn:MovieClip = _window._skip;
			skipBtn.cWidth = 68;
			skipBtn.cHeight = 16;
			_uiLayer.addChildEx(skipBtn, 0, 112, CCanvas.rb);
			if(Data.data.user.techLevel < 10) _window._skip.visible = false;
			
			var detail:Object = Data.data.institute.research.detail;
			var classInfo:Object = Data.data.institute.research['class'];
			var girls:Array = Data.data.institute.research.girls;
			//课题名
			_puzzleName.text = classInfo['classname'];	
			//总血量
			_classLife = _nowLife = classInfo['life'];
			//心跳图
			var blockGroup:Array = detail['psy']['blockGroup'];
			_heartbeat1.gotoAndStop(blockGroup[0]);
			_heartbeat2.gotoAndStop(blockGroup[1]);
			_heartbeat3.gotoAndStop(blockGroup[2]);
			_heartbeat4.gotoAndStop(blockGroup[3]);
			_heartbeat5.gotoAndStop(blockGroup[4]);
			_heartbeat6.gotoAndStop(blockGroup[5]);
			_heartbeat7.gotoAndStop(blockGroup[6]);
			_heartbeat8.gotoAndStop(blockGroup[7]);
			_heartbeat9.gotoAndStop(blockGroup[8]);
			_heartbeat10.gotoAndStop(blockGroup[9]);
			_heartbeat11.gotoAndStop(blockGroup[10]);
			_heartbeat12.gotoAndStop(blockGroup[11]);
			//BOSS站位
			var cls:Object =  getDefinitionByName('ResEnemy1001');
			_enemy = new cls;
			_enemy.x = ENEMYPOS[0];
			_enemy.y = ENEMYPOS[1];
			//BOSS头像
			cls =  getDefinitionByName('ResEnemy1001Portrait');
			_uiLayer.addChildEx(new cls, 0, 2, CCanvas.rt);
			//科学美人站位
			for (var index:String in girls)
			{
				var girlOb:Object = Data.data.girlHero[girls[index]];
				cls =  getDefinitionByName('ResGirl' + girlOb['img'].substr(4));
				var girl:MovieClip = new cls;
				//加入脚本
				girl.addFrameScript(GIRLACTION[girlOb['quality']]['criAtkIns'] - 1, function():void{sendBullet(true)});
				girl.addFrameScript(GIRLACTION[girlOb['quality']]['normalAtkIns'] - 1, function():void{sendBullet(false)});
				if(girlOb['quality'] > 3){
					girl.addFrameScript(GIRLACTION[girlOb['quality']]['sFlashIns'] - 1, function():void{sendBullet(true)});
				}else{
					girl.addFrameScript(GIRLACTION[girlOb['quality']]['sFlashIns'] - 1, function():void{sendBullet(true)});
				}
				girl.addFrameScript(GIRLACTION[girlOb['quality']]['bFlashIns'] - 1, function():void{sendBullet(true)});
				_girlsRes.push(girl);
				girl.x = GIRLPOS[index][0];
				girl.y = GIRLPOS[index][1];
			}
			//将参与者加入背景层
			transferAttender(_bg);
			//开场动画
			_enemy.addFrameScript(38, function():void{
				_readyGoAnim.gotoAndPlay(1);
				_hp.gotoAndPlay(1);
			});
			//开场动画放完后
			_readyGoAnim.addFrameScript(_readyGoAnim.totalFrames - 1, function():void{
				_readyGoAnim.stop();
				//显示当前回合
				showCurrentRound();
				_turn.visible = true;
				_heartbeatLight.visible = true;
				if(Data.data.user.techLevel >= 5) _exit.visible = true;
			});
		}
		
		//执行一次攻击
		private function attackEnemy():void
		{			
			UiUtils.setButtonEnable(_exit, false);
			
			var detail:Object = Data.data.institute.research.detail;
			var girls:Array = Data.data.institute.research.girls;
			//判断是否进入转阶段动画
			var barLife:int = _classLife / 3;
			if(_nowLife > barLife * 2){
				_lastLv = 1;
			}else if(_nowLife > barLife){
				_lastLv = 2;
			}else{
				_lastLv = 3;
			}
			if(detail['classLife'] > barLife * 2){
				_nowLv = 1;
			}else if(detail['classLife'] > barLife){
				_nowLv = 2;
			}else if(detail['classLife'] > 0){
				_nowLv = 3;
			}else{
				_nowLv = 4;
			}
			//美人攻击开始
			var currentGirl:MovieClip = _girlsRes[_currentIndex];
			var girlQuality:int = Data.data.girlHero[girls[_currentIndex]].quality;
			//心跳
			var blockIndex:int = _heartbeatLight.currentFrame;
			if(blockIndex > 48){
				blockIndex =96 - blockIndex + 1;
			}
			_heartbeatEnd.x = _heartbeatLight.x + 58 + blockIndex * 15;
			switch(detail['hitType'])
			{
				case 0:
				{
					_heartbeatEnd.y = 28;
					_heartbeatEnd.visible = true;
					_heartbeatEnd.gotoAndPlay(11);
					if((_lastLv != _nowLv) && !_skipAnim){
						showBigEffect(currentGirl, girlQuality);
					}else{
						currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['criAtk']);
					}
					break;
				}
				case 1:
				{
					_heartbeatEnd.y = 58;
					_heartbeatEnd.visible = true;
					_heartbeatEnd.gotoAndPlay(1);
					currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['normalAtk']);
					break;
				}
				case 2:
				{
					_heartbeatEnd.y = 88;
					_heartbeatEnd.visible = true;
					_heartbeatEnd.gotoAndPlay(26);
					currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['normalAtk']);
					break;
				}
			}
		}
		
		//将我方和敌方移到指定层上
		private function transferAttender(bg:MovieClip):void
		{
			_enemy.x = ENEMYPOS[0];
			_enemy.y = ENEMYPOS[1];
			bg.addChild(_enemy);
			//美人按顺序加入场景
			var lastIndex:int = _girlsRes.length - 1;
			for each (var i:int in GIRLSEQ) 
			{
				if(i > lastIndex) continue;
				_girlsRes[i].x = GIRLPOS[i][0];
				_girlsRes[i].y = GIRLPOS[i][1];
				bg.addChild(_girlsRes[i]);	
			}
		}
		
		//播放大招动画
		private function showBigEffect(currentGirl:MovieClip, girlQuality:int):void{
			var girls:Array = Data.data.institute.research.girls;
			var girlOb:Object = Data.data.girlHero[girls[_currentIndex]];
			//一击必杀
			if(_nowLv == 4 && _nowLife == _classLife){
				//加入敌人
				_enemy.x = 0;
				_enemy.y = 0;
				_bigEff0._enemy.addChild(_enemy);
				//美人按先后加入场景
				for (var i:int = _girlsRes.length - 1; i >= 0; i--) 
				{
					_girlsRes[i].x = 0;
					_girlsRes[i].y = 0;
					_bigEff0['_girl' + i].addChild(_girlsRes[i]);	
				}
				//闪光
				currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['bFlash']);
				_bigEff0.addFrameScript(50, function():void{
					currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['bFlashGo']);
				});
				_bigEff0.addFrameScript(_bigEff0.totalFrames - 1, function():void{
					_bigEff0.stop();
					_bigEff0.visible = false;
					transferAttender(_bg);
				});
				_bigEff0.visible = true;
				_bigEff0.gotoAndPlay(1);
				return;	
			}
			//转阶段
			switch(_nowLv)
			{
				case 2:
				{
					currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['sFlash']);
					transferAttender(_bigEff1);
					_bigEff1.addFrameScript(37, function():void{
						currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['sFlashGo']);
					});
					_bigEff1.addFrameScript(_bigEff1.totalFrames - 1, function():void{
						_bigEff1.stop();
						_bigEff1.visible = false;
						transferAttender(_bg);
					});
					if(girlQuality > 3){
						_bigEff1._eyeBar.gotoAndStop(1);
					}else{
						_bigEff1._eyeBar.gotoAndStop(2);
					}
					try{
						var cls:Object = getDefinitionByName('ResGirl' + girlOb['img'].substr(4) + 'Eye');
						var eye:MovieClip = new cls;
						eye.x = 100;
						_bigEff1._eyeBar.addChild(eye);
					}catch(e:Error){
						
					}
					_bigEff1.visible = true;
					_bigEff1.gotoAndPlay(1);
					break;
				}
				case 3:
				{
					currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['sFlash']);
					transferAttender(_bigEff2);
					_bigEff2.addFrameScript(70, function():void{
						currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['sFlashGo']);
					});
					_bigEff2.addFrameScript(_bigEff2.totalFrames - 1, function():void{
						_bigEff2.stop();
						_bigEff2.visible = false;
						transferAttender(_bg);
					});
					try{
						var cls2:Object = getDefinitionByName('ResGirl' + girlOb['img'].substr(4) + 'Head');
						var head:MovieClip = new cls2;
						_bigEff2._head.addChild(head);
					}catch(e:Error){
						
					}
					_bigEff2.visible = true;
					_bigEff2.gotoAndPlay(1);			
					break;
				}
				case 4:
				{
					currentGirl.gotoAndStop(GIRLACTION[girlQuality]['sFlash']);
					//加入敌人
					_enemy.x = 0;
					_enemy.y = 0;
					_bigEff3._enemy.addChild(_enemy);
					//美人按先后加入场景
					for (var i2:int = _girlsRes.length - 1; i2 >= 0; i2--) 
					{
						_girlsRes[i2].x = 0;
						_girlsRes[i2].y = 0;
						_bigEff3['_girl' + i2].addChild(_girlsRes[i2]);	
					}
					//光晕
					for (var i3:int = 0; i3 <= 5; i3++) 
					{
						if(i3 < _girlsRes.length){
							_bigEff3['_halo' + i3].gotoAndPlay(1);
						}
					}
					_bigEff3.addFrameScript(77, function():void{
						currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['sFlash']);
					});
					_bigEff3.addFrameScript(115, function():void{
						currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['sFlashGo']);
					});
					_bigEff3.addFrameScript(_bigEff3.totalFrames - 1, function():void{
						_bigEff3.stop();
						_bigEff3.visible = false;
						transferAttender(_bg);
					});
					_bigEff3.visible = true;
					_bigEff3.gotoAndPlay(1);
					break;
				}
			}
		}
		
		//发射子弹
		private function sendBullet(isCri:Boolean):void{
			var girls:Array = Data.data.institute.research.girls;
			var quality:int = Data.data.girlHero[girls[_currentIndex]].quality;
			var bullet:MovieClip;
			if(isCri){
				if(quality <= 3){
					bullet = _window['_bulletCriBlue' + (_currentIndex + 1).toString()];
					bullet.gotoAndPlay(1);
				}else{
					bullet = _window['_bulletCriGolden' + (_currentIndex + 1).toString()];
					bullet.gotoAndPlay(1);
				}
			}else{
				if(quality <= 3){
					bullet = _window['_bulletBlue' + (_currentIndex + 1).toString()];
					bullet.gotoAndPlay(1);
				}else{
					bullet = _window['_bulletGolden' + (_currentIndex + 1).toString()];
					bullet.gotoAndPlay(1);
				}
			}
		}
		
		//显示打击效果
		private function enemyBeated():void{
			var detail:Object = Data.data.institute.research.detail;
			//扣血数字
			_hpHurtNum.gotoAndPlay(1);
			_hpHurtNum._bg._count.text = detail.dmg;
			if(detail.combo > 1){
				_cirHitCombo.gotoAndPlay(1);
				_cirHitCombo._num.gotoAndStop(detail.combo);
				//震动
				_bg.gotoAndPlay(2);
			}else if(detail.hitType == 0){
				_criHitAnim.gotoAndPlay(1);
				//震动
				_bg.gotoAndPlay(2);
			}else if(detail.hitType == 2){
				if(_badFlag){
					_bad.gotoAndStop(2);
				}
				else{
					_bad.gotoAndStop(1);
				}
				_bad._anim.gotoAndPlay(1);
			}
			if(detail.hitType == 2){
				_badFlag = true;
			}else{
				_badFlag = false;
			}
			if(detail.combo >= 3){
				_geniusAnim.gotoAndPlay(1);
			}
			//敌人效果
			if(_lastLv == _nowLv){
				_enemy.gotoAndPlay(ENEMYACTION[_lastLv]['beated']);
				reduceHP();
			}else{
				_enemy.gotoAndPlay(ENEMYACTION[_lastLv]['out']);
				_enemy.addFrameScript(ENEMYACTION[_lastLv + 1]['in'] - 2, function():void{
					_enemy.gotoAndPlay(ENEMYACTION[_nowLv]['in']);
					_enemy.addFrameScript(ENEMYACTION[_nowLv]['in'] + 25, reduceHP);
				});
			}
		}
		
		//显示扣血效果
		private function reduceHP():void
		{
			var detail:Object = Data.data.institute.research.detail;
			//扣血效果
			var leftHP:int, leftDmg:int;
			var duration1:Number, duration2:Number, duration3:Number;
			var barLife:int = _classLife / 3;
			//处理一下伤害的超出问题
			if(detail.dmg > _nowLife){
				detail.dmg = _nowLife
			}
			if(_nowLife > barLife * 2){
				leftHP = _nowLife - barLife * 2;
				if(detail.dmg > leftHP){
					duration1 = leftHP / detail.dmg * HPREDUCESEC;
					hpReduce(1, barLife, duration1, function():void{
						leftDmg = detail.dmg - leftHP;
						if(leftDmg > barLife){
							duration2 = barLife / detail.dmg * HPREDUCESEC;
							hpReduce(2, barLife, duration2, function():void{
								leftDmg = leftDmg - barLife;
								duration3 = leftDmg / detail.dmg * HPREDUCESEC;
								hpReduce(3, leftDmg, duration3);
							});
						}else{
							duration2 = HPREDUCESEC - duration1;
							hpReduce(2, leftDmg, duration2);
						}
					});
				}else{
					hpReduce(1, (barLife - leftHP + detail.dmg), HPREDUCESEC);
				}
			}else if(_nowLife > barLife){
				leftHP = _nowLife - barLife;
				if(detail.dmg > leftHP){
					duration2 = leftHP / detail.dmg * HPREDUCESEC;
					hpReduce(2, barLife, duration2, function():void{
						leftDmg = detail.dmg - leftHP;
						duration3 = HPREDUCESEC - duration2;
						hpReduce(3, leftDmg, duration3);
					});
				}else{
					hpReduce(2, (barLife - leftHP + detail.dmg), HPREDUCESEC);
				}
			}else{
				leftHP = _nowLife;
				hpReduce(3, (barLife - leftHP + detail.dmg), HPREDUCESEC);
			}
		}
		
		//回合结束
		private function roundOver():void
		{
			var detail:Object = Data.data.institute.research.detail;
			_nowLife = detail['classLife'];
			//结束判断 胜利
			if(detail['result'] == 1){
				_winAnim.gotoAndPlay(1);
				_winAnim.addFrameScript(_winAnim.totalFrames - 1, function():void{
					_winAnim.stop();
					//通知玩家
					var msg:String = detail.noticeMsg;
					var title:String = "攻关成功";
					ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, {msg:msg, title:title, callback:quit}, false, 0, 0, 0, false));
					//掉落天赋
					if(detail.dropTalent){
						if (ViewManager.hasView(ResearchTalent.NAME)) return;
						var girls:Array = Data.data.institute.research.girls;
						var winData:WindowData = new WindowData(ResearchTalent, {'hid':girls[_currentIndex], 'newTalent':detail.dropTalent, 'callback':function():void{
						}}, true, 0, 0, 0, false);
						ControllerManager.windowController.showWindow(winData);
					}
					UiUtils.setButtonEnable(_exit, true);
					//允许播放升级提示动画
					Main.self.uiLayer.effect.playAnim();
					ControllerManager.yahuanController.continueYahuan();
				});
				return;
			}
			//结束判断 失败
			if(detail['result'] == 2){
				//通知玩家
				var msg:String = detail.noticeMsg;
				var title:String = "攻关失败";
				ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, {msg:msg, title:title, callback:quit}, false, 0, 0, 0, false));
				UiUtils.setButtonEnable(_exit, true);
				//允许播放升级提示动画
				Main.self.uiLayer.effect.playAnim();
				ControllerManager.yahuanController.continueYahuan();
				var msg2:Array = [
					"在心电图达到最高点时攻关，打出连续暴击就容易过啦~",
					"这个课题太难了~不如去《课题成果》找简单的试试？",
					"搭配合理的科学技能，科学美人就会变厉害~",
					"心态放平才能打出暴击哦~别！！！别！！！别拿鼠标砸我！！！"
				];
				var num:int = Math.round(Math.random() * (msg2.length - 1));
				ControllerManager.yahuanController.showYahuan(msg2[num], 2);
				return;
			}
			//显示当前回合
			showCurrentRound();
		}
		
		//显示当前回合
		private function showCurrentRound():void
		{
			UiUtils.setButtonEnable(_exit, true);
			_heartbeatEnd.visible = false;
			var detail:Object = Data.data.institute.research.detail;
			var classInfo:Object = Data.data.institute.research['class'];
			var girls:Array = Data.data.institute.research.girls;
			//轮次
			_turn._totalNumber.gotoAndStop(detail['roundLimit']);
			_turn._turnNumber.gotoAndStop(detail['round']);
			//心跳图
			var blockGroup:Array = detail['psy']['blockGroup'];
			_heartbeat1.gotoAndStop(blockGroup[0]);
			_heartbeat2.gotoAndStop(blockGroup[1]);
			_heartbeat3.gotoAndStop(blockGroup[2]);
			_heartbeat4.gotoAndStop(blockGroup[3]);
			_heartbeat5.gotoAndStop(blockGroup[4]);
			_heartbeat6.gotoAndStop(blockGroup[5]);
			_heartbeat7.gotoAndStop(blockGroup[6]);
			_heartbeat8.gotoAndStop(blockGroup[7]);
			_heartbeat9.gotoAndStop(blockGroup[8]);
			_heartbeat10.gotoAndStop(blockGroup[9]);
			_heartbeat11.gotoAndStop(blockGroup[10]);
			_heartbeat12.gotoAndStop(blockGroup[11]);
			//力度条
			_heartbeatLight.gotoAndPlay(1);
			//攻关按钮
			_researchBtn.enable = true;
			//新手指引
			NewbieController.showNewBieBtn(11, 3, _uiLayer, _uiLayer.cWidth - 142, _uiLayer.cHeight - 47, true, "尽可能在峰值攻关");
			NewbieController.showNewBieBtn(11, 4, _uiLayer, _uiLayer.cWidth - 142, _uiLayer.cHeight - 47, true, "尽可能在峰值攻关");
			//当前美人
			_currentIndex = detail['index'];
			var girlOb:Object = Data.data.girlHero[girls[_currentIndex]];
			var currentGirl:MovieClip = _girlsRes[_currentIndex];
			var girlQuality:int = girlOb.quality;
			currentGirl.gotoAndPlay(GIRLACTION[girlQuality]['attackBegin']);
			//头像
			if(_currentPortrait){
				_portraitAnim._portrait.removeChild(_currentPortrait);
			}
			var cls:Object = getDefinitionByName('ResGirl' + girlOb['img'].substr(4) + 'Portrait');
			_currentPortrait = new cls;
			_portraitAnim._portrait.addChild(_currentPortrait);
			_portraitAnim.gotoAndPlay(1);
			//名片
			_namecard._girlName.text = girlOb['name'];
			_namecard._girlQuality.text = transGirlQuality(girlOb['quality']);
			//当前美人高亮
			for each (var girl:MovieClip in _girlsRes) 
			{
				FilterUtils.setBrightness(girl, -0.3);
			}
			FilterUtils.setBrightness(currentGirl);
		}
		
		private function transGirlQuality(quality:int):String
		{
			var str:String = '';
			switch(quality)
			{
				case 1:
				{
					str = '白色美人';
					break;
				}
				case 2:
				{
					str = '绿色美人';
					break;
				}
				case 3:
				{
					str = '蓝色美人';
					break;
				}
				case 4:
				{
					str = '紫色美人';
					break;
				}
				case 5:
				{
					str = '金色美人';
					break;
				}
			}
			return str;
		}
		
		private function hpReduce(barIndex:int, lostHP:int, duration:Number, complete:Function = null):void
		{
			var posX:int = HPSTARTPOSX + lostHP / _classLife * 3 * 445;
			TweenLite.to(_hp['_hp' + barIndex], duration, {x:posX,  onStart:function():void{
				_hpReduceAnim['_' + barIndex].gotoAndPlay(1);
			}, onUpdate:function():void{
				_hpReduceAnim.x = _hp['_hp' + barIndex].x - HPSTARTPOSX - 10;
			}, onComplete:function():void{
				_hpReduceAnim['_' + barIndex].gotoAndStop(21);
				if(complete != null) complete();
				else roundOver();
			}});	
		}

	}
}