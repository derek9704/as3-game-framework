package com.brickmice.view.guild
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCheckBox;
	import com.brickmice.view.component.BmWindow;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class GuildSetting extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "GuildSetting";
		
		private var _mc:MovieClip;
		private var _verify:int;
		
		public function GuildSetting(callback:Function)
		{
			_mc = new ResGuildSettingWindow;
			super(NAME, _mc);
			
			(_mc._qq as TextField).maxChars = 10;
			(_mc._des as TextField).maxChars = 55;
			
			var data:Object = Data.data.guild;
			
			_mc._qq.text = data.qq;
			_mc._des.text = data.claim;
			
			new BmCheckBox(_mc._checkbox, function():void{
				_verify = 1- _verify;
			}, data.verify == 0);
			
			_verify = data.verify;
			
			new BmButton(_mc._yesBtn, function():void{
				ModelManager.guildModel.guildSetting(Data.data.guild.id, _verify, _mc._qq.text, _mc._des.text, function():void{
					closeWindow();
					callback();
				});
			});
			
		}
	}
}