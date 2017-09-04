import React, {
    PropTypes
} from 'react';

import {
    Text,
    View,
    Image,
    StyleSheet,
    TouchableOpacity
} from 'react-native';
import {connect} from 'react-redux'
/**
 * 活动内容组件
 */
export class PromotionRender extends React.PureComponent {
    constructor(props) {
        super(props);
    }
    render() {
        return (
            <View style={styles.shoppingHeaderLayout}>
                <View style={styles.sectionHeaderSelect}>
                    <Text style={[styles.preferentialLayout, styles.backTextWhite]} allowFontScaling={false}>满减</Text>
                    <Text style={styles.preferentialText} allowFontScaling={false}>已满200，立减40</Text>
                </View>
                <TouchableOpacity activeOpacity={1} style={styles.sectionHeaderSelect} onPress={() => {
                    this.props.onStrollAgain && this.props.onStrollAgain()
                }}>
                    <Text style={styles.visitAgain} allowFontScaling={false}>再逛逛</Text>
                    <Image style={styles.actionImgStyle}
                           source={require('../Img/cart/goIcon.png')}/>
                </TouchableOpacity>
            </View>
        );
    }
}
//样式定义
const styles = StyleSheet.create({
        shoppingHeaderLayout: {
            flexDirection: 'row',
            justifyContent: 'space-between',
            alignItems: 'center',
            paddingLeft: 10,
            paddingRight: 10,
            minHeight: 40,
            maxHeight: 240
        },
        sectionHeaderSelect: {
            flexDirection: 'row',
            alignItems: 'center',
            justifyContent: 'center',
        },
        preferentialLayout: {
            width: 34,
            height: 20,
            backgroundColor: '#ED1C41',
            borderRadius: 2,
            alignSelf:"center",
        },
        backTextWhite: {
            color: 'white',
            fontSize: 13,
            textAlign: "center"
        },
        preferentialText: {
            color: '#666666',
            marginLeft: 10,
            fontSize: 13
        },
        visitAgain: {
            color: '#df2928',
            marginLeft: 10,
            marginRight: 5,
            fontSize: 13
        },
        actionImgStyle: {
            width: 7,
            height: 10,
            resizeMode: "contain"
        },
    }
)
PromotionRender.propTypes={
    onStrollAgain:PropTypes.func,
}
export default connect(state => ({
        cartType: state.CartReducer
    }),
    dispatch => ({})
)(PromotionRender)
