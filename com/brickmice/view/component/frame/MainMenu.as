package com.brickmice.view.component.frame
{
	import com.brickmice.ControllerManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.arena.Arena;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McTip;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.TipHelper;
	
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class MainMenu extends CSprite
	{
		
		public static const NAME : String = "MainMenu";
		
		/**
		 * 菜单资源
		 */
		private var _window : ResMainMenu;		
		private var _max : int;
		
		private var _iconPve:BmButton;
		private var _iconEquipCombine:BmButton;
		private var _iconGuild:BmButton;
		private var _iconBox:BmButton;
		private var _iconBoyHero:BmButton;
		private var _iconGirlHero:BmButton;
		private var _iconChuchai:BmButton;
		private var _iconArena:BmButton;
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_EXPBAR, ViewMessage.UPDATE_UNIT_STATUS, ViewMessage.REFRESH_NEWBIE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_EXPBAR:
					setExpBar();
					break;
				case ViewMessage.UPDATE_UNIT_STATUS:
					updateIconStatus();
					break;
				case ViewMessage.REFRESH_NEWBIE:
					NewbieController.showNewBieBtn(2, 1, this, 98, 35, false, "进入月球战场");
					NewbieController.showNewBieBtn(4, 1, this, 348, 35, true, "进入太阳的试炼");
					NewbieController.showNewBieBtn(5, 1, this, 348, 35, true, "进入太阳的试炼");
					NewbieController.showNewBieBtn(8, 1, this, 98, 35, false, "进入月球战场");
//					NewbieController.showNewBieBtn(21, 1, this, 444, 35, true, "打开噩梦鼠面板");
//					NewbieController.showNewBieBtn(20, 3, this, 444, 35, true, "打开噩梦鼠面板", true);
					NewbieController.showNewBieBtn(22, 1, this, 440, 35, true, "打开噩梦鼠面板");
//					NewbieController.showNewBieBtn(29, 1, this, 597, 35, true, "打开次元箱子");
//					NewbieController.showNewBieBtn(34, 1, this, 597, 35, true, "打开次元箱子");
//					NewbieController.showNewBieBtn(35, 1, this, 440, 35, true, "打开噩梦鼠面板");
					NewbieController.showNewBieBtn(12, 1, this, 518, 35, true, "打开科学美人面板");
//					NewbieController.showNewBieBtn(39, 3, this, 348, 35, true, "进入太阳的试炼");
					NewbieController.showNewBieBtn(6, 1, this, 597, 35, true, "打开次元箱子");
					NewbieController.showNewBieBtn(6, 4, this, 440, 35, true, "打开噩梦鼠面板");
//					NewbieController.showNewBieBtn(46, 1, this, 182, 35, true, "打开分子重组");
//					NewbieController.showNewBieBtn(47, 1, this, 268, 35, true, "打开星际联盟");
					break;
				default:
			}
		}	
		
		public function MainMenu()
		{
			_window = new ResMainMenu();
			
			super(NAME, _window.width, _window.height);
			addChildEx(_window);
			
			//设置经验条
			_max = _window._exp._expBar.width;
			_window._exp._expDetailed.visible = false;
			_window._exp.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_window._exp._expDetailed.visible = true;
			});
			_window._exp.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_window._exp._expDetailed.visible = false;
			});
			
			// 设置所有菜单项
			_iconPve = new BmButton(_window._iconPve, function() : void
			{	
				NewbieController.refreshNewBieBtn(4, 2);
				NewbieController.refreshNewBieBtn(5, 2);
				ControllerManager.solarController.showSolar();
			});
			_iconPve.enable = false;
			
			_iconEquipCombine = new BmButton(_window._iconEquipCombine, function() : void
			{	
				ControllerManager.equipCombineController.showEquipCombine();
			});
			_iconEquipCombine.enable = false;
			TipHelper.setTip(_window._iconEquipCombine, new McTip('科技等级14级开启'));
			
			_iconGuild = new BmButton(_window._iconGuild, function() : void
			{	
				ControllerManager.guildController.showGuild();
			});
			_iconGuild.enable = false;
			TipHelper.setTip(_window._iconGuild, new McTip('科技等级10级开启'));
			
			_iconBox = new BmButton(_window._iconBox, function() : void
			{	
				NewbieController.refreshNewBieBtn(6, 2);
				ControllerManager.bagController.showBag();
			});
			_iconBox.enable = false;
			_iconBoyHero = new BmButton(_window._iconBoyHero, function() : void
			{	
				NewbieController.refreshNewBieBtn(22, 2);
				NewbieController.refreshNewBieBtn(6, 5);
				ControllerManager.boyHeroController.showBoyHero();
			});
			_iconBoyHero.enable = false;
			_iconGirlHero = new BmButton(_window._iconGirlHero, function() : void
			{	
				NewbieController.refreshNewBieBtn(12, 2);
				ControllerManager.girlHeroController.showGirlHero();
			});
			_iconGirlHero.enable = false;
			
			_iconChuchai = new BmButton(_window._iconChuchai, function() : void
			{	
				ControllerManager.activityController.showGuaji();
			});
			_iconChuchai.enable = false;
			TipHelper.setTip(_window._iconChuchai, new McTip('科技等级20级开启'));
			
			_iconArena = new BmButton(_window._iconArena, function() : void
			{	
				NewbieController.hideNewBieBtn();
				NewbieController.refreshNewBieBtn(2, 2);
				NewbieController.refreshNewBieBtn(8, 2);
				ControllerManager.arenaController.showArena();
			});
			_iconArena.enable = false;
		}
		
		/**
		 * 更新Icon开启 
		 * 
		 */
		private function updateIconStatus():void
		{
			var finishedTask:Array = Data.data.finishedTask;
			var index:int = finishedTask.indexOf(5);
			if (index >= 0){
				_iconBox.enable = true;
			}
			index = finishedTask.indexOf(219);
			if (index >= 0){
				_iconChuchai.enable = true;
				TipHelper.clear(_window._iconChuchai);
			}
			index = finishedTask.indexOf(7);
			if (index >= 0){
				_iconArena.enable = true;
			}
			index = finishedTask.indexOf(1);
			if (index >= 0){
				_iconBoyHero.enable = true;
			}
			index = finishedTask.indexOf(9);
			if (index >= 0){
				_iconGirlHero.enable = true;
			}
			index = finishedTask.indexOf(1);
			if (index >= 0){
				_iconPve.enable = true;
			}
			index = finishedTask.indexOf(213);
			if (index >= 0){
				_iconEquipCombine.enable = true;
				TipHelper.clear(_window._iconEquipCombine);
			}
			index = finishedTask.indexOf(27);
			if (index >= 0){
				_iconGuild.enable = true;
				TipHelper.clear(_window._iconGuild);
			}
		}
		
		private function setExpBar():void
		{
			var techExp:int = Data.data.user.techExp;
			var upgradeTechExp:int = Data.data.user.upgradeTechExp;
			_window._exp._expBar.width = techExp / upgradeTechExp * _max;
			var msg:String = '科技点： ' + techExp.toString() + ' / ' + upgradeTechExp.toString() + '  (' + (techExp * 100 / upgradeTechExp).toFixed(2).toString()  + '%)';
			_window._exp._expDetailed.text = msg;
		}
		
	}
}
