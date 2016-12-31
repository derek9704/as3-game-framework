package com.brickmice.view.girlhero
{
	import com.brickmice.data.Data;
	import com.brickmice.data.Trans;
	import com.brickmice.view.component.BmWindow;
	import com.brickmice.view.component.McImage;
	import com.brickmice.view.component.McItem;
	import com.brickmice.view.component.McList;
	import com.brickmice.view.component.McTip;
	import com.framework.utils.TipHelper;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class OtherGirlHero extends BmWindow
	{
		/**
		 * 窗口名字.
		 */
		public static const NAME : String = "OtherGirlHero";
		
		private var _mc:MovieClip;
		private var _exp:MovieClip;
		private var _expBpx:MovieClip;
		private var _lvl:TextField;
		private var _name:TextField;

		private var _itemPanel : McList;
		private var _items : Vector.<DisplayObject>;
		private var _max : int;
		private var _img : McImage;
		
		public function OtherGirlHero()
		{
			_mc = new ResOtherGirlWindow;
			super(NAME, _mc);
			
			_exp = _mc._exp;
			_expBpx = _mc._expBpx;
			_lvl = _mc._lvl;
			_name = _mc['_name'];
			
			// 物品面板
			_itemPanel = new McList(3, 2, 9, 10, 72, 72, true);
			addChildEx(_itemPanel, 258, 161);
			
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
			addChildEx(_img, 103, 80);

			setData();
		}
		
		public function setData() : void
		{
			var data:Object = Data.data.girlInfo;
			
			_name.htmlText = '<font color="' + Trans.heroQualityColor[data.quality] + '">' + data.name + '</font>';
			_lvl.text = data.level;
			_exp.width = data.exp / data.upgradeExp * _max;
			var msg:String = data.exp + ' / ' + data.upgradeExp + '  (' + (int(data.exp) * 100 / int(data.upgradeExp)).toFixed(2).toString()  + '%)';
			_mc._expDetailed.text = msg;
			
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

			_img.reload(data.img + 'b');
			
			// 生成显示的物品列表			
			_items = new Vector.<DisplayObject>;
			var lessonArr : Array = data.lesson;
			for (var i:int = 0; i < 6; i++) 
			{
				var one:Object = lessonArr[i];
				var mc:McItem;
				if(i < data.slotNum){
					if(!one) mc = new McItem();
					else {
						var imgUrl:String = one.img || one.learnedImg;
						mc = new McItem(imgUrl);
					}
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
	}
}