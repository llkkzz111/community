package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by shizhang.cai on 2017/6/13.
 */

public class SearchBean {

    /**
     * totalCnt : 4191
     * sxlist : [{"propertyName":"分类","propertyValue":["厨房用具","餐具","烹饪锅具","整套茶具","保鲜盒、保鲜碗","茶杯","功夫茶具","其他","茶盘/茶台","酒具套件","水/酒/茶具","厨房收纳"]},{"propertyName":"类别","propertyValue":["套装","其他","压缩袋","单品","其他藏品","置物架","碗","菜板","筷子","调味瓶","盘","配件","收纳架","淋浴套装","木质层架","汤碗","单槽","厨用龙头","保温杯","刀叉/勺子","金属层架"]},{"propertyName":"规格","propertyValue":["8寸以上","30cm","1000-2000ml","5000ml以上","33cm","其他","其它","32cm","5.5-7寸","7.5-8寸","28cm","2001-3000ml","24cm","200-400ml","34cm","20cm","18cm","16cm","3.5-5寸","22cm"]},{"propertyName":"材质","propertyValue":["合金","耐热玻璃","陶瓷","复合钢","其它","不锈钢","其他","硅胶","铸铁","金属","玻璃","铁","300系列不锈钢","塑料","全铜","纯钛","钢化玻璃","纳米涂层","400系列不锈钢","铝合金铸件"]},{"propertyName":"适用炉灶","propertyValue":["通用","煤气炉","煤气灶"]},{"propertyName":"类型","propertyValue":["其他","斩切刀/砍骨刀","单底","菜刀/切片刀","环保杯","保温壶","复底"]},{"propertyName":"容量","propertyValue":["501-600ml","200-400ml","其他","1L以下","401-500ml","2L以上","700ml以上"]},{"propertyName":"配茶盘","propertyValue":["其他","木质","竹制"]},{"propertyName":"工艺","propertyValue":["其他","青瓷","耐热玻璃"]},{"propertyName":"套装规格","propertyValue":["10件套以上","单件","6件套","5件套","7-9件套","4件套","2件套","3件套"]},{"propertyName":"单品规格","propertyValue":["2001-5000ml","5L以上","1501-2000ml","501--1000ml","500ml以下","1001--1500ml"]},{"propertyName":"形状","propertyValue":["圆形","长方形","方槽"]},{"propertyName":"包装","propertyValue":["三件套","单刀","一个","四件套"]}]
     * searchItem : 厨房用具
     * pageSize : 24
     * brandinfo : [{"propertyName":"0351600","propertyValue":["库格(KUGEL)"]},{"propertyName":"0030700","propertyValue":["虎牌(TIGER)"]},{"propertyName":"0266400","propertyValue":["皇家·梵诗"]},{"propertyName":"0022700","propertyValue":["GLASS LOCK"]},{"propertyName":"0737700","propertyValue":["珍珠生活(PEARL LIFE)"]},{"propertyName":"0548700","propertyValue":["御煲"]},{"propertyName":"0015700","propertyValue":["双立人(ZWILLING)"]},{"propertyName":"0018200","propertyValue":["MIRACLE DYNASTY"]},{"propertyName":"0079600","propertyValue":["康宁(CORNING)"]},{"propertyName":"0129700","propertyValue":["红玫瑰"]},{"propertyName":"0701700","propertyValue":["欧洛雷(Oroley)"]},{"propertyName":"0320800","propertyValue":["泰福高(TAFUCO)"]},{"propertyName":"0793500","propertyValue":["康铂氏(keepeez)"]},{"propertyName":"0106000","propertyValue":["樱之歌"]},{"propertyName":"0031900","propertyValue":["乐美雅(Luminarc)"]},{"propertyName":"0160500","propertyValue":["贴易固(TEGO)"]},{"propertyName":"0620300","propertyValue":["罗比罗丹"]},{"propertyName":"0053900","propertyValue":["COREN"]},{"propertyName":"0003200","propertyValue":["WOLL"]},{"propertyName":"0039200","propertyValue":["菲仕乐(FISSLER)"]},{"propertyName":"0026200","propertyValue":["WMF"]},{"propertyName":"0320100","propertyValue":["哈尔斯(HAERS)"]},{"propertyName":"0761800","propertyValue":["家立佳(Familove)"]},{"propertyName":"0806100","propertyValue":["越一"]},{"propertyName":"0218900","propertyValue":["SIMELO"]},{"propertyName":"0968800","propertyValue":["UKA"]},{"propertyName":"0115600","propertyValue":["赛普瑞斯"]},{"propertyName":"0918000","propertyValue":["普瑞仕(Press Dome)"]},{"propertyName":"0341200","propertyValue":["美意达(MONETA)"]},{"propertyName":"0978200","propertyValue":["鼎匠"]},{"propertyName":"0917400","propertyValue":["奈赫曼(Nachtmann)"]},{"propertyName":"0869300","propertyValue":["Vacu Vin"]},{"propertyName":"1002900","propertyValue":["千工坊"]},{"propertyName":"0073000","propertyValue":["Staub"]},{"propertyName":"0235400","propertyValue":["拉歌蒂尼(Lagostina)"]},{"propertyName":"0584600","propertyValue":["大岛釜座"]},{"propertyName":"0335900","propertyValue":["SWISS DIAMOND"]},{"propertyName":"0612800","propertyValue":["可李司"]},{"propertyName":"0808600","propertyValue":["美之扣"]},{"propertyName":"0593900","propertyValue":["爱乐仕(ALES)"]},{"propertyName":"0342400","propertyValue":["孔雀(Peacock)"]},{"propertyName":"0640500","propertyValue":["竹中胜治"]},{"propertyName":"0915800","propertyValue":["三叉"]},{"propertyName":"0994100","propertyValue":["金野和司"]},{"propertyName":"0974700","propertyValue":["建厦"]},{"propertyName":"0608600","propertyValue":["敏杨"]},{"propertyName":"0877800","propertyValue":["伯尔尼斯"]},{"propertyName":"0202200","propertyValue":["象印(ZOJIRUSHI)"]},{"propertyName":"0229300","propertyValue":["乐扣乐扣(LOCK&LOCK)"]},{"propertyName":"1001900","propertyValue":["梵酷(Vacu Vin)"]},{"propertyName":"0275300","propertyValue":["贝高福(Berghoff)"]},{"propertyName":"0320000","propertyValue":["席玛(SIMAX)"]},{"propertyName":"0837200","propertyValue":["拜格"]},{"propertyName":"0262300","propertyValue":["德国高仪(GROHE)"]},{"propertyName":"0936600","propertyValue":["利茸"]},{"propertyName":"0743300","propertyValue":["生一"]},{"propertyName":"0050000","propertyValue":["泉字牌"]},{"propertyName":"0915900","propertyValue":["双枪"]},{"propertyName":"0706000","propertyValue":["厨欲无限"]},{"propertyName":"0085700","propertyValue":["思乐得"]},{"propertyName":"0936500","propertyValue":["洁成"]},{"propertyName":"0905800","propertyValue":["锦化成"]},{"propertyName":"0567900","propertyValue":["席格(SIEGER)"]},{"propertyName":"0609200","propertyValue":["威万事"]},{"propertyName":"0741700","propertyValue":["壳氏唯"]},{"propertyName":"0268600","propertyValue":["SOLE LUNA"]},{"propertyName":"0163000","propertyValue":["宝优妮(BLESS)"]},{"propertyName":"0447800","propertyValue":["卫欲无限"]},{"propertyName":"0974800","propertyValue":["AWASAKA"]},{"propertyName":"0505700","propertyValue":["宝家洁"]},{"propertyName":"0610700","propertyValue":["白鸟"]},{"propertyName":"0096900","propertyValue":["苏泊尔(SUPOR)"]},{"propertyName":"0641400","propertyValue":["艾特巴赫(ALTENBACH)"]},{"propertyName":"0419600","propertyValue":["吉优百(Homebest)"]},{"propertyName":"0401200","propertyValue":["顺祥"]},{"propertyName":"0801500","propertyValue":["新思特"]},{"propertyName":"0668100","propertyValue":["和风来"]},{"propertyName":"0921500","propertyValue":["路卡酷(LUCUKU)"]},{"propertyName":"0846000","propertyValue":["佳德"]},{"propertyName":"0899400","propertyValue":["田川町"]},{"propertyName":"0256200","propertyValue":["怡万家(IWAKI)"]},{"propertyName":"0010500","propertyValue":["张小泉"]},{"propertyName":"0029300","propertyValue":["美亚(MEYER)"]},{"propertyName":"0850200","propertyValue":["自然の风"]},{"propertyName":"0808700","propertyValue":["CHEFWAY"]},{"propertyName":"0282300","propertyValue":["墨林(morning)"]},{"propertyName":"0880200","propertyValue":["宜利客"]},{"propertyName":"0893200","propertyValue":["EASY LOCK"]},{"propertyName":"0047000","propertyValue":["ASVEL"]},{"propertyName":"0808800","propertyValue":["聚邦(JEVOL)"]},{"propertyName":"0446700","propertyValue":["康巴赫"]},{"propertyName":"0717800","propertyValue":["RIVER LIGHT"]},{"propertyName":"0924800","propertyValue":["Tassen"]},{"propertyName":"0852500","propertyValue":["优尊陶瓷(YOUZUN TAOCI)"]},{"propertyName":"0762100","propertyValue":["雅客集(YKJ)"]}]
     * morekey : ["厨房用具3M","厨房用具ACA","厨房用具ASVEL","厨房用具AWASAKA","厨房用具CDA","库格(KUGEL)","虎牌(TIGER)","皇家·梵诗","厨房用具","煲、砂锅、炖锅"]
     * tjlist : null
     * resultStr : [{"item_code":"15166151","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"2.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"293","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"韩国","mobile_price":"293","gift_yn":"0","promo_name":null,"item_name":"KUGEL 炫彩系列30CM不粘炒锅劲爆加赠组","tv_yn":"1","min_mobile_price":null,"presenter_name":"104619,童鑫,12频道,2017-04-24","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/6151/15166151-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15074281","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":"593","promo_start_date":null,"saveamt":"6.99","trade_yn":"0","promo_end_date":null,"last_sale_price":"593","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"694","gift_yn":"0","promo_name":null,"item_name":"通塔雷利(Tontarelli)","tv_yn":"1","min_mobile_price":"113","presenter_name":"102278,王姣姣,11频道,2017-04-29","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/07/4281/15074281S.jpg","jl_yn":"1","three_month_saleqty":"10951","gift_item":null,"waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15157306","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":"2975","promo_start_date":null,"saveamt":"19.8","trade_yn":"0","promo_end_date":null,"last_sale_price":"893","shop_url":null,"stock_qty":"12","groupbuy_pro_end_date":null,"origin_name":"泰国/中国","mobile_price":"1975","gift_yn":"1","promo_name":null,"item_name":"珍珠生活(PEARL LIFE)","tv_yn":"1","min_mobile_price":"294","presenter_name":"102091,胡忆菡,12频道,2017-01-07","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/15/7306/15157306-S.jpg","jl_yn":"1","three_month_saleqty":"10476","gift_item":"皇家梵诗 吉象锡罐( 锡罐高度10cm，直径：7.6cm 材质：97%锡 )","waiting_qty":null,"groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15149706","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"3.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"393","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"韩国","mobile_price":"393","gift_yn":"1","promo_name":null,"item_name":"GLASS LOCK 韩国进口 保鲜多功能钢化玻璃容器家庭暖心分享套组","tv_yn":"1","min_mobile_price":null,"presenter_name":"102136,王惟甲,11频道,2017-04-23","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/14/9706/15149706-S.jpg","jl_yn":null,"gift_item":"赠品1：Glasslock储物罐（IP-591）1500ml*2（盒盖 - PP，盒身 -玻璃，密封条 - 硅胶） 赠品2：Glasslock马克杯（IP-626H）500ml*2（盒盖 \u2013 铁，盒身 - 玻璃）","waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15161033","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"8.99","trade_yn":"0","promo_end_date":null,"last_sale_price":"894","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"日本","mobile_price":"894","gift_yn":"0","promo_name":null,"item_name":"珍珠生活 30cm中式铁锅（贺岁优惠组合）","tv_yn":"1","min_mobile_price":null,"presenter_name":"102091,胡忆菡,11频道,2017-01-25","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/1033/15161033-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":null,"groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15157306","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":"Thu Dec 29 17:00:00 CST 2016","saveamt":"8.98","trade_yn":"0","promo_end_date":"Sun Dec 31 23:59:59 CST 2017","last_sale_price":"893","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"日本","mobile_price":"893","gift_yn":"1","promo_name":"珍珠生活积分加赠","item_name":"[压轴凑单]珍珠生活 30cm中式铁锅（贺岁优惠组合）","tv_yn":"1","min_mobile_price":null,"presenter_name":"104619,童鑫,12频道,2016-12-29","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/15/7306/15157306-S.jpg","jl_yn":null,"gift_item":"赠品1：韩代锅盖*1（含盖珠、规格30cm） 赠品2：珍珠生活陶土锅*1(含盖子，2L) 赠品3：珍珠生活搪瓷铁壶五件套*1（规格：0.5L茶壶*1，60ML杯子*2，杯托*2）材质：搪瓷+铁 等级：合格品","waiting_qty":null,"groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"1","cust_price":"0"},{"item_code":"15165166","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"3.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"393","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"393","gift_yn":"1","promo_name":null,"item_name":"[庆生回馈]御煲 陶瓷锅乐家组","tv_yn":"1","min_mobile_price":null,"presenter_name":"104595,王燕华,11频道,2017-03-29","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/5166/15165166-S.jpg","jl_yn":null,"gift_item":"赠品1：Longaberger瓷烧水壶*1 规格：2L 颜色随机 等级：合格品 赠品2：御煲12头强化瓷中餐具*1套（11.4cm碗*6，小汤匙*6）款式、花型随机 等级：合格品","waiting_qty":null,"groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15146928","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"2.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"293","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"韩国","mobile_price":"293","gift_yn":"0","promo_name":null,"item_name":"[今日特卖]GLASS LOCK 韩国进口 保鲜多功能钢化玻璃容器13件套组","tv_yn":"1","min_mobile_price":null,"presenter_name":"105011,严觅,11频道,2017-02-20|105011,严觅,11频道,2017-02-20|105011,严觅,12频道,2017-02-20|105011,严觅,11频道,2017-02-20|105011,严觅,12频道,2017-02-20","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/14/6928/15146928-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15168744","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"24.88","trade_yn":"0","promo_end_date":null,"last_sale_price":"2483","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"2483","gift_yn":"0","promo_name":null,"item_name":"[庆生大直播]双立人 TWIN Gourmet 食分心动中式炒锅套装","tv_yn":"1","min_mobile_price":null,"presenter_name":"102091,胡忆菡,11频道,2017-04-02|102091,胡忆菡,11频道,2017-04-02","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/8744/15168744-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":null,"groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15150685","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"39.88","trade_yn":"0","promo_end_date":null,"last_sale_price":"3983","shop_url":null,"stock_qty":"109","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"3983","gift_yn":"1","promo_name":null,"item_name":"玛戈隆特 西湖盛宴精美骨瓷餐具 家宴尊享套组 32头","tv_yn":"1","min_mobile_price":null,"presenter_name":"105348,杨柳,11频道,2017-05-06","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/15/0685/15150685-S.jpg","jl_yn":null,"gift_item":"西湖盛宴 桥+高脚味碟 （ 35.5cm*8cm*5cm桥梁底托1件、 8.5cm*6.5cm高脚味碟4件、 8cm高脚味碟盖子4件","waiting_qty":"84","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"3988"},{"item_code":"15169058","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"11.8","trade_yn":"0","promo_end_date":null,"last_sale_price":"1175","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"日本","mobile_price":"1175","gift_yn":"0","promo_name":null,"item_name":"[庆生大直播]珍珠生活 33cm中式铁锅套组","tv_yn":"1","min_mobile_price":null,"presenter_name":"105348,杨柳,11频道,2017-04-04|105348,杨柳,11频道,2017-04-04","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/9058/15169058-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15160493","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"9.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"993","shop_url":null,"stock_qty":"34","groupbuy_pro_end_date":null,"origin_name":"中国/法国","mobile_price":"993","gift_yn":"1","promo_name":null,"item_name":"康宁 晶彩透明锅升级装(贺岁献礼)","tv_yn":"1","min_mobile_price":null,"presenter_name":"102278,王姣姣,11频道,2017-01-10","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/0493/15160493-S.jpg","jl_yn":null,"gift_item":"Pyrex餐具12件组*1（含500ml带耳碗*4 型号：514180M/CN，19.5cm汤盘*4 型号：512950M/CN，23cm汤盘*4 型号：514890M/CN） 型号：OV12/CN 材质：耐热玻璃","waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15159036","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"19.8","trade_yn":"0","promo_end_date":null,"last_sale_price":"1975","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"1975","gift_yn":"0","promo_name":null,"item_name":"红玫瑰 盛世华庭 世博之星浮雕骨瓷高档餐具 40头（豪礼限量加赠）","tv_yn":"1","min_mobile_price":null,"presenter_name":"103830,任燕,11频道,2017-03-06","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/15/9036/15159036-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15161122","server_time":"2017-06-13 18:23:35:511","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"9.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"993","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"日本/中国","mobile_price":"993","gift_yn":"0","promo_name":null,"item_name":"康宁 晶钻锅餐具组合","tv_yn":"1","min_mobile_price":null,"presenter_name":"104595,王燕华,11频道,2017-03-09","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/1122/15161122-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15166141","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"8.99","trade_yn":"0","promo_end_date":null,"last_sale_price":"894","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"西班牙/中国","mobile_price":"894","gift_yn":"1","promo_name":null,"item_name":"欧洛雷(Oroley) 煎炒不粘锅焕新组","tv_yn":"1","min_mobile_price":null,"presenter_name":"101156,林奕扬,11频道,2017-03-12","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/6141/15166141-S.jpg","jl_yn":null,"gift_item":"赠品1：OROLEY硅胶铲（9.4*33cm 颜色随机） 赠品2：欧洛雷铸铁锅*1 规格：20cm，容量2.7L","waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15133138","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"11.94","trade_yn":"0","promo_end_date":null,"last_sale_price":"393","shop_url":null,"stock_qty":"11","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"393","gift_yn":"1","promo_name":null,"item_name":"泰福高(TAFUCO) 欢聚一堂6件套","tv_yn":"1","min_mobile_price":null,"presenter_name":null,"waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/13/3138/15133138-S.jpg","jl_yn":null,"gift_item":"泰福高不锈钢保温杯0.3L*1(颜色随机，粉色或蓝色） 材 质： <瓶体>:不锈钢 食品接触用不锈钢：奥氏体不锈钢06cr19ni10 <上盖>:聚丙烯树脂 <饮水口>：聚丙烯树脂 <密封圈>：硅胶树脂","waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15156662","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"9.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"993","shop_url":null,"stock_qty":"15","groupbuy_pro_end_date":null,"origin_name":"法国/美国","mobile_price":"993","gift_yn":"1","promo_name":null,"item_name":"[迎新专享]康宁 透明锅新年感恩装","tv_yn":"1","min_mobile_price":null,"presenter_name":"102091,胡忆菡,11频道,2017-01-19|105011,严觅,12频道,2017-01-19|105011,严觅,11频道,2017-01-19|102091,胡忆菡,12频道,2017-01-19|102091,胡忆菡,11频道,2017-01-19|102091,胡忆菡,12频道,2017-01-19","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/15/6662/15156662-S.jpg","jl_yn":null,"gift_item":"赠品1：康宁晶彩透明锅2.8L双耳煮锅 型号：VS-28-FL 赠品2：康宁晶彩透明锅1.2L双耳煮锅 型号：VS-12-FL 赠品3：康宁餐具snoopy 6件组 型号： 6-SNOOPY/CN（21.5cm分割盘*2,17cm平盘*2，15.5cm小汤碗*2）","waiting_qty":null,"groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15163374","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"9.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"993","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"法国/美国","mobile_price":"993","gift_yn":"0","promo_name":null,"item_name":"康宁 透明锅新年感恩装","tv_yn":"1","min_mobile_price":null,"presenter_name":"105348,杨柳,11频道,2017-02-18","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/3374/15163374-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15118329","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"11.94","trade_yn":"0","promo_end_date":null,"last_sale_price":"393","shop_url":null,"stock_qty":"22","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"393","gift_yn":"1","promo_name":null,"item_name":"美国康铂氏(keepeez) 魔力真空保鲜盖 全新炫彩升级套组（15+3倾情加赠）","tv_yn":"1","min_mobile_price":null,"presenter_name":"102091,胡忆菡,11频道,2017-01-31","waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/11/8329/15118329S.jpg","jl_yn":null,"gift_item":"PressDome食品用真空保鲜罩19cm*7.5cm(直径*高)(高罩子DISCO-R192mm)*1 PressDome食品用真空保鲜罩19cm*5.75cm(直径*高)(矮罩子DISCO-R192mm)*1 PressDome食品用真空保鲜罩25cm*9.5cm(直径*高)(高罩子DISCO-R252mm)*1","waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15141508","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"3.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"393","shop_url":null,"stock_qty":"48","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"393","gift_yn":"1","promo_name":null,"item_name":"樱之歌 韩式手绘釉下彩餐具锅具回馈套组","tv_yn":"1","min_mobile_price":null,"presenter_name":"102136,王惟甲,11频道,2017-01-03","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/14/1508/15141508-S.jpg","jl_yn":null,"gift_item":"赠品1: 樱之歌1L煲仔锅*1 (材质：陶土) 赠品2: 樱之歌4L直火汤锅*1 (材质：陶土)","waiting_qty":null,"groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15138812","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"5.98","trade_yn":"0","promo_end_date":null,"last_sale_price":"593","shop_url":null,"stock_qty":"35","groupbuy_pro_end_date":null,"origin_name":"法国","mobile_price":"593","gift_yn":"1","promo_name":null,"item_name":"乐美雅 乐享生活大满贯套组","tv_yn":"1","min_mobile_price":null,"presenter_name":null,"waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/13/8812/15138812-S.jpg","jl_yn":null,"gift_item":"赠品：乐美雅海岸线钢化壶5件套*1 （含壶1000ml*1,杯250ml*4 )颜色：糖果粉 材质：壶盖-聚丙烯/防护套-硅胶/主体-玻璃；单壶重约680g，单杯重约195g","waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15145564","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"12.99","trade_yn":"0","promo_end_date":null,"last_sale_price":"1294","shop_url":null,"stock_qty":"20","groupbuy_pro_end_date":null,"origin_name":"美国","mobile_price":"1294","gift_yn":"1","promo_name":null,"item_name":"美国进口康宁 如意蓝莲8人份餐具 季节限定 特惠套组","tv_yn":"1","min_mobile_price":null,"presenter_name":null,"waiting_yn":"1","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/14/5564/15145564-S.jpg","jl_yn":null,"gift_item":"赠品1：康宁2.25L双耳煮锅（P-22）*1 赠品2：康宁20cm玻璃蒸格（VSM-20）*1材质：耐热玻璃 赠品3：WORLD KITCHEN芝加哥刀具摩登波尔多红系列3件组（果蔬刀*1、厨师刀*1、中式片刀*1）型号：CC-MBS3PCS/CN 材质：食品接触用不锈钢X50CrMoV15，ABS，TPR 赠品4：Snapware Pyrex四面锁扣保鲜盒6件组（圆形400ml*2,圆形620ml*2，正方形520ml*2）型号: SP-6EP465RSLN/CN 材质：耐热玻璃/PP/硅胶","waiting_qty":"0","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15165354","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"28.88","trade_yn":"0","promo_end_date":null,"last_sale_price":"2883","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"2883","gift_yn":"0","promo_name":null,"item_name":"双立人 TruClad美食品格锅具套组","tv_yn":"1","min_mobile_price":null,"presenter_name":"102091,胡忆菡,12频道,2017-03-18","waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/5354/15165354-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":null,"groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"},{"item_code":"15164309","server_time":"2017-06-13 18:23:35:512","groupbuy_yn":"0","item_ven":null,"max_mobile_price":null,"promo_start_date":null,"saveamt":"6","trade_yn":"0","promo_end_date":null,"last_sale_price":"195","shop_url":null,"stock_qty":"0","groupbuy_pro_end_date":null,"origin_name":"中国","mobile_price":"195","gift_yn":"0","promo_name":null,"item_name":"贴易固 神奇无痕挂钩超值回馈组（17+29+10）[全国栏目专享]","tv_yn":"1","min_mobile_price":null,"presenter_name":null,"waiting_yn":"0","shop_name":null,"item_url":"https://www.ocj.com.cn/item_images/item/15/16/4309/15164309-S.jpg","jl_yn":null,"gift_item":null,"waiting_qty":"270","groupbuy_pro_start_date":null,"kjt_yn":"0","pro_yn":"0","cust_price":"0"}]
     * moreCate : ["进口食品","牛乳钙、液体钙、钙片","进口保健品","医药保健","中老年养身组","蜂蜜、蜂胶","左旋肉碱","深海鱼油","鱼肝油","维生素","葡萄籽","高丽参","燕窝","其他","酵素","蓟类","女士保健","传统滋养","服饰","女式蕾丝衫、女雪纺衫、女真丝衫","女上衣","女装","女外套","厨房用具","煲、砂锅、炖锅","烹饪锅具","玻璃锅、透明锅","不锈钢锅","压力锅","小奶锅","透明锅","平底锅","不粘锅","蒸锅","汤锅","煎锅","炒锅","个护化妆","电子美容仪","美容护理仪器/工具","洗护工具","美容仪","美妆工具","彩妆","家装建材","厨房龙头","厨房装修","家具","沙发","客厅家具","大小家电","电水壶","厨房小家电","饮水机","水设备","焖烧壶","水具","水/酒/茶具","焖烧杯","保温壶","餐具","碗套装","保鲜盒、保鲜碗","空气炸锅","电烤箱","家居、家饰","衣架衣罩","衣物收纳","收纳用品","收纳洗晒","洗晒用品","清洁剂、清洁液","洗洁精、清洁剂、洗涤剂","家庭清洁","纸品、清洁","洗洁精","洗涤剂","水精灵","柔顺剂、柔软剂、柔顺喷雾","衣物清洁","除菌消毒液、喷雾","女士内衣洗衣液","衣物洗护组合","地板清洁精油","熨衣上浆液","馨之屋水精灵","空气清新剂","管道清洁剂","富培美水精灵","洗衣凝珠","洗衣酵素","洗衣皂","洗衣液","洗衣粉","洗手液","苏打","吸尘器","生活小家电","清洁工具","生活大家电","铸铁锅","吸顶灯","灯具灯饰","即热式热水器","厨卫大家电","康宁餐具套装","婚庆餐具","儿童餐具","餐具套装","密封罐","调料盒","筷子","碗","料理机/料理棒","红木家具","热销","女春秋外套","女式大衣","床品套件","床上用品","座钟","钟","杂物收纳","收纳柜","烟灶套餐","油烟机","煤气灶","蚕丝被","被子","羽绒被","清洗机","拖把","被套","床品单件","电压力锅","电饭煲","生鲜","牛腩牛肋骨组合","牛肉","猪牛羊肉","牛腱牛肋骨组合","牛仔骨牛尾组合","牛筋牛肋条组合","牛腩牛腱组合","牛腩牛尾组合","牛腱牛筋组合","牛羊肉卷组合","涮肉","牛尾牛腱组合","牛尾牛筋组合","牛筋牛腱组合","猪大排组合","猪肉","猪肉组合","五花肉片","牛羊肉串","牛肉组合","猪小排","猪颈肉","羊腿肉","羊肉","羊肉块","牛仔骨","牛肉糜","牛肉块","牛肉卷","牛肋骨","猪肘","猪蹄","羊排","蹄髈","牛腩","牛腱","牛尾","牛排","牛筋","肋排","火腿","大排","牛皮床","床","卧室","餐桌椅组合","餐桌/椅","餐厅家具","消毒柜","洗碗机","保温杯","仿羊羔绒床垫","床垫/床褥","羊毛床垫","乳胶床垫","记忆床垫","鹅绒床垫","雨伞雨具","生活日用","遮阳伞","户外家具","微波炉、光波炉","蒸汽炉","电暖宝、暖宝宝","保暖降温","退热贴","汤婆子","驱虫防虫","收纳层架","挂钩粘钩","置物架","厨房收纳","果盘/果碟","修脚器","手足护理","身体护理","美体仪器","咖啡机","电热毯","取暖电器","晾衣架、晾衣杆","电动晾衣架","家用五金","五金工具","围巾","配饰","披肩","方巾"]
     */

