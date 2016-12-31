package com.brickmice.data
{
	import com.brickmice.view.bag.Bag;
	import com.brickmice.view.component.McTip;

	/**
	 * 本地化文件
	 *
	 * @author derek
	 */
	public class Trans
	{
		/**
		 * 物品类型
		 */
		public static const itemTypeName : Object = {"equip" : "装备", "plus" : "道具", "goods" : "物品", "material" : "资源", "virtual" : "货币"};
	
		/**
		 * 课题类型
		 */
		public static const itemClassTypeName : Object = {"lesson" : "科技", "paper" : "军需"};
	
		/**
		 * 装备类型
		 */
		public static const equipTypeName : Object = {"fly" : "飞行器", "rod" : "权杖", "chip" : "脑波增幅芯片", "emblem" : "纹章", "flag" : "战旗", "symbol" : "信物"};
		
		/**
		 * 军需类型
		 */
		public static const armTypeName : Object = {"pen" : "文具", "medic" : "医护", "sting" : "穿刺", "metal" : "五金", "toy" : "电动玩具", "beam" : "能量"};	
		
		/**
		 * 科技主分类
		 */
		public static const lessonTypeName : Object = {"nature" : "自然科学", "human" : "人文科学"};	
		
		/**
		 * 科技次分类
		 */
		public static const lessonSubTypeName : Object = {"astro" : "天文学", "maths" : "数学", "logic" : "逻辑学", "earth" : "地球科学", "phy" : "物理学", "chem" : "化学", "life" : "生命科学", "classic" : "西洋古典学", "phi" : "哲学", "region" : "宗教学", "lang" : "语言学", "art" : "艺术", "history" : "历史学"};	
		
		/**
		 * 员工状态
		 */
		public static const heroStatus : Object = {
			"free" : "空闲", "house" : "驻守", "attack" : "进攻", "march" : "行军", "dead" : "死亡",
			"revive" : "复活", "train" : "训练", "study" : "研究","aim":"助战"
		};		
		
		/**
		 * 生成TIPS 
		 * @param data
		 */
		public static function transTips(item:Object) : McTip
		{
			var msg:String = '<font color="#ff9900" size="14">' + item.name + '</font>' + '<br><font color="#ffd374">类型：</font><font color="#f8eeb1">' + Trans.itemTypeName[item.type] + '</font><br>';
			if(item.subtype == 'arm') msg += '<font color="#ffd374">子类型：</font><font color="#f8eeb1">' + Trans.armTypeName[item.armtype] + '</font><br>'
			if(item.type == 'equip') {
				msg += '<font color="#ffd374">强化等级：</font><font color="#f8eeb1">' + item.intensifyLevel.toString() + '</font><br><font color="#ffd374">部位：</font><font color="#f8eeb1">' 
					+ Trans.equipTypeName[item.subtype] + '</font><br>' + '<font color="#ffd374">穿戴需求：</font><font color="#f8eeb1">噩梦鼠' + item.level.toString() + '级</font><br>';
				if(item.subtype == 'emblem') msg += '<font color="#ffd374">贡献度需求：</font><font color="#f8eeb1">' + item.special1 + '</font><br>';	
				if(item.attack != 0) msg += '<font color="#ffd374">统率力：</font><font color="#f8eeb1">' + item.attack.toString() + '</font><br>';
				if(item.defense != 0) msg += '<font color="#ffd374">意志力：</font><font color="#f8eeb1">' + item.defense.toString() + '</font><br>';
				if(item.carry != 0) msg += '<font color="#ffd374">带兵数：</font><font color="#f8eeb1">' + item.carry.toString() + '</font><br>';
				if(item.scamper != 0) msg += '<font color="#ffd374">行动力：</font><font color="#f8eeb1">' + item.scamper.toString() + '</font><br>';
			}
			else msg += '<font color="#ffd374">物品等级：</font><font color="#f8eeb1">' + item.level.toString() + '</font><br>';
			if(item.type == 'equip' || item.type == 'plus') msg += '<font color="#ffd374">出售价格：</font><font color="#f8eeb1">' + item.saleprice + '</font><br>';
			if(item.subtype == 'arm' || item.subtype == 'mouse') msg += '<font color="#ffd374">攻击力：</font><font color="#f8eeb1">' + item.attack + '</font><br>' + '<font color="#ffd374">防御力：</font><font color="#f8eeb1">' + item.defense + '</font><br>';
//			if(item.subtype == 'mouse') msg += '<font color="#ffd374">负重：</font><font color="#f8eeb1">' + (int(item.carry) - int(item.weight)).toString() + '</font><br>';	
			if(item.type == 'goods') msg += '<font color="#ffd374">重量：</font><font color="#f8eeb1">' + item.weight + '</font><br>';
			msg += '<font color="#f8eeb1">' + item.describe + '</font><br>';
			return new McTip(msg);
		}
		
		/**
		 * 生成课题TIPS 
		 * @param data
		 */
		public static function transClassTips(item:Object, got:Boolean = true, ticketName:String = '') : McTip
		{
			var msg:String = '<font color="#ff9900" size="14">' + item.classname + '</font>' + '<br><font color="#ffd374">类型：</font><font color="#f8eeb1">' + Trans.itemClassTypeName[item.subtype] + '</font><br>';
			if(item.subtype == 'lesson') msg += '<font color="#ffd374">科技分类：</font><font color="#f8eeb1">' + Trans.lessonTypeName[item.lessontype] + " " + Trans.lessonSubTypeName[item.lessonsubtype] + '</font><br>';
			msg += '<font color="#ffd374">课题等级：</font><font color="#f8eeb1">' + item.classlevel + '</font><br>';
			if(!got) {
				msg += '<font color="#ffd374">攻关难度：</font><font color="#f8eeb1">' + item.difficulty + '</font><br>';
				msg += '<font color="#ffd374">科技点奖励：</font><font color="#f8eeb1">' + item.rewardtechpoint + '</font><br>';
				msg += '<font color="#ffd374">经验奖励：</font><font color="#f8eeb1">' + item.rewardexp + '</font><br>';
			}
			if(item.subtype == 'lesson'){
				if(item.addlogic != 0) msg += '<font color="#ffd374">增加逻辑力：</font><font color="#f8eeb1">' + item.addlogic + '</font><br>';
				if(item.addcreat != 0) msg += '<font color="#ffd374">增加创造力：</font><font color="#f8eeb1">' + item.addcreat + '</font><br>';
				msg += '<font color="#ffd374">学习技能点：</font><font color="#f8eeb1">' + item.learnpoint + '</font><br>';
			}
			if(item.skill){
				msg += '<font color="#ffd374">附加属性：</font><font color="#f8eeb1">' + item.skill.describe + '</font><br>';
			}
			if(ticketName != ''){
				msg += '<font color="#ff0000">前置课题：</font><font color="#f8eeb1">' + ticketName + '</font><br>';
			}
			return new McTip(msg);
		}
		
		/**
		 * 员工品质颜色
		 */
		public static const heroQualityColor : Object = {"1" : "#F1E5CA", "2" : "#C6DD9B", "3" : "#86D9DB", "4" : "#CFACEE", "5" : "#FFCC00"};
		
	}
}
