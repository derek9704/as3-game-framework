package com.brickmice.view.planet
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	import com.framework.core.ViewManager;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class WarAlarm extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "WarAlarm";
		
		private var _mc:MovieClip;
		private var _armBtn:MovieClip;
		private var _sendTroopsBtn:MovieClip;
		private var _detailBtn:MovieClip;
		
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _pid:int = 0;
		private var _selectedInfo:Object;
		
		public function WarAlarm(data : Object)
		{
			_mc = new ResWarAlarmWindow;
			super(NAME, _mc);
			
			_sendTroopsBtn = _mc._sendTroopsBtn;
			_armBtn = _mc._armBtn;
			_detailBtn = _mc._detailBtn;
			
			_armBtn.visible = false;
			
			new BmButton(_detailBtn, function():void{
				if(_pid) ControllerManager.planetController.showPlanet(_pid);
			});
			
			new BmButton(_sendTroopsBtn, function():void{
				if (ViewManager.hasView(TroopAction.NAME)) return;
				if(_selectedInfo.unionId >= 3){
					var troopType:String = _selectedInfo.unionId == 3 ? TroopAction.HOUSE : TroopAction.REINFORCE;
				}else{
					troopType = _selectedInfo.unionId != Data.data.user.union ? TroopAction.HOUSE : TroopAction.REINFORCE;
				}
				var troopActionWin:BmWindow = new TroopAction(troopType, _pid, _selectedInfo);
				addChildCenter(troopActionWin);
			});
			
			UiUtils.setButtonEnable(_detailBtn, false);
			UiUtils.setButtonEnable(_sendTroopsBtn, false);
			
			setData();
		}
		
		public function setData() : void
		{
			// 面板
			_panel = new McList(1, 9, 0, 2, 419, 18, false);
			addChildEx(_panel, 47, 118);
			
			// 生成显示的面板
			_items = new Vector.<DisplayObject>;
			for each(var one:Object in Data.data.warAlarm){
				var mc : WarAlarmListItem = new WarAlarmListItem(one, clickHandler);
				_items.push(mc);
			}
			_panel.setItems(_items);
		}
		
		public function clickHandler(info:Object):void
		{
			_pid = info.pid;
			_selectedInfo = info;
			UiUtils.setButtonEnable(_detailBtn, true);
			UiUtils.setButtonEnable(_sendTroopsBtn, true);
			for each (var everyItem:DisplayObject in _items)
			{
				(everyItem as WarAlarmListItem).setClick(false);;
			}
		}
	}
}