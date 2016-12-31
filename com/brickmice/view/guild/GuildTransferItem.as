package com.brickmice.view.guild
{
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
	public class GuildTransferItem extends Sprite
	{
		private var _mc:ResGuildTransferItem;

		public function GuildTransferItem(info : Object, callback:Function)
		{
			_mc = new ResGuildTransferItem;
			addChild(_mc);

			_mc._name.text = info.name;
			_mc._totalContr.text = info.totalContr;
			_mc._tech.text = info.techLevel;
			
			var gid:int = Data.data.guild.id;

			new BmButton(_mc._approveBtn, function():void{
				ModelManager.guildModel.guildLeaderChange(gid, info.id, callback);
			});
			
		}

	}
}
