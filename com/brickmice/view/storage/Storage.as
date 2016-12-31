package com.brickmice.view.storage
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McTip;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Storage extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Storage";
		
		public static const CHEESE : String = "cheese";
		public static const ARM : String = "arm";
		public static const MOUSE : String = "mouse";
		public static const MATERIAL : String = "material";
		public static const PAGESIZE : uint = 5;
		
		private var _mc:MovieClip;
		private var _lvl:TextField;
		private var _upgrade:MovieClip;
		private var _nextStock:TextField;
		private var _nextBtn:MovieClip;
		private var _prevBtn:MovieClip;
		private var _closeBtn:MovieClip;
		private var _lvlTxt:TextField;
		private var _stockTxt:TextField;
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
		private var _itemPanel : McList;
		private var _page : int = 1;	//当前页
		private var _pageNum : int = 1; //页面数量
		
		public function Storage(data : Object)
		{
			_mc = new ResStorageWindow;
			super(NAME, _mc);
			
			_lvl = _mc._lvl;
			_upgrade = _mc._upgrade;
			_nextStock = _mc._nextStock;
			_nextBtn = _mc._nextBtn;
			_prevBtn = _mc._prevBtn;
			_closeBtn = _mc._closeBtn;
			_lvlTxt = _mc._lvlTxt;
			_stockTxt = _mc._stockTxt;
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
				ModelManager.storageModel.upgradeStorage(_type, function():void
				{
					setData();
					ViewManager.sendMessage(ViewMessage.UPGRADE_STORAGE, _type);
				});
			});
			
			new BmButton(_prevBtn, function(event : MouseEvent) : void
			{
				_page--;
				setData();
			});
			
			new BmButton(_nextBtn, function(event : MouseEvent) : void
			{
				_page++;
				setData();
			});		
			
			_itemPanel = new McList(5, 1, 12, 0, 72, 90, true);
			addChildEx(_itemPanel, 78, 160);
			
			setData();	
			
			//新手指引
//			if(_type == MATERIAL) NewbieController.showNewBieBtn(30, 3, this, 438, 355, true, "升级仓库");
		}
		
		public function setData(changeType:String = null) : void
		{
			if(changeType != null) _type = changeType;
			var title:String, nametext:String;
			_nextBtn.visible = true;
			_prevBtn.visible = true;
			switch(_type)
			{
				case "material":
				{
					title = "原料仓库";
					nametext = "原料仓库等级：";
					_nextBtn.visible = false;
					_prevBtn.visible = false;	
					break;
				}
				case "cheese":
				{
					title = "奶酪仓库";
					nametext = "奶酪仓库等级：";
					break;
				}
				case "arm":
				{
					title = "军需仓库";
					nametext = "军需仓库等级：";
					break;
				}
				case "mouse":
				{
					title = "发条鼠军营";
					nametext = "发条鼠军营等级：";
					break;
				}
			}
			var unitData:Object = Data.data.storage[_type];
			_title.text = title;
			_lvlTxt.text = nametext;
			_lvl.text = unitData.level;
			
			if(_type == 'material')
				_stockTxt.text = "各原料库存上限：   " + unitData.volume;
			else
				_stockTxt.text = "库存：   " + unitData.currentVolume + "/" + unitData.volume;
			
			_nextStock.text = unitData.nextVolume == null ? "--" : unitData.nextVolume;
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
			
			// 获取相应类型的物品列表
			var items:Array = [];
			for(var k:Object in unitData.items) {
				if(unitData.items[k].num != 0)
					items.push(unitData.items[k]);
			}
			
			//按照物品等级排序
			items.sortOn("level", Array.NUMERIC);
			
			// 格子数量
			var len:int = items.length;
			
			// 起始物品位置
			var start:int = (_page - 1) * PAGESIZE;
			
			// 结束物品位置
			var max:int = start + PAGESIZE;
			
			//最大页数
			_pageNum = Math.ceil(len/PAGESIZE);
			
			UiUtils.setButtonEnable(_prevBtn, _page > 1);
			UiUtils.setButtonEnable(_nextBtn, _page < _pageNum);
			
			// 生成显示的物品列表
			var _items : Vector.<DisplayObject> = new Vector.<DisplayObject>;
			
			// 遍历所有物品
			for (var i : int = start; i < max; i++)
			{
				if (i < len)
				{
					items[i].pos = i;
					var text:String = "重：" + items[i].totalWeight;
					var mc : McItem = new McItem(items[i].img, 0, items[i].num, true, text);
					_items.push(mc);
					// 设置tip
					TipHelper.setTip(mc, Trans.transTips(items[i]));
				}
			}			
			_itemPanel.setItems(_items);
		}	
	
	}
}