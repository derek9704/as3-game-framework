package com.brickmice.view.guild
{
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class GuildListDetail extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "GuildListDetail";
		
		private var _mc:MovieClip;
		
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		
		public function GuildListDetail()
		{
			_mc = new ResGuildListDetailWindow;
			super(NAME, _mc);
			
			var info:Object = Data.data.guildDetail;
			
			_mc["_name"].text = info.name;
			_mc._manager.text = info.leader;
			_mc._lvl.text = info.level;
			_mc._member.text = info.memberCount;
			_mc._rank.text = info.rank;
			_mc._createDate.text = (info.createDate as String).substr(0, 10);
			
			// 面板
			_panel = new McList(1, 9, 0, 1, 225, 18, false);
			addChildEx(_panel, 49, 187);
			
			// 生成显示的面板
			_items = new Vector.<DisplayObject>;
			for each(var one:Object in info.member){
				var mc : GuildListMemberItem = new GuildListMemberItem(one);
				_items.push(mc);
			}
			_panel.setItems(_items);
		}
	}
}