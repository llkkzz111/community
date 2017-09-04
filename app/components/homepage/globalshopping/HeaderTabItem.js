/**
 * Created by YASIN on 2017/6/5.
 * 头部tabitem
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
export default class HeaderTabItem extends React.Component {
    static propTypes = {
        icon: Image.propTypes.source,
        flag: PropTypes.string,
        title: PropTypes.string,
        onItemClick: PropTypes.func
    }

    render() {
        return (
            <TouchableOpacity activeOpacity={1} onPress={this.props.onItemClick}>
                <View style={styles.container}>
                    <View style={styles.iconContainer}>
                        <Image
                            style={styles.iconStyle}
                            source={this.props.icon}
                        />
                        {this.props.flag ? (
                            <Image
                                style={styles.flagContainer}
                                source={require('../../../../foundation/Img/home/globalshopping/icon_new_.png')}
                            >

                            </Image>
                        ):null}
                    </View>
                    <Text allowFontScaling={false} style={styles.titleStyle}>{this.props.title}</Text>
                </View>
            </TouchableOpacity>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.scaleSize(128 + 30),
        alignItems: 'center'
    },
    iconStyle: {
        width: ScreenUtils.scaleSize(99),
        height: ScreenUtils.scaleSize(99),
        borderRadius:ScreenUtils.scaleSize(50)
    },
    iconContainer:{
        alignItems:'center',
        alignSelf:'stretch',
    },
    flagContainer:{
        width:ScreenUtils.scaleSize(34),
        height:ScreenUtils.scaleSize(35),
        position:'absolute',
        top:0,
        right:ScreenUtils.scaleSize(12)
    },
    titleStyle:{
        color:Colors.text_dark_grey,
        fontSize:ScreenUtils.scaleSize(26),
        marginTop:ScreenUtils.scaleSize(20)
    }
});
