package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by liutao on 2017/6/22.
 */

public class ReserveOrderBean {


    /**
     * receivers : {"receivermanage_seq":"0000000005","receiver_seq":"0000000032","default_yn":"1","receiver_name":"刘强","receiver_post":"200062","receiver_post_seq":"0092","receiver_addr":"长阳路7777号","receiver_hp":"13511183211","use_yn":"1","addr_m":"上海市普陀区","area_lgroup":"10"}
     * useable_deposit : 9,999,471.9
     * useable_saveamt : 150,000
     * useable_cardamt : 21321211
     * auto_order_yn : true
     * directDelivery : true
     * total_price : 298
     * coupon_price : 0
     * orders : [{"isCouponUsable":true,"carts":[{"internet_id":"ocj_20170605917427","item":{"item_code":"15157634","unit_code":"001","msale_code":"TM","count":1,"item_name":"西班牙进口 凯利蔻KIRIKO洗衣液超值组3+3+2","path":"http://image1.ocj.com.cn/item_images/item/15/15/7634/15157634A.jpg","integral":"2.93","sale_price":298,"price":293,"dc_amt":5,"last_sale_price":293},"memberPromo":"","twgiftcartVO":[{"gift_item_code":"22222","gift_unit_code":"002","giftpromo_no":"200911230014","giftpromo_seq":"001","item_name":"乐扣乐扣双环保温瓶（Silver）(赠品)","path":"http://image1.ocj.com.cn/item_images/item/11/79/75/117975A.jpg"}]}],"couponList":[{"coupon_no":0,"coupon_note":"A券","real_coupon_amt":10,"dc_gb":10,"coupon_seq":"000000003","dc_endDate":""}]}]
     * dc_amt : 5
     * total_real_price : 293
     * pay_flg : 1
     */

    private ReceiversBean receivers;
    private String useable_deposit;
    private String useable_saveamt;
    private String useable_cardamt;
    private boolean auto_order_yn;
    private boolean directDelivery;
    private int total_price;
    private int coupon_price;
    private int dc_amt;
    private int total_real_price;
    private String pay_flg;
    private List<OrdersBean> orders;

    public ReceiversBean getReceivers() {
        return receivers;
    }

    public void setReceivers(ReceiversBean receivers) {
        this.receivers = receivers;
    }

    public String getUseable_deposit() {
        return useable_deposit;
    }

    public void setUseable_deposit(String useable_deposit) {
        this.useable_deposit = useable_deposit;
    }

    public String getUseable_saveamt() {
        return useable_saveamt;
    }

    public void setUseable_saveamt(String useable_saveamt) {
        this.useable_saveamt = useable_saveamt;
    }

    public String getUseable_cardamt() {
        return useable_cardamt;
    }

    public void setUseable_cardamt(String useable_cardamt) {
        this.useable_cardamt = useable_cardamt;
    }

    public boolean isAuto_order_yn() {
        return auto_order_yn;
    }

    public void setAuto_order_yn(boolean auto_order_yn) {
        this.auto_order_yn = auto_order_yn;
    }

    public boolean isDirectDelivery() {
        return directDelivery;
    }

    public void setDirectDelivery(boolean directDelivery) {
        this.directDelivery = directDelivery;
    }

    public int getTotal_price() {
        return total_price;
    }

    public void setTotal_price(int total_price) {
        this.total_price = total_price;
    }

    public int getCoupon_price() {
        return coupon_price;
    }

    public void setCoupon_price(int coupon_price) {
        this.coupon_price = coupon_price;
    }

    public int getDc_amt() {
        return dc_amt;
    }

    public void setDc_amt(int dc_amt) {
        this.dc_amt = dc_amt;
    }

    public int getTotal_real_price() {
        return total_real_price;
    }

    public void setTotal_real_price(int total_real_price) {
        this.total_real_price = total_real_price;
    }

    public String getPay_flg() {
        return pay_flg;
    }

    public void setPay_flg(String pay_flg) {
        this.pay_flg = pay_flg;
    }

    public List<OrdersBean> getOrders() {
        return orders;
    }

    public void setOrders(List<OrdersBean> orders) {
        this.orders = orders;
    }


    public static class OrdersBean {
        /**
         * isCouponUsable : true
         * carts : [{"internet_id":"ocj_20170605917427","item":{"item_code":"15157634","unit_code":"001","msale_code":"TM","count":1,"item_name":"西班牙进口 凯利蔻KIRIKO洗衣液超值组3+3+2","path":"http://image1.ocj.com.cn/item_images/item/15/15/7634/15157634A.jpg","integral":"2.93","sale_price":298,"price":293,"dc_amt":5,"last_sale_price":293},"memberPromo":"","twgiftcartVO":[{"gift_item_code":"22222","gift_unit_code":"002","giftpromo_no":"200911230014","giftpromo_seq":"001","item_name":"乐扣乐扣双环保温瓶（Silver）(赠品)","path":"http://image1.ocj.com.cn/item_images/item/11/79/75/117975A.jpg"}]}]
         * couponList : [{"coupon_no":0,"coupon_note":"A券","real_coupon_amt":10,"dc_gb":10,"coupon_seq":"000000003","dc_endDate":""}]
         */

        private boolean isCouponUsable;
        private List<CartsBean> carts;
        private List<CouponListBean> couponList;

        public boolean isIsCouponUsable() {
            return isCouponUsable;
        }

        public void setIsCouponUsable(boolean isCouponUsable) {
            this.isCouponUsable = isCouponUsable;
        }

        public List<CartsBean> getCarts() {
            return carts;
        }

        public void setCarts(List<CartsBean> carts) {
            this.carts = carts;
        }

        public List<CouponListBean> getCouponList() {
            return couponList;
        }

