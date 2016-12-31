package com.brickmice.view.girlhero
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McHeroSelect;
	import com.brickmice.view.component.McList;
	import com.framework.core.Message;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class GirlHeroChooseLesson extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "GirlHeroChooseLesson";
		public static const PAGESIZE : uint = 10;
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _tabView : BmTabView;
		private var _hid:int = 0;
		private var _cid:int = -1;
		private var _pageCount:int = 1;
		private var _page : int = 1;	//当前页
		private var _itemArr:Array = [];
		private var _hasPoint:int;
		private var _pos:int;
		
		public function GirlHeroChooseLesson(hid:int, pos:int, callback:Function, pageType:String)
		{
			_mc = new ResGirlHeroChooseLessonWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;			
			_hid = hid;
			_pos = pos;

			// 面板
			_panel = new McList(5, 2, 6, 8, 77, 118, true);
			addChildEx(_panel, 54, 78);
			
			new BmButton(_yesBtn, function():void{
				if(_cid == -1) {
					closeWindow();
					return;
				}
				
				ModelManager.girlHeroModel.learnGirlHeroLesson(_hid, _cid, _pos, function():void{
					callback();
					closeWindow();
				});
			});
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue('nature', _mc._natureTab), new KeyValue('human', _mc._humanTab), new KeyValue('skill', _mc._skillTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				_page = 1;
				setData(id);
			});
			
			// 前页按钮
			new BmButton(_mc._prevBtn, function(event : MouseEvent) : void
			{
				_page--;
				setData();
			});
			
			//后页按钮
			new BmButton(_mc._nextBtn, function(event : MouseEvent) : void
			{
				_page++;
				setData();
			});
			
			setData(pageType);
			_tabView.selectId = pageType;
			
			//新手指引
			NewbieController.showNewBieBtn(12, 3, this, 60, 183, true, "选择一个技能");
		}
		
		private function hasLesson(id:int):Boolean
		{
			var lesson:Array = Data.data.girlHero[_hid].lesson;
			for each(var one:Object in lesson) {
				if(one && one.id == id) return true;
			}
			return false;
		}
		
		private function setData(type:String = null) : void
		{
			if(type){
				// 获取相应类型的物品列表
				_itemArr = [];
				var lessones:Object = Data.data.institute.lesson;
				for each(var one:Object in lessones) {
					if(!one.learned) continue;
					if(hasLesson(one.id)) continue;
					if(type == 'nature' && one.lessontype != 'nature') continue;
					if(type == 'human' && one.lessontype != 'human') continue;
					if(type == 'skill' && !one.skill) continue;
					_itemArr.push(one);
				}
				_itemArr.sortOn(["learnpoint", "id"], [Array.DESCENDING | Array.NUMERIC, Array.DESCENDING | Array.NUMERIC]);
				
				_pageCount = Math.ceil(_itemArr.length / PAGESIZE);	
			}
			//技能点提示
			_hasPoint = Data.data.girlHero[_hid].point;
			if(Data.data.girlHero[_hid].lesson[_pos]){
				_hasPoint += int(Data.data.girlHero[_hid].lesson[_pos].learnpoint);
			}
			calcPoint(0);
			//初始
			_cid = -1;			
			// 格子数量
			var count:int = _itemArr.length;
			// 起始物品位置
			var start:int = (_page - 1) * PAGESIZE;
			// 结束物品位置
			var max:int = start + PAGESIZE > count ? count : start + PAGESIZE;
			
			UiUtils.setButtonEnable(_mc._prevBtn, _page > 1);
			UiUtils.setButtonEnable(_mc._nextBtn, _page < _pageCount);
			
			// 生成显示的物品列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有物品
			for (var i : int = start; i < max; i++)
			{
				var one2:Object = _itemArr[i];
				var imgUrl:String = one2.img || one2.learnedImg;
				var mc : McHeroSelect = new McHeroSelect(imgUrl, 0, one2.classname, 0, false, true, true);
				// 设置tip
				TipHelper.setTip(mc, Trans.transClassTips(one2));
				addClickEvent(mc, one2);
				_items.push(mc);
			}
			
			_panel.setItems(_items);
		}	
		
		private function addClickEvent(mc:McHeroSelect, one:Object):void
		{
			mc.evts.addClick(function():void{
				NewbieController.refreshNewBieBtn(12, 4);
				//先将其他设为不选
				for each (var item:McHeroSelect in _items) 
				{
					item.selected = false;
				}
				mc.selected = true;
				
				_cid = one.id;
				calcPoint(one.learnpoint);
			});
		}
		
		private function calcPoint(usePoint:int):void
		{
			_mc._detailPoint.textColor = _hasPoint >= usePoint ? 0x89DC74 : 0xFF0000;
			_mc._detailPoint.text = usePoint + "/" + _hasPoint;
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_NEWBIE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_NEWBIE:
					NewbieController.showNewBieBtn(12, 4, this, 389, 357, true, "确定学习该技能");
					break;
				default:
			}
		}
		
	}
}