/**
 * Created by Administrator on 2017/5/12.
 */
import React, {PropTypes} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Dimensions,
    TouchableOpacity,
} from 'react-native';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
const {width} = Dimensions.get('window');


export default class PromotionGoodsFooter extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            //allSelected: this.props.allSelected,
        };
    }

    render() {
        return (
            <View style={styles.promotionGoodsFooter}>
                <View style={styles.promptView}>
                    <Text allowFontScaling={false} style={styles.promptText}>还差</Text>
                    <Text allowFontScaling={false} style={styles.promptPriceText}>¥198</Text>
                </View>
                <TouchableOpacity activeOpacity={1} onpress>
                    <View style={styles.toCartView}>
                        <Text allowFontScaling={false} style={styles.toCartText}>去购物车</Text>
                    </View>
                </TouchableOpacity>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    promotionGoodsFooter: {
        height: 60,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'flex-start',
    },
    promptView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'white',
        width: width / 3 * 2,
        height: 60,
    },
    promptText: {
        color: Colors.text_black,
        fontSize: Fonts.page_title_font(),
    },
    promptPriceText: {
        color: Colors.main_color,
        fontSize: Fonts.page_title_font(),
    },
    toCartView: {
        backgroundColor: Colors.main_color,
        width: width / 3,
        justifyContent: 'center',
        alignItems: 'center',
        height: 60,
    },
    toCartText: {
        color: 'white',
        fontSize: Fonts.page_title_font()
    },
})