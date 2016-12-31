package com.brickmice.view.boyhero
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Consts;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McTip;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	import com.framework.utils.FilterUtils;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	import com.framework.utils.UiUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class BoyHero extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "BoyHero";
		public static const ARM : String = 'arm';
		public static const EQUIP : String = 'equip';
		public static const INCITY : Array = ['free', 'train', 'dead', 'revive'];
		
		private var _mc:MovieClip;
		private var _exp:MovieClip;
		private var _lvl:TextField;
		private var _pos:TextField;
		private var _fireBtn:MovieClip;
		private var _nameBtn:MovieClip;
		private var _trainingBtn:MovieClip;
		private var _trainingCompleteBtn:MovieClip;
		private var _withdrawBtn:MovieClip;
		private var _regenBtn:MovieClip;
		private var _modifyTroopsBtn:MovieClip;
		private var _modifyArmBtn:MovieClip;		
		private var _armTab:MovieClip;
		private var _equipmentTab:MovieClip;
		private var _girlMc:McItem;

		private var _chooseHeroId : int = 0;
		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _heroTab : BmTabView;
		private var _heros : Vector.<DisplayObject>;
		private var _tabView : BmTabView;
		private var _max : int;
		private var _img : McImage;
		
		public function BoyHero(data : Object)
		{
			_mc = new ResBoyHeroWindow;
			super(NAME, _mc);
			
			_exp = _mc._exp;
			_modifyTroopsBtn = _mc._modifyTroopsBtn;
			_nameBtn = _mc._nameBtn;
			_lvl = _mc._lvl;
			_armTab = _mc._armTab;
			_fireBtn = _mc._fireBtn;
			_equipmentTab = _mc._equipmentTab;
			_modifyArmBtn = _mc._modifyArmBtn;
			_pos = _mc._pos;
			_trainingBtn = _mc._trainingBtn;
			_trainingCompleteBtn = _mc._trainingCompleteBtn;
			_withdrawBtn = _mc._withdrawBtn;
			_regenBtn = _mc._regenBtn;
			
			new BmButton(_fireBtn, function(event : MouseEvent) : void
			{
				var data:Object = {};
				data.msg = "确认要转化此噩梦鼠？将无法找回！";
				data.action = "client";
				data.args = function():void{
					ModelManager.boyHeroModel.fireBoyHero(_chooseHeroId, function():void{
						_chooseHeroId = 0;
						setData();
					});
				}
				ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
			});
			if(Data.data.user.techLevel < 10) {
				UiUtils.setButtonEnable(_fireBtn, false);
				TipHelper.setTip(_fireBtn, new McTip("科技等级10级开启"));
			}else{
				TipHelper.setTip(_fireBtn, new McTip("转化同时，也会解雇这只噩梦鼠"));
			}
			
			new BmButton(_trainingBtn, function(event : MouseEvent) : void
			{
				ModelManager.schoolModel.startSchoolTraining([_chooseHeroId], setData);
			});
			if(Data.data.user.techLevel < 18) {
				UiUtils.setButtonEnable(_trainingBtn, false);
				TipHelper.setTip(_trainingBtn, new McTip("科技等级18级开启"));
			}
			
			new BmButton(_trainingCompleteBtn, function(event : MouseEvent) : void
			{
				ModelManager.schoolModel.finishSchoolTraining(0, _chooseHeroId, setData);
			});

			new BmButton(_withdrawBtn, function(event : MouseEvent) : void
			{
				ModelManager.warModel.retreatWar(Data.data.boyHero[_chooseHeroId].planet.id, _chooseHeroId, setData);
			});		
			
			new BmButton(_regenBtn, function(event : MouseEvent) : void
			{
				var data:Object = {};
				data.msg = "确认要转生此噩梦鼠？品质提升，天赋保留，等级会归为1";
				data.action = "client";
				data.args = function():void{
					ModelManager.boyHeroModel.regenBoyHero(_chooseHeroId, function():void{
						_chooseHeroId = 0;
						setData();
					});
				}
				ControllerManager.windowController.showWindow(new WindowData(ConfirmMessage, data, true, 0, 0, 0, false));
			});		
			
			new BmButton(_modifyArmBtn, function(event : MouseEvent) : void
			{
				if (ViewManager.hasView(ModifyArm.NAME)) return;
//				NewbieController.refreshNewBieBtn(35, 3);
				var data:Object = Data.data.boyHero[_chooseHeroId];
				var modifyArmWin:BmWindow = new ModifyArm(data, setData);
				addChildCenter(modifyArmWin);			
			});
			
			new BmButton(_modifyTroopsBtn, function(event : MouseEvent) : void
			{
				if (ViewManager.hasView(ModifyTroops.NAME)) return;
//				NewbieController.refreshNewBieBtn(21, 3);
				NewbieController.refreshNewBieBtn(22, 4);
				var data:Object = Data.data.boyHero[_chooseHeroId];
				var modifyTroopsWin:BmWindow = new ModifyTroops(data, setData);
				addChildCenter(modifyTroopsWin);
			});
			
			new BmButton(_nameBtn, function(event : MouseEvent) : void
			{
				if (ViewManager.hasView(ModifyBoyName.NAME)) return;
				var data:Object = Data.data.boyHero[_chooseHeroId];
				var modifyBoyName:BmWindow = new ModifyBoyName(data, setData);
				addChildCenter(modifyBoyName);
			});
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue(EQUIP, _equipmentTab), new KeyValue(ARM, _armTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				changeTab(id);
			});
			
			//HerosTab
			tabs = new Vector.<KeyValue>();
			for(var i:int = 1; i <= 10; i++){
				tabs.push(new KeyValue('init', _mc["_tab" + i]));	
			}
			_heroTab = new BmTabView(tabs, function(id : String) : void
			{
				NewbieController.refreshNewBieBtn(22, 3);
				_chooseHeroId = int(id);
				changeHero();
			});
			
			// 物品面板
			_itemPanel = new McList(3, 2, 9, 10, 72, 72, true);
			addChildEx(_itemPanel, 356, 158);
			
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
			addChildEx(_img, 171, 53);
			
			//说明
			TipHelper.setTip(_mc._detailSpirit, new McTip("1意志力=50部队防御力"));
			TipHelper.setTip(_mc._detailLead, new McTip("1统率力=50部队攻击力"));
			TipHelper.setTip(_mc._detailDex, new McTip("25行动力=1%行军速度"));
			
			setData();
			
			//新手指引
