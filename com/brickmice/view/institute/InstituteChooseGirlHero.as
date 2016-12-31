package com.brickmice.view.institute
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McHeroSelect;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	import com.framework.ui.sprites.WindowData;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class InstituteChooseGirlHero extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "InstituteChooseGirlHero";
		
		private var _mc:MovieClip;
		private var _yesBtn:MovieClip;
		private var _heroPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _ids:Array = [];
		private var _maxCount:int = 0;
		
		public function InstituteChooseGirlHero(callback:Function)
		{
			_maxCount = Data.data.institute.slotNum;
			_mc = new ResInstituteChooseGirlHeroWindow;
			super(NAME, _mc);
			
			_yesBtn = _mc._yesBtn;
			
			// 员工面板
			_heroPanel = new McList(5, 2, 8, 11, 77, 118, true);
			addChildEx(_heroPanel, 49, 71);
			
			new BmButton(_yesBtn, function():void{
				if(_ids.length == 0){
					var data:Object = {};
					data.msg = "您确定要将所有美人移出研究所么？这样会导致无法攻关，并停止获得科技点。";
					data.action = "client";
					data.args = function():void{
						ModelManager.instituteModel.joinInstitute(_ids, function():void{
							NewbieController.refreshNewBieBtn(10, 5);
							callback();
							closeWindow();
						});
					}
					ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
				}else{
					ModelManager.instituteModel.joinInstitute(_ids, function():void{
						NewbieController.refreshNewBieBtn(10, 5);
						callback();
						closeWindow();
					});
				}
			});
			
			// 生成显示的员工列表
			_items = new Vector.<DisplayObject>;
			
			// 遍历所有员工
			var data:Object = Data.data.girlHero;
			var heroArr:Array = [];
			for(var k:String in data) heroArr.push(data[k]);
			heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
			for each(var one:Object in heroArr) {
				var enabled:Boolean = (one.status == 'free' || one.status == 'study');
				var selected:Boolean = one.status == 'study';
				if(selected) _ids.push(one.id);
				var mc : McHeroSelect = new McHeroSelect(one.img, one.level, one.name, one.quality, selected, enabled);
				if(enabled) addClickHeroEvent(mc, one);
				_items.push(mc);
			}
			_heroPanel.setItems(_items);
		}
		
		private function addClickHeroEvent(mc:McHeroSelect, one:Object):void
		{
			mc.evts.addClick(function():void{
				if(!mc.selected){
					// 获取位置
					var index:int = _ids.indexOf(one.id);
					// 如果在队列中.则移除之
					if (index >= 0)
						_ids.splice(index, 1);
				}else{
					NewbieController.refreshNewBieBtn(10, 4);
					if(_ids.length >= _maxCount){
						TextMessage.showEffect('已经没有多余的研究位了！', 2);
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
					NewbieController.showNewBieBtn(10, 3, this, 57, 177, true, "选择科学美人",false, true);
					NewbieController.showNewBieBtn(10, 4, this, 402, 354, true, "选择确定", false, true);
					break;
				default:
			}
		}	
	}
}