/**
 * Created by Administrator on 2017/5/24.
 */
//视频主页预告栏目ITEM
import React from 'react';
import {
    Dimensions,
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    FlatList,
    ART,
    Platform,
    DeviceEventEmitter,
} from 'react-native';

import Toast, {DURATION} from 'react-native-easy-toast';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';
import RushToBuyProduct from './RushToBuyProduct';
import RemindMe from '../net/video/RemindMe';

let {width} = Dimensions.get('window');
let path;
export default class PreparationItem extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            alreadyRemind: false,
        }
    }

    renderDraw = () => {
        return (
            <ART.Surface width={width} height={5}>
                <ART.Shape d={path} fill="#F4F4F4"/>
            </ART.Surface>
        )
    }

    toRemindMe(preparationItem) {
        // this.setState({
        //     alreadyRemind: !this.state.alreadyRemind,
        // })
        if (this.RemindMe) {
            this.RemindMe.setCancled(true);
        }

        this.RemindMe = new RemindMe({
            "platform": Platform.OS,
            "seq_code": preparationItem.contentCode,
            "liveName": preparationItem.title,
            "starttime": preparationItem.playDateLong//开始时间
        }, 'POST');
        this.RemindMe.start(
            (response) => {
                if (response.code === 200) {
                    if (response.message && response.message === 'succeed') {
                        this.setState({
                            alreadyRemind: true,
                        });
                    }

                } else {
                    DeviceEventEmitter.emit('showToast');
                }
            }, (erro) => {
                DeviceEventEmitter.emit('showToast');
                // console.log(erro);
            });
    }

    render() {
        let {preparationItem} = this.props;
        if (preparationItem.isRemind && preparationItem.isRemind > 0) {
            this.state.alreadyRemind = true;
        }
        return (

            <View style={styles.itemView}>

                <View style={styles.programItem}>
                    <Image source={{
                        uri: preparationItem.firstImgUrl ?
                            preparationItem.firstImgUrl : '1'
                    }}
                           style={styles.programImg}/>
                    <View style={styles.contents}>
                        <Text style={styles.programItemName} numberOfLines={2}
                              allowFontScaling={false}>{preparationItem.title}</Text>
                        <View style={styles.authorAndTime}>
                            <Text numberOfLines={1} style={styles.onLiveTime}
                                  allowFontScaling={false}>{preparationItem.videoDate}</Text>
                            {
                                this.state.alreadyRemind || (preparationItem.isRemind && preparationItem.isRemind > 0) ?
                                    <View style={styles.alreadyRemindView}>
                                        <Image source={require('../Img/shoppingPage/icon_dui.png')}
                                               style={styles.alreadyRemindImg}/>
                                        <Text style={styles.alreadyRemind} allowFontScaling={false}>已提醒</Text>
                                    </View>
                                    : <TouchableOpacity
                                        activeOpacity={1}
                                        onPress={
                                            () => {
                                                this.toRemindMe(preparationItem)
                                            }
                                        }>
                                        <View style={{
                                            backgroundColor: '#3673F1',
                                            width: ScreenUtil.scaleSize(130),
                                            height: ScreenUtil.scaleSize(40),
                                            flexDirection: 'row',
                                            alignItems: 'center',
                                            justifyContent: 'center',
                                            borderRadius: ScreenUtil.scaleSize(4)
                                        }}>
                                            <Image source={require('../Img/shoppingPage/alarm_.png')}
                                                   style={styles.alreadyRemindImg}/>
                                            <Text style={styles.remind} allowFontScaling={false}>提醒我</Text>
                                        </View></TouchableOpacity>
                            }
                        </View>
                    </View>

                    <View style={styles.onLiveTitleViewStyle}>
                        <View style={styles.circleStyle}/>
                        <Text style={styles.onLiveText} allowFontScaling={false}>即将播出</Text>
                    </View>
                </View>

                <View style={styles.deltaStyle}>
                    {this.renderDraw()}
                    <FlatList
                        data={preparationItem.componentList}
                        renderItem={({item, index}) => {
                            return (
                                <RushToBuyProduct key={index} keyIndex={index} rushToBuyItem={item}/>
                            )
                        }}/>
                </View>
                <View style={{
                    marginTop: ScreenUtil.scaleSize(20),
                    height: ScreenUtil.scaleSize(10),
                    flex: 1,
                    marginHorizontal: ScreenUtil.scaleSize(20),
                }}></View>
                <Toast ref="toast"/>
            </View>
        )
    }


}


