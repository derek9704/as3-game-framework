package com.brickmice.view.railway
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCountDown;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.utils.DateUtils;
	import com.framework.utils.UiUtils;
	
	import flash.display.Sprite;

	/**
	 * @author derek
	 */
	public class TrafficListItem extends Sprite
	{
		private var _mc:ResTrafficList;
		
		public function TrafficListItem(info : Object)
		{
			_mc = new ResTrafficList;
			addChild(_mc);
			
			_mc._type.text = info.typeName;
			_mc._planet.text = info.pName;
			_mc._count.text = info.trainCount;
			
			_mc._cancelBtn.visible = false;
			
			var leftTime:int = info.arriveTime - Math.floor(DateUtils.nowDateTimeByGap(Consts.timeGap));
			if(leftTime < 0) leftTime = 0;
			var countDown:BmCountDown = new BmCountDown(_mc._time, leftTime, function():void{
				UiUtils.setButtonEnable(_mc._reachBtn, false);
			});
			countDown.startTimer();
					
			new BmButton(_mc._reachBtn, function() : void
			{
//				NewbieController.refreshNewBieBtn(32, 4);
				ConfirmMessage.callBack = function():void{
					countDown.stopTimer();
				};
				ModelManager.railwayModel.confirmRailwayTeleport(info.id, info.type, function():void{
					countDown.stopTimer();
				});
			});
	
		}
	}
}
