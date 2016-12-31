package com.brickmice.view.component.frame
{
	
	import com.brickmice.ControllerManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.McPanel;
	import com.framework.core.Message;
	import com.framework.ui.basic.sprite.CSprite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class TaskPanel extends CSprite
	{
		
		public static const NAME : String = "TaskPanel";
		private static var scollValue:Number = 0;
		public static var tempNewbieId:int = 100;
		
		private var _window : ResTask;
		private var _taskPanel:McPanel;
		private var _narrowBtn:MovieClip;
		private var _zoomBtn:MovieClip;
		
		public function TaskPanel()
		{
			_window = new ResTask();
			super(NAME, _window.width, _window.height);
			addChildEx(_window);
			
			_narrowBtn = _window._narrowBtn;
			_zoomBtn = _window._zoomBtn;
			
			_window._questWindowBg.height = 244;
	
			_window._chargeBtn.buttonMode = true;
			_window._chargeBtn.addEventListener(MouseEvent.CLICK,  function():void{
				ControllerManager.activityController.showShouChong();
			});

			new BmButton(_zoomBtn, function():void{
				_narrowBtn.visible = true;
				_zoomBtn.visible = false;
				_taskPanel.visible = true;
				_window._questWindowBg.height = 244;
			});
			
			new BmButton(_narrowBtn, function():void{
				_narrowBtn.visible = false;
				_zoomBtn.visible = true;
				_taskPanel.visible = false;
				_window._questWindowBg.height = 48;
			});
		}
		
		private function setData():void
		{
			//清空数据
			if (_taskPanel != null && _taskPanel.stage)
			{
				_taskPanel.removeSelf();
			}
			// 面板
			_taskPanel = new McPanel("", 193, 187, true, true);
			_taskPanel.visible = _narrowBtn.visible;
			addChildEx(_taskPanel, 11, 41);
			_taskPanel.scrollCallBack = function():void{
				scollValue = _taskPanel.vScrollValue;
			};

			// 获取相应类型的物品列表
			var items:Array = [];
			for each(var info:Object in Data.data.task) items.push(info);
			//按照任务ID排序
			items.sortOn("id", Array.NUMERIC);
			//更新全局的新手箭头
			tempNewbieId = 100;
			NewbieController.newbieTaskFinished = false;
			//先解析一下任务，把完成的提到前面来
			var itemsFinished:Array = [];
			var itemsUnfinished:Array = [];
			for (var i:int = 0; i < items.length; i++) 
			{
				//设置显示每个任务的显示对象
				var eTask:EveryTask = new EveryTask(items[i]);
				if(eTask.isComplete) itemsFinished.push(eTask);
				else itemsUnfinished.push(eTask);
			}
			//显示
			var infoHeight:int = 0;
			for each (var everyTask:EveryTask in itemsFinished) 
			{
				everyTask.y = infoHeight;
				_taskPanel.addItem(everyTask);
				infoHeight += everyTask.cHeight;
				//更新下新手箭头
				if(tempNewbieId == everyTask.id){
					NewbieController.showNewBieBtn(tempNewbieId, 0, this, 120, infoHeight + 31, true, '获得任务奖励');
				}
			}
			for each (var everyTask2:EveryTask in itemsUnfinished) 
			{
				everyTask2.y = infoHeight;
				_taskPanel.addItem(everyTask2);
				infoHeight += everyTask2.cHeight;
			}
			
			_taskPanel.vScrollValue = scollValue;
			
			//更新新手引导
			if(tempNewbieId != NewbieController.newbieTaskId){
				NewbieController.newbieTaskId = tempNewbieId;
				NewbieController.newbieTaskStep = 1;
				NewbieController.hideNewBieBtn();
				NewbieController.refreshNewBieBtn(tempNewbieId, 1);
			}
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_TASK, ViewMessage.REFRESH_SHOUCHONGREWARD];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_TASK:
					setData();
					break;
				case ViewMessage.REFRESH_SHOUCHONGREWARD:
					_window._chargeBtn.visible = Data.data.user.shouChongRewardGot != 1;
					//绿色服
					if(Consts.isGreen) _window._chargeBtn.visible = false;
					break;
				default:
			}
		}		
	}
}
