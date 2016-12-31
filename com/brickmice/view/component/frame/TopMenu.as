package com.brickmice.view.component.frame
{
	import com.brickmice.ControllerManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.arena.Arena;
	import com.brickmice.view.component.BmButton;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.greensock.TweenLite;
	
	/**
	 * 顶部按钮集 
	 * @author Derek
	 * 
	 */
	public class TopMenu extends CSprite
	{
		public static const NAME : String = "TopMenu";
		
		private var _iconExtraMoney : ResExtraMoneyBtn;
		private var _iconWarAlarm : ResWarAlarmBtn;
		private var _iconRank : ResRankBtn;
		private var _iconDiscovery : ResDiscoveryBtn;
		private var _iconActivity : ResActivityBtn;
		private var _iconHelper : ResHelperBtn;
		private var _iconBoss : ResBossBtn;
		private var _iconNotice : ResNoticeBtn;
		private var _iconCity : ResCityBtn;
		private var _iconWorld : ResWorldBtn;
		private var _arr : Array = [];
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.ENTER_CITY, ViewMessage.ENTER_WORLD, ViewMessage.REFRESH_WARALARMFLAG, 
				ViewMessage.UPDATE_UNIT_STATUS, ViewMessage.REFRESH_NEWBIE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.ENTER_CITY:
					_iconNotice.visible = Data.data.user.showNotice == '1';
					_iconActivity.visible = Data.data.system.showActivity == '1';
					
					var finishedTask:Array = Data.data.finishedTask;
					var index:int = finishedTask.indexOf(21);
					if (index >= 0){		
						_iconCity.visible = false;
						_iconWorld.visible = true;
						clickCallBack();
					}
					break;
				case ViewMessage.ENTER_WORLD:
					finishedTask = Data.data.finishedTask;
					index = finishedTask.indexOf(21);
					if (index >= 0){		
						_iconCity.visible = true;
						_iconWorld.visible = false;
						clickCallBack();
					}
					break;
				case ViewMessage.REFRESH_WARALARMFLAG:
					_iconWarAlarm.visible = (Data.data.warAlarmFlag == 1 && Data.data.user.techLevel >= 12);
					clickCallBack();
					break;
				case ViewMessage.UPDATE_UNIT_STATUS:
					updateIconStatus();
					clickCallBack();
					break;
				case ViewMessage.REFRESH_NEWBIE:
					if(_iconCity.visible) {
						NewbieController.showNewBieBtn(25, 1, this, -78, 33, true, "回到月球基地");
					}else{
						NewbieController.showNewBieBtn(22, 6, this, -78, 33, true, "前往星际棋盘");
						NewbieController.showNewBieBtn(26, 1, this, -78, 33, true, "前往星际棋盘");
					}
					NewbieController.showNewBieBtn(23, 1, this, -160, 33, true, "打开星球探索面板");
					break;
				default:
			}
		}	
		
		/**
		 * 更新Icon开启 
		 * 
		 */
		private function updateIconStatus():void
		{
			var finishedTask:Array = Data.data.finishedTask;
			var index:int = finishedTask.indexOf(22);
			if (index >= 0){
				_iconDiscovery.visible = true;
			}
			index = finishedTask.indexOf(21);
			if (index >= 0){
				if(!_iconCity.visible) _iconWorld.visible = true;
			}
			index = finishedTask.indexOf(223);
			if (index >= 0){
				_iconExtraMoney.visible = true;
			}
			index = finishedTask.indexOf(27);
			if (index >= 0){
				_iconRank.visible = true;
				_iconBoss.visible = true;
			}
			index = finishedTask.indexOf(205);
			if (index >= 0){
				_iconHelper.visible = true;
			}
		}
		
		public function TopMenu()
		{
			super(NAME, 0, 0, true);
			
			_iconCity = new ResCityBtn;
			new BmButton(_iconCity, function() : void{
//				NewbieController.refreshNewBieBtn(18, 2);
//				NewbieController.refreshNewBieBtn(30, 2);
				ControllerManager.cityController.enterCity();
			});
			addChildEx(_iconCity);
			_iconCity.visible = false;
			
			_iconWorld = new ResWorldBtn;
			new BmButton(_iconWorld, function() : void{
//				NewbieController.refreshNewBieBtn(17, 2);
				NewbieController.refreshNewBieBtn(22, 7);
				NewbieController.refreshNewBieBtn(26, 2);
//				NewbieController.refreshNewBieBtn(33, 2);
				ControllerManager.worldController.enterWorld();
			});
			addChildEx(_iconWorld);
			_iconWorld.visible = false;
			
			_iconHelper = new ResHelperBtn;
			new BmButton(_iconHelper, function() : void{
				ControllerManager.renpinController.showRenpin();
			});
			addChildEx(_iconHelper);
			_iconHelper.visible = false;
			
			_iconNotice = new ResNoticeBtn;
			new BmButton(_iconNotice, function() : void{
				ControllerManager.activityController.showNotice();
				_iconNotice.visible = false;
			});
			addChildEx(_iconNotice);
			
			_iconBoss = new ResBossBtn;
			new BmButton(_iconBoss, function() : void{
				ControllerManager.arenaController.showBoss();
			});
			addChildEx(_iconBoss);
			_iconBoss.visible = false;
			
			_iconDiscovery = new ResDiscoveryBtn;
			new BmButton(_iconDiscovery, function() : void{
				NewbieController.refreshNewBieBtn(23, 2);
				ControllerManager.discoveryController.showDiscovery();
			});
			addChildEx(_iconDiscovery);
			_iconDiscovery.visible = false;
			
			_iconActivity = new ResActivityBtn;
			new BmButton(_iconActivity, function() : void{
				ControllerManager.activityController.showActivity();
			});
			addChildEx(_iconActivity);
			
			_iconRank = new ResRankBtn;
			new BmButton(_iconRank, function() : void{
				ControllerManager.rankController.showRank();
			});
			addChildEx(_iconRank);
			_iconRank.visible = false;
			
			_iconExtraMoney = new ResExtraMoneyBtn;
			new BmButton(_iconExtraMoney, function() : void{
//				NewbieController.refreshNewBieBtn(41, 2);
				ControllerManager.extraMoneyController.showExtraMoney();
			});
			addChildEx(_iconExtraMoney);
			_iconExtraMoney.visible = false;
			
			_iconWarAlarm = new ResWarAlarmBtn;
			new BmButton(_iconWarAlarm, function() : void{
				ControllerManager.warAlarmController.showWarAlarm();
			});
			_iconWarAlarm.visible = false;
			addChildEx(_iconWarAlarm);
			
			_arr.push(_iconWorld, _iconCity, _iconDiscovery, _iconRank, _iconExtraMoney, _iconActivity,  _iconHelper, _iconBoss, _iconWarAlarm, _iconNotice);
		}		
		
		private function clickCallBack() : void
		{
			var num : int = -1;
			for (var i : int = 0 ; i < _arr.length ; i++)
			{
				if (_arr[i].visible)
				{
					TweenLite.to(_arr[i], 0.5, {x:num * 80 - 5, y:0});
					num--;
				}
			}
		}
	}
}