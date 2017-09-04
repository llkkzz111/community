/**
 * Created by MASTERMIAO on 2017/5/7.
 * 个人中心个人信息组件
 */
'use strict';
import React from 'react';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
import {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableOpacity,
    TouchableWithoutFeedback,
    Platform,
} from 'react-native';
import * as routeConfig from '../../app/config/routeConfig'
import * as RouteManager from '../../app/config/PlatformRouteManager';
import RnConnect from '../../app/config/rnConnect';
import {Actions} from 'react-native-router-flux';
import {getStatusHeightHome}from '../../foundation/common/NavigationBar';
import AppConst from '../../app/constants/AppConstant';
import Immutable from 'immutable';
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
export default class PersonLevelDesc extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            userInfo: this.props.userInfo
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            userInfo: nextProps.userInfo
        });
    }

    shouldComponentUpdate(nextProps, nextState) {
        return !Immutable.is(this.state.userInfo, nextProps.userInfo);
    }

    render() {
        return (
            <Image
                style={styles.container}
                source={require('../Img/me/img_bg_.png')}>
                <View style={styles.containerbg}>
                    {this.membersLevel()}
                </View>
            </Image>
        );
    }


    /**
     * 用户等级信息
     * @returns {XML}
     */
    membersLevel() {
        let userInfo = this.state.userInfo ? this.state.userInfo : "";
        let vipNUm = userInfo.benefit_rule ? userInfo.benefit_rule.vipBool : '';
        //    let custPhoto =  userInfo.check_member_info?userInfo.check_member_info.cust_photo:'' ;
        let userName = userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : '';
        let nextName = userInfo.benefit_rule ? userInfo.benefit_rule.next_level : '';
        let vipBool = userInfo.benefit_rule ? userInfo.benefit_rule.isEm : "";
        let flag = userInfo.benefit_rule ? (userInfo.benefit_rule.vipBool === 'YES' && userInfo.benefit_rule.need_mon === '0' && userInfo.benefit_rule.custLevel !== 'VIP' && userInfo.benefit_rule.next_level === 'VIP') : false;
        if (vipNUm === "NO") {
            if (userName === "贵宾级") {
                return (
                    <View style={styles.bottomContainer}>
                        <View style={styles.userInfoContainer}>
                            <View style={styles.advarContainerStyle}>
                                {this._renderPortrai()}
                                <Image
                                    source={require('../Img/me/icon_viptag_blue_@3x.png')}
                                    style={styles.vipTextContainer}
                                >
                                    <Text allowFontScaling={false} style={styles.vipTextStyle}>
                                        {userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : ''}</Text>
                                </Image>
                                <Image style={styles.crowIconStyle}
                                       source={require('../Img/me/icon_crown_blue_@3x.png')}/>
                            </View>
                            <View style={styles.advarRightContainerStyle}>
                                <Text allowFontScaling={false}
                                      style={styles.nameTextStyle}>{userInfo.check_member_info ? userInfo.check_member_info.cust_name : ''}</Text>
                                <TouchableOpacity activeOpacity={1} onPress={this._onSignClick.bind(this)}>
                                    <View style={styles.signContainerStyle}>
                                        <Image style={styles.signImg} source={require('../Img/me/icon_sign_.png')}/>
                                        <Text allowFontScaling={false} style={styles.personDescStyle}>签到</Text>
                                    </View>
                                </TouchableOpacity>
                            </View>
                        </View>
                        <View style={styles.bottomVipContainerStyle}>
                            <View style={styles.clubDescContainerStyle}>
                                {flag ? <Text
                                            allowFontScaling={false}
                                            style={styles.vipTextStyle}>恭喜您下月1日即可升级为VIP会员。</Text> :
                                        <Text allowFontScaling={false}
                                              style={styles.vipTextStyle}>离{userInfo.benefit_rule ? userInfo.benefit_rule.next_level : ''}
                                            还差
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.need_num : ''}次,
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.need_mon : ''}元
                                        </Text> }
                            </View>
                            {this._vipTriba()}
                        </View>
                    </View>
                )
            }

            if (userName === "优质级") {
                return (
                    <View style={styles.bottomContainer}>
                        <View style={styles.userInfoContainer}>
                            <View style={styles.advarContainerStyle}>
                                {this._renderPortrai()}
                                <Image
                                    source={require('../Img/me/icon_viptag_green_@3x.png')}
                                    style={styles.vipTextContainer}
                                >
                                    <Text allowFontScaling={false} style={styles.vipTextStyle}>
                                        {userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : ''}</Text>
                                </Image>
                                <Image style={styles.crowIconStyle}
                                       source={require('../Img/me/icon_crown_green_@3x.png')}/>
                            </View>
                            <View style={styles.advarRightContainerStyle}>
                                <Text allowFontScaling={false}
                                      style={styles.nameTextStyle}>{userInfo.check_member_info ? userInfo.check_member_info.cust_name : ''}</Text>
                                <TouchableOpacity activeOpacity={1} onPress={this._onSignClick.bind(this)}>
                                    <View style={styles.signContainerStyle}>
                                        <Image style={styles.signImg} source={require('../Img/me/icon_sign_.png')}/>
                                        <Text allowFontScaling={false} style={styles.personDescStyle}>签到</Text>
                                    </View>
                                </TouchableOpacity>
                            </View>
                        </View>
                        <View style={styles.bottomVipContainerStyle}>
                            <View style={styles.clubDescContainerStyle}>
                                {flag ? <Text
                                            allowFontScaling={false}
                                            style={styles.vipTextStyle}>恭喜您下月1日即可升级为VIP会员。</Text> :
                                        <Text allowFontScaling={false}
                                              style={styles.vipTextStyle}>离{userInfo.benefit_rule ? userInfo.benefit_rule.next_level : ''}
                                            还差
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.need_num : ''}次,
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.need_mon : ''}元,就能解锁</Text>}
                                <View style={{flexDirection: 'row'}}>
                                    <View style={styles.giftImgStyle}>
                                        <Image style={styles.giftImgStyle2}
                                               source={require('../Img/me/icon_memberday_@3x.png')}/>
                                    </View>
                                </View>
                            </View>
                            {this._vipTriba()}
                        </View>
                    </View>
                )
            }

            if (userName === "黄金级") {
                return (
                    <View style={styles.bottomContainer}>
                        <View style={styles.userInfoContainer}>
                            <View style={styles.advarContainerStyle}>
                                {this._renderPortrai()}
                                <Image
                                    source={require('../Img/me/icon_viptag_brown_@3x.png')}
                                    style={styles.vipTextContainer}
                                >
                                    <Text allowFontScaling={false} style={styles.vipTextStyle}>
                                        {userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : ''}</Text>
                                </Image>
                                <Image style={styles.crowIconStyle}
                                       source={require('../Img/me/icon_crown_brown_@3x.png')}/>
                            </View>
                            <View style={styles.advarRightContainerStyle}>
                                <Text allowFontScaling={false}
                                      style={styles.nameTextStyle}>{userInfo.check_member_info ? userInfo.check_member_info.cust_name : ''}</Text>
                                <TouchableOpacity activeOpacity={1} onPress={this._onSignClick.bind(this)}>
                                    <View style={styles.signContainerStyle}>
                                        <Image style={styles.signImg} source={require('../Img/me/icon_sign_.png')}/>
                                        <Text allowFontScaling={false} style={styles.personDescStyle}>签到</Text>
                                    </View>
                                </TouchableOpacity>
                            </View>
                        </View>
                        <View style={styles.bottomVipContainerStyle}>
                            <View style={styles.clubDescContainerStyle}>
                                {flag ? <Text
                                            allowFontScaling={false}
                                            style={styles.vipTextStyle}>恭喜您下月1日即可升级为VIP会员。</Text> :
                                        <Text allowFontScaling={false}
                                              style={styles.vipTextStyle}>离{userInfo.benefit_rule ? userInfo.benefit_rule.next_level : ''}
                                            还差
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.need_num : ''}次,
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.need_mon : ''}元,就能解锁</Text>}
                                <View style={{flexDirection: 'row'}}>
                                    <View style={styles.giftImgStyle}>
                                        <Image style={styles.giftImgStyle2}
                                               source={require('../Img/me/icon_giftA_@3x.png')}/>
                                    </View>
                                    <View style={styles.giftImgStyle}>
                                        <Image style={styles.giftImgStyle2}
                                               source={require('../Img/me/icon_upgrade_@3x.png')}/>
                                    </View>
                                </View>
                            </View>
                            {this._vipTriba()}
                        </View>
                    </View>
                )
            }

            if (userName === "白金级") {
                return (
                    <View style={styles.bottomContainer}>
                        <View style={styles.userInfoContainer}>
                            <View style={styles.advarContainerStyle}>
                                {this._renderPortrai()}
                                <Image
                                    source={require('../Img/me/icon_viptag_pink_@3x.png')}
                                    style={styles.vipTextContainer}
                                >
                                    <Text allowFontScaling={false} style={styles.vipTextStyle}>
                                        {userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : ''}</Text>
                                </Image>
                                <Image style={styles.crowIconStyle}
                                       source={require('../Img/me/icon_crown_pink_@3x.png')}/>
                            </View>
                            <View style={styles.advarRightContainerStyle}>
                                <Text allowFontScaling={false}
                                      style={styles.nameTextStyle}>{userInfo.check_member_info ? userInfo.check_member_info.cust_name : ''}</Text>
                                <TouchableOpacity activeOpacity={1} onPress={this._onSignClick.bind(this)}>
                                    <View style={styles.signContainerStyle}>
                                        <Image style={styles.signImg} source={require('../Img/me/icon_sign_.png')}/>
                                        <Text allowFontScaling={false} style={styles.personDescStyle}>签到</Text>
                                    </View>
                                </TouchableOpacity>
                            </View>
                        </View>
                        <View style={styles.bottomVipContainerStyle}>
                            <View style={styles.clubDescContainerStyle}>
                                {flag ? <Text
                                    allowFontScaling={false}
                                    style={styles.vipTextStyle}>恭喜您下月1日即可升级为VIP会员。</Text> :
                                    <Text allowFontScaling={false}
                                          style={styles.vipTextStyle}>离{userInfo.benefit_rule ? userInfo.benefit_rule.next_level : ''}
                                        还差
                                        {userInfo.benefit_rule ? userInfo.benefit_rule.need_num : ''}次,
                                        {userInfo.benefit_rule ? userInfo.benefit_rule.need_mon : ''}元,就能解锁</Text>}
                                <View style={{flexDirection: 'row'}}>
                                    <View style={styles.giftImgStyle}>
                                        <Image style={styles.giftImgStyle2}
                                               source={require('../Img/me/icon_giftB_@3x.png')}/>
                                    </View>
                                    <View style={styles.giftImgStyle}>
                                        <Image style={styles.giftImgStyle2}
                                               source={require('../Img/me/icon_longevity_@3x.png')}/>
                                    </View>
                                </View>
                            </View>
                            {this._vipTriba()}
                        </View>
                    </View>
                )
            }

            // 是否为内部员工 vipBool:false是员工
            if (vipBool === true) {
                if (userName === "钻石级") {
                    return (
                        <View style={styles.bottomContainer}>
                            <View style={styles.userInfoContainer}>
                                <View style={styles.advarContainerStyle}>
                                    {this._renderPortrai()}
                                    <Image
                                        source={require('../Img/me/icon_viptag_purple_@3x.png')}
                                        style={styles.vipTextContainer}
                                    >
                                        <Text allowFontScaling={false} style={styles.vipTextStyle}>
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : ''}</Text>
                                    </Image>
                                    <Image style={styles.crowIconStyle}
                                           source={require('../Img/me/icon_crown_purple_@3x.png')}/>
                                </View>
                                <View style={styles.advarRightContainerStyle}>
                                    <Text allowFontScaling={false}
                                          style={styles.nameTextStyle}>{userInfo.check_member_info ? userInfo.check_member_info.cust_name : ''}</Text>
                                    <TouchableOpacity activeOpacity={1} onPress={this._onSignClick.bind(this)}>
                                        <View style={styles.signContainerStyle}>
                                            <Image style={styles.signImg} source={require('../Img/me/icon_sign_.png')}/>
                                            <Text allowFontScaling={false} style={styles.personDescStyle}>签到</Text>
                                        </View>
                                    </TouchableOpacity>
                                </View>
                            </View>
                            <View style={styles.bottomVipContainerStyle}>
                                <View style={styles.clubDescContainerStyle}>
                                    {flag ? <Text
                                                allowFontScaling={false}
                                                style={styles.vipTextStyle}>恭喜您下月1日即可升级为VIP会员。</Text> :
                                            <Text allowFontScaling={false}
                                                  style={styles.vipTextStyle}>离{userInfo.benefit_rule ? userInfo.benefit_rule.next_level : ''}
                                                还差
                                                {userInfo.benefit_rule ? userInfo.benefit_rule.need_num : ''}次,
                                                {userInfo.benefit_rule ? userInfo.benefit_rule.need_mon : ''}元,就能解锁</Text>}
                                    <View style={{flexDirection: 'row'}}>
                                        <View style={styles.giftImgStyle}>
                                            <Image style={styles.giftImgStyle2}
                                                   source={require('../Img/me/icon_vip_@3x.png')}/>
                                        </View>
                                        <View style={styles.giftImgStyle}>
                                            <Image style={styles.giftImgStyle2}
                                                   source={require('../Img/me/icon_specialoffers_@3x.png')}/>
                                        </View>
                                    </View>
                                </View>
                                {this._vipTriba()}
                            </View>
                        </View>
                    )
                }
                if (userName === "VIP") {
                    return (
                        <View style={styles.bottomContainer}>
                            <View style={styles.userInfoContainer}>
                                <View style={styles.advarContainerStyle}>
                                    {this._renderPortrai()}
                                    <Image
                                        source={require('../Img/me/img_tag_@2x.png')}
                                        style={styles.vipTextContainer}
                                    >
                                        <Text allowFontScaling={false} style={styles.vipTextStyle}>
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : ''}</Text>
                                    </Image>
                                    <Image style={styles.crowIconStyle}
                                           source={require('../Img/me/icon_crown_@2x.png')}/>
                                </View>
                                <View style={styles.advarRightContainerStyle}>
                                    <Text allowFontScaling={false}
                                          style={styles.nameTextStyle}>{userInfo.check_member_info ? userInfo.check_member_info.cust_name : ''}</Text>
                                    <TouchableOpacity activeOpacity={1} onPress={this._onSignClick.bind(this)}>
                                        <View style={styles.signContainerStyle}>
                                            <Image style={styles.signImg} source={require('../Img/me/icon_sign_.png')}/>
                                            <Text allowFontScaling={false} style={styles.personDescStyle}>签到</Text>
                                        </View>
                                    </TouchableOpacity>
                                </View>
                            </View>
                            <View style={styles.bottomVipContainerStyle}>
                                <View style={styles.clubDescContainerStyle}>
                                    <Text allowFontScaling={false} style={styles.vipTextStyle}>今日会员特价，点击了解更多 →</Text>
                                </View>
                                {this._vipTriba()}
                            </View>
                        </View>
                    )
                }
            } else {
                if (userName === "钻石级") {
                    return (
                        <View style={styles.bottomContainer}>
                            <View style={styles.userInfoContainer}>
                                <View style={styles.advarContainerStyle}>
                                    {this._renderPortrai()}
                                    <Image
                                        source={require('../Img/me/icon_viptag_purple_@3x.png')}
                                        style={styles.vipTextContainer}
                                    >
                                        <Text allowFontScaling={false} style={styles.vipTextStyle}>
                                            {userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : ''}</Text>
                                    </Image>
                                    <Image style={styles.crowIconStyle}
                                           source={require('../Img/me/icon_crown_purple_@3x.png')}/>
                                </View>
                                <View style={styles.advarRightContainerStyle}>
                                    <Text allowFontScaling={false}
                                          style={styles.nameTextStyle}>{userInfo.check_member_info ? userInfo.check_member_info.cust_name : ''}</Text>
                                    <TouchableOpacity activeOpacity={1} onPress={this._onSignClick.bind(this)}>
                                        <View style={styles.signContainerStyle}>
                                            <Image style={styles.signImg} source={require('../Img/me/icon_sign_.png')}/>
                                            <Text allowFontScaling={false} style={styles.personDescStyle}>签到</Text>
                                        </View>
                                    </TouchableOpacity>
                                </View>
                            </View>
                            <View style={styles.bottomVipContainerStyle}>
                                <View style={styles.clubDescContainerStyle}>
                                    {flag ? <Text
                                                allowFontScaling={false}
                                                style={styles.vipTextStyle}>恭喜您下月1日即可升级为VIP会员。</Text> :
                                            <Text allowFontScaling={false} style={styles.vipTextStyle}>今日会员特价，点击了解更多 →</Text>}
                                </View>
                                {this._vipTriba()}
                            </View>
                        </View>
                    )
                }
            }
        } else {
            if (nextName === "VIP") {
                return (
                    <View style={styles.bottomContainer}>
                        <View style={styles.userInfoContainer}>
                            <View style={styles.advarContainerStyle}>
                                {this._renderPortrai()}
                                <Image
                                    source={require('../Img/me/icon_viptag_pink_@3x.png')}
                                    style={styles.vipTextContainer}
                                >
                                    <Text allowFontScaling={false} style={styles.vipTextStyle}>
                                        {userInfo.benefit_rule ? userInfo.benefit_rule.custLevel : ''}</Text>
                                </Image>
                                <Image style={styles.crowIconStyle}
                                       source={require('../Img/me/icon_crown_pink_@3x.png')}/>
                            </View>
                            <View style={styles.advarRightContainerStyle}>
                                <Text allowFontScaling={false}
                                      style={styles.nameTextStyle}>{userInfo.check_member_info ? userInfo.check_member_info.cust_name : ''}</Text>
                                <TouchableOpacity activeOpacity={1} onPress={this._onSignClick.bind(this)}>
                                    <View style={styles.signContainerStyle}>
                                        <Image style={styles.signImg} source={require('../Img/me/icon_sign_.png')}/>
                                        <Text allowFontScaling={false} style={styles.personDescStyle}>签到</Text>
                                    </View>
                                </TouchableOpacity>
                            </View>
                        </View>
                        <View style={styles.bottomVipContainerStyle}>
                            <View style={styles.clubDescContainerStyle}>
                                {flag ? <Text
                                    allowFontScaling={false}
                                    style={styles.vipTextStyle}>恭喜您下月1日即可升级为VIP会员。</Text> :
                                    <Text allowFontScaling={false}
                                          style={styles.vipTextStyle}>离{userInfo.benefit_rule ? userInfo.benefit_rule.next_level : ''}
                                        还差
                                        {userInfo.benefit_rule ? userInfo.benefit_rule.need_mon : ''}元,就能解锁</Text>}
                                <View style={{flexDirection: 'row'}}>
                                    <View style={styles.giftImgStyle}>
                                        <Image style={styles.giftImgStyle2}
                                               source={require('../Img/me/icon_giftB_@3x.png')}/>
                                    </View>
                                    <View style={styles.giftImgStyle}>
                                        <Image style={styles.giftImgStyle2}
                                               source={require('../Img/me/icon_longevity_@3x.png')}/>
                                    </View>
                                </View>
                            </View>
                            {this._vipTriba()}
                        </View>
                    </View>
                )
            }
        }
    }


    /**
     * Vip 会员俱乐部
     */
    _vipTriba() {
        let self = this;
        return (
            <TouchableOpacity
                activeOpacity={1}
                onPress={self._onClubClick.bind(this)}
                style={{
                    width:ScreenUtils.scaleSize(170),
                    height:ScreenUtils.scaleSize(78),
                    alignItems:"flex-end",
                    justifyContent:"center"
                }}
            >
                <Text allowFontScaling={false} style={styles.clubDescStyle}>会员俱乐部 ></Text>
            </TouchableOpacity>
        )
    }

    /**
     * 渲染vip描述信息
     * @private
     *
     */
    _renderPortrai() {
        let userInfo = this.state.userInfo ? this.state.userInfo : "";
        let custPhoto = userInfo.check_member_info ? userInfo.check_member_info.cust_photo : '';
        custPhoto = custPhoto + '#' + (new Date().getTime());
        return (
            <TouchableWithoutFeedback
            onPress={()=>{
                this._onCustPhoto();
            }}
            >
                <Image style={styles.advarStyle} source={{uri: custPhoto}}/>
            </TouchableWithoutFeedback>
        )
    }


    /**
     *
     * @private
     */
    _onCustPhoto(){
        RouteManager.routeJump({
            page: routeConfig.PersonalInformation
        })
    }

    /**
     * 点击签到
     * @private
     */
    _onSignClick() {
        DataAnalyticsModule.trackEvent2('AP1706C019F008001O008001', "");
        //RnConnect.pushs({page: routeConfig.MePageocj_Sign});
        RouteManager.routeJump({
            page: routeConfig.Sign
        })
    }

    /**
     * 俱乐部
     * @private
     */
    _onClubClick() {
        DataAnalyticsModule.trackEvent2('AP1706C019F010001A001001', "");
        //Actions.MeVipPromotion({value: AppConst.H5_BASE_URL + '/oclub/moblieOclubInfo'});
        RouteManager.routeJump({
            page: routeConfig.WebView,
            param: {url: AppConst.H5_BASE_URL + '/oclub/moblieOclubInfo'},
            fromPage: routeConfig.MePage,
        })
    }

    componentDidUnMount() {
        if (this.UserSignRequest) this.UserSignRequest.setCancled(true);
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(360),
    },
    containerbg: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(360),
        paddingTop: getStatusHeightHome(),
    },
    topTouchArea: {
        height: 30,
        width: 30,
        alignItems: "center",
        justifyContent: "center"
    },
    bottomContainer: {
        position: 'absolute',
        left: 0,
        right: 0,
        bottom: 0
    },
    advarStyle: {
        width: ScreenUtils.scaleSize(140),
        height: ScreenUtils.scaleSize(140),
        borderRadius: ScreenUtils.scaleSize(70),
        borderWidth: ScreenUtils.scaleSize(5),
        borderColor: '#F37E8A',
        marginBottom: ScreenUtils.scaleSize(-25)
    },
    bottomVipContainerStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        height: ScreenUtils.scaleSize(78),
        backgroundColor: '#CF311A',
        paddingLeft: ScreenUtils.scaleSize(30),
        paddingRight: ScreenUtils.scaleSize(30),
    },
    vipTextStyle: {
        color: '#fff',
        fontSize: ScreenUtils.setSpText(24),
        backgroundColor: 'transparent'
    },
    giftImgStyle: {
        width: ScreenUtils.scaleSize(34),
        height: ScreenUtils.scaleSize(34),
        backgroundColor: '#FFFFFF50',
        borderRadius: ScreenUtils.scaleSize(34),
        marginLeft: ScreenUtils.scaleSize(5),
    },
    giftImgStyle2: {
        width: ScreenUtils.scaleSize(34),
        height: ScreenUtils.scaleSize(34),
    },
    clubDescStyle: {
        color: '#FFFFFF',
        fontSize: ScreenUtils.setSpText(24)
    },
    clubDescContainerStyle: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    userInfoContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingLeft: ScreenUtils.scaleSize(50),
    },
    advarContainerStyle: {
        alignItems: 'center'
    },
    vipTextContainer: {
        ...Platform.select({
            ios: {
                width: ScreenUtils.scaleSize(150),
                height: ScreenUtils.scaleSize(40),
                justifyContent: 'center',
                alignItems: 'center'
            },

            android: {
                width: ScreenUtils.scaleSize(150),
                height: ScreenUtils.scaleSize(40),
                justifyContent: 'center',
                alignItems: 'center'
            }
        })

    },
    crowIconStyle: {
        position: 'absolute',
        top: ScreenUtils.scaleSize(-9),
        right: ScreenUtils.scaleSize(-8)
    },
    advarRightContainerStyle: {
        marginLeft: ScreenUtils.scaleSize(33),
    },
    nameTextStyle: {
        color: '#fff',
        fontSize: ScreenUtils.setSpText(28),
        backgroundColor: 'transparent'
    },
    signContainerStyle: {
        backgroundColor: '#FFFFFF20',
        marginTop: ScreenUtils.scaleSize(20),
        flexDirection: 'row',
        paddingLeft: ScreenUtils.scaleSize(30),
        paddingRight: ScreenUtils.scaleSize(30),
        paddingTop: ScreenUtils.scaleSize(10),
        paddingBottom: ScreenUtils.scaleSize(10),
        justifyContent: 'center',
        alignItems: 'center'
    },
    signImg: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(36),
    },
    personDescStyle: {
        color: '#fff',
        fontSize: ScreenUtils.setSpText(28),
        backgroundColor: 'transparent',
        marginLeft: ScreenUtils.scaleSize(10)
    }
});