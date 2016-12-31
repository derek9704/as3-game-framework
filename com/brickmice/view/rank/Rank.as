package com.brickmice.view.rank
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.framework.utils.KeyValue;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class Rank extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Rank";
		
		private var _mc:MovieClip;

		private var _tabView : BmTabView;
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _page:int = 1;
		private var _type:String = '6';
		
		public function Rank(data : Object)
		{
			_mc = new ResRankWindow;
			super(NAME, _mc);
			
			new BmButton(_mc._jumpBtn, function():void{
				ModelManager.rankModel.getRankData(int(_type), int(_mc._jumpNum.text), setData);
			});
			
			new BmButton(_mc._myRankBtn, function():void{
				ModelManager.rankModel.getMyRankData(int(_type), setData);
			});
			
			new BmButton(_mc._prevBtn, function():void{
				_page--;
				ModelManager.rankModel.getRankData(int(_type), _page, setData);
			});
			
			new BmButton(_mc._nextBtn, function():void{
				_page++;
				ModelManager.rankModel.getRankData(int(_type), _page, setData);
			});
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue('1', _mc._honorTab), new KeyValue('2', _mc._techTab), new KeyValue('3', _mc._girlHeroTab), new KeyValue('4', _mc._boyHeroTab), new KeyValue('5', _mc._guildTab), new KeyValue('6', _mc._teamTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				_type = id;
				ModelManager.rankModel.getMyRankData(int(_type), setData);
			});
			
			// 面板
			_panel = new McList(1, 10, 0, 0, 499, 20, false);
			addChildEx(_panel, 68.8, 130.4);
			
			setData();
		}
		
		public function setData() : void
		{
			_mc._boyHeroTop.visible = false;
			_mc._girlHeroTop.visible = false;
			_mc._techTop.visible = false;
			_mc._honorTop.visible = false;
			_mc._guildTop.visible = false;
			_mc._teamTop.visible = false;
			
			_tabView.selectId = _type;
			var data:Object = Data.data.rank;
			_page = data.pageNow;
			_mc._num.text = data.pageNow + '/' + data.pageCount;
			UiUtils.setButtonEnable(_mc._prevBtn, data.pageNow > 1);
			UiUtils.setButtonEnable(_mc._nextBtn, data.pageNow < data.pageCount);
			_items = new Vector.<DisplayObject>;
			var item:Object;
			switch(_type)
			{
				case '1':
				{
					_mc._honorTop.visible = true;
					for each (item in data.info) 
					{
						var mc : RankHonorItem = new RankHonorItem(item);
						mc.buttonMode = true;
						_items.push(mc);
					}
					_panel.setItems(_items);
					break;
				}
				case '2':
				{
					_mc._techTop.visible = true;
					for each (item in data.info) 
					{
						var mc2 : RankTechItem = new RankTechItem(item);
						mc2.buttonMode = true;
						_items.push(mc2);
					}
					_panel.setItems(_items);
					break;
				}
				case '3':
				{
					_mc._girlHeroTop.visible = true;
					for each (item in data.info) 
					{
						var mc3 : RankGirlItem = new RankGirlItem(item);
						mc3.buttonMode = true;
						_items.push(mc3);
					}
					_panel.setItems(_items);
					break;
				}
				case '4':
				{
					_mc._boyHeroTop.visible = true;
					for each (item in data.info) 
					{
						var mc4 : RankBoyItem = new RankBoyItem(item);
						mc4.buttonMode = true;
						_items.push(mc4);
					}
					_panel.setItems(_items);
					break;
				}
				case '5':
				{
					_mc._guildTop.visible = true;
					for each (item in data.info) 
					{
						var mc5 : RankGuildItem = new RankGuildItem(item);
						mc5.buttonMode = true;
						_items.push(mc5);
					}
					_panel.setItems(_items);
					break;
				}
				case '6':
				{
					_mc._teamTop.visible = true;
					for each (item in data.info) 
					{
						var mc6 : RankTeamItem = new RankTeamItem(item);
						mc6.buttonMode = true;
						_items.push(mc6);
					}
					_panel.setItems(_items);
					break;
				}
			}
		}
	}
}