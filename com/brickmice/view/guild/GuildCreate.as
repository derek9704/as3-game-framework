package com.brickmice.view.guild
{
	import com.brickmice.ModelManager;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCheckBox;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.ViewManager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class GuildCreate extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "GuildCreate";
		
		private var _mc:MovieClip;
		private var _verify:int = 1;
		
		public function GuildCreate()
		{
			_mc = new ResGuildCreateWindow;
			super(NAME, _mc);
			
			(_mc._name as TextField).maxChars = 6;
			(_mc._qq as TextField).maxChars = 10;
			(_mc._des as TextField).maxChars = 55;
			
			_mc._name.text = "";
			_mc._qq.text = "";
			_mc._des.text = "";
			
			new BmCheckBox(_mc._checkbox, function():void{
				_verify = 1- _verify;
			});
			
			new BmButton(_mc._yesBtn, function():void{
				ModelManager.guildModel.createGuild(_mc._name.text, _verify, _mc._qq.text, _mc._des.text, function():void{
					(ViewManager.retrieveView(GuildList.NAME) as GuildList).closeWindow();
				});
			});
			
		}
	}
}