        public void setCouponList(List<CouponListBean> couponList) {
            this.couponList = couponList;
        }

        public static class CartsBean {
            /**
             * internet_id : ocj_20170605917427
             * item : {"item_code":"15157634","unit_code":"001","msale_code":"TM","count":1,"item_name":"西班牙进口 凯利蔻KIRIKO洗衣液超值组3+3+2","path":"http://image1.ocj.com.cn/item_images/item/15/15/7634/15157634A.jpg","integral":"2.93","sale_price":298,"price":293,"dc_amt":5,"last_sale_price":293}
             * memberPromo :
             * twgiftcartVO : [{"gift_item_code":"22222","gift_unit_code":"002","giftpromo_no":"200911230014","giftpromo_seq":"001","item_name":"乐扣乐扣双环保温瓶（Silver）(赠品)","path":"http://image1.ocj.com.cn/item_images/item/11/79/75/117975A.jpg"}]
             */

            private String internet_id;
            private ItemBean item;
            private String memberPromo;
            private List<TwgiftcartVOBean> twgiftcartVO;

            public String getInternet_id() {
                return internet_id;
            }

            public void setInternet_id(String internet_id) {
                this.internet_id = internet_id;
            }

            public ItemBean getItem() {
                return item;
            }

            public void setItem(ItemBean item) {
                this.item = item;
            }

            public String getMemberPromo() {
                return memberPromo;
            }

            public void setMemberPromo(String memberPromo) {
                this.memberPromo = memberPromo;
            }

            public List<TwgiftcartVOBean> getTwgiftcartVO() {
                return twgiftcartVO;
            }

            public void setTwgiftcartVO(List<TwgiftcartVOBean> twgiftcartVO) {
                this.twgiftcartVO = twgiftcartVO;
            }

            public static class ItemBean {
                /**
                 * item_code : 15157634
                 * unit_code : 001
                 * msale_code : TM
                 * count : 1
                 * item_name : 西班牙进口 凯利蔻KIRIKO洗衣液超值组3+3+2
                 * path : http://image1.ocj.com.cn/item_images/item/15/15/7634/15157634A.jpg
                 * integral : 2.93
                 * sale_price : 298
                 * price : 293
                 * dc_amt : 5
                 * last_sale_price : 293
                 */

                private String item_code;
                private String unit_code;
                private String msale_code;
                private int count;
                private String item_name;
                private String path;
                private String integral;
                private int sale_price;
                private int price;
                private int dc_amt;
                private int last_sale_price;
                private List<String> sx_gifts;

                public String getItem_code() {
                    return item_code;
                }

                public void setItem_code(String item_code) {
                    this.item_code = item_code;
                }

                public String getUnit_code() {
                    return unit_code;
                }

                public void setUnit_code(String unit_code) {
                    this.unit_code = unit_code;
                }

                public String getMsale_code() {
                    return msale_code;
                }

                public void setMsale_code(String msale_code) {
                    this.msale_code = msale_code;
                }

                public int getCount() {
                    return count;
                }

                public void setCount(int count) {
                    this.count = count;
                }

                public String getItem_name() {
                    return item_name;
                }

                public void setItem_name(String item_name) {
                    this.item_name = item_name;
                }

                public String getPath() {
                    return path;
                }

                public void setPath(String path) {
                    this.path = path;
                }

                public String getIntegral() {
                    return integral;
                }

                public void setIntegral(String integral) {
                    this.integral = integral;
                }

                public int getSale_price() {
                    return sale_price;
                }

                public void setSale_price(int sale_price) {
                    this.sale_price = sale_price;
                }

                public int getPrice() {
                    return price;
                }

                public void setPrice(int price) {
                    this.price = price;
                }

                public int getDc_amt() {
                    return dc_amt;
                }

                public void setDc_amt(int dc_amt) {
                    this.dc_amt = dc_amt;
                }

                public int getLast_sale_price() {
                    return last_sale_price;
                }

                public void setLast_sale_price(int last_sale_price) {
                    this.last_sale_price = last_sale_price;
                }

                public List<String> getSx_gifts() {
                    return sx_gifts;
                }

                public void setSx_gifts(List<String> sx_gifts) {
                    this.sx_gifts = sx_gifts;
                }
            }

            public static class TwgiftcartVOBean {
                /**
                 * gift_item_code : 22222
                 * gift_unit_code : 002
                 * giftpromo_no : 200911230014
                 * giftpromo_seq : 001
                 * item_name : 乐扣乐扣双环保温瓶（Silver）(赠品)
                 * path : http://image1.ocj.com.cn/item_images/item/11/79/75/117975A.jpg
                 */

                private String gift_item_code;
                private String gift_unit_code;
                private String giftpromo_no;
                private String giftpromo_seq;
                private String item_name;
                private String path;

                public String getGift_item_code() {
                    return gift_item_code;
                }

                public void setGift_item_code(String gift_item_code) {
                    this.gift_item_code = gift_item_code;
                }

                public String getGift_unit_code() {
                    return gift_unit_code;
                }

                public void setGift_unit_code(String gift_unit_code) {
                    this.gift_unit_code = gift_unit_code;
                }

                public String getGiftpromo_no() {
                    return giftpromo_no;
                }

                public void setGiftpromo_no(String giftpromo_no) {
                    this.giftpromo_no = giftpromo_no;
                }

                public String getGiftpromo_seq() {
                    return giftpromo_seq;
                }

                public void setGiftpromo_seq(String giftpromo_seq) {
                    this.giftpromo_seq = giftpromo_seq;
                }

                public String getItem_name() {
                    return item_name;
                }

                public void setItem_name(String item_name) {
                    this.item_name = item_name;
                }

                public String getPath() {
                    return path;
                }

                public void setPath(String path) {
                    this.path = path;
                }
            }
        }
    }
}
