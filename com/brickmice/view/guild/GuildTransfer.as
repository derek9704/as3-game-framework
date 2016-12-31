package com.brickmice.view.guild
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class GuildTransfer extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "GuildTransfer";
		
		private var _mc:MovieClip;
		private var _callback:Function;
		
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		
		public function GuildTransfer(callback:Function)
		{
			_mc = new ResGuildTransferWindow;
			super(NAME, _mc);
			
			_callback = callback;
			
			// 面板
			_panel = new McList(1, 13, 0, 3, 236, 17, false);
			addChildEx(_panel, 44, 89);
			
			setData();
		}
		
		public function setData():void
		{
			var data:Object = Data.data.guild;
			//生成条目
			_items = new Vector.<DisplayObject>;
			for each(var one:Object in data.member){
				if(one.id == Data.data.user.id) continue;
				var mc : GuildTransferItem = new GuildTransferItem(one, function():void{
					ModelManager.guildModel.guildInfo(data.id, function():void{
						_callback();
						closeWindow();
					})
				});
				_items.push(mc);
			}
			_panel.setItems(_items);
		}
		
	}
}