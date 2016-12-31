package com.brickmice.view.girlhero
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmTabButton;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McTip;
	import com.brickmice.view.component.prompt.ConfirmMessage;
	import com.brickmice.view.girlhero.GirlHeroTalentExchange;
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

	public class GirlHero extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "GirlHero";
		
		private var _mc:MovieClip;
		private var _exp:MovieClip;
		private var _expBpx:MovieClip;
		private var _lvl:TextField;
		private var _startResearchBtn:MovieClip;
		private var _closeBtn:MovieClip;
		private var _fireBtn:MovieClip;
		private var _inheritBtn:MovieClip;
		private var _talentBtn:MovieClip;
		private var _pos:TextField;
		private var _nameBtn:MovieClip;
		
		private var _chooseHeroId : int = 0;
		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _heroTab : BmTabView;
		private var _heros : Vector.<DisplayObject>;
		private var _max : int;
		private var _img : McImage;
		
		public function GirlHero(data : Object)
		{
			_mc = new ResGirlHeroWindow;
			super(NAME, _mc);
			
			_exp = _mc._exp;
			_expBpx = _mc._expBpx;
			_lvl = _mc._lvl;
			_startResearchBtn = _mc._startResearchBtn;
			_nameBtn = _mc._nameBtn;
			_closeBtn = _mc._closeBtn;
			_fireBtn = _mc._fireBtn;
			_inheritBtn = _mc._inheritBtn;
			_talentBtn = _mc._talentBtn;
			_pos = _mc._pos;
			
			new BmButton(_fireBtn, function() : void
			{
				var data:Object = {};
				data.msg = "确认要转化此科学美人？将无法找回！";
				data.action = "client";
				data.args = function():void{
					ModelManager.girlHeroModel.fireGirlHero(_chooseHeroId, function():void{
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
				TipHelper.setTip(_fireBtn, new McTip("转化同时，也会解雇这个科学美人"));
			}
			
			new BmButton(_inheritBtn, function() : void
			{
				if (ViewManager.hasView(Inherit.NAME)) return;
				var inheritWin:BmWindow = new Inherit(_chooseHeroId, setData);
				addChildCenter(inheritWin);
			});
			
			new BmButton(_nameBtn, function(event : MouseEvent) : void
			{
				if (ViewManager.hasView(ModifyGirlName.NAME)) return;
				var data:Object = Data.data.girlHero[_chooseHeroId];
				var modifyGirlName:BmWindow = new ModifyGirlName(data, setData);
				addChildCenter(modifyGirlName);
			});
			
			new BmButton(_talentBtn, function() : void
			{
				if (ViewManager.hasView(GirlHeroTalentExchange.NAME)) return;
				var talentWin:BmWindow = new GirlHeroTalentExchange(_chooseHeroId, changeHero);
				addChildCenter(talentWin);
			});
			if(Data.data.user.techLevel < 28) {
				UiUtils.setButtonEnable(_talentBtn, false);
				TipHelper.setTip(_talentBtn, new McTip("科技等级28级开启"));
			}
			
			//HerosTab
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			for(var i:int = 1; i <= 10; i++){
				tabs.push(new KeyValue('init', _mc["_tab" + i]));	
			}
			_heroTab = new BmTabView(tabs, function(id : String) : void
			{
				_chooseHeroId = int(id);
				changeHero();
			});
			
			// 物品面板
			_itemPanel = new McList(3, 2, 9, 10, 72, 72, true);
			addChildEx(_itemPanel, 356, 161);
			
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
			addChildEx(_img, 200, 80);

			//说明
			TipHelper.setTip(_mc._detailLogic, new McTip("逻辑力增加科研速度和基础攻击力"));
			TipHelper.setTip(_mc._detailCreate, new McTip("创造力增加科研速度和暴击伤害"));

			setData();

			//新手指引
			NewbieController.showNewBieBtn(12, 2, this, 359, 196, true, "打开技能选择页面");
		}
		
		public function setData() : void
		{
			var data:Object = Data.data.girlHero;
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
			
			var data:Object = Data.data.girlHero[_chooseHeroId];
			_lvl.text = data.level;
			_exp.width = data.exp / data.upgradeExp * _max;
			var msg:String = data.exp + ' / ' + data.upgradeExp + '  (' + (int(data.exp) * 100 / int(data.upgradeExp)).toFixed(2).toString()  + '%)';
			_mc._expDetailed.text = msg;
			_pos.text = Trans.heroStatus[data.status];
			
			var str:String = '';
			
			str = "天赋：" + (data.talent ? data.talent.name : "无");
			_mc._detailTalent.text = str;
			TipHelper.clear(_mc._detailTalent);
			if(data.talent && data.talent.id){
				TipHelper.setTip(_mc._detailTalent, new McTip(data.talent.describe));
			}
			
			str = "能力点：" + data.point + '/' + data.pointLimit;
			_mc._detailPoint.text = str;
			
			str = "逻辑：" + Math.floor(data.logic).toString();
			_mc._detailLogic.text = str;
			
			str = "创造力：" + Math.floor(data.create).toString();
			_mc._detailCreate.text = str;
			
			str = "研究速度：" + Math.floor(data.speed).toString() + "/每分钟";
			_mc._detailSpeed.text = str;
			
			UiUtils.setButtonEnable(_inheritBtn, true);
			if(data.level < 50 || data.ancestor != "") UiUtils.setButtonEnable(_inheritBtn, false);
			
			// 设置tip
			msg = '科学美人50级开启';
			if(data.inherit != "") msg = '已被' + data.inherit + '传承';
			if(data.ancestor != "") {
				if(data.inherit != "")
					msg += '<br>已传承给' + data.ancestor;
				else
					msg = '已传承给' + data.ancestor;
			}
			_img.reload(data.img + 'b');
			TipHelper.clear(_inheritBtn);
			TipHelper.setTip(_inheritBtn, new McTip(msg));

			showItem();
		}
		
		private function showItem() : void
		{
			// 生成显示的物品列表			
			_items = new Vector.<DisplayObject>;
			var lessonArr : Array = Data.data.girlHero[_chooseHeroId].lesson;
			for (var i:int = 0; i < 6; i++) 
			{
				var one:Object = lessonArr[i];
				var mc:McItem;
				if(i < Data.data.girlHero[_chooseHeroId].slotNum){
					if(!one) mc = new McItem();
					else {
						var imgUrl:String = one.img || one.learnedImg;
						mc = new McItem(imgUrl);
					}
					setLesson(mc, i, one);
					mc.buttonMode = true;
					// 设置tip
					if(one) TipHelper.setTip(mc, Trans.transClassTips(one));
				}
				else
				{
					mc = new McItem('unopen');
				}
				_items.push(mc);
			}
			_itemPanel.setItems(_items);		
		}
		
		private function setLesson(mc:McItem, i:int, ob:Object):void
		{
			if(ob != null) {
				mc.delFunc = function():void{
					ModelManager.girlHeroModel.removeGirlHeroLesson(_chooseHeroId, i, changeHero);
				};	
			}
			mc.evts.addEventListener(MouseEvent.CLICK, function(event : MouseEvent) : void
			{
				if (ViewManager.hasView(GirlHeroChooseLesson.NAME)) return;
				var pageType:String = 'nature';
				if(ob != null) pageType = ob['lessontype'];
				NewbieController.refreshNewBieBtn(12, 3);
				var win:BmWindow = new GirlHeroChooseLesson(_chooseHeroId, i, changeHero, pageType);
				addChildCenter(win);	
			});
		}
	}
}