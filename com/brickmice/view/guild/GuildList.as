package com.brickmice.view.guild
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.framework.core.ViewManager;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class GuildList extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "GuildList";
		
		private var _mc:MovieClip;
		private var _createGuildBtn:MovieClip;
		private var _nextBtn:MovieClip;
		private var _prevBtn:MovieClip;
		private var _searchBtn:MovieClip;
		private var _num:TextField;
		private var _searchContent:TextField;
		
		private var _page:int = 1;
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		
		public function GuildList(data : Object = null)
		{
			_mc = new ResGuildListWindow;
			super(NAME, _mc);
			
			_createGuildBtn = _mc._createGuildBtn;
			_nextBtn = _mc._nextBtn;
			_prevBtn = _mc._prevBtn;
			_searchBtn = _mc._searchBtn;
			_num = _mc._num;
			_searchContent = _mc._searchContent;
			
			_searchContent.maxChars = 6;
			_searchContent.text ='';
			
			new BmButton(_searchBtn, function():void{
				_page = 1;
				ModelManager.guildModel.guildList(1, _searchContent.text, setData);
			});
			
			new BmButton(_prevBtn, function():void{
				_page --;
				ModelManager.guildModel.guildList(_page, _searchContent.text, setData);
			});
			
			new BmButton(_nextBtn, function():void{
				_page ++;
				ModelManager.guildModel.guildList(_page, _searchContent.text, setData);
			});
			
			new BmButton(_createGuildBtn, function():void{
				if (ViewManager.hasView(GuildCreate.NAME)) return;
				var win:BmWindow = new GuildCreate();
				addChildCenter(win);		
			});		
			
			// 面板
			_panel = new McList(1, 11, 0, 1, 499, 20, false);
			addChildEx(_panel, 66, 93);
			
			setData();
			
			//新手指引
//			NewbieController.showNewBieBtn(47, 2, this, 594, 198, false, "选择加入一个联盟");
		}
		
		public function setData() : void
		{
			var data:Object = Data.data.guildList;
			UiUtils.setButtonEnable(_prevBtn, _page > 1);
			UiUtils.setButtonEnable(_nextBtn, _page < data.pageCount);
			var pageCount:String = data.pageCount != null ? data.pageCount : "1";
			_num.text = _page + "/" + pageCount;
			
			if(Data.data.guild && Data.data.guild.id) {
				UiUtils.setButtonEnable(_createGuildBtn, false);
			}
			
			//生成条目
			_items = new Vector.<DisplayObject>;
			for each(var one:Object in data.list){
				var mc : GuildListItem = new GuildListItem(one);
				_items.push(mc);
			}
			_panel.setItems(_items);
		}
	}
}