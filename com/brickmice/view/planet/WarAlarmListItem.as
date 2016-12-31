package com.brickmice.view.planet
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmCountDown;
	import com.framework.utils.DateUtils;
	import com.brickmice.view.component.BmButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class WarAlarmListItem extends Sprite
	{
		private var _mc:ResWarAlarmListItem;
		private var _time:BmCountDown;
		private var _flag:Boolean = false;
		
		public function WarAlarmListItem(info : Object, callback:Function)
		{
			_mc = new ResWarAlarmListItem;
			addChild(_mc);
			
			_mc.gotoAndStop(1);
			
			var leftTime:int = info.arriveTime - Math.floor(DateUtils.nowDateTimeByGap(Consts.timeGap));
			if(leftTime < 0) leftTime = 0;
			_time = new BmCountDown(_mc._time, leftTime, null, '已开战');
			_time.startTimer();
			
			_mc._pName.text = info.pName;
			_mc._playerName.text = info.name;
			_mc._troopCount.text = info.troopNum;
			if(info.unionId >= 3){
				_mc._type.text = info.unionId == 4 ? '进攻方' : '防守方';
			}else{
				_mc._type.text = info.unionId == Data.data.user.union ? '进攻方' : '防守方';
			}
			
			_mc.addEventListener(MouseEvent.MOUSE_OVER, function(event : MouseEvent) : void
			{
				_mc.gotoAndStop(2);
			});
			
			_mc.addEventListener(MouseEvent.MOUSE_OUT, function(event : MouseEvent) : void
			{
				if(_flag)
					_mc.gotoAndStop(3);
				else
					_mc.gotoAndStop(1);
			});
			
			_mc.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{
				callback(info);
				setClick(true);
			});
			_mc.buttonMode = true;
		}
		
		public function setClick(flag:Boolean):void
		{
			_flag = flag;
			if(flag)
				_mc.gotoAndStop(3);
			else
				_mc.gotoAndStop(1);
		}
	}
}
