package com.brickmice.view.boyhero
{
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McTip;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class OtherBoyHero extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "OtherBoyHero";
		public static const ARM : String = 'arm';
		public static const EQUIP : String = 'equip';
		
		private var _mc:MovieClip;
		private var _exp:MovieClip;
		private var _lvl:TextField;
		private var _name:TextField;
		private var _armTab:MovieClip;
		private var _equipmentTab:MovieClip;
		private var _girlMc:McItem;

		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _tabView : BmTabView;
		private var _img : McImage;
		private var _max : int;
		
		public function OtherBoyHero()
		{
			_mc = new ResOtherBoyWindow;
			super(NAME, _mc);
			
			_exp = _mc._exp;
			_lvl = _mc._lvl;
			_armTab = _mc._armTab;
			_equipmentTab = _mc._equipmentTab;
			_name = _mc['_name'];
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue(EQUIP, _equipmentTab), new KeyValue(ARM, _armTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				changeTab(id);
			});
			
			// 物品面板
			_itemPanel = new McList(3, 2, 9, 10, 72, 72, true);
			addChildEx(_itemPanel, 259, 167);
			
			//经验条
			_max = _exp.width;
			_mc._expDetailed.visible = false;
			_mc._expDetailed.mouseEnabled = _mc._exp.mouseEnabled = false;
			_mc._expBpx.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_mc._expDetailed.visible = true;
			});
			_mc._expBpx.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_mc._expDetailed.visible = false;
			});
			
			//头像
			_img = new McImage();
			addChildEx(_img, 74, 53);
			
			//说明
			TipHelper.setTip(_mc._detailSpirit, new McTip("1意志力=50部队防御力"));
			TipHelper.setTip(_mc._detailLead, new McTip("1统率力=50部队攻击力"));
			TipHelper.setTip(_mc._detailDex, new McTip("25行动力=1%行军速度"));
			
			setData();
		}
		
		public function setData() : void
		{
			var data:Object = Data.data.boyInfo;
			
			_name.htmlText = '<font color="' + Trans.heroQualityColor[data.quality] + '">' + data.name + '</font>';
			_lvl.text = data.level;
			//经验条
			_exp.width = data.exp / data.upgradeExp * _max;
			var msg:String = data.exp + ' / ' + data.upgradeExp + '  (' + (int(data.exp) * 100 / int(data.upgradeExp)).toFixed(2).toString()  + '%)';
			_mc._expDetailed.text = msg;
			
			//解析一下装备的加成
			var equipTroop:int = 0;
			var equipSpirit:int = 0;
			var equipLead:int = 0;
			var equipDex:int = 0;
			for each (var equip:Object in data.equip) 
			{
				if(equip == null) continue;
				equipTroop += int(equip.carry);
				equipSpirit += int(equip.defense);
				equipLead += int(equip.attack);
				equipDex += int(equip.scamper);
			}
			
			var str:String = '';
			
			str = "天赋：" + (data.talent ? data.talent.name : "无");
			_mc._detailTalent.text = str;
			TipHelper.clear(_mc._detailTalent);
			if(data.talent && data.talent.id){
				TipHelper.setTip(_mc._detailTalent, new McTip(data.talent.describe));
			}
			
			str = "军队：" + data.currentTroop + '/' + Math.floor(data.troop).toString();
			str += equipTroop == 0 ? "" : (" + " + equipTroop.toString());
			_mc._detailTroop.text = str;
			
			str = "军队攻击力：" + Math.floor(data.attack).toString();
			_mc._detailAttack.text = str;
			
			str = "军队防御力：" + Math.floor(data.defense).toString();
			_mc._detailDefense.text = str;
			
			str = "暴击：" + data.crit + '%';
			_mc._detailCrit.text = str;
			
			str = "意志力：" + Math.floor(data.spirit).toString();
			str += equipSpirit == 0 ? "" : (" + " + equipSpirit.toString());
			_mc._detailSpirit.text = str;
			
			str = "统率力：" + Math.floor(data.lead).toString();
			str += equipLead == 0 ? "" : (" + " + equipLead.toString());
			_mc._detailLead.text = str;
			
			str = "行动力：" + Math.floor(data.dex).toString();
			str += equipDex == 0 ? "" : (" + " + equipDex.toString()); 
			_mc._detailDex.text = str;
		
			_img.reload(data.img + 'b');

			_tabView.selectId = EQUIP;
			changeTab(EQUIP);
			
			//助战美人
			if(_girlMc) removeChild(_girlMc);
			if(data.level < 50){
				_girlMc = new McItem('unopen', 0, 0, false);
			}
			else if(!data.girlHero.id) {
				_girlMc = new McItem('init', 0, 0, false);	
			}
			else {
				_girlMc = new McItem(data.girlHero.img, 0, 0, false);
				// 设置tip
				TipHelper.setTip(_girlMc, new McTip('<font color="' + Trans.heroQualityColor[data.girlHero.quality] + '">' + data.girlHero.name + '</font>'));
			}
			addChildEx(_girlMc, 44.6, 79.2);
		}
		
		private function changeTab(id : String) : void
		{
			if(id == EQUIP){
				// 生成显示的装备面板
				_items = new Vector.<DisplayObject>;
				var equipArr : Array = Data.data.boyInfo.equip;
				for (var i:int = 0; i < 6; i++) 
				{
					var one:Object = equipArr[i];
					var mc:McItem;
					if(!one) mc = new McItem('equipBg' + i);
					else mc = new McItem(one.img, one.intensifyLevel);
					_items.push(mc);
					// 设置tip
					if(one) TipHelper.setTip(mc, Trans.transTips(one));
				}
				_itemPanel.setItems(_items);		
			}else{
				// 生成显示的军需面板
				var items:Array = [];
				_items = new Vector.<DisplayObject>;
				for each(var k:Object in Data.data.boyInfo.arm) items.push(k);
				//按照物品等级排序
				items.sortOn("level", Array.NUMERIC);
				for each(var one2:Object in items){
					var mc2 : McItem = new McItem(one2.img, 0, one2.num);
					_items.push(mc2);
					// 设置tip
					TipHelper.setTip(mc2, Trans.transTips(one2));
				}
				_itemPanel.setItems(_items);		
			}
		}
	}
}