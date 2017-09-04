/**
 * Created by jzz on 2017/7/12.
 * 首页引导图
 */

import React, {PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Image,
    Modal,
    TouchableWithoutFeedback,
    AsyncStorage,
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
export default class VipGuidePage extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isVisible: false,
            showVip: false,
        }
    }

    componentWillMount() {
    }

    componentWillUnmount() {

    }

    show() {
        if (this.props.vipOffSet.y === 0) {
            return
        }
        this.props.showVipGuideNeedScroll();
        AsyncStorage.setItem('CAN_VIP_SHOW', 'NO')
        this.setState({
            isVisible: true,
            showVip: true,
        })
    }

    vipClick() {

        this.setState({
            isVisible: false,
            showVip: false,
        })
    }

    render() {
        const { showVip } = this.state;
        return (
            <Modal transparent={true}
                   style={styles.modal}
                   visible={this.state.isVisible}
                   animationType={'fade'}
                   onRequestClose={() => {
                       this.setState({
                           isVisible: false,
                       })
                   }}>
                <View transparent={true} style={styles.containerView}>
                    {
                        showVip ?
                            <View style={styles.vipView}>
                                <TouchableWithoutFeedback onPress={() => this.vipClick()}>
                                    <Image style={[styles.vipImage, {top: this.props.vipOffSet.y - ScreenUtils.screenW / 1.5 - ScreenUtils.scaleSize(120)}]}
                                           source={require('../../../foundation/Img/HomePageGuideImgs/img_guide_vip.png')}></Image>
                                </TouchableWithoutFeedback>
                                <Image style={[styles.vipIcon,
                                    {top: this.props.vipOffSet.y - ScreenUtils.scaleSize(159)}]}
                                       source={require('../../../foundation/Img/HomePageGuideImgs/img_guide_vip_icon.png')}>
                                </Image>
                            </View>
                            :
                            null
                    }
                </View>
            </Modal>
        );
    }
}
const styles=StyleSheet.create({
    modal: {
        flex: 1,
    },
    containerView: {
        flex: 1,
        backgroundColor: 'rgba(1,1,1,0.7)',
    },
    baseStyle: {
        alignItems: 'center'
    },
    vipView: {
        flex: 1,
    },
    vipImage: {
        position: 'absolute',
        width: ScreenUtils.screenW ,
        height: ScreenUtils.screenW  / 1.5,
        resizeMode:'contain',
    },
    vipIcon: {
        position: 'absolute',
        left:ScreenUtils.screenW / 2 -  ScreenUtils.scaleSize(190),
        width: ScreenUtils.scaleSize(260),
        height: ScreenUtils.scaleSize(260),
        resizeMode:'contain',
    },

});
