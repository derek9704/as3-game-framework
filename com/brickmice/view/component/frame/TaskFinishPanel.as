package com.brickmice.view.component.frame
{
	import com.brickmice.ControllerManager;
	import com.brickmice.Main;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McList;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class TaskFinishPanel extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "TaskFinishPanel";
		
		private var _mc:MovieClip;
		
		private var _panel : McList;
		private var _items : Vector.<DisplayObject>;
		
		public function TaskFinishPanel(data:Object)
		{
			_mc = new ResTaskFinishWindow;
			super(NAME, _mc);
			
			// 面板
			_panel = new McList(5, 1, 13, 0, 80, 115, true);
			addChildEx(_panel, 40.5, 119.5);
			
			//生成条目
			_items = new Vector.<DisplayObject>;
			for each(var one:Object in data.reward){
				var mc : TaskFinishItem = new TaskFinishItem(one);
				_items.push(mc);
			}
			_panel.setItems(_items);
			
			//排下位置
			if(_items.length == 1){
				_panel.x = 226;
			}else if(_items.length == 2){
				_panel.x = 186;
			}else if(_items.length == 3){
				_panel.x = 133;
			}else if(_items.length == 4){
				_panel.x = 80;
			}else{
				_panel.x = 40.5;
			}
			
			_mc._unlockBuilding.visible = false;
			
			//处理梦露
			ControllerManager.yahuanController.stopYahuan();
			Main.self.newbieBtn.visible = false;
			onClosed = function():void{
				Main.self.newbieBtn.visible = true;
				ControllerManager.yahuanController.continueYahuan();
			}
			//处理建筑开启
			switch(data.id)
			{
				case 1:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 太阳的试炼";
					break;
				}
				case 5:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 次元箱子";
					break;
				}
				case 6:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 强化中心";
					break;
				}
				case 7:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 月球战场";
					break;
				}
				case 9:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 研究所";
					break;
				}
				case 202:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 稀铁矿 原料仓库";
					break;
				}
				case 203:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 宝石矿";
					break;
				}
				case 204:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 发条鼠工厂 发条鼠军营";
					break;
				}
				case 205:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 人品试验机";
					break;
				}
				case 206:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 奶酪原浆矿";
					break;
				}
				case 207:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 奶酪工厂 奶酪仓库";
					break;
				}
				case 208:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 铁道部";
					break;
				}
				case 21:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 星际棋盘";
					break;
				}
				case 22:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 星球探索";
					break;
				}
				case 27:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 排行榜 星际联盟";
					break;
				}
				case 211:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 战争预警 噩梦教堂";
					break;
				}
				case 213:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 分子重组";
					break;
				}
				case 215:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 军需工厂 军需仓库";
					break;
				}
				case 217:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 噩梦军校";
					break;
				}
				case 219:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 星际出差";
					break;
				}
				case 221:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 物资交易中心";
					break;
				}
				case 223:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 宇宙外快";
					break;
				}
				case 225:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 试炼挑战关卡";
					break;
				}
				case 227:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 试炼兑换天赋";
					break;
				}
				case 304:
				{
					_mc._unlockBuilding.visible = true;
					_mc._unlockBuilding._txt.text = "开启： 月球战场团战模式";
					break;
				}
			}
		}
		
	}
}