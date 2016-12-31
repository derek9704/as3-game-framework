package com.brickmice.view.guild
{
	import com.brickmice.ModelManager;
	import com.brickmice.view.component.BmButton;
	
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class GuildTaskItem extends Sprite
	{
		private var _mc:ResGuildTaskItem;

		public function GuildTaskItem(gid:int, info : Object, callback:Function)
		{
			_mc = new ResGuildTaskItem;
			addChild(_mc);
			
			_mc._title.text = info.name;
			_mc._des.text = info.des;
			_mc._num1.text = info.aims[0][3];
			_mc._num2.text = info.aims[0][2];
				
			var btn:BmButton = new BmButton(_mc._awardBtn, function():void{
				ModelManager.taskModel.finishTask(info.id, function():void{
					ModelManager.guildModel.guildInfo(gid, function():void{
						callback();
					})
				});
			});
			btn.enable = info.aims[0][3] >= info.aims[0][2];
		}

	}
}
