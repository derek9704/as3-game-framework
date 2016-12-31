package com.brickmice.view.brain
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McCountDown;
	import com.brickmice.view.component.McTip;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.MovieClip;

	public class Brain extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Brain";
		
		private var _mc:MovieClip;
		private var _purpleCallBtn:MovieClip;
		private var _whiteCallBtn:MovieClip;
		private var _blueCallBtn:MovieClip;
		private var _closeBtn:MovieClip;
		private var _greenCallBtn:MovieClip;
		private var _receiverBtn1:MovieClip;
		private var _receiverBtn2:MovieClip;
		private var _receiverBtn3:MovieClip;
		private var _receiverBtn4:MovieClip;
		private var _receiverBtn5:MovieClip;
		
		private var _hero1:BrainSlot;
		private var _hero2:BrainSlot;
		private var _hero3:BrainSlot;
		private var _hero4:BrainSlot;
		private var _hero5:BrainSlot;
		private var _blueCallCoolingTime:McCountDown;
		private var _purpleCallCoolingTime:McCountDown;
		private var _whiteCallCoolingTime:McCountDown;
		private var _greenCallCoolingTime:McCountDown;
		
		public function Brain(data : Object)
		{
			_mc = new ResBrainReceiverWindow;
			super(NAME, _mc);
			
			_receiverBtn4 = _mc._receiverBtn4;
			_purpleCallBtn = _mc._purpleCallBtn;
			_whiteCallBtn = _mc._whiteCallBtn;
			_blueCallBtn = _mc._blueCallBtn;
			_receiverBtn3 = _mc._receiverBtn3;
			_closeBtn = _mc._closeBtn;
			_greenCallBtn = _mc._greenCallBtn;
			_receiverBtn2 = _mc._receiverBtn2;
			_receiverBtn1 = _mc._receiverBtn1;
			_receiverBtn5 = _mc._receiverBtn5;

			new BmButton(_receiverBtn1, function():void{
				ModelManager.brainModel.receiveBrain(0, function():void{
					setData();
				});
			});
			new BmButton(_receiverBtn2, function():void{
				NewbieController.refreshNewBieBtn(20, 3);
				ModelManager.brainModel.receiveBrain(1, setData);
			});
			new BmButton(_receiverBtn3, function():void{
				ModelManager.brainModel.receiveBrain(2, function():void{
					NewbieController.refreshNewBieBtn(1, 3, false, true);
					setData();
				});
			});
			new BmButton(_receiverBtn4, function():void{
				ModelManager.brainModel.receiveBrain(3, setData);
			});
			new BmButton(_receiverBtn5, function():void{
//				NewbieController.refreshNewBieBtn(20, 3, true, true);
				ModelManager.brainModel.receiveBrain(4, setData);
			});
			
			new BmButton(_whiteCallBtn, function():void{
				callRefresh(1);
			});
			new BmButton(_greenCallBtn, function():void{
				callRefresh(2);
			});
			new BmButton(_blueCallBtn, function():void{
				callRefresh(3);
			});
			new BmButton(_purpleCallBtn, function():void{
				callRefresh(4);
			});
			_whiteCallCoolingTime = new McCountDown(0, 0xF3E7CC, 89, function():void{
				ModelManager.brainModel.getBrainData(setData);
			}, "center");
			addChildEx(_whiteCallCoolingTime, 89, 307);
			_greenCallCoolingTime = new McCountDown(0, 0xF3E7CC, 89, function():void{
				ModelManager.brainModel.getBrainData(setData);
			}, "center");			
			addChildEx(_greenCallCoolingTime, 198, 307);
			_blueCallCoolingTime = new McCountDown(0, 0xF3E7CC, 89, function():void{
				ModelManager.brainModel.getBrainData(setData);
			}, "center");
			addChildEx(_blueCallCoolingTime, 308, 307);
			_purpleCallCoolingTime = new McCountDown(0, 0xF3E7CC, 89, function():void{
				ModelManager.brainModel.getBrainData(setData);
			}, "center");
			addChildEx(_purpleCallCoolingTime, 416, 307);
			
			if(Data.data.user.techLevel < 10){
				_whiteCallBtn.visible = _greenCallBtn.visible = _blueCallBtn.visible = _purpleCallBtn.visible = false;
				_whiteCallCoolingTime.visible = _greenCallCoolingTime.visible = _blueCallCoolingTime.visible = _purpleCallCoolingTime.visible = false;
			}
			
			_hero1 = new BrainSlot;
			addChildEx(_hero1, 24, 63);
			_hero2 = new BrainSlot;
			addChildEx(_hero2, 137, 63);
			_hero3 = new BrainSlot;
			addChildEx(_hero3, 251, 63);
			_hero4 = new BrainSlot;
			addChildEx(_hero4, 366, 63);
			_hero5 = new BrainSlot;
			addChildEx(_hero5, 480, 63);
			
			//一键
			_mc._allTransformationBtn.hitArea = _mc._allTransformationBtn._mask;
			new BmButton(_mc._allTransformationBtn, function():void{
				ModelManager.brainModel.transAllBrain(setData);
			});
			if(Data.data.user.techLevel < 10) _mc._allTransformationBtn.visible = false;
			
			TipHelper.setTip(_mc._allTransformationBtn, new McTip("将所有可用大脑转化为宇宙币和矿石资源，转化奖励随荣誉等级提升"));
			
			setData();
			
			onClosed = function():void{
				//刷新箭头
				ViewManager.sendMessage(ViewMessage.REFRESH_TASK);
			};
			
			//新手指引
			NewbieController.showNewBieBtn(1, 2, this, 248, 276, true, "接收一个军官脑");
			NewbieController.showNewBieBtn(9, 2, this, 16, 276, true, "接收一个科学脑");
//			NewbieController.showNewBieBtn(20, 3, this, 476, 276, true, "接收一个军官脑");
			NewbieController.showNewBieBtn(20, 2, this, 129, 276, true, "接收一个科学脑");
//			NewbieController.showNewBieBtn(25, 1, this, 444, 65, true, "转化大脑能量");
		}
		
		public function setData() : void
		{
			var brainData:Object = Data.data.brain;
			
			_mc._girlMax.text = _mc._boyMax.text = brainData.hireLimit;
			
			var boyHero:Object = Data.data.boyHero;
			var boyCount:int = 0;
			for each (var boy:Object in boyHero) 
			{
				boyCount++;
			}
			_mc._boyNow.text = boyCount.toString();
			
			var girlHero:Object = Data.data.girlHero;
			var girlCount:int = 0;
			for each (var girl:Object in girlHero) 
			{
				girlCount++;
			}
			_mc._girlNow.text = girlCount.toString();
			
			_hero1.setHero(brainData.heroes[0], 0, setData);
			_hero2.setHero(brainData.heroes[1], 1, setData);
			_hero3.setHero(brainData.heroes[2], 2, setData);
			_hero4.setHero(brainData.heroes[3], 3, setData);
			_hero5.setHero(brainData.heroes[4], 4, setData);
			
			var leftTime1:int = int(brainData.call[1].leftTime);
			var leftTime2:int = int(brainData.call[2].leftTime);
			var leftTime3:int = int(brainData.call[3].leftTime);
			var leftTime4:int = int(brainData.call[4].leftTime);
			
			_whiteCallCoolingTime.setTime(leftTime1);
			_whiteCallCoolingTime.startTimer();
			_greenCallCoolingTime.setTime(leftTime2);
			_greenCallCoolingTime.startTimer();
			_blueCallCoolingTime.setTime(leftTime3);
			_blueCallCoolingTime.startTimer();
			_purpleCallCoolingTime.setTime(leftTime4);
			_purpleCallCoolingTime.startTimer();
			
			if(Data.data.user.techLevel < 10){
				_mc._whiteBtnAnime.visible = false;
				_mc._greenBtnAnime.visible = false;
				_mc._blueBtnAnime.visible = false;
				_mc._purpleBtnAnime.visible = false;
			}else{
				_mc._whiteBtnAnime.visible = leftTime1 == 0;
				_mc._greenBtnAnime.visible = leftTime2 == 0;
				_mc._blueBtnAnime.visible = leftTime3 == 0;
				_mc._purpleBtnAnime.visible = leftTime4 == 0;
			}

			
			UiUtils.setButtonEnable(_receiverBtn1, Data.data.brain.heroes[0].isHired != 1);
			UiUtils.setButtonEnable(_receiverBtn2, Data.data.brain.heroes[1].isHired != 1);
			UiUtils.setButtonEnable(_receiverBtn3, Data.data.brain.heroes[2].isHired != 1);
			UiUtils.setButtonEnable(_receiverBtn4, Data.data.brain.heroes[3].isHired != 1);
			UiUtils.setButtonEnable(_receiverBtn5, Data.data.brain.heroes[4].isHired != 1);
		}	
		
		private function callRefresh(type:int):void
		{
			if(Data.data.brain.call[type].leftTime != 0){
				ConfirmMessage.callBack = setData;
				ModelManager.brainModel.confirmRefreshBrain(type);
			}
			else
				ModelManager.brainModel.refreshBrain(type, setData);
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
					NewbieController.showNewBieBtn(20, 3, this, 476, 276, true, "接收一个军官脑");
					NewbieController.showNewBieBtn(1, 3, this, 544, 32, true, "关闭面板", true);
//					NewbieController.showNewBieBtn(19, 3, this, 418, 18, true, "关闭大脑接收器", true);
//					NewbieController.showNewBieBtn(25, 1, this, 444, 65, true, "转化大脑能量");
//					NewbieController.showNewBieBtn(24, 3, this, 16, 276, true, "接收一个军官脑");
					break;
				default:
			}
		}	
	}
}