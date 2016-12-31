package com.brickmice.view.guild
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.DateUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class GuildMemberItem extends Sprite
	{
		private var _mc:ResGuildMemberItem;

		public function GuildMemberItem(info : Object, canKick:Boolean, callback:Function)
		{
			_mc = new ResGuildMemberItem;
			addChild(_mc);
			
			_mc._memberName.htmlText = "<a href='event:#'>" + info.name + "</a>";
			switch(info.job)
			{
				case "0":
				{
					_mc._popt.text = "会员";
					break;
				}
				case "1":
				{
					_mc._popt.text = "理事";
					break;
				}
				case "2":
				{
					_mc._popt.text = "盟主";
					break;
				}
			}
			_mc._honorLvl.text = info.honorLevel;
			_mc._techLvl.text = info.techLevel;
			_mc._todayContribution.text = info.dailyContr;
			_mc._totalContribution.text = info.totalContr;
			var leftTime:int = Math.floor(DateUtils.nowDateTimeByGap(Consts.timeGap)) - info.lastLoginTime; 
			if(leftTime <= 300){
				_mc._landingTime.text = '在线';
			}else{
				var minutes:int = leftTime / 60;
				var hour:int = minutes / 60;
				var day:int = hour /24;
				if(day > 0) _mc._landingTime.text = day + '天前';
				else if(hour > 0) _mc._landingTime.text = hour + '小时前';
				else _mc._landingTime.text = minutes + '分钟前';
			}
			leftTime = Math.floor(DateUtils.nowDateTimeByGap(Consts.timeGap)) - info.time; 
			_mc._new.visible = leftTime <= 3600 * 24;
			
			new BmButton(_mc._kickBtn, function():void{
				var data:Object = {};
				data.msg = "确认要将" + info.name + "踢出联盟？人家很伤心的哟~";
				data.action = "client";
				data.args = function():void{
					ModelManager.guildModel.kickGuild(Data.data.guild.id, info.id, function():void{
						ModelManager.guildModel.guildInfo(Data.data.guild.id, function():void{
							callback();
						})
					});
				}
				ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
			});
			
			_mc._kickBtn.visible = canKick;
			
			_mc._memberName.addEventListener(MouseEvent.CLICK, function():void{
				ControllerManager.userInfoController.showOtherUserInfo(info.id);
			});
		}

	}
}
