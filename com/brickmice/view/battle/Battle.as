package com.brickmice.view.battle
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.arena.ArenaLose;
	import com.brickmice.view.arena.ArenaWin;
	import com.brickmice.view.boss.BossLose;
	import com.brickmice.view.boss.BossWin;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.prompt.NoticeMessage;
	import com.brickmice.view.solar.SolarLose;
	import com.brickmice.view.solar.SolarTalent;
	import com.brickmice.view.solar.SolarWin;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.CWindow;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 战斗
	 *
	 * @author derek
	 */
	public class Battle extends CWindow
	{

		/**
		 * 名字.
		 */
		public static const NAME : String = "Battle";

		private var _mc:MovieClip;
		private var _deathAnim1:MovieClip;
		private var _deathAnim2:MovieClip;
		private var _deathAnim21:MovieClip;
		private var _deathAnim22:MovieClip;
		
		private var _type:int;
		private var _myInfo:Object;
		private var _life1:int;
		private var _life2:int;
		private var _ship1Lv:int;
		private var _ship2Lv:int;
		private var _flashFlag1:Boolean = false;
		private var _flashFlag2:Boolean = false;
		
		private var _myTeam:Array;
		private var _enemyTeam:Array;
		private var _myIndex:int = 0;
		private var _enemyIndex:int = 0;
		
		private var _challengeData:Object;
		private var _level:int;
		private var _pid:int;
		private var _pName:String;
		
		public function Battle(data:Object)
		{
			// 初始化并加入资源
			super(NAME, 1000, 600, null, null, 0, 0);
			_mc = new ResBattleWindow();
			_mc.scrollRect = new Rectangle(0, 0, 1000, 600);
			addChildEx(_mc);
			
			_mc._line.gotoAndStop(41);
			for (var i:int = 1; i <= 2; i++) 
			{
				_mc['_flash' + i].gotoAndStop(19);
				_mc['_hero' + i]._lv1.gotoAndStop(1);
				_mc['_hero' + i]._lv2.gotoAndStop(1);
				_mc['_hero' + i]._lv3.gotoAndStop(1);
				_mc._topBar['_hp' + i]._hpReduceAnim.gotoAndStop(21);
			}
			
			_mc._topBar._hp1.addFrameScript(20, function():void{
				_mc._topBar._hp1.stop();
				_mc._line.gotoAndPlay(1);
				timerHandler();
			});
			
			//赋值信息
			_mc._topBar._user1.text = Data.data.user.name;
			_mc._topBar._union1.gotoAndStop(3 - Data.data.user.union);
			
			_deathAnim1 = new ResBattleDeathAnim;
			_deathAnim1.gotoAndStop(28);
			addChildEx(_deathAnim1, 692 - 52, 182 + 124);
			
			_deathAnim2 = new ResBattleDeathAnim;
			_deathAnim2.gotoAndStop(28);
			addChildEx(_deathAnim2, 142 + 120, 182 + 124);
			
			_deathAnim21 = new ResBattleDeathAnim2;
			_deathAnim21.gotoAndStop(28);
			addChildEx(_deathAnim21, 842 - 52, 210 + 124);
			
			_deathAnim22 = new ResBattleDeathAnim2;
			_deathAnim22.gotoAndStop(28);
			addChildEx(_deathAnim22, 275 + 120, 210 + 124);
			
			_type = data.type;
			if(data.type == 1){
				_myInfo = data.myInfo;
				_mc._topBar._levelName.text = '月球战场(单挑)';		
				var enemyInfo:Object = data.rival;
				_life2 = enemyInfo.heroTroop;
				_mc._topBar._boy2.text = enemyInfo.heroName;
				var img:McImage = new McImage(enemyInfo.heroImg + 'b');
				img.x = -36;
				img.y = -13;
				_mc._topBar._head2.addChild(img);
				
				_mc._topBar._user2.text = enemyInfo.userName;
				_mc._topBar._union2.gotoAndStop(3 - enemyInfo.union);
				_mc._topBar._lv2.text = "Lv:" + enemyInfo.heroLevel;
				
				_ship2Lv = getShipIndex(enemyInfo.heroQuality);
				_mc._hero2['_lv' + _ship2Lv].play();
				img = new McImage(enemyInfo.heroImg + 'b');
				_mc._hero2['_lv' + _ship2Lv]._cabin._hero.addChild(img);
			}else if(data.type == 2){
//				_mc._topBar._levelName.text = '月球战场(团战)';		
//				enemyInfo = data.rival;
//				_myTeam = data.myTeam;
//				_myInfo = _myTeam[0];
//				_enemyTeam = enemyInfo.heroArr;				
//				var heroInfo:Array = enemyInfo.heroArr[0];
//				_life2 = heroInfo.heroTroop;
//				_mc._topBar._boy2.text = heroInfo.heroName;
//				img = new McImage(heroInfo.heroImg + 'b');
//				img.x = -36;
//				img.y = -13;
//				_mc._topBar._head2.addChild(img);
//				
//				_mc._topBar._user2.text = enemyInfo.userName;
//				_mc._topBar._union2.gotoAndStop(3 - enemyInfo.union);
//				_mc._topBar._lv2.text = "Lv:" + heroInfo.heroLevel;
//				
//				_ship2Lv = getShipIndex(heroInfo.heroQuality);
//				_mc._hero2['_lv' + _ship2Lv].play();
//				img = new McImage(heroInfo.heroImg + 'b');
//				_mc._hero2['_lv' + _ship2Lv]._cabin._hero.addChild(img);
			}else if(data.type == 3 || data.type == 4){
				_myInfo = data.myInfo;
				_mc._topBar._levelName.text = data.levelName;
				
				enemyInfo = data.rival;
				_level = enemyInfo.level;
				_pid = data.pid;
				_challengeData = data.type == 4 ? data.rival : null;
				_pName = data.pName;
				_life2 = enemyInfo.houseTroop;
				_mc._topBar._boy2.text = '试炼官';
				
				var heroIndex:int = 1;
				var heroQuality:int = 1;
				if(data.type == 3){
					if(enemyInfo['level'] == 5 || enemyInfo['level'] == 10) {
						heroQuality = 4;
						if(data.pid <= 10) heroIndex = 4;
						else heroIndex = 2;
					}else if (enemyInfo['level'] == 15){
						heroQuality = 5;
						if(data.pid <= 10) heroIndex = 3;
						else heroIndex = 5;
					}					
				}else{
					if(enemyInfo['level'] < 5) {
						heroQuality = 4;
						if(data.pid <= 10) heroIndex = 4;
						else heroIndex = 2;
					}else{
						heroQuality = 5;
						if(data.pid <= 10) heroIndex = 3;
						else heroIndex = 5;
					}
				}
				img = new McImage('npc00' + heroIndex);
				img.x = -36;
				img.y = -13;
				_mc._topBar._head2.addChild(img);
				
				_mc._topBar._user2.text = '第' + _level + '关';
				_mc._topBar._union2.gotoAndStop(3 - Data.data.user.union);
				_mc._topBar._lv2.text = "Lv:" + enemyInfo.houseLevel;
				
				_ship2Lv = getShipIndex(heroQuality);
				_mc._hero2['_lv' + _ship2Lv].play();
				img = new McImage('npc00' + heroIndex);
				_mc._hero2['_lv' + _ship2Lv]._cabin._hero.addChild(img);
			}else if(data.type == 5){
				_myInfo = data.myInfo;
				_mc._topBar._levelName.text = 'BOSS战';		
				enemyInfo = data.rival;
				_life2 = enemyInfo.heroTroop;
				_mc._topBar._boy2.text = enemyInfo.heroName;
				img = new McImage(enemyInfo.heroImg + 'b');
				img.x = -36;
				img.y = -13;
				_mc._topBar._head2.addChild(img);
				
				_mc._topBar._user2.text = enemyInfo.userName;
				_mc._topBar._union2.gotoAndStop(3 - enemyInfo.union);
				_mc._topBar._lv2.text = "Lv:" + enemyInfo.heroLevel;
				
				_ship2Lv = getShipIndex(enemyInfo.heroQuality);
				_mc._hero2['_lv' + _ship2Lv].play();
				img = new McImage(enemyInfo.heroImg + 'b');
				_mc._hero2['_lv' + _ship2Lv]._cabin._hero.addChild(img);
			}
			
			_life1 = _myInfo.currentTroop;
			_mc._topBar._boy1.text = _myInfo.name;
			img = new McImage(_myInfo.img + 'b');
			img.x = -36;
			img.y = -13;
			_mc._topBar._head1.addChild(img);
			_mc._topBar._lv1.text = "Lv:" + _myInfo.level;
			
			_ship1Lv = getShipIndex(_myInfo.quality);
			_mc._hero1['_lv' + _ship1Lv].play();
			img = new McImage(_myInfo.img + 'b');
			_mc._hero1['_lv' + _ship1Lv]._cabin._hero.addChild(img);
		}
		
		private var _step:int = 0;
		private var _timeoutId:int = 0;
		
		private function timerHandler() : void
		{
			var data:Object;
			if(_type <= 2){
				data = Data.data.arena.battleResult;
			}else if(_type <= 4){
				data = Data.data.solar.battleResult;
			}else{
				data = Data.data.boss.battleResult;
			}
			var length:int = data.detail.length;
			
			if(_step == length) {
				if(data.result == 1){
					_mc._mouse2.gotoAndPlay(56);
					_mc._mouse1.gotoAndPlay(23);
					_mc._hero2['_lv' + _ship2Lv].gotoAndPlay(59);
					_mc._hero1['_lv' + _ship1Lv].gotoAndPlay(22);
				}else{
					_mc._mouse1.gotoAndPlay(56);
					_mc._mouse2.gotoAndPlay(23);
					_mc._hero1['_lv' + _ship1Lv].gotoAndPlay(59);
					_mc._hero2['_lv' + _ship2Lv].gotoAndPlay(22);
				}
				
				_mc._line.gotoAndStop(41);
				_mc._flash1.gotoAndStop(19);
				_mc._flash2.gotoAndStop(19);
				
				_timeoutId = setTimeout(gameOver, 2000);
				return;
			}
			
			var battle:Object = data.detail[_step];
			
//			if(_type == 2){
//				var heroInfo:Object;
//				if(battle['atkHeroIndex'] != _myIndex){
//					_myIndex = battle['atkHeroIndex'];
//					heroInfo = _myTeam[battle['atkHeroIndex']];	
//					_life1 = heroInfo.currentTroop;
//					_mc._topBar._boy1.text = heroInfo.name;
//					_mc._topBar._lv1.text = "Lv:" + heroInfo.level;
//					_mc._topBar._head1.removeChildAt(0);
//					var img:McImage = new McImage(heroInfo.img + 'b');
//					img.x = -36;
//					img.y = -13;
//					_mc._topBar._head1.addChild(img);
//					
//					_ship1Lv = getShipIndex(heroInfo.quality);
//					_mc._hero1['_lv' + _ship1Lv]._cabin._hero.removeChildAt(0);
//					_mc._hero1['_lv' + _ship1Lv].gotoAndPlay(1);
//					img = new McImage(heroInfo.img + 'b');
//					_mc._hero1['_lv' + _ship1Lv]._cabin._hero.addChild(img);
//				}
//				if(battle['defHeroIndex'] != _enemyIndex){	
//				}	
//			}
			
			//动画
			if(battle.atkIsCrit == 1){
				_deathAnim21._bg._count.text = battle.defMouseLose;
				_deathAnim21.gotoAndPlay(1);
			}else{
				_deathAnim1._bg._count.text = battle.defMouseLose;
				_deathAnim1.gotoAndPlay(1);
			}
			if(battle.defIsCrit == 1){
				_deathAnim22._bg._count.text = battle.atkMouseLose;
				_deathAnim22.gotoAndPlay(1);		
			}else{
				_deathAnim2._bg._count.text = battle.atkMouseLose;
				_deathAnim2.gotoAndPlay(1);			
			}
			
			hpReduce(1, battle.atkLeftMouse);
			if(battle.atkLeftMouse < _life1 / 2 && !_flashFlag1){
				_flashFlag1 = true;
				_mc._flash1.gotoAndPlay(1);
			}
			
			hpReduce(2, battle.defLeftMouse);
			if(battle.defLeftMouse < _life2 / 2 && !_flashFlag2){
				_flashFlag2 = true;
				_mc._flash2.gotoAndPlay(1);
			}
			
			_step++;
			
			_timeoutId = setTimeout(timerHandler, 700);
			
			if(Math.random() > 0.5){
				var star:MovieClip = new ResBattleStar;
				star.scaleX = star.scaleY = Math.random() / 2 + 0.5;
				star.gotoAndPlay(1);
				star.buttonMode = true;
				star.addEventListener(MouseEvent.MOUSE_OVER, function():void{
					TweenLite.killTweensOf(star);
					star.mouseEnabled = false;
					star.gotoAndPlay(5);
					ModelManager.boyHeroModel.addStarExp(_myInfo.id);
				});
				//星星行进路线	50-550	50-950
				if(Math.random() > 0.5){
					var y1:Number = Math.random() * 500 + 50;
					var y2:Number = Math.random() * 500 + 50;
					var speed:Number = Math.random() * 5 + 5;
					if(Math.random() > 0.5){
						star.x = -100;
						star.y = y1;
						_mc.addChild(star);
						TweenLite.to(star, speed, {x:1100, y:y2});	
					}else{
						star.rotation = 180;
						star.x = 1100;
						star.y = y1;
						_mc.addChild(star);
						TweenLite.to(star, speed, {x:-100, y:y2});
					}
				}else{
					var x1:Number = Math.random() * 900 + 50;
					var x2:Number = Math.random() * 900 + 50;
					speed = Math.random() * 5 + 5;
					if(Math.random() > 0.5){
						star.rotation = 90;
						star.x = x1;
						star.y = -100;
						_mc.addChild(star);
						TweenLite.to(star, speed, {x:x2, y:700});
					}else{
						star.rotation = -90;
						star.x = x1;
						star.y = 700;
						_mc.addChild(star);
						TweenLite.to(star, speed, {x:x2, y:-100});
					}
				}
			}
		}
		
		private function gameOver():void
		{
			var data:Object;
			if(_type <= 2){
				data = Data.data.arena.battleResult;
			}else if(_type <= 4){
				data = Data.data.solar.battleResult;
			}else{
				data = Data.data.boss.battleResult;
			}
			if (_timeoutId)
				clearTimeout(_timeoutId);
			
			if(_type <= 2){
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
				//刷新箭头
				ViewManager.sendMessage(ViewMessage.REFRESH_TASK);
				ViewManager.sendMessage(ViewMessage.REFRESH_NEWBIE);
			}else if(_type <= 4){
				//刷新新手
				NewbieController.refreshNewBieBtn(4, 11, false, true);
				NewbieController.refreshNewBieBtn(5, 8, false, true);
				//通知玩家
				if(data.noticeMsg){
					var msg:String = data.noticeMsg;
					var title:String = "提示信息";
					ControllerManager.windowController.showWindow(new WindowData(NoticeMessage, {msg:msg, title:title}, false, 0, 0, 0, false));
				}
				if(data.result == 1){
					if (ViewManager.hasView(SolarWin.NAME)) return;
					win = new SolarWin(_level, _pid, _pName, data);
					addChildCenter(win);		
				}else{
					if (ViewManager.hasView(SolarLose.NAME)) return;
					win2 = new SolarLose(_pid, _pName, data, _challengeData);
					addChildCenter(win2);
					msg2 = [
						"失败了，别气馁~试着强化一下装备吧~",
						"这关卡太难了~为什么不挑战一下之前的简单关卡呢？",
						"你的噩梦鼠不够强大哦~配上高级军需试试？"
					];
					num = Math.round(Math.random() * (msg2.length - 1));
					ControllerManager.yahuanController.showYahuan(msg2[num], 2);
				}
				//掉落天赋
				if(data.dropTalent){
					if (ViewManager.hasView(SolarTalent.NAME)) return;
					var winData:WindowData = new WindowData(SolarTalent, {'hid':_myInfo['id'], 'newTalent':data.dropTalent, 'callback':function():void{
					}}, true, 0, 0, 0, false);
					ControllerManager.windowController.showWindow(winData);
				}
			}else{
				//通知玩家
				if(data.result == 1){
					if (ViewManager.hasView(BossWin.NAME)) return;
					win = new BossWin(data);
					addChildCenter(win);		
				}else{
					if (ViewManager.hasView(BossLose.NAME)) return;
					win2 = new BossLose(data);
					addChildCenter(win2);
				}
			}
			//允许播放升级提示动画
			Main.self.uiLayer.effect.playAnim();
			ControllerManager.yahuanController.continueYahuan();
		}
		
		private function hpReduce(type:int, lostHP:int):void
		{
			var posX:int = -264;
			if(type == 1){
				posX += 445 - lostHP / _life1 * 445;
			}else{
				posX += 445 - lostHP / _life2 * 445;
			}
			TweenLite.to(_mc._topBar['_hp' + type]._mask, 0.5, {x:posX,  onStart:function():void{
				_mc._topBar['_hp' + type]._hpReduceAnim.gotoAndPlay(1);
			}, onUpdate:function():void{
				_mc._topBar['_hp' + type]._hpReduceAnim.x = _mc._topBar['_hp' + type]._mask.x + 208;
			}, onComplete:function():void{
				_mc._topBar['_hp' + type]._hpReduceAnim.gotoAndStop(21);
			}});	
		}
		
		/**
		 * 获取飞船序号 
		 * @param quality
		 * @return 
		 * 
		 */
		private function getShipIndex(quality:int):int
		{
			switch(quality)
			{
				case 4:
				{
					return 2;
				}
				case 5:
				{
					return 3;
				}	
				default:
				{
					return 1;
				}
			}
		}

	}
}