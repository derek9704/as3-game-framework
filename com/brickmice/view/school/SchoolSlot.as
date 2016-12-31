package com.brickmice.view.school
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTiming;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McTip;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.MovieClip;
	
	public class SchoolSlot extends CSprite
	{
		private var _mc:MovieClip;
		private var _pos:int = 0;
		private var _trainingTime:BmTiming;
		private var _img : McItem;
		private var _expMax : int;
		private var _maxTime:int;
		
		public function SchoolSlot(callback:Function, openVipLevel:int)
		{
			super('', 103, 257, false);
			
			_mc = new ResTraining;
			addChildEx(_mc);
			
			_expMax = _mc._exp.width;

			_maxTime = Data.data.school.timeLimit * 60;
			_trainingTime = new BmTiming(_mc._trainingTime, 0, _maxTime);
			_trainingTime.everyMinuteHandler = function():void{
				ModelManager.schoolModel.getSchoolData(callback);
			};
			
			new BmButton(_mc._trainingCompletedBtn, function():void{
//				NewbieController.refreshNewBieBtn(39, 3);
				ModelManager.schoolModel.finishSchoolTraining(_pos, 0, callback);
			});
			
			new BmButton(_mc._goldenTrainBtn, function():void{
				ConfirmMessage.callBack = callback;
				ModelManager.schoolModel.confirmSchoolGoldenTraining(_pos);
			});			
			// 设置tip
			var msg:String = '军校之魂可以让噩梦鼠瞬间升至噩梦军校的等级!';
			TipHelper.setTip(_mc._goldenTrainBtn, new McTip(msg));
			
			//头像
			_img = new McItem("unopen");
			addChildEx(_img, 15, 28);
			
			_mc._name.text = "";
			_mc._lvl.text = "";	
			_mc._trainingExp.text = "";
			_mc._exp.width = 0;
			_mc._trainingTime.text = "";
			_mc._prompt.text = 'VIP' + openVipLevel;
			UiUtils.setButtonEnable(_mc._trainingCompletedBtn, false);
			UiUtils.setButtonEnable(_mc._goldenTrainBtn, false);
		}
		
		public function setHero(clickFun:Function, data:Object, pos:int):void
		{
			_pos = pos;
			
			_img.evts.addClick(function():void{
				clickFun();
			});
			
			if(data.id){
				_mc._prompt.text = '训练中';
				var heroData:Object = Data.data.boyHero[data.id];
				_img.resetImage(heroData.img);
				_mc._name.text = heroData.name;
				_mc._lvl.text = heroData.level;
				_mc._trainingExp.text = data.getExp;
				_mc._exp.width = heroData.exp / heroData.upgradeExp * _expMax;
				_trainingTime.setTime(data.passedTime);
				_trainingTime.startTimer();
				UiUtils.setButtonEnable(_mc._trainingCompletedBtn, true);
				UiUtils.setButtonEnable(_mc._goldenTrainBtn, true);
				if(heroData.level >= Data.data.school.level)
					UiUtils.setButtonEnable(_mc._goldenTrainBtn, false);
			}else{
				_img.clear();
				_mc._prompt.text = '空闲';
				_mc._name.text = "";
				_mc._lvl.text = "";	
				_mc._trainingExp.text = "";
				_mc._exp.width = 0;
				_trainingTime.stopTimerWithoutCallBack();
				UiUtils.setButtonEnable(_mc._trainingCompletedBtn, false);
				UiUtils.setButtonEnable(_mc._goldenTrainBtn, false);
			}
		}
	}
}