    private int totalCnt;
    private String searchItem;
    private int pageSize;
    private Object tjlist;
    private List<SxlistBean> sxlist;
    private List<BrandinfoBean> brandinfo;
    private List<RegionBean> regionlist;
    private List<String> morekey;
    private List<ResultStrBean> resultStr;
    private List<String> moreCate;

    public List<RegionBean> getRegionlist() {
        return regionlist;
    }

    public void setRegionlist(List<RegionBean> regionlist) {
        this.regionlist = regionlist;
    }

    public int getTotalCnt() {
        return totalCnt;
    }

    public void setTotalCnt(int totalCnt) {
        this.totalCnt = totalCnt;
    }

    public String getSearchItem() {
        return searchItem;
    }

    public void setSearchItem(String searchItem) {
        this.searchItem = searchItem;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public Object getTjlist() {
        return tjlist;
    }

    public void setTjlist(Object tjlist) {
        this.tjlist = tjlist;
    }

    public List<SxlistBean> getSxlist() {
        return sxlist;
    }

    public void setSxlist(List<SxlistBean> sxlist) {
        this.sxlist = sxlist;
    }

    public List<BrandinfoBean> getBrandinfo() {
        return brandinfo;
    }

    public void setBrandinfo(List<BrandinfoBean> brandinfo) {
        this.brandinfo = brandinfo;
    }

    public List<String> getMorekey() {
        return morekey;
    }

    public void setMorekey(List<String> morekey) {
        this.morekey = morekey;
    }

    public List<ResultStrBean> getResultStr() {
        return resultStr;
    }

    public void setResultStr(List<ResultStrBean> resultStr) {
        this.resultStr = resultStr;
    }

    public List<String> getMoreCate() {
        return moreCate;
    }

    public void setMoreCate(List<String> moreCate) {
        this.moreCate = moreCate;
    }

    public static class SxlistBean {
        /**
         * propertyName : 分类
         * propertyValue : ["厨房用具","餐具","烹饪锅具","整套茶具","保鲜盒、保鲜碗","茶杯","功夫茶具","其他","茶盘/茶台","酒具套件","水/酒/茶具","厨房收纳"]
         */

        private String propertyName;
        private List<String> propertyValue;

        public String getPropertyName() {
            return propertyName;
        }

        public void setPropertyName(String propertyName) {
            this.propertyName = propertyName;
        }

        public List<String> getPropertyValue() {
            return propertyValue;
        }

        public void setPropertyValue(List<String> propertyValue) {
            this.propertyValue = propertyValue;
        }
    }

    public static class BrandinfoBean {
        /**
         * propertyName : 0351600
         * propertyValue : ["库格(KUGEL)"]
         */

        private String propertyName;
        private List<String> propertyValue;

        public String getPropertyName() {
            return propertyName;
        }

        public void setPropertyName(String propertyName) {
            this.propertyName = propertyName;
        }

        public List<String> getPropertyValue() {
            return propertyValue;
        }

        public void setPropertyValue(List<String> propertyValue) {
            this.propertyValue = propertyValue;
        }
    }

    public static class RegionBean {
        private String region_name;//: "日本",
        private String region_code;//: "0081"

        public String getRegion_name() {
            return region_name;
        }

        public void setRegion_name(String region_name) {
            this.region_name = region_name;
        }

        public String getRegion_code() {
            return region_code;
        }

        public void setRegion_code(String region_code) {
            this.region_code = region_code;
        }
    }

    public static class ResultStrBean {
        /**
         * item_code : 15166151
         * server_time : 2017-06-13 18:23:35:511
         * groupbuy_yn : 0
         * item_ven : null
         * max_mobile_price : null
         * promo_start_date : null
         * saveamt : 2.98
         * trade_yn : 0
         * promo_end_date : null
         * last_sale_price : 293
         * shop_url : null
         * stock_qty : 0
         * groupbuy_pro_end_date : null
         * origin_name : 韩国
         * mobile_price : 293
         * gift_yn : 0
         * promo_name : null
         * item_name : KUGEL 炫彩系列30CM不粘炒锅劲爆加赠组
         * tv_yn : 1
         * min_mobile_price : null
         * presenter_name : 104619,童鑫,12频道,2017-04-24
         * waiting_yn : 1
         * shop_name : null
         * item_url : https://www.ocj.com.cn/item_images/item/15/16/6151/15166151-S.jpg
         * jl_yn : null
         * gift_item : null
         * waiting_qty : 0
         * groupbuy_pro_start_date : null
         * kjt_yn : 0
         * pro_yn : 0
         * cust_price : 0
         * three_month_saleqty : 10951
         */

        private String item_code;
        private String server_time;
        private String groupbuy_yn;
        private Object item_ven;
        private Object max_mobile_price;
        private Object promo_start_date;
        private String saveamt;
        private String trade_yn;
        private Object promo_end_date;
        private String last_sale_price;
        private Object shop_url;
        private String stock_qty;
        private Object groupbuy_pro_end_date;
        private String origin_name;
        private String mobile_price;
        private String gift_yn;
        private Object promo_name;
        private String item_name;
        private String tv_yn;
        private Object min_mobile_price;
        private String presenter_name;
        private String waiting_yn;
        private Object shop_name;
        private String item_url;
        private Object jl_yn;
        private Object gift_item;
        private String waiting_qty;
        private Object groupbuy_pro_start_date;
        private String kjt_yn;
        private String pro_yn;
        private String cust_price;
        private String three_month_saleqty;

        public String getItem_code() {
            return item_code;
        }

        public void setItem_code(String item_code) {
            this.item_code = item_code;
        }

        public String getServer_time() {
            return server_time;
        }

        public void setServer_time(String server_time) {
            this.server_time = server_time;
        }

        public String getGroupbuy_yn() {
            return groupbuy_yn;
        }

        public void setGroupbuy_yn(String groupbuy_yn) {
            this.groupbuy_yn = groupbuy_yn;
        }

        public Object getItem_ven() {
            return item_ven;
        }

        public void setItem_ven(Object item_ven) {
            this.item_ven = item_ven;
        }

        public Object getMax_mobile_price() {
            return max_mobile_price;
        }

        public void setMax_mobile_price(Object max_mobile_price) {
            this.max_mobile_price = max_mobile_price;
        }

        public Object getPromo_start_date() {
            return promo_start_date;
        }

        public void setPromo_start_date(Object promo_start_date) {
            this.promo_start_date = promo_start_date;
        }

        public String getSaveamt() {
            return saveamt;
        }

        public void setSaveamt(String saveamt) {
            this.saveamt = saveamt;
        }

        public String getTrade_yn() {
            return trade_yn;
        }

        public void setTrade_yn(String trade_yn) {
            this.trade_yn = trade_yn;
        }

        public Object getPromo_end_date() {
            return promo_end_date;
        }

        public void setPromo_end_date(Object promo_end_date) {
            this.promo_end_date = promo_end_date;
        }

        public String getLast_sale_price() {
            return last_sale_price;
        }

        public void setLast_sale_price(String last_sale_price) {
            this.last_sale_price = last_sale_price;
        }

        public Object getShop_url() {
            return shop_url;
        }

        public void setShop_url(Object shop_url) {
            this.shop_url = shop_url;
        }

        public String getStock_qty() {
            return stock_qty;
        }

        public void setStock_qty(String stock_qty) {
            this.stock_qty = stock_qty;
        }

        public Object getGroupbuy_pro_end_date() {
            return groupbuy_pro_end_date;
        }

        public void setGroupbuy_pro_end_date(Object groupbuy_pro_end_date) {
            this.groupbuy_pro_end_date = groupbuy_pro_end_date;
        }

        public String getOrigin_name() {
            return origin_name;
        }

        public void setOrigin_name(String origin_name) {
            this.origin_name = origin_name;
        }

        public String getMobile_price() {
            return mobile_price;
        }

        public void setMobile_price(String mobile_price) {
            this.mobile_price = mobile_price;
        }

        public String getGift_yn() {
            return gift_yn;
        }

        public void setGift_yn(String gift_yn) {
            this.gift_yn = gift_yn;
        }

        public Object getPromo_name() {
            return promo_name;
        }

        public void setPromo_name(Object promo_name) {
            this.promo_name = promo_name;
        }

        public String getItem_name() {
            return item_name;
        }

        public void setItem_name(String item_name) {
            this.item_name = item_name;
        }

        public String getTv_yn() {
            return tv_yn;
        }

        public void setTv_yn(String tv_yn) {
            this.tv_yn = tv_yn;
        }

        public Object getMin_mobile_price() {
            return min_mobile_price;
        }

        public void setMin_mobile_price(Object min_mobile_price) {
            this.min_mobile_price = min_mobile_price;
        }

        public String getPresenter_name() {
            return presenter_name;
        }

        public void setPresenter_name(String presenter_name) {
            this.presenter_name = presenter_name;
        }

        public String getWaiting_yn() {
            return waiting_yn;
        }

        public void setWaiting_yn(String waiting_yn) {
            this.waiting_yn = waiting_yn;
        }

        public Object getShop_name() {
            return shop_name;
        }

        public void setShop_name(Object shop_name) {
            this.shop_name = shop_name;
        }

        public String getItem_url() {
            return item_url;
        }

        public void setItem_url(String item_url) {
            this.item_url = item_url;
        }

        public Object getJl_yn() {
            return jl_yn;
        }

        public void setJl_yn(Object jl_yn) {
            this.jl_yn = jl_yn;
        }

        public Object getGift_item() {
            return gift_item;
        }

        public void setGift_item(Object gift_item) {
            this.gift_item = gift_item;
        }

        public String getWaiting_qty() {
            return waiting_qty;
        }

        public void setWaiting_qty(String waiting_qty) {
            this.waiting_qty = waiting_qty;
        }

        public Object getGroupbuy_pro_start_date() {
            return groupbuy_pro_start_date;
        }

        public void setGroupbuy_pro_start_date(Object groupbuy_pro_start_date) {
            this.groupbuy_pro_start_date = groupbuy_pro_start_date;
        }

        public String getKjt_yn() {
            return kjt_yn;
        }

        public void setKjt_yn(String kjt_yn) {
            this.kjt_yn = kjt_yn;
        }

        public String getPro_yn() {
            return pro_yn;
        }

        public void setPro_yn(String pro_yn) {
            this.pro_yn = pro_yn;
        }

        public String getCust_price() {
            return cust_price;
        }

        public void setCust_price(String cust_price) {
            this.cust_price = cust_price;
        }

        public String getThree_month_saleqty() {
            return three_month_saleqty;
        }

        public void setThree_month_saleqty(String three_month_saleqty) {
            this.three_month_saleqty = three_month_saleqty;
        }
    }
}