const styles = StyleSheet.create({
    itemView: {
        paddingBottom: ScreenUtil.scaleSize(20),
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#dddddd',
    },
    programItem: {
        zIndex: 1,
        paddingHorizontal: ScreenUtil.scaleSize(20),
        paddingTop: ScreenUtil.scaleSize(20),
        backgroundColor: Colors.background_white,
        flexDirection: 'row',
        justifyContent: 'flex-start'
    },
    programImg: {
        width: ScreenUtil.scaleSize(180),
        height: ScreenUtil.scaleSize(180),
    },
    remindImg: {
        marginRight: ScreenUtil.scaleSize(10),
        backgroundColor: 'rgba(0, 0, 0, 0)',
        width: ScreenUtil.scaleSize(25),
        height: ScreenUtil.scaleSize(25),
    },
    alreadyRemindImg: {
        width: ScreenUtil.scaleSize(19),
        height: ScreenUtil.scaleSize(19),
        resizeMode: 'stretch',
        marginRight: ScreenUtil.scaleSize(10)
    },
    remind: {
        fontSize: ScreenUtil.setSpText(23),
        color: Colors.text_white,
    },
    alreadyRemind: {
        fontSize: ScreenUtil.scaleSize(23),
        color: '#3673F1',
        textAlignVertical: 'center',
    },
    authorAndTime: {
        marginTop: ScreenUtil.scaleSize(10),
        justifyContent: 'space-between',
        flexDirection: 'row',
        marginRight: ScreenUtil.scaleSize(15),
    },

    contents: {
        paddingLeft: ScreenUtil.scaleSize(10),
        flex: 1,
        justifyContent: 'space-between',
        height: ScreenUtil.scaleSize(180),
    },
    programItemName: {
        color: Colors.text_black,
        fontSize: Fonts.standard_normal_font(),
        includeFontPadding: false
    },
    onLiveTime: {
        color: '#F14967',
        fontSize: Fonts.secondary_font(),
        backgroundColor: 'rgba(0, 0, 0, 0)',
        fontWeight: 'bold',
        flex: 1
    },
    deltaStyle: {
        //marginTop: -5
    },
    playSoonViewStyle: {
        height: ScreenUtil.scaleSize(30),
        width: ScreenUtil.scaleSize(124),
        position: 'absolute',
        left: ScreenUtil.scaleSize(30),
        top: ScreenUtil.scaleSize(30),
        zIndex: 10,
        justifyContent: 'center',
    },
    playSoonText: {
        backgroundColor: 'rgba(0, 0, 0, 0)',
        color: Colors.text_white,
        fontSize: Fonts.tag_font(),
        paddingLeft: ScreenUtil.scaleSize(20),
    },
    onLiveTitleViewStyle: {
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(30),
        width: ScreenUtil.scaleSize(124),
        backgroundColor: '#FFB000',
        borderRadius: ScreenUtil.scaleSize(50),
        position: 'absolute',
        left: ScreenUtil.scaleSize(30),
        top: ScreenUtil.scaleSize(30),
        zIndex: 10,
        alignItems: 'center',
        justifyContent: 'center'
    },

    circleStyle: {
        backgroundColor: '#fff',
        height: ScreenUtil.scaleSize(6),
        width: ScreenUtil.scaleSize(6),
        borderRadius: ScreenUtil.scaleSize(3),
        marginRight: ScreenUtil.scaleSize(5),
    },

    onLiveText: {
        backgroundColor: 'transparent',
        color: Colors.text_white,
        //height:20,
        textAlignVertical: 'center',
        textAlign: 'center',
        fontSize: ScreenUtil.scaleSize(22),

    },
    alreadyRemindView: {
        width: ScreenUtil.scaleSize(130),
        height: ScreenUtil.scaleSize(40),
        borderColor: '#3673F1',
        borderWidth: ScreenUtil.scaleSize(1),
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: ScreenUtil.scaleSize(4)
    },
});
