package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.solar.Solar;
	import com.framework.core.ViewManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 新手指引
	 *
	 * @author derek
	 */
	public class NewbieController
	{
		/**
		 * 当前新手任务ID
		 */
		public static var newbieTaskId : int = 100;
		/**
		 * 当前新手任务步骤
		 */
		public static var newbieTaskStep : int = 1;
		/**
		 * 是否完成当前新手任务
		 */
		public static var newbieTaskFinished : Boolean = false;
		
		/**
		 * 记录提示过的新手任务ID
		 */
		private static var hintedTaskId : int = 0;
		/**
		 * 记录提示过的新手任务步骤
		 */
		private static var hintedTaskStep : int = 0;
		
		
		/**
		 * 显示新手箭头
		 * 
		 */
		public static function showNewBieBtn(taskId:int, taskStep:int, container:DisplayObjectContainer, x:int, y:int, dir:Boolean, text:String, ignoreTaskFinished:Boolean = false, hasMask:Boolean = false):void
		{
			if((taskStep == 0) || (newbieTaskId == taskId && newbieTaskStep == taskStep && (!newbieTaskFinished || ignoreTaskFinished))){	
				Main.self.newbieBtn.x = x;
				Main.self.newbieBtn.y = y;
				Main.self.newbieBtn.gotoAndStop(dir ? 1 : 2);
				Main.self.newbieBtn._arrow._detailed.text = text;
				Main.self.newbieBtn._mask.visible = hasMask || taskId <= 5;
				container.addChild(Main.self.newbieBtn);
				//只提示一次
				if(hintedTaskId == taskId && hintedTaskStep == taskStep) return;
				hintedTaskId = taskId;
				hintedTaskStep = taskStep;
				//这里放梦露的提示
				switch(taskId)
				{
					case 1:
					{
						if(taskStep == 1){
							monroeHint(container, '勇敢的' + Data.data.user.name + '，等你好久了，我是梦露。');
							monroeHint(container, '这里是月球，你的基地，你将从这里起步。建设基地，训练噩梦鼠军团，最终称霸银河！');
							monroeHint(container, '你的师傅被外星人抓走了。。。所以，悟空，你在哪里？~');
						}
						break;
					}
					case 4:
					{
						if(taskStep == 1){
							monroeHint(container, '太阳的试炼就是个人副本了，在这里可以训练噩梦鼠，还可获得各类装备。');
						}else if(taskStep == 2){
							monroeHint(container, '欢迎来到美丽的太阳系，这里共有10颗星球，会随着攻略进度逐步开放。');
						}else if(taskStep == 4){
							monroeHint(container, '首先选择一只出战的噩梦鼠');
						}else if(taskStep == 7){
							monroeHint(container, '噩梦鼠是将领，带兵才能打仗。所以需要先给他配备发条鼠。');
						}else if(taskStep == 0){
							if (ViewManager.hasView(Solar.NAME)) {
								monroeHint(container, '任务完成，离开太阳的试炼去领奖励吧~');
							}
						}
						break;
					}
					case 5:
					{
						if(taskStep == 0){
							if (ViewManager.hasView(Solar.NAME)) {
								monroeHint(container, '任务完成，离开太阳的试炼去领奖励吧~');
							}
						}
						break;
					}	
					case 6:
					{
						if(taskStep == 1){
							monroeHint(container, '打开装备礼包，获得基础装备');
						}else if(taskStep == 4){
							monroeHint(container, '给噩梦鼠装备上吧');
						}
						break;
					}
					case 7:
					{
						if(taskStep == 1){
							monroeHint(container, '消耗宇宙币强化装备，可以大大提升噩梦鼠的战斗力');
						}
						break;
					}
					case 2:
					{
						if(taskStep == 1){
							monroeHint(container, '荣誉等级代表了玩家的战斗等级。在月球战场，你可以与其他玩家切磋武艺。同时提升噩梦鼠和荣誉等级。');
						}else if(taskStep == 2){
							monroeHint(container, '照例先选择出战噩梦鼠');
						}else if(taskStep == 5){
							monroeHint(container, '升级后，我们可以多带几个发条鼠~');
						}
						break;
					}
					case 3:
					{
						if(taskStep == 0){
							if (ViewManager.hasView(Solar.NAME)) {
								monroeHint(container, '任务完成，离开太阳的试炼去领奖励吧~');
							}
						}
						break;
					}
					case 9:
					{
						if(taskStep == 1){
							monroeHint(container, '下面向你介绍科学美人，噩梦鼠在外征战，美人负责基地建设。');
							monroeHint(container, '我们先招募一个科学美人吧');
						}
						break;
					}
					case 10:
					{
						if(taskStep == 1){
							monroeHint(container, '科技等级代表了玩家的建设等级，研究所是提升科技等级的主要场所');
						}else if(taskStep == 2){
							monroeHint(container, '只要将科学美人加入研究所，然后开始研究，就会自动获取经验');
						}
						break;
					}
					case 11:
					{
						if(taskStep == 1){
							monroeHint(container, '迅速提高科技等级的办法就是科技攻关');
							monroeHint(container, '研究所中的美人即是科技攻关的参与者');
						}else if(taskStep == 3){
							monroeHint(container, '这里是攻关场景，你的美人会轮番出战，攻击魔方，待魔方旋转归位时就攻关成功啦~');
							monroeHint(container, '画面正下方这排是攻关用的心电图，当光波停在最高点时点击攻关按钮，就能打出暴击哦！');
						}
						break;
					}
					case 12:
					{
						if(taskStep == 1){
							monroeHint(container, '科技课题攻关成功后，获得科学技能');
							monroeHint(container, '科学美人可以装备科学技能以提升能力');
						}
						break;
					}
					case 16:
					{
						if(taskStep == 1){
							monroeHint(container, '我们的稀铁矿恢复工作了！');
							monroeHint(container, '升级稀铁矿，提高稀铁产量');
						}
						break;
					}	
					case 17:
					{
						if(taskStep == 1){
							monroeHint(container, '宝石矿也恢复工作了！');
							monroeHint(container, '宇宙中共有3种能量宝石，宝石矿只产出本方阵营的宝石，墨色银河帝国产出夜石莉莉斯，白色宇宙国际产出月石夏娃。');
							monroeHint(container, '升级宝石矿，提高宝石产量');
						}
						break;
					}		
					case 15:
					{
						if(taskStep == 1){
							monroeHint(container, '发条鼠还够用么？现在可以自己制造了');
						}
						if(taskStep == 3){
							monroeHint(container, '制造发条鼠消耗稀铁');
						}
						break;
					}
					case 18:
					{
						if(taskStep == 1){
							monroeHint(container, '我们的奶酪原浆矿恢复工作了！');
							monroeHint(container, '升级奶酪原浆矿，提高原浆产量');
						}
						break;
					}
					case 25:
					{
						if(taskStep == 1){
							monroeHint(container, '奶酪用来做什么？可不是给老鼠吃的，是用来做贸易的，奶酪贸易将会带来大量宇宙币');
						}else if(taskStep == 0){
							monroeHint(container, '奶酪品种会随着奶酪工厂等级提高而逐步开放');
						}
						break;
					}
					case 21:
					{
						if(taskStep == 1){
							monroeHint(container, '终于要向银河进军了！');
							monroeHint(container, '在银河通行，需要搭载银河列车');
						}
						break;
					}	
					case 26:
					{
						if(taskStep == 1){
							monroeHint(container, '勇敢的少年啊，我们终于要前往神秘的银河了，前方会有什么等待着你呢？');
							monroeHint(container, '让我们先把之前生产的那些奶酪卖掉吧。');
						}else if(taskStep == 2){
							monroeHint(container, '欢迎来到广袤的银河，你的脚步将不再停留在月球，这里所有的星球都将留下你的足迹');
						}else if(taskStep == 0){
							monroeHint(container, '列车到达后，你就能收到宇宙币了');
						}
						break;
					}
					case 20:
					{
						if(taskStep == 1){
							monroeHint(container, '科技等级的提升也会提升可招募英雄的上限');
							monroeHint(container, '现在我们再去招募一只噩梦鼠和一个科学美人吧~');
						}else if(taskStep == 0){
							monroeHint(container, '千万不要忘记将美人加入研究所，并配上技能哦~');
						}
						break;
					}	
					case 22:
					{
						if(taskStep == 1){
							monroeHint(container, '噩梦鼠可以被派去银河执行任务，给你的噩梦鼠配上士兵出发吧！');
						}else if(taskStep == 13){
							monroeHint(container, '使用立即到达，免去银河列车的行驶时间');
						}else if(taskStep == 0){
							monroeHint(container, '你的噩梦鼠已经到达指定星球了');
						}
						break;
					}
					case 23:
					{
						if(taskStep == 1){
							monroeHint(container, '星球探索可以获得经验和宝物，越高等级的噩梦鼠探索成功的几率越大~');
						}
						break;
					}
					case 27:
					{
						if(taskStep == 0){
							monroeHint(container, '恭喜你，你已经是一名合格的银河战士了！');
							monroeHint(container, '长路漫漫，前方还有无尽的试炼等待着你！');
							monroeHint(container, '无所适从时，记得多和其他的玩家交流！');
							monroeHint(container, '前进吧，少年！这是属于你的世界！');
						}
						break;
					}
				}
				return;
			}
		}
	
		/**
		 * 梦露提示
		 * 
		 */
		private static function monroeHint(container:DisplayObjectContainer, msg:String):void
		{
			if(container.stage) {
				var timeFlag:uint = setTimeout(function():void{
					clearTimeout(timeFlag);
					ControllerManager.yahuanController.showYahuan(msg);
				}, 100);
			}else{
				container.addEventListener(Event.ADDED_TO_STAGE, function():void{
					container.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
					ControllerManager.yahuanController.showYahuan(msg);
				});	
			}
		}
		
		/**
		 * 隐藏新手箭头
		 * 
		 */
		public static function hideNewBieBtn():void
		{
			if(Main.self.newbieBtn.parent) Main.self.newbieBtn.parent.removeChild(Main.self.newbieBtn);
		}
		
		/**
		 * 发送更新新手箭头信息 
		 */
		public static function refreshNewBieBtn(taskId:int, taskStep:int, forceNextStep:Boolean = false, ignoreTaskFinished:Boolean = false):void
		{
			if(newbieTaskId == 100 || newbieTaskId != taskId) return;
			if(!ignoreTaskFinished && newbieTaskFinished) return;
			if(forceNextStep && ((taskStep - newbieTaskStep) != 1)) return;
			newbieTaskStep = taskStep;
			ViewManager.sendMessage(ViewMessage.REFRESH_NEWBIE);
		}
		
	}
}
