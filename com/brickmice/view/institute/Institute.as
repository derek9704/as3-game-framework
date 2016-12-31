package com.brickmice.view.institute
{
	import com.brickmice.ModelManager;
	import com.brickmice.controller.NewbieController;
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.ViewMessage;
	import com.brickmice.view.component.BmButton;
	import com.brickmice.view.component.BmCountDown;
	import com.brickmice.view.component.BmTabView;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.prompt.TextMessage;
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.utils.KeyValue;
	import com.framework.utils.TipHelper;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Institute extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "Institute";
		public static const RESEARCH : String = 'research';
		public static const NEWLESSON : String = 'newLesson';
		public static const NEWPAPER : String = 'newPaper';
		public static const GOTLESSON : String = 'gotLesson';
		public static const GOTPAPER : String = 'gotPaper';
		
		private var _mc:MovieClip;
		private var _exp:MovieClip;
		private var _expBox:MovieClip;
		private var _armIssueTab:MovieClip;
		private var _lvl:TextField;
		private var _techIssueTab:MovieClip;
		private var _researchSpeed:MovieClip;
		private var _girlHeroTab:MovieClip;
		private var _closeBtn:MovieClip;
		private var _armAchievementTab:MovieClip;
		private var _techAchievementTab:MovieClip;
		private var _girlGotExp:MovieClip;
		private var _scd:BmCountDown;
		
		private var _max : int;
		private var _tabView : BmTabView;
		private var _currentTab:String;
		private var _itemPanel : McList;
		private var _newClassPanel : McList;
		private var _items : Vector.<DisplayObject>;
		
		private var _time1Btn:BmButton;
		private var _time2Btn:BmButton;
		private var _time3Btn:BmButton;
		private var _time4Btn:BmButton;
		private var _selectedType:int = 0;
		
		public function Institute(data : Object)
		{
			_currentTab = data.type;
			
			_mc = new ResInstituteWindow;
			super(NAME, _mc);
			
			_exp = _mc._exp;
			_expBox = _mc._expBox;
			_armIssueTab = _mc._armIssueTab;
			_girlGotExp = _mc._girlGotExp;
			_lvl = _mc._lvl;
			_techIssueTab = _mc._techIssueTab;
			_researchSpeed = _mc._researchSpeed;
			_girlHeroTab = _mc._girlHeroTab;
			_closeBtn = _mc._closeBtn;
			_armAchievementTab = _mc._armAchievementTab;
			_techAchievementTab = _mc._techAchievementTab;
			
			new BmButton(_mc._startBtn, function():void{
				if(!_selectedType){
					TextMessage.showEffect("请先选择研究模式", 2);
				}
				else ModelManager.instituteModel.startInstituteStudy(_selectedType, function():void{
					setTimeBtns();
					setData();
				});
			});
			
			new BmButton(_mc._stopBtn, function():void{
				ModelManager.instituteModel.stopInstituteStudy(function():void{
					setTimeBtns();
					setData();
				});
			});
			
			_time1Btn = new BmButton(_mc._time1, function():void{selectTime(1)}, true);
			_time2Btn = new BmButton(_mc._time2, function():void{selectTime(2)}, true);
			_time3Btn = new BmButton(_mc._time3, function():void{selectTime(3)}, true);
			_time4Btn = new BmButton(_mc._time4, function():void{selectTime(4)}, true);
			
			//经验条
			_max = _exp.width;
			_mc._expDetailed.visible = false;
			_mc._expDetailed.mouseEnabled = _mc._exp.mouseEnabled = false;
			_mc._expBox.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				_mc._expDetailed.visible = true;
			});
			_mc._expBox.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				_mc._expDetailed.visible = false;
			});
			
			//Tabs
			var tabs : Vector.<KeyValue> = new Vector.<KeyValue>();
			tabs.push(new KeyValue(RESEARCH, _girlHeroTab), new KeyValue(NEWLESSON, _techIssueTab), new KeyValue(NEWPAPER, _armIssueTab), new KeyValue(GOTLESSON, _techAchievementTab), new KeyValue(GOTPAPER, _armAchievementTab));
			_tabView = new BmTabView(tabs, function(id : String) : void
			{
				if(id == NEWLESSON) {
					NewbieController.refreshNewBieBtn(11, 2);
//					NewbieController.refreshNewBieBtn(5, 3);
//					NewbieController.refreshNewBieBtn(7, 3);
				}
				if(id == NEWPAPER) {
//					NewbieController.refreshNewBieBtn(43, 3);
				}	
				_currentTab = id;
				setData();
			});
			
			// 物品面板
			_itemPanel = new McList(6, 1, 2, 0, 79, 103, true);
			addChildEx(_itemPanel, 35, 160);
			
			// 课题面板
			_newClassPanel = new McList(6, 1, 1, 0, 79, 115, true);
			addChildEx(_newClassPanel, 35, 140);
			
			setTimeBtns();
			setData();
			
			//新手指引
			NewbieController.showNewBieBtn(10, 2, this, 24, 196, true, "打开选择科学美人窗口", false, true);
			NewbieController.showNewBieBtn(11, 1, this, 135, 115, true, "切换到科技新课题页面", false, true);
