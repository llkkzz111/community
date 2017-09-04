/**
 * Created by 卓原 on 2017/5/22 0022.
 * 折扣商品图文组件 左上角折扣文字，图下方有售价，原价和已售个数
 */


import React from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableOpacity,

} from 'react-native';
import * as ScreenUtil from'../utils/ScreenUtil';
let item = {
    id: 1,
    url: 'url',
    img: require('../Img/home/googs1@2x.png'),
    discount: 1.5,
    title: '商品名称有点…',
    price: 188,
    originalPrice: 200,
    sellnumber: 200
};
export default class HorizontalItem extends React.PureComponent {


    constructor(props) {
        super(props);
        this.state = {
            hasDiscount: true,          //控制是否显示图片左上角的折扣
            hasTitle: true,             //控制是否显示标题
        }

    }

    _onPressButton(url) {
    }

    render() {
        //let item = this.props.item;
        return (
            <TouchableOpacity activeOpacity={1} onPress={() => this._onPressButton(item.url)}>
                <View style={styles.container}>
                    <Image source={item.img}
                           resizeMode={'cover'}
                           style={styles.imagesize}
                    >
                        {
                            this.state.hasDiscount ? <View style={styles.discountView}>
                                <Text style={styles.discount} allowFontScaling={false}>{item.discount}折</Text>
                            </View> : null
                        }

                    </Image>
                    <View>
                        {
                            this.state.hasTitle ?
                                <Text numberOfLines={2} style={styles.title} allowFontScaling={false}>{item.title}</Text> : null
                        }
                        <View style={styles.horiza}>
                            <Text style={styles.price} allowFontScaling={false}>¥{item.price}</Text>
                            <View>
                                <Text style={styles.originalPrice} allowFontScaling={false}>¥{item.originalPrice}</Text>
                            </View>
                        </View>
                        <Text style={styles.sellnumber} allowFontScaling={false}>{item.sellnumber} 件已售</Text>
                    </View>
                </View>
            </TouchableOpacity>
        );
    }

}

const styles = StyleSheet.create({
    container: {
        marginHorizontal: 5,
        width: ScreenUtil.screenW / 4,
    },
    imagesize: {
        width: ScreenUtil.screenW / 4,
        height: ScreenUtil.screenW / 4,
    },
    discountView: {
        width: 30,
        height: 30,
        backgroundColor: "#ED1C41",
        justifyContent: 'center',
        alignItems: 'center',
    },
    discount: {
        color: 'white',
        fontWeight: 'bold',
        fontSize: 10
    },
    originalPrice: {
        color: '#999',
        textDecorationLine: 'line-through',
        fontSize: 10,
    },
    price: {
        //includeFontPadding: false,
        color: '#E5290D',
        fontWeight: 'bold',
        fontSize: 14,
        textAlignVertical: 'bottom'
    },
    sellnumber: {
        color: '#666',
        fontSize: 10
    },
    horiza: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-end',
    },
});
