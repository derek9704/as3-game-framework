package com.brickmice.view.guild
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.ViewManager;
	import com.framework.utils.UiUtils;
	
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class GuildListItem extends Sprite
	{
		private var _mc:ResGuildListItem;

		public function GuildListItem(info : Object)
		{
			_mc = new ResGuildListItem;
			addChild(_mc);

			_mc._campLogo.gotoAndStop(Data.data.user.union);
			_mc._name.text = info.name;
			_mc._auditLogo.gotoAndStop(2 - info.verify);
			_mc._rank.text = info.rank;
			_mc._lvl.text = info.level;
			_mc._guildManager.text = info.leader;
			_mc._member.text = info.memberCount;
			_mc._full.visible = int(info.memberCount) >= int(info.memberLimit);
			
			new BmButton(_mc._detailedBtn, function():void{
				ControllerManager.guildController.showOtherGuildInfo(info.id);
			});
			
			new BmButton(_mc._joinBtn, function():void{
				UiUtils.setButtonEnable(_mc._joinBtn, false);
				ModelManager.guildModel.applyGuild(info.id);
			});
			
			if(Data.data.guild && Data.data.guild.id){
				UiUtils.setButtonEnable(_mc._joinBtn, false);
			}
		}

	}
}