//			NewbieController.showNewBieBtn(43, 2, this, 319, 115, true, "切换到军需课题页面 ");
		}
		
		private function setTimeBtns():void
		{
			//研究计时
			var unitData:Object = Data.data.institute;
			_mc._time1.visible = true;
			_mc._time2.visible = true;
			_mc._time3.visible = true;
			_mc._time4.visible = true;
			_mc._startBtn.visible = true;
			_mc._stopBtn.visible = true;
			_time1Btn.enable = true;
			_time2Btn.enable = Data.data.user.vip >= 1;
			_time3Btn.enable = Data.data.user.vip >= 3;
			_time4Btn.enable = Data.data.user.vip >= 5;
			_mc._time1CountDown.visible = false;
			_mc._time2CountDown.visible = false;
			_mc._time3CountDown.visible = false;
			_mc._time4CountDown.visible = false;
			
			if(unitData['study']['leftTime']){
				_mc._startBtn.visible = false;
				_time1Btn.enable = false;
				_time2Btn.enable = false;
				_time3Btn.enable = false;
				_time4Btn.enable = false;
				var studyType:int = unitData['study']['type'];
				_mc['_time' + studyType].visible = false;
				var smc:MovieClip = _mc['_time' + studyType + 'CountDown'];
				smc.visible = true;
				if(_scd){
					_scd.stopTimerWithoutCallBack();
				}
				_scd = new BmCountDown(smc._countDown, unitData['study']['leftTime'], setData);
				_scd.startTimer();
			}else{
				selectTime(1, false);
				_mc._stopBtn.visible = false;
			}
		}
		
		private function selectTime(type:int, flag:Boolean = true):void
		{
//			if(flag) NewbieController.refreshNewBieBtn(2, 6);
			_selectedType = type;
			_time1Btn.selected = type == 1;
			_time2Btn.selected = type == 2;
			_time3Btn.selected = type == 3;
			_time4Btn.selected = type == 4;
		}
		
		public function setData() : void
		{
			var unitData:Object = Data.data.institute;
			_lvl.text = unitData.level;
			_exp.width = Data.data.user.techExp / Data.data.user.upgradeTechExp * _max;
			var msg:String = Data.data.user.techExp + ' / ' + Data.data.user.upgradeTechExp + '  (' + (int(Data.data.user.techExp) * 100 / int(Data.data.user.upgradeTechExp)).toFixed(2).toString()  + '%)';
			_mc._expDetailed.text = msg;
			_tabView.selectId = _currentTab;
			
			if(unitData['study']['leftTime']){
				_mc._startBtn.visible = false;
			}else{
				_mc._stopBtn.visible = false;
			}
			
			if(_currentTab == RESEARCH){
				_researchSpeed.visible = true;
				_itemPanel.visible = true;
				_newClassPanel.visible = false;
				_girlGotExp.visible = true;
				_girlGotExp._expSpeed.text = unitData.girlExpAdd;
				
				// 生成显示的物品列表
				_items = new Vector.<DisplayObject>;
				
				var heroes:Object = unitData.heroes;
				
				var allSpeed:int = 0;
				for (var i:int = 1; i <= 6; i++) {
					var mc : McItem;
					if(i <= unitData.slotNum){
						if(heroes[i] && heroes[i].id){
							var hero:Object = Data.data.girlHero[heroes[i].id];
							allSpeed += hero.speed;
							var text:String = hero.name + '<br>' + Math.floor(hero.speed).toString() + ' / 分钟';
							mc = new McItem(hero.img, hero.level, 0, true, text);
						}
						else{
							mc = new McItem();
						}
						mc.evts.addClick(showSelectHeroWin);
					}
					else
					{
						mc = new McItem('unopen');
					}
					
					_items.push(mc);
				}
				_itemPanel.setItems(_items);	
				_researchSpeed._researchSpeed.text = Math.floor(allSpeed).toString();
			}else if(_currentTab == NEWLESSON)
			{
				_researchSpeed.visible = false;
				_itemPanel.visible = false;
				_newClassPanel.visible = true;
				_girlGotExp.visible = false;
				_newClassPanel.setHScrollBarNull();
				// 生成显示的物品列表
				_items = new Vector.<DisplayObject>;
				
				var lessones:Object = unitData.lesson;
				var lessonArr:Array = [];
				for(var k:String in lessones) lessonArr.push(lessones[k]);
				var mc2 : NewClassSlot;
				lessonArr.sortOn(["classlevel", "id"], [Array.NUMERIC, Array.NUMERIC]);
				for each(var one:Object in lessonArr) {
					if(one.learned == 1) continue;
					//前置判断
					var ticketName:String = '';
					if(one.ticket1 && one.ticket1 != 0){
						if(!Data.data.institute.lesson[one.ticket1] || Data.data.institute.lesson[one.ticket1].learned == 0){
							ticketName += one.ticket1name;
						}
					}
					if(one.ticket2 && one.ticket2 != 0){
						if(!Data.data.institute.lesson[one.ticket2] || Data.data.institute.lesson[one.ticket2].learned == 0){
							ticketName += "|" + one.ticket2name;
						}
					}
					mc2 = new NewClassSlot(one, ticketName);
					_items.push(mc2);
				}
				_newClassPanel.setItems(_items);
			}else if(_currentTab == NEWPAPER)
			{
				_researchSpeed.visible = false;
				_itemPanel.visible = false;
				_newClassPanel.visible = true;
				_girlGotExp.visible = false;
				_newClassPanel.setHScrollBarNull();
				// 生成显示的物品列表
				_items = new Vector.<DisplayObject>;
				
				var papers:Object = unitData.paper;
				var paperArr:Array = [];
				for(var k2:String in papers) paperArr.push(papers[k2]);
				var mc3 : NewClassSlot;
				paperArr.sortOn(["classlevel", "id"], [Array.NUMERIC, Array.NUMERIC]);
				for each(var one2:Object in paperArr) {
					if(one2.learned == 1) continue;
					mc3 = new NewClassSlot(one2, '');
					_items.push(mc3);
				}
				_newClassPanel.setItems(_items);
			}else if(_currentTab == GOTLESSON)
			{
				_researchSpeed.visible = false;
				_itemPanel.visible = false;
				_newClassPanel.visible = true;
				_girlGotExp.visible = false;
				_newClassPanel.setHScrollBarNull();
				// 生成显示的物品列表
				_items = new Vector.<DisplayObject>;
				
				var lessones2:Object = unitData.lesson;
				var lessonArr2:Array = [];
				for(var k3:String in lessones2) lessonArr2.push(lessones2[k3]);
				var mc4 : NewClassSlot;
				lessonArr2.sortOn(["classlevel", "id"], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC | Array.DESCENDING]);
				for each(var one3:Object in lessonArr2) {
					if(!one3.learned == 1) continue;
					mc4 = new NewClassSlot(one3, '');
					_items.push(mc4);
				}
				_newClassPanel.setItems(_items);
			}else{
				_researchSpeed.visible = false;
				_itemPanel.visible = false;
				_newClassPanel.visible = true;
				_girlGotExp.visible = false;
				_newClassPanel.setHScrollBarNull();
				// 生成显示的物品列表
				_items = new Vector.<DisplayObject>;
				
				var papers2:Object = unitData.paper;
				var paperArr2:Array = [];
				for(var k4:String in papers2) paperArr2.push(papers2[k4]);
				var mc5 : NewClassSlot;
				paperArr2.sortOn(["classlevel", "id"], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC | Array.DESCENDING]);
				for each(var one4:Object in paperArr2) {
					if(!one4.learned == 1) continue;
					mc5 = new NewClassSlot(one4, '');
					_items.push(mc5);
				}
				_newClassPanel.setItems(_items);
			}
			updateClassNewFlag();
		}
		
		private function showSelectHeroWin(e:MouseEvent):void
		{
			if (ViewManager.hasView(InstituteChooseGirlHero.NAME)) return;
			var win:BmWindow = new InstituteChooseGirlHero(setData);
			addChildCenter(win);
			NewbieController.refreshNewBieBtn(10, 3);
		}
		
		/**
		 * 消息监听
		 */
		override public function listenerMessage() : Array
		{
			return [ViewMessage.REFRESH_INSTITUTE, ViewMessage.REFRESH_NEWBIE];
		}	
		
		/**
		 * 消息捕获
		 */
		override public function handleMessage(message : Message) : void
		{
			switch(message.type)
			{
				case ViewMessage.REFRESH_INSTITUTE:
					updateClassNewFlag();
					break;
				case ViewMessage.REFRESH_NEWBIE:
//					NewbieController.showNewBieBtn(2, 5, this, 40, 309, true, "选择研究的时间");
					NewbieController.showNewBieBtn(10, 5, this, 392, 343, true, "开始研究工作", false, true);
					NewbieController.showNewBieBtn(11, 1, this, 135, 115, true, "切换到科技新课题页面", false, true);
					NewbieController.showNewBieBtn(11, 2, this, 43, 238, true, "选择经典数学进行攻关", false, true);
//					NewbieController.showNewBieBtn(43, 3, this, 43, 238, true, "开始攻关");
					break;
				default:
			}
		}		
		
		private function updateClassNewFlag():void
		{
			//课题
			var lessones:Object = Data.data.institute.lesson;
			var lessonCount:int = 0;
			for each(var one3:Object in lessones) {
				if(one3.learned == 1) continue;
				//前置判断
				if(one3.ticket1 && one3.ticket1 != 0){
					if(!Data.data.institute.lesson[one3.ticket1] || Data.data.institute.lesson[one3.ticket1].learned == 0){
						continue;
					}
				}
				if(one3.ticket2 && one3.ticket2 != 0){
					if(!Data.data.institute.lesson[one3.ticket2] || Data.data.institute.lesson[one3.ticket2].learned == 0){
						continue;
					}
				}
				lessonCount++;
			}
			_mc._newAinm1.visible = lessonCount > 0;
			//图纸
			var paperes:Object = Data.data.institute.paper;
			var paperCount:int = 0;
			for each(var one2:Object in paperes) {
				if(one2.learned == 1) continue;
				paperCount++;
			}
			_mc._newAinm2.visible = paperCount > 0;
		}
		
	}
}