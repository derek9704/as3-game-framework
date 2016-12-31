package com.brickmice.view.component.frame
{
	
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McTip;
	import com.framework.core.Message;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.SoundUtils;
	import com.framework.utils.TipHelper;
	
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	
	/**
	 * @author derek
	 */
	public class HeadInfo extends CSprite
	{
		
		public static const NAME : String = "HeadInfo";
		private var _window : ResHead;
		private var systemBtn:ResSystemBtn;
		private var _headImg:McImage;
		private var _gotMoneyAnim:MovieClip;
		
		private var _runOnce:Boolean = false;
		
		public function HeadInfo()
		{
			_window = new ResHead();
			super(NAME, _window.width, _window.height);
			addChildEx(_window);
			
			TipHelper.setTip(_window._coins, new McTip("宇宙币"));
			TipHelper.setTip(_window._golden, new McTip("宇宙钻"));
			TipHelper.setTip(_window._techLvl, new McTip("科技等级"));
			TipHelper.setTip(_window._honorLvl, new McTip("荣誉等级"));
			TipHelper.setTip(_window._vip, new McTip("VIP特权"));
			
			_window._vip.buttonMode = true;
			_window._vip.addEventListener(MouseEvent.CLICK, function():void{
				ControllerManager.vipController.showVip();
			});
			
			_window._rechargeBtn.visible = false;
			
			new BmButton(_window._head, function():void{
				ControllerManager.userInfoController.showUserInfo();
			});
			
			systemBtn = new ResSystemBtn;
			new BmButton(systemBtn._maximizeBtn, function() : void{
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				systemBtn._maximizeBtn.visible = false;
				systemBtn._maximize2Btn.visible = true;
			});
			TipHelper.setTip(systemBtn._maximizeBtn, new McTip("全屏模式"));
			
			new BmButton(systemBtn._maximize2Btn, function() : void{
				stage.displayState = StageDisplayState.NORMAL;
				systemBtn._maximizeBtn.visible = true;
				systemBtn._maximize2Btn.visible = false;
			});
			TipHelper.setTip(systemBtn._maximize2Btn, new McTip("退出全屏"));
			
			new BmButton(systemBtn._soundBtn, function() : void{
				ModelManager.userModel.switchMusic();
				musicControl(false);
			});
			TipHelper.setTip(systemBtn._soundBtn, new McTip("关闭音乐"));
			
			new BmButton(systemBtn._sound2Btn, function() : void{
				ModelManager.userModel.switchMusic();
				musicControl(true);
			});
			TipHelper.setTip(systemBtn._sound2Btn, new McTip("开启音乐"));
			
			new BmButton(systemBtn._mailBtn, function() : void{
				ControllerManager.mailController.showMail();
			});
			TipHelper.setTip(systemBtn._mailBtn, new McTip("邮件"));
			
			systemBtn._maximize2Btn.visible = false;
			systemBtn._sound2Btn.visible = false;
			addChildEx(systemBtn, 234, 2);
		}	
		
		private function musicControl(musicState:Boolean):void{
			systemBtn._soundBtn.visible = musicState == true;
			systemBtn._sound2Btn.visible = musicState == false;
			SoundUtils.musicState = musicState;
			SoundUtils.musicControl();	
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.SET_MUSIC, ViewMessage.NEW_MAIL, ViewMessage.REFRESH_USER];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_USER:
					setInfo();
					break;
				case ViewMessage.SET_MUSIC:
					systemBtn._soundBtn.visible = message.data == true;
					systemBtn._sound2Btn.visible = message.data == false;
					break;
				case ViewMessage.NEW_MAIL:
					systemBtn._mailBtn.gotoAndStop(4);
					break;
				default:
			}
		}	
		
		/**
		 * 使用用户数据来填充用户面板
		 */
		private function setInfo() : void
		{
			if(!_runOnce){
				//以下只初始化一次
				_window._playerName.text = Data.data.user.name;
				_window._campLogo.gotoAndStop(Data.data.user.union);
				TipHelper.setTip(_window._campLogo, new McTip(Data.data.user.unionName));
				
				_headImg = new McImage(Data.data.user.headImg);
				_headImg.mouseEnabled = false;
				addChildEx(_headImg, 18, 1);
				
				//各种效果
				_gotMoneyAnim = new ResGotMoneyAnim;
				_gotMoneyAnim.gotoAndStop(1);
				_gotMoneyAnim.visible = false;
				addChildEx(_gotMoneyAnim, 100, 30);
				_gotMoneyAnim.addFrameScript(_gotMoneyAnim.totalFrames - 1, function():void{
					_gotMoneyAnim.stop();
					_gotMoneyAnim.visible = false;
				});
				
				_runOnce = true;
			}
			var coinsNow:int = int(_window._coins.text);
			if(Data.data.user.coins > coinsNow){
				_gotMoneyAnim.gotoAndPlay(1);
				_gotMoneyAnim.visible = true;
			}
			
			_window._job.text = Data.data.user.honorName;
			
			_window._coins.text = Data.data.user.coins;
			
			_window._golden.text = (int(Data.data.user.golden) + int(Data.data.user.silver)).toString();
			
			_window._honorLvl.text = Data.data.user.honorLevel;
			
			_window._techLvl.text = Data.data.user.techLevel;
			
			_window._vip.gotoAndStop(int(Data.data.user.vip) + 1);
		}		
		
		
	}
}
