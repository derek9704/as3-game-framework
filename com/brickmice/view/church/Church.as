package com.brickmice.view.church
{
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmWindow;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.brickmice.view.component.BmButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Church extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Church";
		
		private var _mc:MovieClip;
		private var _nextRevivalTime:TextField;
		private var _lvl:TextField;
		private var _revivalTime:TextField;
		private var _upgrade:MovieClip;
		private var _closeBtn:MovieClip;
		
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
		
		private var _slot1:ChurchSlot;
		private var _slot2:ChurchSlot;
		private var _slot3:ChurchSlot;
		
		public function Church(data : Object)
		{
			_mc = new ResChurchWindow;
			super(NAME, _mc);
			
			_nextRevivalTime = _mc._nextRevivalTime;
			_lvl = _mc._lvl;
			_revivalTime = _mc._revivalTime;
			_upgrade = _mc._upgrade;
			_closeBtn = _mc._closeBtn;
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
				ModelManager.churchModel.upgradeChurch(function():void
				{
					setData();
					ViewManager.sendMessage(ViewMessage.UPGRADE_CHURCH);
				});
			});
			
			_slot1 = new ChurchSlot(setData, 0);
			addChildEx(_slot1, 81, 128);
			_slot2 = new ChurchSlot(setData, 1);
			addChildEx(_slot2, 182, 128);
			_slot3 = new ChurchSlot(setData, 5);
			addChildEx(_slot3, 282, 128);
			
			setData();
		}
			
		public function setData() : void
		{
			var unitData:Object = Data.data.church;
			_lvl.text = unitData.level;
			_revivalTime.text = (unitData.reviveTime / 60).toString();
			_nextRevivalTime.text = unitData.nextReviveTime == null ? "--" : (unitData.nextReviveTime / 60).toString();
			
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
			
			var slotNum:int = Data.data.church.slotNum;
			_slot1.setHero(Data.data.church.slots[1], 1);
			if(slotNum > 1)
				_slot2.setHero(Data.data.church.slots[2], 2);
			if(slotNum > 2)
				_slot3.setHero(Data.data.church.slots[3], 3);
		}
	}
}