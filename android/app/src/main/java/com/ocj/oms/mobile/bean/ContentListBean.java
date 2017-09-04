package com.ocj.oms.mobile.bean;

import com.google.gson.annotations.SerializedName;

import java.util.Date;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/12 14:09
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class ContentListBean {
    /**
     * item_code : null
     * dc_gb : null
     * dc_rate : 0
     * dc_amt : 0
     * promo_last_name : null
     * last_sale_price : 0
     * save_amt : 0
     * saveamt_rate : 0
     * saveamt_extra : 0
     * saveamt_org : 0
     * dccoupon_no : null
     * co_dc : 0
     * co_end_date : null
     * gift_item_code : null
     * promo_save_gb : null
     * promo_dc_gb : null
     * promo_dc_amt : 0
     * norest_allot_month : null
     * sale_price_month : 0
     * dfQty : 0
     * inter_attrb_type : null
     * order_poss_qty : null
     * reserve_qty : null
     * video_yn : 0
     * yintai_yn : 0
     * toysrus_yn : 0
     * merge_yn : null
     * merge_type : null
     * sale_price_kr : 0
     * item_name_kr : null
     * dccoupon_min_ten : null
     * two_piece_off : null
     * hiokr_yn : null
     * promo_fixed_price : 0
     * car_price : null
     * services_yn : null
     * custom_yn : null
     * custom_gb : null
     * saveamt_st : 0
     * showCart_yn : 1
     * showCartQty_yn : 0
     * is_ljlj : null
     * is_zhg : null
     * is_tuan : null
     * is_kr : null
     * is_food : null
     * is_tv : null
     * is_brand_tuan : null
     * brand_tuan_url : null
     * prepay_yn : null
     * internet_att_type : null
     * seq_shop_num : 8752
     * seq_temp_num : 0
     * seq_temp_corner_num : 0
     * set_num : 0
     * promom_jf : null
     * promom_dz : null
     * promom_zp : null
     * set_nm : null
     * set_img_path_nm : null
     * set_img_file_nm : null
     * disp_link : null
     * shop_corner_img_file_nm : null
     * shop_corner_img_path_nm : null
     * contentList : null
     * totalcnt : 0
     * seq_content_num : 1
     * seq_temp_corner_tgt_num : 12729
     * corner_tgt_order : 0
     * o_item_qty : 0
     * site_cd : null
     * content_nm : null
     * conts_path_nm : /image_site/shop/conts/8752/7581/10910/12729/
     * conts_file_nm : 1_20170110150021_16.png
     * conts_type_cd : null
     * conts_title_nm : null
     * conts_tgt_num : null
     * conts_title_style : null
     * disp_tgt_cd : 02
     * conts_desc : VIP礼包
     * conts_desc1 : null
     * conts_desc2 : null
     * html_desc : null
     * connect_type_cd : 4
     * connect_tgt_addr : http://m.ocj.com.cn/image_site/event/eventitem/vip/privilege.html#p0
     * connect_tgt_addr_new : null
     * disp_conts_num : 1
     * alt_desc : VIP礼包
     * disp_area_cd : 8752_7581_10910_12729_1
     * disp_end_dt : null
     * disp_start_dt : null
     * disp_pri_order : 0
     * dccoupon_info : null
     * contentLink : http://m.ocj.com.cn/image_site/event/eventitem/vip/privilege.html#p0
     * web_desc : null
     * bold_yn : null
     * under_line_yn : null
     * font_color : null
     * tag5_yn : null
     * dis_diagram_cd : null
     * co_titem_end_cnt : 0
     * qty : null
     * max_qty : 0
     * cnt : null
     * isOnday : null
     * bestNew : null
     * morefree : null
     * flag : null
     * sitem_code : null
     * item_name : null
     * brand_code : null
     * brand_name : null
     * brand_url : null
     * cust_price : 0
     * item_price : 0
     * sale_price : 0
     * co_titem_cnt : 0
     * co_copurchase_no : null
     * origin_name : null
     * tv_yn : null
     * best_item_yn : null
     * new_item_yn : null
     * subside_yn : null
     * tag_type : null
     * tag_txt : null
     * tag_img_path : null
     * tag_img_name : null
     * tag_img_link : null
     * region_cd : 2000
     * sub_cd : null
     * msale_code : null
     * isYinTai : null
     * isTeHui : null
     * isSmg : null
     * conts_Title : null
     * interest_count : 0
     * cntStar : 0
     * opoint_num : 0
     * gift_gb : null
     * prom_dc_gb : null
     * cost_total : 0
     * prom_total : 0
     * isOuTuan : null
     * isTvWarn : null
     * waiting_yn : null
     * internet_yn : null
     * sale_gb : null
     * sign_gb : null
     * item_qty : 0
     * limit_qty : 0
     * o_limit_qty : 0
     * o_item_desc : null
     * brandFlag : null
     * item_ven_code : null
     * o_pass_qty : 0
     * genuine_product_yn : null
     * lin_bao : null
     * linbao_yn : null
     * linbao_date : null
     * omsitemqty : 0
     * kjt_yn : null
     * oversea_yn : null
     * sc_yn : null
     * globalbuy_yn : 0
     * grade_value : null
     * draw_num : null
     * event_no : null
     * picVoteEvt : null
     * lgroup : null
     * trade_type : null
     * domain_id : null
     * contentImage : http://image1.ocj.com.cn/image_site/shop/conts/8752/7581/10910/12729/1_20170110150021_16.png
     * item_image : null
     * time : 0
     * qtyState : 0
     */


    private String item_code;//商品编号
    private String dc_gb;//折扣状态
    private double dc_rate;//折扣率
    private double dc_amt;//折扣价
    private String promo_last_name;//促销名称
    private double last_sale_price;//促销价
    private double save_amt;//积分
    private double saveamt_rate;//积分金额
    private double saveamt_extra;//加赠积分
    private double saveamt_org;//商品（原始）积分
    private String dccoupon_no;//折扣券编号
    private double co_dc;//otuan折扣率
    private Date co_end_date;//折扣券结束日期
    private String gift_item_code;//赠品开关：1-有赠品
    private String promo_save_gb;//右上角积分角标开关
    private String promo_dc_gb;//促销状态
    private double promo_dc_amt;//促销降价)
    private String norest_allot_month;//分期数, 商品列表不显示
    private double sale_price_month;//分期月供, 商品列表不显示
    private int dfQty;//dfQty(免费配送的订购件数).
    private String inter_attrb_type;
    private String order_poss_qty;
    private String reserve_qty;
    private int video_yn;
    private int yintai_yn;
    private int toysrus_yn;///**是否是玩具城的商品*/
    private String merge_yn;//是否是合包装
    private String merge_type;//合包装类型
    private double sale_price_kr;//韩币
    private String item_name_kr;//韩文商品名
    private String dccoupon_min_ten;//立减十元icon
    private String two_piece_off; //两件立减
    private String hiokr_yn; //韩国馆商品
    private int promo_fixed_price;//KR一口价标识
    private String car_price;//汽车类商品售价
    private String services_yn;//是否服务类商品
    private String custom_yn;//是否定制类商品
    private String custom_gb;//是否定制类商品
    private double saveamt_st;//积分风暴
    private int showCart_yn = 1;//是否显示购物车
    private int showCartQty_yn = 0;//是否控制修改购买数量
    private String is_ljlj;//手机标签
    private String is_zhg;//手机标签
    private String is_tuan;//手机标签
    private String is_kr;//手机标签
    private String is_food;//手机标签
    private String is_tv;//手机标签
    private String is_brand_tuan;//手机标签
    private String brand_tuan_url;//品牌团链接
    private String prepay_yn;// 是否货到付款标志
    private String internet_att_type;//判断目录商品是否为目录团购

    private int seq_shop_num;
    private int seq_temp_num;
    private int seq_temp_corner_num;
    private int set_num;
    private String promom_jf;//积分促销名称
    private String promom_dz;//打折促销名称
    private String promom_zp;//赠品促销名称
    private String set_nm;
    private String set_img_path_nm;//(set 图片路径)
    private String set_img_file_nm;//t图片文件名
    private String disp_link;
    private String shop_corner_img_file_nm;
    private String shop_corner_img_path_nm;
    private Object contentList;
    private int totalcnt;

    private int seq_content_num;
    private int seq_temp_corner_tgt_num;
    private int corner_tgt_order;
    private int o_item_qty;
    private String site_cd;//地区号
    private String content_nm;
    private String conts_path_nm;//图片路径)
    private String conts_file_nm;//图片名
    private String conts_type_cd;
    private String conts_title_nm;
    private String conts_tgt_num;
    private String conts_title_style;
    private String disp_tgt_cd;
    private String conts_desc;
    private String conts_desc1;
    private String conts_desc2;
    private String html_desc;
    private String connect_type_cd;
    private String connect_tgt_addr;
    private String connect_tgt_addr_new;
    private int disp_conts_num;

    private String alt_desc;
    private String disp_area_cd;
    private String disp_end_dt;
    private String disp_start_dt;

    private int disp_pri_order;
    private String dccoupon_info;
    private String contentLink;
    private String web_desc;
    private String bold_yn;
    private String under_line_yn;
    private String font_color;
    private String tag5_yn;
    private String dis_diagram_cd;
    private String co_titem_end_cnt;
    /* 以下用于海鸥团，vicky添加 */
    private Integer qty;// 库存
    private String max_qty;// 限量
    private Integer cnt;// 关注人数
    private Boolean isOnday;// 限时一天
    private Boolean bestNew;// 今日最新
    private Boolean morefree;// 多件再省
    private String flag;// 区分各种角标
    private String sitem_code;
    private String item_name;//商品名称
    private String brand_code;
    private String brand_name;
    private String brand_url;

    private double cust_price;//市场价
    private double item_price;//销售价
    private double sale_price;
    private int co_titem_cnt;
    private String co_copurchase_no;
    private String origin_name;
    private String tv_yn;//左上角TV角标开关
    private String best_item_yn;//左下角best角标开关
    private String new_item_yn;//左下角new角标开关
    private String subside_yn;
    private String tag_type;
    private String tag_txt;
    private String tag_img_path;
    private String tag_img_name;
    private String tag_img_link;
    private String region_cd;//地区号
    private String sub_cd;//分站号
    private String msale_code;//销售通道
    @SerializedName("TotalCnt")
    //private Integer totalcnt;//商品评论
    private Boolean isYinTai;//银泰百货
    private Boolean isTeHui;//限时特惠
    private Boolean isSmg;
    private String conts_Title;// 团购商品描述

    private int interest_count;
    private int cntStar;
    private int opoint_num;
    private String gift_gb;//销类型：01-积分/02-赠品/03-打折
    private String prom_dc_gb;//打折类型区分：金额/比率(10-金额，20-比率
    private double cost_total;//寿星价：折扣金额/比率
    private double prom_total;//折扣金额/比率
    /* 鸥点商城红利专区属性 end */
    private String isOuTuan;// 是否鸥团商品
    private String isTvWarn;// 是否定制了播出提醒
    private String waiting_yn;// 等待入库
    private String internet_yn;
    private String sale_gb;
    private String sign_gb;
    private int item_qty; // 商品库存
    private int limit_qty;  // 限量
    private int o_limit_qty;
    private String o_item_desc;
    private String brandFlag;// 品牌团标签
    private String item_ven_code;// 供货商编号
    private int o_pass_qty;// 商品库存
  /*  private String merge_yn;//是否是合包装
    private String merge_type;//合包装类型*/
    private String genuine_product_yn; // 是否正品保障 0=否 1=是
    private String lin_bao;// 合包装类型
    private String linbao_yn;
    private String linbao_date;// 临保有效时间
    private String omsitemqty = "0";// 体验馆报名人数， 商品兑换剩余库存
    private String kjt_yn;
    private String oversea_yn;
    private String sc_yn;// 是否商城商品
    private String globalbuy_yn = "0";// 是否全球购商品
  //  private int promo_fixed_price;//KR一口价标识
    private String grade_value;
    private String draw_num;// 鸥券抽奖点数
    private String event_no;// 鸥券抽奖活动编号
    //	private List<PicVoteEvent> picVoteEvt;
    private String lgroup; // 大工业分类号 hujw add
    private String trade_type;// 全球购属性：01直邮；02自贸
    private String domain_id;// OMS跟踪
    private String contentImage;
    private String item_image;

    private int time;
    private String qtyState;

    public String getItem_code() {
        return item_code;
    }

    public void setItem_code(String item_code) {
        this.item_code = item_code;
    }

    public String getDc_gb() {
        return dc_gb;
    }

    public void setDc_gb(String dc_gb) {
        this.dc_gb = dc_gb;
    }

    public double getDc_rate() {
        return dc_rate;
    }

    public void setDc_rate(double dc_rate) {
        this.dc_rate = dc_rate;
    }

    public double getDc_amt() {
        return dc_amt;
    }

    public void setDc_amt(double dc_amt) {
        this.dc_amt = dc_amt;
    }

    public String getPromo_last_name() {
        return promo_last_name;
    }

    public void setPromo_last_name(String promo_last_name) {
        this.promo_last_name = promo_last_name;
    }

    public double getLast_sale_price() {
        return last_sale_price;
    }

    public void setLast_sale_price(double last_sale_price) {
        this.last_sale_price = last_sale_price;
    }

    public double getSave_amt() {
        return save_amt;
    }

    public void setSave_amt(double save_amt) {
        this.save_amt = save_amt;
    }

    public double getSaveamt_rate() {
        return saveamt_rate;
    }

    public void setSaveamt_rate(double saveamt_rate) {
        this.saveamt_rate = saveamt_rate;
    }

    public double getSaveamt_extra() {
        return saveamt_extra;
    }

    public void setSaveamt_extra(double saveamt_extra) {
        this.saveamt_extra = saveamt_extra;
    }

    public double getSaveamt_org() {
        return saveamt_org;
    }

    public void setSaveamt_org(double saveamt_org) {
        this.saveamt_org = saveamt_org;
    }

    public String getDccoupon_no() {
        return dccoupon_no;
    }

    public void setDccoupon_no(String dccoupon_no) {
        this.dccoupon_no = dccoupon_no;
    }

    public double getCo_dc() {
        return co_dc;
    }

    public void setCo_dc(double co_dc) {
        this.co_dc = co_dc;
    }

    public Date getCo_end_date() {
        return co_end_date;
    }

    public void setCo_end_date(Date co_end_date) {
        this.co_end_date = co_end_date;
    }

    public String getGift_item_code() {
        return gift_item_code;
    }

    public void setGift_item_code(String gift_item_code) {
        this.gift_item_code = gift_item_code;
    }

    public String getPromo_save_gb() {
        return promo_save_gb;
    }

    public void setPromo_save_gb(String promo_save_gb) {
        this.promo_save_gb = promo_save_gb;
    }

    public String getPromo_dc_gb() {
        return promo_dc_gb;
    }

    public void setPromo_dc_gb(String promo_dc_gb) {
        this.promo_dc_gb = promo_dc_gb;
    }

    public double getPromo_dc_amt() {
        return promo_dc_amt;
    }

    public void setPromo_dc_amt(double promo_dc_amt) {
        this.promo_dc_amt = promo_dc_amt;
    }

    public String getNorest_allot_month() {
        return norest_allot_month;
    }

    public void setNorest_allot_month(String norest_allot_month) {
        this.norest_allot_month = norest_allot_month;
    }

    public double getSale_price_month() {
        return sale_price_month;
    }

    public void setSale_price_month(double sale_price_month) {
        this.sale_price_month = sale_price_month;
    }

    public int getDfQty() {
        return dfQty;
    }

    public void setDfQty(int dfQty) {
        this.dfQty = dfQty;
    }

    public String getInter_attrb_type() {
        return inter_attrb_type;
    }

    public void setInter_attrb_type(String inter_attrb_type) {
        this.inter_attrb_type = inter_attrb_type;
    }

    public String getOrder_poss_qty() {
        return order_poss_qty;
    }

    public void setOrder_poss_qty(String order_poss_qty) {
        this.order_poss_qty = order_poss_qty;
    }

    public String getReserve_qty() {
        return reserve_qty;
    }

    public void setReserve_qty(String reserve_qty) {
        this.reserve_qty = reserve_qty;
    }

    public int getVideo_yn() {
        return video_yn;
    }

    public void setVideo_yn(int video_yn) {
        this.video_yn = video_yn;
    }

    public int getYintai_yn() {
        return yintai_yn;
    }

    public void setYintai_yn(int yintai_yn) {
        this.yintai_yn = yintai_yn;
    }

    public int getToysrus_yn() {
        return toysrus_yn;
    }

    public void setToysrus_yn(int toysrus_yn) {
        this.toysrus_yn = toysrus_yn;
    }

    public String getMerge_yn() {
        return merge_yn;
    }

    public void setMerge_yn(String merge_yn) {
        this.merge_yn = merge_yn;
    }

    public String getMerge_type() {
        return merge_type;
    }

    public void setMerge_type(String merge_type) {
        this.merge_type = merge_type;
    }

    public double getSale_price_kr() {
        return sale_price_kr;
    }

    public void setSale_price_kr(double sale_price_kr) {
        this.sale_price_kr = sale_price_kr;
    }

    public String getItem_name_kr() {
        return item_name_kr;
    }

    public void setItem_name_kr(String item_name_kr) {
        this.item_name_kr = item_name_kr;
    }

    public String getDccoupon_min_ten() {
        return dccoupon_min_ten;
    }

    public void setDccoupon_min_ten(String dccoupon_min_ten) {
        this.dccoupon_min_ten = dccoupon_min_ten;
    }

    public String getTwo_piece_off() {
        return two_piece_off;
    }

    public void setTwo_piece_off(String two_piece_off) {
        this.two_piece_off = two_piece_off;
    }

    public String getHiokr_yn() {
        return hiokr_yn;
    }

    public void setHiokr_yn(String hiokr_yn) {
        this.hiokr_yn = hiokr_yn;
    }

    public int getPromo_fixed_price() {
        return promo_fixed_price;
    }

    public void setPromo_fixed_price(int promo_fixed_price) {
        this.promo_fixed_price = promo_fixed_price;
    }

    public String getCar_price() {
        return car_price;
    }

    public void setCar_price(String car_price) {
        this.car_price = car_price;
    }

    public String getServices_yn() {
        return services_yn;
    }

    public void setServices_yn(String services_yn) {
        this.services_yn = services_yn;
    }

    public String getCustom_yn() {
        return custom_yn;
    }

    public void setCustom_yn(String custom_yn) {
        this.custom_yn = custom_yn;
    }

    public String getCustom_gb() {
        return custom_gb;
    }

    public void setCustom_gb(String custom_gb) {
        this.custom_gb = custom_gb;
    }

    public double getSaveamt_st() {
        return saveamt_st;
    }

    public void setSaveamt_st(double saveamt_st) {
        this.saveamt_st = saveamt_st;
    }

    public int getShowCart_yn() {
        return showCart_yn;
    }

    public void setShowCart_yn(int showCart_yn) {
        this.showCart_yn = showCart_yn;
    }

    public int getShowCartQty_yn() {
        return showCartQty_yn;
    }

    public void setShowCartQty_yn(int showCartQty_yn) {
        this.showCartQty_yn = showCartQty_yn;
    }

    public String getIs_ljlj() {
        return is_ljlj;
    }

    public void setIs_ljlj(String is_ljlj) {
        this.is_ljlj = is_ljlj;
    }

    public String getIs_zhg() {
        return is_zhg;
    }

    public void setIs_zhg(String is_zhg) {
        this.is_zhg = is_zhg;
    }

    public String getIs_tuan() {
        return is_tuan;
    }

    public void setIs_tuan(String is_tuan) {
        this.is_tuan = is_tuan;
    }

    public String getIs_kr() {
        return is_kr;
    }

    public void setIs_kr(String is_kr) {
        this.is_kr = is_kr;
    }

    public String getIs_food() {
        return is_food;
    }

    public void setIs_food(String is_food) {
        this.is_food = is_food;
    }

    public String getIs_tv() {
        return is_tv;
    }

    public void setIs_tv(String is_tv) {
        this.is_tv = is_tv;
    }

    public String getIs_brand_tuan() {
        return is_brand_tuan;
    }

    public void setIs_brand_tuan(String is_brand_tuan) {
        this.is_brand_tuan = is_brand_tuan;
    }

    public String getBrand_tuan_url() {
        return brand_tuan_url;
    }

    public void setBrand_tuan_url(String brand_tuan_url) {
        this.brand_tuan_url = brand_tuan_url;
    }

    public String getPrepay_yn() {
        return prepay_yn;
    }

    public void setPrepay_yn(String prepay_yn) {
        this.prepay_yn = prepay_yn;
    }

    public String getInternet_att_type() {
        return internet_att_type;
    }

    public void setInternet_att_type(String internet_att_type) {
        this.internet_att_type = internet_att_type;
    }

    public int getSeq_shop_num() {
        return seq_shop_num;
    }

    public void setSeq_shop_num(int seq_shop_num) {
        this.seq_shop_num = seq_shop_num;
    }

    public int getSeq_temp_num() {
        return seq_temp_num;
    }

    public void setSeq_temp_num(int seq_temp_num) {
        this.seq_temp_num = seq_temp_num;
    }

    public int getSeq_temp_corner_num() {
        return seq_temp_corner_num;
    }

    public void setSeq_temp_corner_num(int seq_temp_corner_num) {
        this.seq_temp_corner_num = seq_temp_corner_num;
    }

    public int getSet_num() {
        return set_num;
    }

    public void setSet_num(int set_num) {
        this.set_num = set_num;
    }

    public String getPromom_jf() {
        return promom_jf;
    }

    public void setPromom_jf(String promom_jf) {
        this.promom_jf = promom_jf;
    }

    public String getPromom_dz() {
        return promom_dz;
    }

    public void setPromom_dz(String promom_dz) {
        this.promom_dz = promom_dz;
    }

    public String getPromom_zp() {
        return promom_zp;
    }

    public void setPromom_zp(String promom_zp) {
        this.promom_zp = promom_zp;
    }

    public String getSet_nm() {
        return set_nm;
    }

    public void setSet_nm(String set_nm) {
        this.set_nm = set_nm;
    }

    public String getSet_img_path_nm() {
        return set_img_path_nm;
    }

    public void setSet_img_path_nm(String set_img_path_nm) {
        this.set_img_path_nm = set_img_path_nm;
    }

    public String getSet_img_file_nm() {
        return set_img_file_nm;
    }

    public void setSet_img_file_nm(String set_img_file_nm) {
        this.set_img_file_nm = set_img_file_nm;
    }

    public String getDisp_link() {
        return disp_link;
    }

    public void setDisp_link(String disp_link) {
        this.disp_link = disp_link;
    }

    public String getShop_corner_img_file_nm() {
        return shop_corner_img_file_nm;
    }

    public void setShop_corner_img_file_nm(String shop_corner_img_file_nm) {
        this.shop_corner_img_file_nm = shop_corner_img_file_nm;
    }

    public String getShop_corner_img_path_nm() {
        return shop_corner_img_path_nm;
    }

    public void setShop_corner_img_path_nm(String shop_corner_img_path_nm) {
        this.shop_corner_img_path_nm = shop_corner_img_path_nm;
    }

    public Object getContentList() {
        return contentList;
    }

    public void setContentList(Object contentList) {
        this.contentList = contentList;
    }

    public int getTotalcnt() {
        return totalcnt;
    }

    public void setTotalcnt(int totalcnt) {
        this.totalcnt = totalcnt;
    }

    public int getSeq_content_num() {
        return seq_content_num;
    }

    public void setSeq_content_num(int seq_content_num) {
        this.seq_content_num = seq_content_num;
    }

    public int getSeq_temp_corner_tgt_num() {
        return seq_temp_corner_tgt_num;
    }

    public void setSeq_temp_corner_tgt_num(int seq_temp_corner_tgt_num) {
        this.seq_temp_corner_tgt_num = seq_temp_corner_tgt_num;
    }

    public int getCorner_tgt_order() {
        return corner_tgt_order;
    }

    public void setCorner_tgt_order(int corner_tgt_order) {
        this.corner_tgt_order = corner_tgt_order;
    }

    public int getO_item_qty() {
        return o_item_qty;
    }

    public void setO_item_qty(int o_item_qty) {
        this.o_item_qty = o_item_qty;
    }

    public String getSite_cd() {
        return site_cd;
    }

    public void setSite_cd(String site_cd) {
        this.site_cd = site_cd;
    }

    public String getContent_nm() {
        return content_nm;
    }

    public void setContent_nm(String content_nm) {
        this.content_nm = content_nm;
    }

    public String getConts_path_nm() {
        return conts_path_nm;
    }

    public void setConts_path_nm(String conts_path_nm) {
        this.conts_path_nm = conts_path_nm;
    }

    public String getConts_file_nm() {
        return conts_file_nm;
    }

    public void setConts_file_nm(String conts_file_nm) {
        this.conts_file_nm = conts_file_nm;
    }

    public String getConts_type_cd() {
        return conts_type_cd;
    }

    public void setConts_type_cd(String conts_type_cd) {
        this.conts_type_cd = conts_type_cd;
    }

    public String getConts_title_nm() {
        return conts_title_nm;
    }

    public void setConts_title_nm(String conts_title_nm) {
        this.conts_title_nm = conts_title_nm;
    }

    public String getConts_tgt_num() {
        return conts_tgt_num;
    }

    public void setConts_tgt_num(String conts_tgt_num) {
        this.conts_tgt_num = conts_tgt_num;
    }

    public String getConts_title_style() {
        return conts_title_style;
    }

    public void setConts_title_style(String conts_title_style) {
        this.conts_title_style = conts_title_style;
    }

    public String getDisp_tgt_cd() {
        return disp_tgt_cd;
    }

    public void setDisp_tgt_cd(String disp_tgt_cd) {
        this.disp_tgt_cd = disp_tgt_cd;
    }

    public String getConts_desc() {
        return conts_desc;
    }

    public void setConts_desc(String conts_desc) {
        this.conts_desc = conts_desc;
    }

    public String getConts_desc1() {
        return conts_desc1;
    }

    public void setConts_desc1(String conts_desc1) {
        this.conts_desc1 = conts_desc1;
    }

    public String getConts_desc2() {
        return conts_desc2;
    }

    public void setConts_desc2(String conts_desc2) {
        this.conts_desc2 = conts_desc2;
    }

    public String getHtml_desc() {
        return html_desc;
    }

    public void setHtml_desc(String html_desc) {
        this.html_desc = html_desc;
    }

    public String getConnect_type_cd() {
        return connect_type_cd;
    }

    public void setConnect_type_cd(String connect_type_cd) {
        this.connect_type_cd = connect_type_cd;
    }

    public String getConnect_tgt_addr() {
        return connect_tgt_addr;
    }

    public void setConnect_tgt_addr(String connect_tgt_addr) {
        this.connect_tgt_addr = connect_tgt_addr;
    }

    public String getConnect_tgt_addr_new() {
        return connect_tgt_addr_new;
    }

    public void setConnect_tgt_addr_new(String connect_tgt_addr_new) {
        this.connect_tgt_addr_new = connect_tgt_addr_new;
    }

    public int getDisp_conts_num() {
        return disp_conts_num;
    }

    public void setDisp_conts_num(int disp_conts_num) {
        this.disp_conts_num = disp_conts_num;
    }

    public String getAlt_desc() {
        return alt_desc;
    }

    public void setAlt_desc(String alt_desc) {
        this.alt_desc = alt_desc;
    }

    public String getDisp_area_cd() {
        return disp_area_cd;
    }

    public void setDisp_area_cd(String disp_area_cd) {
        this.disp_area_cd = disp_area_cd;
    }

    public String getDisp_end_dt() {
        return disp_end_dt;
    }

    public void setDisp_end_dt(String disp_end_dt) {
        this.disp_end_dt = disp_end_dt;
    }

    public String getDisp_start_dt() {
        return disp_start_dt;
    }

    public void setDisp_start_dt(String disp_start_dt) {
        this.disp_start_dt = disp_start_dt;
    }

    public int getDisp_pri_order() {
        return disp_pri_order;
    }

    public void setDisp_pri_order(int disp_pri_order) {
        this.disp_pri_order = disp_pri_order;
    }


    public String getDccoupon_info() {
        return dccoupon_info;
    }

    public void setDccoupon_info(String dccoupon_info) {
        this.dccoupon_info = dccoupon_info;
    }

    public String getContentLink() {
        return contentLink;
    }

    public void setContentLink(String contentLink) {
        this.contentLink = contentLink;
    }

    public String getWeb_desc() {
        return web_desc;
    }

    public void setWeb_desc(String web_desc) {
        this.web_desc = web_desc;
    }

    public String getBold_yn() {
        return bold_yn;
    }

    public void setBold_yn(String bold_yn) {
        this.bold_yn = bold_yn;
    }

    public String getUnder_line_yn() {
        return under_line_yn;
    }

    public void setUnder_line_yn(String under_line_yn) {
        this.under_line_yn = under_line_yn;
    }

    public String getFont_color() {
        return font_color;
    }

    public void setFont_color(String font_color) {
        this.font_color = font_color;
    }

    public String getTag5_yn() {
        return tag5_yn;
    }

    public void setTag5_yn(String tag5_yn) {
        this.tag5_yn = tag5_yn;
    }

    public String getDis_diagram_cd() {
        return dis_diagram_cd;
    }

    public void setDis_diagram_cd(String dis_diagram_cd) {
        this.dis_diagram_cd = dis_diagram_cd;
    }

    public String getCo_titem_end_cnt() {
        return co_titem_end_cnt;
    }

    public void setCo_titem_end_cnt(String co_titem_end_cnt) {
        this.co_titem_end_cnt = co_titem_end_cnt;
    }

    public Integer getQty() {
        return qty;
    }

    public void setQty(Integer qty) {
        this.qty = qty;
    }

    public String getMax_qty() {
        return max_qty;
    }

    public void setMax_qty(String max_qty) {
        this.max_qty = max_qty;
    }

    public Integer getCnt() {
        return cnt;
    }

    public void setCnt(Integer cnt) {
        this.cnt = cnt;
    }

    public Boolean getOnday() {
        return isOnday;
    }

    public void setOnday(Boolean onday) {
        isOnday = onday;
    }

    public Boolean getBestNew() {
        return bestNew;
    }

    public void setBestNew(Boolean bestNew) {
        this.bestNew = bestNew;
    }

    public Boolean getMorefree() {
        return morefree;
    }

    public void setMorefree(Boolean morefree) {
        this.morefree = morefree;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getSitem_code() {
        return sitem_code;
    }

    public void setSitem_code(String sitem_code) {
        this.sitem_code = sitem_code;
    }

    public String getItem_name() {
        return item_name;
    }

    public void setItem_name(String item_name) {
        this.item_name = item_name;
    }

    public String getBrand_code() {
        return brand_code;
    }

    public void setBrand_code(String brand_code) {
        this.brand_code = brand_code;
    }

    public String getBrand_name() {
        return brand_name;
    }

    public void setBrand_name(String brand_name) {
        this.brand_name = brand_name;
    }

    public String getBrand_url() {
        return brand_url;
    }

    public void setBrand_url(String brand_url) {
        this.brand_url = brand_url;
    }

    public double getCust_price() {
        return cust_price;
    }

    public void setCust_price(double cust_price) {
        this.cust_price = cust_price;
    }

    public double getItem_price() {
        return item_price;
    }

    public void setItem_price(double item_price) {
        this.item_price = item_price;
    }

    public double getSale_price() {
        return sale_price;
    }

    public void setSale_price(double sale_price) {
        this.sale_price = sale_price;
    }

    public int getCo_titem_cnt() {
        return co_titem_cnt;
    }

    public void setCo_titem_cnt(int co_titem_cnt) {
        this.co_titem_cnt = co_titem_cnt;
    }

    public String getCo_copurchase_no() {
        return co_copurchase_no;
    }

    public void setCo_copurchase_no(String co_copurchase_no) {
        this.co_copurchase_no = co_copurchase_no;
    }

    public String getOrigin_name() {
        return origin_name;
    }

    public void setOrigin_name(String origin_name) {
        this.origin_name = origin_name;
    }

    public String getTv_yn() {
        return tv_yn;
    }

    public void setTv_yn(String tv_yn) {
        this.tv_yn = tv_yn;
    }

    public String getBest_item_yn() {
        return best_item_yn;
    }

    public void setBest_item_yn(String best_item_yn) {
        this.best_item_yn = best_item_yn;
    }

    public String getNew_item_yn() {
        return new_item_yn;
    }

    public void setNew_item_yn(String new_item_yn) {
        this.new_item_yn = new_item_yn;
    }

    public String getSubside_yn() {
        return subside_yn;
    }

    public void setSubside_yn(String subside_yn) {
        this.subside_yn = subside_yn;
    }

    public String getTag_type() {
        return tag_type;
    }

    public void setTag_type(String tag_type) {
        this.tag_type = tag_type;
    }

    public String getTag_txt() {
        return tag_txt;
    }

    public void setTag_txt(String tag_txt) {
        this.tag_txt = tag_txt;
    }

    public String getTag_img_path() {
        return tag_img_path;
    }

    public void setTag_img_path(String tag_img_path) {
        this.tag_img_path = tag_img_path;
    }

    public String getTag_img_name() {
        return tag_img_name;
    }

    public void setTag_img_name(String tag_img_name) {
        this.tag_img_name = tag_img_name;
    }

    public String getTag_img_link() {
        return tag_img_link;
    }

    public void setTag_img_link(String tag_img_link) {
        this.tag_img_link = tag_img_link;
    }

    public String getRegion_cd() {
        return region_cd;
    }

    public void setRegion_cd(String region_cd) {
        this.region_cd = region_cd;
    }

    public String getSub_cd() {
        return sub_cd;
    }

    public void setSub_cd(String sub_cd) {
        this.sub_cd = sub_cd;
    }

    public String getMsale_code() {
        return msale_code;
    }

    public void setMsale_code(String msale_code) {
        this.msale_code = msale_code;
    }

    public void setTotalcnt(Integer totalcnt) {
        this.totalcnt = totalcnt;
    }

    public Boolean getYinTai() {
        return isYinTai;
    }

    public void setYinTai(Boolean yinTai) {
        isYinTai = yinTai;
    }

    public Boolean getTeHui() {
        return isTeHui;
    }

    public void setTeHui(Boolean teHui) {
        isTeHui = teHui;
    }

    public Boolean getSmg() {
        return isSmg;
    }

    public void setSmg(Boolean smg) {
        isSmg = smg;
    }

    public String getConts_Title() {
        return conts_Title;
    }

    public void setConts_Title(String conts_Title) {
        this.conts_Title = conts_Title;
    }

    public int getInterest_count() {
        return interest_count;
    }

    public void setInterest_count(int interest_count) {
        this.interest_count = interest_count;
    }

    public int getCntStar() {
        return cntStar;
    }

    public void setCntStar(int cntStar) {
        this.cntStar = cntStar;
    }

    public int getOpoint_num() {
        return opoint_num;
    }

    public void setOpoint_num(int opoint_num) {
        this.opoint_num = opoint_num;
    }

    public String getGift_gb() {
        return gift_gb;
    }

    public void setGift_gb(String gift_gb) {
        this.gift_gb = gift_gb;
    }

    public String getProm_dc_gb() {
        return prom_dc_gb;
    }

    public void setProm_dc_gb(String prom_dc_gb) {
        this.prom_dc_gb = prom_dc_gb;
    }

    public double getCost_total() {
        return cost_total;
    }

    public void setCost_total(double cost_total) {
        this.cost_total = cost_total;
    }

    public double getProm_total() {
        return prom_total;
    }

    public void setProm_total(double prom_total) {
        this.prom_total = prom_total;
    }

    public String getIsOuTuan() {
        return isOuTuan;
    }

    public void setIsOuTuan(String isOuTuan) {
        this.isOuTuan = isOuTuan;
    }

    public String getIsTvWarn() {
        return isTvWarn;
    }

    public void setIsTvWarn(String isTvWarn) {
        this.isTvWarn = isTvWarn;
    }

    public String getWaiting_yn() {
        return waiting_yn;
    }

    public void setWaiting_yn(String waiting_yn) {
        this.waiting_yn = waiting_yn;
    }

    public String getInternet_yn() {
        return internet_yn;
    }

    public void setInternet_yn(String internet_yn) {
        this.internet_yn = internet_yn;
    }

    public String getSale_gb() {
        return sale_gb;
    }

    public void setSale_gb(String sale_gb) {
        this.sale_gb = sale_gb;
    }

    public String getSign_gb() {
        return sign_gb;
    }

    public void setSign_gb(String sign_gb) {
        this.sign_gb = sign_gb;
    }

    public int getItem_qty() {
        return item_qty;
    }

    public void setItem_qty(int item_qty) {
        this.item_qty = item_qty;
    }

    public int getLimit_qty() {
        return limit_qty;
    }

    public void setLimit_qty(int limit_qty) {
        this.limit_qty = limit_qty;
    }

    public int getO_limit_qty() {
        return o_limit_qty;
    }

    public void setO_limit_qty(int o_limit_qty) {
        this.o_limit_qty = o_limit_qty;
    }

    public String getO_item_desc() {
        return o_item_desc;
    }

    public void setO_item_desc(String o_item_desc) {
        this.o_item_desc = o_item_desc;
    }

    public String getBrandFlag() {
        return brandFlag;
    }

    public void setBrandFlag(String brandFlag) {
        this.brandFlag = brandFlag;
    }

    public String getItem_ven_code() {
        return item_ven_code;
    }

    public void setItem_ven_code(String item_ven_code) {
        this.item_ven_code = item_ven_code;
    }

    public int getO_pass_qty() {
        return o_pass_qty;
    }

    public void setO_pass_qty(int o_pass_qty) {
        this.o_pass_qty = o_pass_qty;
    }

    public String getGenuine_product_yn() {
        return genuine_product_yn;
    }

    public void setGenuine_product_yn(String genuine_product_yn) {
        this.genuine_product_yn = genuine_product_yn;
    }

    public String getLin_bao() {
        return lin_bao;
    }

    public void setLin_bao(String lin_bao) {
        this.lin_bao = lin_bao;
    }

    public String getLinbao_yn() {
        return linbao_yn;
    }

    public void setLinbao_yn(String linbao_yn) {
        this.linbao_yn = linbao_yn;
    }

    public String getLinbao_date() {
        return linbao_date;
    }

    public void setLinbao_date(String linbao_date) {
        this.linbao_date = linbao_date;
    }

    public String getOmsitemqty() {
        return omsitemqty;
    }

    public void setOmsitemqty(String omsitemqty) {
        this.omsitemqty = omsitemqty;
    }

    public String getKjt_yn() {
        return kjt_yn;
    }

    public void setKjt_yn(String kjt_yn) {
        this.kjt_yn = kjt_yn;
    }

    public String getOversea_yn() {
        return oversea_yn;
    }

    public void setOversea_yn(String oversea_yn) {
        this.oversea_yn = oversea_yn;
    }

    public String getSc_yn() {
        return sc_yn;
    }

    public void setSc_yn(String sc_yn) {
        this.sc_yn = sc_yn;
    }

    public String getGlobalbuy_yn() {
        return globalbuy_yn;
    }

    public void setGlobalbuy_yn(String globalbuy_yn) {
        this.globalbuy_yn = globalbuy_yn;
    }

    public String getGrade_value() {
        return grade_value;
    }

    public void setGrade_value(String grade_value) {
        this.grade_value = grade_value;
    }

    public String getDraw_num() {
        return draw_num;
    }

    public void setDraw_num(String draw_num) {
        this.draw_num = draw_num;
    }

    public String getEvent_no() {
        return event_no;
    }

    public void setEvent_no(String event_no) {
        this.event_no = event_no;
    }

    public String getLgroup() {
        return lgroup;
    }

    public void setLgroup(String lgroup) {
        this.lgroup = lgroup;
    }

    public String getTrade_type() {
        return trade_type;
    }

    public void setTrade_type(String trade_type) {
        this.trade_type = trade_type;
    }

    public String getDomain_id() {
        return domain_id;
    }

    public void setDomain_id(String domain_id) {
        this.domain_id = domain_id;
    }

    public String getContentImage() {
        return contentImage;
    }

    public void setContentImage(String contentImage) {
        this.contentImage = contentImage;
    }

    public String getItem_image() {
        return item_image;
    }

    public void setItem_image(String item_image) {
        this.item_image = item_image;
    }

    public int getTime() {
        return time;
    }

    public void setTime(int time) {
        this.time = time;
    }

    public String getQtyState() {
        return qtyState;
    }

    public void setQtyState(String qtyState) {
        this.qtyState = qtyState;
    }
}
