package com.brickmice.view.school
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McHeroSelect;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class SchoolChooseBoyHero extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "SchoolChooseBoyHero";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _heroPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _ids:Array = [];
		private var _maxCount:int = 0;
		
		public function SchoolChooseBoyHero(callback:Function)
		{
			_maxCount = Data.data.school.slotNum;
			_mc = new ResSchoolChooseBoyHeroWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			
			// 员工面板
			_heroPanel = new McList(5, 2, 8, 11, 77, 118, true);
			addChildEx(_heroPanel, 49, 71);
			
			new BmButton(_yesBtn, function():void{
				if(!_ids.length) {
					closeWindow();
					return;
				}
				ModelManager.schoolModel.startSchoolTraining(_ids, function():void{
					callback();
					closeWindow();
				});
			});
			
			// 生成显示的员工列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有员工
			var data:Object = Data.data.boyHero;
			var heroArr:Array = [];
			for(var k:String in data) heroArr.push(data[k]);
			heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
			for each(var one:Object in heroArr) {
				var enabled:Boolean = (one.status == 'free' && one.level != 100);
				var selected:Boolean = one.status == 'train';
				if(selected) _maxCount--;
				var mc : McHeroSelect = new McHeroSelect(one.img, one.level, one.name, one.quality, selected, enabled);
				if(enabled) addClickHeroEvent(mc, one);
				_items.push(mc);
			}
			_heroPanel.setItems(_items);
			
			//新手指引
//			NewbieController.showNewBieBtn(23, 3, this, 56, 173, true, "选择需要训练的噩梦鼠");
		}
		
		private function addClickHeroEvent(mc:McHeroSelect, one:Object):void
		{
			mc.evts.addClick(function():void{
//				NewbieController.refreshNewBieBtn(23, 4);
				if(!mc.selected){
					// 获取位置
					var index:int = _ids.indexOf(one.id);
					// 如果在队列中.则移除之
					if (index >= 0)
						_ids.splice(index, 1);
				}else{
					if(_ids.length >= _maxCount){
						TextMessage.showEffect('已经没有多余的训练位了！', 2);
						mc.selected = false;
					}else{
						_ids.push(one.id);
					}
				}
			});
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
//					NewbieController.showNewBieBtn(23, 4, this, 391, 362, true, "确定开始训练");
					break;
				default:
			}
		}	
	}
}