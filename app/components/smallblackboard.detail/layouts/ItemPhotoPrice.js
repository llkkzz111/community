/**
* @file 小黑板详情相关商品推荐item
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import React, { Component } from 'react';
import {
    View,
    Text,
    Image
} from 'react-native';
import Colors from 'CONFIG/colors';
import pressStorage from 'FOUNDATION/PressStorage';
import { ItemPhotoPrice as styles } from '../style';

/**
* @classdesc
* 小黑板相关商品列表
* @const {class}
**/
@pressStorage({
    name: 'product'
})
export default class ItemPhotoPrice extends Component {
    static defaultProps = {
        data:{
            firstImgUrl: '', //图片源地址
            title: '', // 标题
            salePrice:'', //折后价
            originalPrice:'', // 原价
            destinationUrl:'', //  目标地址
            destinationUrlType:'', //  目标地址类型 1商品 2站内页面 3手动输入 4无
            salesVolume:'', //  销售量
            inStock:'', //  库存
            discount:'', //  折扣
            activityType:'', //  活动
            integral:'', // 积分
            gifts:'', //  赠品
        }
    };
    constructor(props){
    	super(props);
    	this.state = {
            select: this.props.filter() // 是否访问过相关商品
        };
    }
    componentWillReceiveProps(nextProps) {
        nextProps.filter ? this.setState({
            select: nextProps.filter()
        }) : null;
    }
    shouldComponentUpdate(newProps, newState) {
        return newState.select !== this.state.select;
    }
    render() {
        const { item } = this.props;
        return (
            <View style={styles.footPointGoods}>
                <Image source={{uri: item.firstImgUrl}} style={styles.imgStyle}/>
                <View style={styles.goodsInfor}>
                    <View style={styles.prductNameViewStyle}>
                        {
                            `${item.discount}` !== "0" && item.discount ?
                                (
                                    <View>
                                        <Image style={styles.iconStyle} source={require('IMG/goodsdetail/icon_discount_@3x.png')}>
                                            <Text allowFontScaling={false} style={styles.cheep}>{ item.discount }折</Text>
                                        </Image>
                                        <Text allowFontScaling={false} numberOfLines={2} style={[
                                            styles.prductNameTextStyle, {
                                                color: this.state.select ? Colors.text_light_grey : Colors.text_black
                                            }
                                        ]}>
                                            { "           " + item.title }
                                        </Text>
                                    </View>
                                ) : (
                                    <View>
                                        <Text allowFontScaling={false} numberOfLines={2} style={[
                                            styles.prductNameTextStyle, {
                                                color: this.state.select ? Colors.text_light_grey : Colors.text_black
                                            }
                                        ]}>
                                            { item.title }
                                        </Text>
                                    </View>
                                )
                        }
                    </View>
                    <View style={styles.priceViewStyle}>
                        { item.salePrice &&
                            <Text allowFontScaling={false} style={styles.priceTextStyle}>￥ { item.salePrice }</Text> }
                        {
                            item.originalPrice && item.salePrice && Number(item.originalPrice) > Number(item.salePrice) ? (
                                <Text allowFontScaling={false} style={styles.unPriceTextStyle}>{ item.originalPrice }</Text>
                            ) : null
                        }
                    </View>
                    <View style={styles.alreadyBuyViewStyle}>
                        { `${item.salesVolume}` !== "0" && <Text allowFontScaling={false}>{ item.salesVolume } 人已购买</Text> }
                    </View>
                </View>
            </View>
        );
    }
}
