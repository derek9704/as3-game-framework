package com.brickmice.view.component.layer
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.chat.Chat;
	import com.brickmice.view.component.frame.Effect;
	import com.brickmice.view.component.frame.HeadInfo;
	import com.brickmice.view.component.frame.MainMenu;
	import com.brickmice.view.component.frame.StateTrack;
	import com.brickmice.view.component.frame.TaskPanel;
	import com.brickmice.view.component.frame.TopMenu;
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.layer.CLayer;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * ui层
	 *
	 * @author derek
	 */
	public class UiLayer extends CLayer
	{
		private var _upBorder:ResTopBg;
		private var _mainMenu : MainMenu;
		private var _userPanel : HeadInfo;
		private var _effect : Effect;
		private var _btnSprite : TopMenu;
		private var _shopBtn:ResShopBtn;
		private var _giftBtn:ResGiftBtn;
		private var _stateTrack : StateTrack;
		private var _chat : Chat;
		private var _taskPanel : TaskPanel;
		// private var _systemNoticeForm : SystemNoticeForm;
		public static const ALL:int = 254;
		public static const NOTICEFORM:int = 128;
		public static const TASKTRACK:int = 64;
		public static const STATETRACK:int = 32;
		public static const CHAT:int = 16;
		public static const BTNS:int = 8;
		public static const MENU:int = 4;
		public static const HEAD:int = 2;
		public static const HIDE:int = 0;
		
		public function UiLayer(width:int, height:int)
		{
			super(width, height);
			
			//  上边框
			_upBorder = new ResTopBg;
			_upBorder.width = cWidth - 232;
			addChildEx(_upBorder, 0, 0, CCanvas.rt);
			
			//  加入用户面板
			_userPanel = new HeadInfo();
			addChildEx(_userPanel, 0, -3);
			
			//商城
			_shopBtn = new ResShopBtn;
			 new BmButton(_shopBtn, function() : void{
				 navigateToURL(new URLRequest(Data.data.system.chargeUrl), "_blank");
			});
			addChildEx(_shopBtn, 263, 0);
			
			//礼包
			_giftBtn = new ResGiftBtn;
			new BmButton(_giftBtn, function() : void{
				ControllerManager.blueSunController.showGift();
			});
			addChildEx(_giftBtn, 323, 0);
			
			// 加入效果
			_effect = new Effect();
			addChildEx(_effect);
			
			//  加入主菜单
			_mainMenu = new MainMenu();
			addChildEx(_mainMenu, 0, 0, CCanvas.rb);
			
			//  加入追踪面板
			_stateTrack = new StateTrack();
			addChildEx(_stateTrack, 10, 100);
			
			//  加入聊天FLASH
			_chat = new Chat();
			addChildEx(_chat, 1, -1, CCanvas.lb);
			
			//  加入任务面板
			 _taskPanel = new TaskPanel();
			 addChildEx(_taskPanel, 10, 70, rt);
			 
			 _btnSprite = new TopMenu();
			 addChildEx(_btnSprite, 0, 0, CCanvas.rt);
			 
			 // 当层被修改大小的时候的响应事件
			 onResize = function():void
			 {
				 _upBorder.width = cWidth - 232;
			 };
		}
		
		public function get effect():Effect
		{
			return _effect;
		}

		public function set headVisible(value:int):void
		{
			_userPanel.visible = (value & 2) != 0;
			_mainMenu.visible = (value & 4) != 0;
			_btnSprite.visible = (value & 8) != 0;
		    _shopBtn.visible = _giftBtn.visible = _btnSprite.visible;
			_chat.visible = (value & 16) != 0;
			_stateTrack.visible = ((value & 32) != 0) && Data.data.user.techLevel >= 3;
			_taskPanel.visible = (value & 64) != 0;
			_upBorder.visible = value ? true : false;
			
			
			//绿色服
			if(Consts.isGreen){
				_shopBtn.visible = false;
				addChildEx(_giftBtn, 263, 0);
			}
		}
	}
}
