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
	public class GuildApplyItem extends Sprite
	{
		private var _mc:ResGuildApplyItem;

		public function GuildApplyItem(info : Object, callback:Function)
		{
			_mc = new ResGuildApplyItem;
			addChild(_mc);

			_mc._name.text = info.name;
			_mc._honor.text = info.honorLevel;
			_mc._tech.text = info.techLevel;
			
			var gid:int = Data.data.guild.id;
			
			new BmButton(_mc._detailedBtn, function():void{
				ControllerManager.userInfoController.showOtherUserInfo(info.id);
			});
			
			new BmButton(_mc._refuseBtn, function():void{
				ModelManager.guildModel.rejectGuildApply(gid, info.id, callback);
			});
			
			new BmButton(_mc._approveBtn, function():void{
				ModelManager.guildModel.agreeGuildApply(gid, info.id, callback);
			});
			
		}

	}
}
