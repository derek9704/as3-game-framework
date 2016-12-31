package com.brickmice.view.school
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class School extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "School";
		
		private var _mc:MovieClip;
		private var _nextExpSpeedTxt:TextField;
		private var _lvl:TextField;
		private var _upgrade:MovieClip;
		private var _nextExpSpeed:TextField;
		private var _closeBtn:MovieClip;
		private var _maxTime:TextField;
		private var _expSpeedTxt:TextField;
		private var _expSpeed:TextField;
		
		private var _techLv:TextField;
		private var _coins:TextField;
		private var _iron:TextField;
		private var _moonStone:TextField;
		private var _lifeStone:TextField;
		private var _nightStone:TextField;
		private var _unitPoint:TextField;
		private var _checkBox1:MovieClip;
		private var _checkBox2:MovieClip;
		private var _checkBox3:MovieClip;
		private var _checkBox4:MovieClip;
		private var _checkBox5:MovieClip;
		private var _checkBox6:MovieClip;
		private var _checkBox7:MovieClip;
		
		private var _slot1:SchoolSlot;
		private var _slot2:SchoolSlot;
		private var _slot3:SchoolSlot;
		
		public function School(data : Object)
		{
			_mc = new ResSchoolWindow;
			super(NAME, _mc);
			
			_nextExpSpeedTxt = _mc._nextExpSpeedTxt;
			_lvl = _mc._lvl;
			_upgrade = _mc._upgrade;
			_nextExpSpeed = _mc._nextExpSpeed;
			_closeBtn = _mc._closeBtn;
			_maxTime = _mc._maxTime;
			_expSpeedTxt = _mc._expSpeedTxt;
			_expSpeed = _mc._expSpeed;
			_techLv = _mc._upgrade._techLv;
			_coins = _mc._upgrade._coins;
			_iron = _mc._upgrade._iron;
			_moonStone = _mc._upgrade._moonStone;
			_lifeStone = _mc._upgrade._lifeStone;
			_nightStone = _mc._upgrade._nightStone;
			_unitPoint = _mc._upgrade._unitPoint;	
			_checkBox1 = _mc._upgrade._checkBox1;
			_checkBox2 = _mc._upgrade._checkBox2;
			_checkBox3 = _mc._upgrade._checkBox3;
			_checkBox4 = _mc._upgrade._checkBox4;
			_checkBox5 = _mc._upgrade._checkBox5;
			_checkBox6 = _mc._upgrade._checkBox6;
			_checkBox7 = _mc._upgrade._checkBox7;
			
			new BmButton(_mc._upgrade._upgradeBtn, function(event : MouseEvent) : void
			{
				ModelManager.schoolModel.upgradeSchool(function():void
				{
					setData();
					ViewManager.sendMessage(ViewMessage.UPGRADE_SCHOOL);
				});
			});
			
			_slot1 = new SchoolSlot(setData, 0);
			addChildEx(_slot1, 56, 91);
			_slot2 = new SchoolSlot(setData, 1);
			addChildEx(_slot2, 166, 91);
			_slot3 = new SchoolSlot(setData, 5);
			addChildEx(_slot3, 277, 91);
			
			setData();
			
			//新手指引
//			NewbieController.showNewBieBtn(23, 2, this, 84, 156, true, "打开选择噩梦鼠面板");
//			NewbieController.showNewBieBtn(39, 2, this, 70, 318, true, "完成训练");
		}
		
		private function showSelectHeroWin():void
		{
			if (ViewManager.hasView(SchoolChooseBoyHero.NAME)) return;
//			NewbieController.refreshNewBieBtn(23, 3);
			var win:BmWindow = new SchoolChooseBoyHero(setData);
			addChildCenter(win);
		}
		
		public function setData() : void
		{
			var unitData:Object = Data.data.school;
			_lvl.text = unitData.level;
			_expSpeed.text = unitData.expRatio;
			_nextExpSpeed.text = unitData.nextExpRatio == null ? "--" : unitData.nextExpRatio;
			_maxTime.text = (unitData.timeLimit / 60).toString() + "小时";
			
			_techLv.text = unitData.updateRequire.techLevel;
			if(Data.data.user.techLevel >= unitData.updateRequire.techLevel)
				_checkBox1.gotoAndStop(2);
			else
				_checkBox1.gotoAndStop(1);
			
			_coins.text = unitData.updateRequire.coins ;
			if(Data.data.user.coins  >= unitData.updateRequire.coins)
				_checkBox2.gotoAndStop(2);
			else
				_checkBox2.gotoAndStop(1);
			
			_iron.text = unitData.updateRequire.iron;
			if(unitData.updateRequire.iron == 0 || Data.data.storage.material.items[Consts.ID_IRON]["num"]  >= unitData.updateRequire.iron)
				_checkBox3.gotoAndStop(2);
			else
				_checkBox3.gotoAndStop(1);
			
			_moonStone.text = unitData.updateRequire.moonStone;
			if(unitData.updateRequire.moonStone == 0 || Data.data.storage.material.items[Consts.ID_MOONSTONE]["num"]  >= unitData.updateRequire.moonStone)
				_checkBox4.gotoAndStop(2);
			else
				_checkBox4.gotoAndStop(1);
			
			_lifeStone.text = unitData.updateRequire.lifeStone ;
			if(unitData.updateRequire.lifeStone == 0 || Data.data.storage.material.items[Consts.ID_LIFESTONE]["num"]  >= unitData.updateRequire.lifeStone)
				_checkBox5.gotoAndStop(2);
			else
				_checkBox5.gotoAndStop(1);
			
			_nightStone.text = unitData.updateRequire.nightStone ;
			if(unitData.updateRequire.nightStone == 0 || Data.data.storage.material.items[Consts.ID_NIGHTSTONE]["num"]  >= unitData.updateRequire.nightStone)
				_checkBox6.gotoAndStop(2);
			else
				_checkBox6.gotoAndStop(1);
			
			_unitPoint.text = unitData.updateRequire.unitPoint ;
			if(Data.data.unit.point   >= unitData.updateRequire.unitPoint)
				_checkBox7.gotoAndStop(2);
			else
				_checkBox7.gotoAndStop(1);
			
			var slotNum:int = Data.data.school.slotNum;
			_slot1.setHero(showSelectHeroWin, Data.data.school.slots[1], 1);
			if(slotNum > 1)
				_slot2.setHero(showSelectHeroWin, Data.data.school.slots[2], 2);
			if(slotNum > 2)
				_slot3.setHero(showSelectHeroWin, Data.data.school.slots[3], 3);
		}
	}
}