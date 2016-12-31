package com.brickmice.view.mine
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

	public class Mine extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Mine";
		
		public static const PUREE : String = "puree";
		public static const IRON : String = "iron";
		public static const GEM : String = "gem";
		
		private var _mc:MovieClip;
		private var _mineLvlTxt:TextField;
		private var _lvl:TextField;
		private var _upgrade:MovieClip;
		private var _closeBtn:MovieClip;
		private var _yield:TextField;
		private var _nextYield:TextField;
		private var _title:TextField;
		
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
		
		private var _type:String;
		
		public function Mine(data : Object)
		{
			_mc = new ResMineWindow;
			super(NAME, _mc);
			
			_mineLvlTxt = _mc._mineLvlTxt;
			_lvl = _mc._lvl;
			_upgrade = _mc._upgrade;
			_closeBtn = _mc._closeBtn;
			_yield = _mc._yield;
			_nextYield = _mc._nextYield;
			_title = _mc._title;
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
			
			_type = data.type;
			
			new BmButton(_mc._upgrade._upgradeBtn, function(event : MouseEvent) : void
			{
				ModelManager.mineModel.upgradeMine(_type, function():void
				{
					setData();
					ViewManager.sendMessage(ViewMessage.UPGRADE_MINE, _type);
				});
			});

			setData();	
			
			//新手指引
			if(_type == IRON) NewbieController.showNewBieBtn(16, 2, this, 279, 333, true, "升级稀铁矿");
			if(_type == PUREE) NewbieController.showNewBieBtn(18, 2, this, 279, 333, true, "升级奶酪原浆矿");
			if(_type == GEM) NewbieController.showNewBieBtn(17, 2, this, 279, 333, true, "升级宝石矿");
		}
		
		public function setData(changeType:String = null) : void
		{
			if(changeType != null) _type = changeType;
			var title:String, nametext:String;
			switch(_type)
			{
				case PUREE:
				{
					title = "奶酪原浆矿";
					nametext = "奶酪原浆矿区等级：";
					break;
				}
				case IRON:
				{
					title = "稀铁矿";
					nametext = "稀铁矿区等级：";
					break;
				}
				case GEM:
				{
					title = "宇宙宝石矿";
					nametext = "宇宙宝石矿区等级：";
					break;
				}
			}
			var unitData:Object = Data.data.mine[_type];
			_title.text = title;
			_mineLvlTxt.text = nametext;
			_lvl.text = unitData.level;
			_yield.text = unitData.produceRatio ;
			_nextYield.text = unitData.nextProduceRatio == null ? "--" : unitData.nextProduceRatio;
			
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
		}	
	}
}