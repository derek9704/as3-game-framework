package com.brickmice.view.component.frame
{
	
	import com.brickmice.Main;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McTip;
	import com.framework.core.Message;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;

	/**
	 * 效果动画
	 * @author derek
	 */
	public class Effect extends CSprite
	{
		
		public static const NAME : String = "Effect";

		private var _techLevelUpAnim:MovieClip;
		private var _whiteHonorLevelUpAnim:MovieClip;
		private var _blackHonorLevelUpAnim:MovieClip;
		private var _girlLevelUpAnim:MovieClip;
		private var _boyLevelUpAnim:MovieClip;
		private var _findSymbolAnim:MovieClip;
		private var _findPaperAnim:MovieClip;
		private var _findLessonAnim:MovieClip;
		private var _dailyRewardAnim:MovieClip;
		private var _warVictory:MovieClip;
		private var _callKan:MovieClip;

		private var _itemLesson:McItem = null;
		private var _itemPaper:McItem = null;
		private var _itemSymbol:McItem = null;
		private var _rewardItem:McItem = null;
		private var _animArr:Array = [];
		private var _stopAnim : Boolean = false;
		private var _runAnim:Boolean = false;
		
		public function Effect()
		{
			super(NAME);
			
			_techLevelUpAnim = new ResTechLevelUpAnim;
			_techLevelUpAnim.gotoAndStop(1);
			_techLevelUpAnim.visible = false;
			_techLevelUpAnim.cWidth = 318;
			_techLevelUpAnim.cHeight = 176;
			_techLevelUpAnim.addFrameScript(_techLevelUpAnim.totalFrames - 1, function():void{
				_techLevelUpAnim.stop();
				_techLevelUpAnim.visible = false;
				Main.self.tipLayer.removeChild(_techLevelUpAnim);
				runNextAnim();
			});
			
			_whiteHonorLevelUpAnim = new ResWhiteHonorLevelUpAnim;
			_whiteHonorLevelUpAnim.gotoAndStop(1);
			_whiteHonorLevelUpAnim.visible = false;
			_whiteHonorLevelUpAnim.cWidth = 325;
			_whiteHonorLevelUpAnim.cHeight = 190;
			_whiteHonorLevelUpAnim.addFrameScript(_whiteHonorLevelUpAnim.totalFrames - 1, function():void{
				_whiteHonorLevelUpAnim.stop();
				_whiteHonorLevelUpAnim.visible = false;
				Main.self.tipLayer.removeChild(_whiteHonorLevelUpAnim);
				runNextAnim();
			});
			
			_blackHonorLevelUpAnim = new ResBlackHonorLevelUpAnim;
			_blackHonorLevelUpAnim.gotoAndStop(1);
			_blackHonorLevelUpAnim.visible = false;
			_blackHonorLevelUpAnim.cWidth = 325;
			_blackHonorLevelUpAnim.cHeight = 190;
			_blackHonorLevelUpAnim.addFrameScript(_blackHonorLevelUpAnim.totalFrames - 1, function():void{
				_blackHonorLevelUpAnim.stop();
				_blackHonorLevelUpAnim.visible = false;
				Main.self.tipLayer.removeChild(_blackHonorLevelUpAnim);
				runNextAnim();
			});
			
			_girlLevelUpAnim = new ResGirlLevelUpAnim;
			_girlLevelUpAnim.gotoAndStop(1);
			_girlLevelUpAnim.visible = false;
			_girlLevelUpAnim.cWidth = 359;
			_girlLevelUpAnim.cHeight = 174;
			_girlLevelUpAnim.addFrameScript(_girlLevelUpAnim.totalFrames - 1, function():void{
				_girlLevelUpAnim.stop();
				_girlLevelUpAnim.visible = false;
				Main.self.tipLayer.removeChild(_girlLevelUpAnim);
				runNextAnim();
			});
			
			_boyLevelUpAnim = new ResBoyLevelUpAnim;
			_boyLevelUpAnim.gotoAndStop(1);
			_boyLevelUpAnim.visible = false;
			_boyLevelUpAnim.cWidth = 303;
			_boyLevelUpAnim.cHeight = 174;
			_boyLevelUpAnim.addFrameScript(_boyLevelUpAnim.totalFrames - 1, function():void{
				_boyLevelUpAnim.stop();
				_boyLevelUpAnim.visible = false;
				Main.self.tipLayer.removeChild(_boyLevelUpAnim);
				runNextAnim();
			});
				
			_warVictory = new ResWarVictory;
			_warVictory.gotoAndStop(1);
			_warVictory.visible = false;
			_warVictory.cWidth = 380;
			_warVictory.cHeight = 187;
			_warVictory._union.gotoAndStop(1);
			_warVictory.addFrameScript(_warVictory.totalFrames - 1, function():void{
				_warVictory.stop();
				_warVictory.visible = false;
				Main.self.tipLayer.removeChild(_warVictory);
				runNextAnim();
			});
			
			_callKan = new ResCallKanAnim;
			_callKan.gotoAndStop(1);
			_callKan.visible = false;
			_callKan.cWidth = 553;
			_callKan.cHeight = 241;
			_callKan.gotoAndStop(1);
			_callKan.addFrameScript(_callKan.totalFrames - 1, function():void{
				_callKan.stop();
				_callKan.visible = false;
				Main.self.tipLayer.removeChild(_callKan);
			});
			
			_findLessonAnim = new ResFindLessonAnim;
			_findLessonAnim.visible = false;
			_findLessonAnim.cWidth = 380;
			_findLessonAnim.cHeight = 187;
			new BmButton(_findLessonAnim._btn, function():void{
				TipHelper.clear(_itemLesson);
				_findLessonAnim._title.removeChild(_itemLesson);
				_itemLesson = null;
				_findLessonAnim.visible = false;
				Main.self.tipLayer.removeChild(_findLessonAnim);
				runNextAnim();
			});
			
			_findPaperAnim = new ResFindPaperAnim;
			_findPaperAnim.visible = false;
			_findPaperAnim.cWidth = 380;
			_findPaperAnim.cHeight = 187;
			new BmButton(_findPaperAnim._btn, function():void{
				TipHelper.clear(_itemPaper);
				_findPaperAnim._title.removeChild(_itemPaper);
				_itemPaper = null;
				_findPaperAnim.visible = false;
				Main.self.tipLayer.removeChild(_findPaperAnim);
				runNextAnim();
			});
			
			_findSymbolAnim = new ResFindSymbolAnim;
			_findSymbolAnim.visible = false;
			_findSymbolAnim.cWidth = 380;
			_findSymbolAnim.cHeight = 187;
			new BmButton(_findSymbolAnim._btn, function():void{
				TipHelper.clear(_itemSymbol);
				_findSymbolAnim._title.removeChild(_itemSymbol);
				_itemSymbol = null;
				_findSymbolAnim.visible = false;
				Main.self.tipLayer.removeChild(_findSymbolAnim);
				runNextAnim();
			});
			
			_dailyRewardAnim = new ResDailyReward;
			_dailyRewardAnim.visible = false;
			_dailyRewardAnim.cWidth = 380;
			_dailyRewardAnim.cHeight = 187;
			new BmButton(_dailyRewardAnim._btn, function():void{
				ModelManager.activityModel.getLogonReward(function():void{
					TipHelper.clear(_rewardItem);
					_dailyRewardAnim._title.removeChild(_rewardItem);
					_rewardItem = null;
					_dailyRewardAnim.visible = false;
					Main.self.tipLayer.removeChild(_dailyRewardAnim);
				});
			});
		}	
		
		private function runNextAnim():void
		{
			_animArr.shift();
			if(_animArr.length == 0){
				_runAnim = false;
			}else{
				var str:String = _animArr[0];
				switch(str)
				{
					case 'tech':
					{
						playTechAnim();
						break;
					}
					case 'honor':
					{
						playHonorAnim();
						break;
					}
					case 'boy':
					{
						playBoyAnim();
						break;
					}
					case 'girl':
					{
						playGirlAnim();
						break;
					}
				}
			}
		}
		
		//暂停播放动画，存储在池子中
		public function stopAnim():void
		{
			_stopAnim = true;
		}
		
		//从外部控制一下动画的播放时间
		public function playAnim():void
		{
			var str:String = _animArr[0];
			switch(str)
			{
				case 'tech':
				{
					playTechAnim();
					break;
				}
				case 'honor':
				{
					playHonorAnim();
					break;
				}
				case 'boy':
				{
					playBoyAnim();
					break;
				}
				case 'girl':
				{
					playGirlAnim();
					break;
				}
			}
			_stopAnim = false;
		}

		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_TECHLEVEL, ViewMessage.REFRESH_HONORLEVEL, ViewMessage.HERO_LEVELUP, 
				ViewMessage.GOT_DISCOVERY, ViewMessage.REFRESH_DAILYLOGONREWARD, ViewMessage.WAR_VICTORY, ViewMessage.CALL_KAN];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_TECHLEVEL:
					if(_stopAnim || _runAnim){
						_animArr.push('tech');
						return;
					}else{
						playTechAnim();
					}
					break;
				case ViewMessage.REFRESH_HONORLEVEL:
					if(_stopAnim || _runAnim){
						_animArr.push('honor');
						return;
					}else{
						playHonorAnim();
					}
					break;
				case ViewMessage.HERO_LEVELUP:
					if(_stopAnim || _runAnim){
						_animArr.push(message.data);
						return;
					}else{
						if(message.data == "boy") playBoyAnim();
						else playGirlAnim();
					}
					break;
				case ViewMessage.GOT_DISCOVERY:
					playDiscoveryAnim(message.data);
					break;
				case ViewMessage.WAR_VICTORY:
					playWarAnim(message.data);
					break;
				case ViewMessage.CALL_KAN:
					playCallKan(message.data);
					break;
				case ViewMessage.REFRESH_DAILYLOGONREWARD:
					if(_rewardItem) _dailyRewardAnim._title.removeChild(_rewardItem);
					_dailyRewardAnim.visible = true;
					var item:Object = Data.data.user.logonReward;
					_rewardItem = new McItem(item.img, 0, item.num, true, item.name);
					_rewardItem.x = 35;
					_rewardItem.y = 35;
					TipHelper.setTip(_rewardItem, Trans.transTips(item));
					_dailyRewardAnim._title.addChild(_rewardItem);
					_dailyRewardAnim.gotoAndPlay(1);
					Main.self.tipLayer.addChildCenter(_dailyRewardAnim);
					break;
				default:
			}
		}		
		
		private function playDiscoveryAnim(data:Object):void
		{
			_runAnim = true;
			switch(data.subtype)
			{
				case 'paper':
				{
					if(_itemPaper) _findPaperAnim._title.removeChild(_itemPaper);
					_findPaperAnim.visible = true;
					_itemPaper = new McItem(data.img, 0, data.num, true, data.name);
					_itemPaper.x = 35;
					_itemPaper.y = 35;
					TipHelper.setTip(_itemPaper, Trans.transTips(data));
					_findPaperAnim._title.addChild(_itemPaper);
					_findPaperAnim.gotoAndPlay(1);
					Main.self.tipLayer.addChildCenter(_findPaperAnim);
					break;
				}
				case 'lesson':
				{
					if(_itemLesson) _findLessonAnim._title.removeChild(_itemLesson);
					_findLessonAnim.visible = true;
					_itemLesson = new McItem(data.img, 0, data.num, true, data.name);
					_itemLesson.x = 35;
					_itemLesson.y = 35;
					TipHelper.setTip(_itemLesson, Trans.transTips(data));
					_findLessonAnim._title.addChild(_itemLesson);
					_findLessonAnim.gotoAndPlay(1);
					Main.self.tipLayer.addChildCenter(_findLessonAnim);
					break;
				}
				case 'symbol':
				{
					if(_itemSymbol) _findSymbolAnim._title.removeChild(_itemSymbol);
					_findSymbolAnim.visible = true;
					_itemSymbol = new McItem(data.img, 0, data.num, true, data.name);
					_itemSymbol.x = 35;
					_itemSymbol.y = 35;
					TipHelper.setTip(_itemSymbol, Trans.transTips(data));
					_findSymbolAnim._title.addChild(_itemSymbol);
					_findSymbolAnim.gotoAndPlay(1);
					Main.self.tipLayer.addChildCenter(_findSymbolAnim);
					break;
				}
			}
		}
		
		private function playWarAnim(data:Object):void
		{
			if(data.union >= 3) return;
			_runAnim = true;
			_warVictory._txt.htmlText = data.txt;
			_warVictory._union.gotoAndStop(3 - data.union);
			Main.self.tipLayer.addChildCenter(_warVictory);
			_warVictory.gotoAndPlay(1);
			_warVictory.visible = true;
		}
		
		private function playCallKan(data:Object):void
		{
			_callKan.gotoAndPlay(1);
			_callKan._anim.gotoAndPlay(1);
			_callKan._anim._txt.htmlText = data.txt;
			_callKan._anim._union.gotoAndStop(data.union);
			_callKan._anim._head.gotoAndStop(data.head);
			_callKan._anim._bg.gotoAndStop(data.head);
			Main.self.tipLayer.addChildV(_callKan);
			_callKan.visible = true;
		}
		
		private function playTechAnim():void
		{
			_runAnim = true;
			Main.self.tipLayer.addChildCenter(_techLevelUpAnim);
			_techLevelUpAnim.gotoAndPlay(1);
			_techLevelUpAnim.visible = true;
		}
		
		private function playHonorAnim():void
		{
			_runAnim = true;
			var upAnim:MovieClip = Data.data.user.union == 1 ? _whiteHonorLevelUpAnim : _blackHonorLevelUpAnim;
			Main.self.tipLayer.addChildCenter(upAnim);
			upAnim.gotoAndPlay(1);
			upAnim.visible = true;
		}
		
		private function playBoyAnim():void
		{
			_runAnim = true;
			Main.self.tipLayer.addChildCenter(_boyLevelUpAnim);
			_boyLevelUpAnim.gotoAndPlay(1);
			_boyLevelUpAnim.visible = true;
		}
		
		private function playGirlAnim():void
		{
			_runAnim = true;
			Main.self.tipLayer.addChildCenter(_girlLevelUpAnim);
			_girlLevelUpAnim.gotoAndPlay(1);
			_girlLevelUpAnim.visible = true;
		}		
		
	}
}
