/**
 * Created by Administrator on 2017/5/24.
 */
//视频主页热门栏目ITEM
import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
} from 'react-native';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
import {Actions} from 'react-native-router-flux';

export default class PopularColumnItem extends React.PureComponent {

    constructor(props) {
        super(props);
        this.state = {}
    }

    render() {
        let {popularColumnItem} = this.props;
        return (
            <TouchableOpacity style={styles.popularColumnItem} onPress={() => {
                this.props.onClick({
                    lgroup: popularColumnItem.lgroup,
                    contentType: popularColumnItem.contentType,
                    codeValue: popularColumnItem.codeValue
                })
            }} activeOpacity={1}>
                {
                    popularColumnItem.firstImgUrl ? (
                        <View style={styles.imgWrap}>
                            <Image source={{uri: popularColumnItem.firstImgUrl}} style={styles.popularImgStyle}/>
                            <View style={styles.playStyle}>
                                <Image source={require('../Img/shoppingPage/Icon_playbtn_.png')}
                                       style={styles.playStyleImg}/>
                            </View>
                        </View>
                    ) : null
                }
                {
                    popularColumnItem.title ? (
                        <View style={styles.liveSHowTime}>
                            <Text style={styles.liveSHowTimeText} allowFontScaling={false}>{popularColumnItem.title}</Text>
                        </View>
                    ) : null
                }
                {
                    popularColumnItem.subtitle ? (
                        <View style={{
                            marginTop: ScreenUtils.scaleSize(10),
                            alignItems: 'center',
                            justifyContent: 'center',
                            marginHorizontal: ScreenUtils.scaleSize(15)
                        }}>
                            <Text numberOfLines={2} style={styles.summaryText} allowFontScaling={false}>{popularColumnItem.subtitle}</Text>
                        </View>
                    ) : null
                }
            </TouchableOpacity>
        )
    }

}

const styles = StyleSheet.create({
    douTextStyle1: {
        color: '#333',
        fontSize: ScreenUtils.setSpText(28),
        marginLeft: ScreenUtils.scaleSize(30),
    },
    douTextStyle2: {
        color: '#666',
        marginTop: ScreenUtils.scaleSize(10),
        fontSize: ScreenUtils.setSpText(26),
        marginLeft: ScreenUtils.scaleSize(30),
    },
    popularColumnItem: {
        // padding: 10,
        backgroundColor: Colors.text_white,
        marginBottom: ScreenUtils.scaleSize(20),
        //   width: 170,
    },
    popularImgViewStyle: {
        height: 210,
        width: 150,
    },
    popularImgStyle: {
        width: 150,
        height: 170,
        resizeMode: 'contain'
    },
    imgWrap: {
        alignItems: 'center',
        justifyContent: 'center',
        marginRight: 10,
        marginLeft: 10
    },
    playStyle: {
        width: ScreenUtils.scaleSize(66),
        height: ScreenUtils.scaleSize(66),
        borderRadius: ScreenUtils.scaleSize(33),
        backgroundColor: "#fff",
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: ScreenUtils.scaleSize(33) * -1
    },
    playStyleImg: {
        width: ScreenUtils.scaleSize(46),
        height: ScreenUtils.scaleSize(46),
    },
    playbtnStyle: {
        width: 23,
        height: 23,
    },
    liveSHowTime: {
        justifyContent: 'center',
        alignItems: 'center',
    },

    liveSHowTimeText: {
        color: Colors.main_color,
        fontSize: Fonts.tag_font()
    },
    summaryText: {
        color: Colors.text_dark_grey,
        fontSize: Fonts.tag_font(),
    },

});