package com.brickmice.view.component.frame
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.view.component.McLabel;
	import com.brickmice.view.component.McTip;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.FilterUtils;
	import com.framework.utils.TipHelper;
	
	import flash.events.MouseEvent;
	
	public class EveryTask extends CSprite
	{
		public var isComplete:Boolean = true;
		public var id:int;
		
		public function EveryTask(data:Object)
		{
			super("", 180);
			
			id = data.id;
			//任务名
			var taskNameStr:String = data.name;
			//任务类型(1:新手，2：主线，3：每日，4：联盟)
			switch(data.type)
			{
				case "1":
					taskNameStr = "【新手】" + taskNameStr;
					//更新一下全局的新手ID
					TaskPanel.tempNewbieId = data.id;
					break;
				case "2":
					taskNameStr = "【主线】" + taskNameStr;
					break;
				case "3":
					taskNameStr = "【每日】" + taskNameStr;
					break;
				case "4":
					taskNameStr = "【联盟】" + taskNameStr;
					break;
			}
			var taskName:McLabel = new McLabel(taskNameStr, 0x000000, 'left', 180);
			addChildEx(taskName);
			//任务描述
			var taskDes:McLabel = new McLabel(data.des, 0x1f5919, 'left', 180);
			addChildEx(taskDes, 0, taskName.height);
			taskDes.mouseEnabled = true;
			taskDes.selectable = false;
			taskDes.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				FilterUtils.glow(taskDes, 0xFFFFFF);
			});
			taskDes.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				FilterUtils.clearGlow(taskDes);
			});
			TipHelper.setTip(taskDes, new McTip(data.aimStr[i]));
			//设置目标数值
			for(var i:int = 0, len:int = data.aims.length ; i < len ; i++)
			{
				if(data.aims[i][2] > data.aims[i][3]) {
					isComplete = false;
				}
				var targetStr:String = data.aims[i][3] + "/" + data.aims[i][2];
				var target:McLabel = new McLabel(targetStr, 0xFF0000, 'left', 180);
				addChildEx(target, 0, taskName.height + taskDes.height + i * target.height);
			}
			//领取奖励文本
			if(isComplete){
				var getReward:McLabel = new McLabel("<a href='event:#'><u>[领取奖励]</u></a>", 0xFFFF00, 'left', 0, 0, 12, false, [FilterUtils.createGlow(0x000000, 500)]);
				getReward.mouseEnabled = true;
				getReward.selectable = false;
				//领取奖励点击效果
				getReward.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
					ModelManager.taskModel.finishTask(data.id, function():void{});
				});
				addChildEx(getReward, 111, target.y);
				//更新一下全局的新手任务是否完成
				if(TaskPanel.tempNewbieId == data.id){
					NewbieController.newbieTaskFinished = true;
				}
			}
			//设置高度
			cHeight = target.y + target.height;
		}
	}
}