//			NewbieController.showNewBieBtn(21, 2, this, 539, 370, true, "打开调整兵力面板");
			NewbieController.showNewBieBtn(22, 2, this, 25, 109, true, "选择新招募的噩梦鼠");
//			NewbieController.showNewBieBtn(35, 2, this, 484, 370, true, "打开调整军需面板");
			NewbieController.showNewBieBtn(6, 5, this, 357, 196, true, "打开权杖选择面板");
		}
		
		public function setData() : void
		{
			var data:Object = Data.data.boyHero;
			var heroArr:Array = [];
			for(var k:String in data) heroArr.push(data[k]);
			heroArr.sortOn(["level", "id"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);
			//隐藏所有员工标签
			_heroTab.hideAllTab();
			
			var index:int = 0;
			for each(var one:Object in heroArr) {
				var tab:BmTabButton = _heroTab.getIndexTab(index);
				tab.id = one.id;
				tab.filter = [FilterUtils.createGlow(0x000000, 500)];
				tab.text = '<font color="' + Trans.heroQualityColor[one.quality] + '">' + one.name + '</font>';
				tab.visible = true;
				if(_chooseHeroId == 0) {
					_chooseHeroId = one.id;
					_heroTab.selectId = one.id;
				}
				index++;
			}
	
			changeHero();
		}
		
		private function changeHero():void
		{
			if(!_chooseHeroId){
				closeWindow();
				return;
			}
			
			var data:Object = Data.data.boyHero[_chooseHeroId];
			_lvl.text = data.level;
			//经验条
			_exp.width = data.exp / data.upgradeExp * _max;
			var msg:String = data.exp + ' / ' + data.upgradeExp + '  (' + (int(data.exp) * 100 / int(data.upgradeExp)).toFixed(2).toString()  + '%)';
			_mc._expDetailed.text = msg;
			
			_pos.text = Trans.heroStatus[data.status];
			if(data.status == 'house' || data.status == 'march' || data.status == 'attack'){
				var pos:String = data.planet.name ? data.planet.name : '月球';
				_pos.appendText("：" + pos);
			}
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
			
			if(data.level < 60) {
				UiUtils.setButtonEnable(_regenBtn, false);
				TipHelper.setTip(_regenBtn, new McTip('噩梦鼠80级开启'));
			}else if(data.quality == 5 && data.zs == 1){
				UiUtils.setButtonEnable(_regenBtn, false);
				TipHelper.setTip(_regenBtn, new McTip('噩梦鼠已达到顶级品质'));
			}
			else{
				UiUtils.setButtonEnable(_regenBtn, true);
				TipHelper.clear(_regenBtn);
			}
			 
			var enabled:Boolean = (data.status == 'free' && data.level != 100);	
			_img.reload(data.img + 'b');
			if(Data.data.user.techLevel < 18) enabled = false;
			UiUtils.setButtonEnable(_trainingBtn, enabled);
			
			_trainingCompleteBtn.visible = data.status == 'train';
			
			enabled = data.status == 'house';
			UiUtils.setButtonEnable(_withdrawBtn, enabled);
			// 获取位置
			var index:int = INCITY.indexOf(data.status);
			enabled = index >= 0;
			UiUtils.setButtonEnable(_modifyTroopsBtn, enabled);
			UiUtils.setButtonEnable(_modifyArmBtn, enabled);

			_tabView.selectId = EQUIP;
			changeTab(EQUIP);
			
			//助战美人
			if(_girlMc) removeChild(_girlMc);
			if(data.girlHero.id){
				_girlMc = new McItem(data.girlHero.img, 0, 0, false);
				// 设置tip
				TipHelper.setTip(_girlMc, new McTip('<font color="' + Trans.heroQualityColor[data.girlHero.quality] + '">' + data.girlHero.name + '</font>'));
				_girlMc.delFunc = function():void{
					ModelManager.boyHeroModel.girlAimBoyHero(_chooseHeroId, 0, changeHero);
				};	
			}
			else if(data.level < 50){
				_girlMc = new McItem('unopen', 0, 0, false);	
				TipHelper.setTip(_girlMc, new McTip('加入助战美人，噩梦鼠50级开启'));
			}
			else {
				_girlMc = new McItem('init', 0, 0, false);	
				TipHelper.setTip(_girlMc, new McTip('加入助战美人'));
			}
			if(data.level >= 50){
				_girlMc.evts.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
				{
					if (ViewManager.hasView(BoyHeroChooseGirl.NAME)) return;
					var win:BmWindow = new BoyHeroChooseGirl(data.girlHero.id, _chooseHeroId, changeHero);
					addChildCenter(win);		
				});
				_girlMc.buttonMode = true;	
			}
			addChildEx(_girlMc, 143.3, 76.1);
		}
		
		
		private function transEquip(index:int):String
		{
			var str:String = '';
			switch(index)
			{
				case 0:
				{
					str = 'rod';
					break;
				}
				case 1:
				{
					str = 'chip';
					break;
				}
				case 2:
				{
					str = 'fly';
					break;
				}
				case 3:
				{
					str = 'emblem';
					break;
				}
				case 4:
				{
					str = 'flag';
					break;
				}
				case 5:
				{
					str = 'symbol';
					break;
				}
			}
			return str;
		}
		
		private function setEquip(mc:McItem, i:int, hasEquip:Boolean):void
		{
			if(hasEquip) {
				mc.delFunc = function():void{
					ModelManager.boyHeroModel.removeBoyHeroEquip(_chooseHeroId, i, changeHero);
				};	
			}
			mc.evts.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{
				if (ViewManager.hasView(BoyHeroChooseEquip.NAME)) return;
				NewbieController.refreshNewBieBtn(6, 6, true);
				NewbieController.refreshNewBieBtn(6, 9, true);
				NewbieController.refreshNewBieBtn(6, 12, true);
				var win:BmWindow = new BoyHeroChooseEquip(_chooseHeroId, transEquip(i), changeHero);
				addChildCenter(win);		
			});
		}
		
		private function changeTab(id : String) : void
		{
			if(id == EQUIP){
				// 生成显示的装备面板
				_items = new Vector.<DisplayObject>;
				var equipArr : Array = Data.data.boyHero[_chooseHeroId].equip;
				for (var i:int = 0; i < 6; i++) 
				{
					var one:Object = equipArr[i];
					var mc:McItem;
					if(!one) mc = new McItem('equipBg' + i);
					else mc = new McItem(one.img, one.intensifyLevel);
					setEquip(mc, i, one != null);
					_items.push(mc);
					mc.buttonMode = true;
					// 设置tip
					if(one) TipHelper.setTip(mc, Trans.transTips(one));
				}
				_itemPanel.setItems(_items);		
			}else{
				// 生成显示的军需面板
				var items:Array = [];
				_items = new Vector.<DisplayObject>;
				for each(var k:Object in Data.data.boyHero[_chooseHeroId].arm) items.push(k);
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
					NewbieController.showNewBieBtn(22, 3, this, 539, 370, true, "打开调整兵力面板");
					NewbieController.showNewBieBtn(6, 8, this, 436, 196, true, "打开芯片选择面板");
					NewbieController.showNewBieBtn(6, 11, this, 515, 196, true, "打开飞行器面板");
					break;
				default:
			}
		}	
	}
}