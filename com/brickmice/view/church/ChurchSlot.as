package com.brickmice.view.church
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCountDown;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.UiUtils;
	
	import flash.display.MovieClip;
	
	public class ChurchSlot extends CSprite
	{
		private var _mc:MovieClip;
		private var _pos:int = 0;
		private var _rivivalTime:BmCountDown;
		private var _img : McItem;
		
		public function ChurchSlot(callBack:Function, openVipLevel:int)
		{
			super('', 79, 200, false);
			
			_mc = new ResRevival;
			addChildEx(_mc);

			_rivivalTime = new BmCountDown(_mc._time, 0, function():void{
				ModelManager.churchModel.getChurchData(callBack);
			});
			
			new BmButton(_mc._btn, function():void{
				ConfirmMessage.callBack = callBack;
				ModelManager.churchModel.confirmChurchGoldenRevival(_pos);
			});
			
			//头像
			_img = new McItem('unopen');
			addChildEx(_img, 4, 28);
			
			_mc._name.text = "";
			_mc._lvl.text = "";
			_mc._time.text = "";
			_mc._prompt.text = 'VIP' + openVipLevel;
			UiUtils.setButtonEnable(_mc._btn, false);
		}
		
		public function setHero(data:Object, pos:int):void
		{
			_pos = pos;
			
			if(data.id){
				_mc._prompt.text = '复活中';
				var heroData:Object = Data.data.boyHero[data.id];
				_img.resetImage(heroData.img);
				_mc._name.text = heroData.name;
				_mc._lvl.text = heroData.level;	
				_rivivalTime.setTime(data.leftTime);
				_rivivalTime.startTimer();
				UiUtils.setButtonEnable(_mc._btn, true);
			}else{
				_img.clear();
				_mc._prompt.text = '空闲';
				_mc._name.text = "";
				_mc._lvl.text = "";	
				_rivivalTime.stopTimerWithoutCallBack();
				UiUtils.setButtonEnable(_mc._btn, false);
			}
		}
	}
}