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
    Platform
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
export default class GuidePage extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isVisible: false,
            showTopGuide: false,
            showBlackboard: false,
            showLiving: false,
            showVip: false,
        }
    }

    componentWillMount() {
    }

    componentWillUnmount() {

    }

    show() {
        if(this.props.showBlackboard) {
            this.setState({
                isVisible: true,
                showBlackboard: true
            })
        } else {
            this.blackboardClick();
        }

    }

    topGuideClick() {
        this.setState({
            showTopGuide: false,
            showBlackboard: true,
        })
    }

    blackboardClick() {
        // this.props.showVipGuideNeedScroll();
        if (this.props.showVipGuide) {
            this.props.showVipGuideNeedScroll();
            AsyncStorage.setItem('CAN_VIP_SHOW', 'NO')
            this.setState({
                isVisible: true,
                showBlackboard: false,
                showVip: true,
            })
        } else {
            this.setState({
                isVisible: true,
                showBlackboard: false,
                showLiving: true,
            })
        }
    }

    vipClick() {
        this.setState({
            showVip: false,
            showLiving: true,
        })
    }

    livingClick() {
        this.setState({
            showLiving: false,
            isVisible: false,
        })
    }

    render() {
        const { showTopGuide, showBlackboard,showLiving, showVip } = this.state;
        return (
           <Modal transparent={true}
                  style={styles.modal}
                  visible={this.state.isVisible}
                  animationType={'fade'}
                  onRequestClose={() => {
                      this.setState({
                          isVisible: false,
                      })
                  }}
           >
               <View transparent={true} style={styles.containerView}>

                   {
                       showTopGuide ?
                           <TouchableWithoutFeedback onPress={() => this.topGuideClick()}>
                               <Image style={[styles.topGuide]}
                                      source={require('../../../foundation/Img/HomePageGuideImgs/img_guide.png')}>
                               </Image>
                           </TouchableWithoutFeedback>
                           :
                           null
                   }

                   {
                       showBlackboard ?
                           <View>
                               <View>
                                   <Image style={[styles.blackBoard, {
                                       ...Platform.select({
                                            ios: {
                                               top: this.props.blackBoardOffSet.y,
                                            },
                                            android: {
                                               top: this.props.blackBoardOffSet.y- 22,
                                            }})
                                       }]}
                                         source={require('../../../foundation/Img/HomePageGuideImgs/img_guide_blackboard_icon.png')}>
                                   </Image>
                               </View>
                               <TouchableWithoutFeedback onPress={() => this.blackboardClick()}>
                                   <Image style={[styles.blackBoardInfo, {top: this.props.blackBoardOffSet.y - ScreenUtils.screenW / 6.0 * 5 - 22}]}
                                          source={require('../../../foundation/Img/HomePageGuideImgs/img_black_board_image.png')}>
                                   </Image>
                               </TouchableWithoutFeedback>
                           </View>
                           :
                           null
                   }

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

                   {
                       showLiving ?
                           <View style={styles.livingView}>
                               <TouchableWithoutFeedback onPress={() => this.livingClick()}>
                                   <Image style={styles.livingImage}
                                          source={require('../../../foundation/Img/HomePageGuideImgs/img_guide_show.png')}></Image></TouchableWithoutFeedback>
                               <Image style={styles.livingIcon}
                                      source={require('../../../foundation/Img/HomePageGuideImgs/img_guide_show_icon.png')}></Image>
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
    topGuide: {
        position: 'absolute',
        left: ScreenUtils.screenW * 0.15,
        width: ScreenUtils.screenW * 0.7,
        height: ScreenUtils.screenW * 1.63 * 0.7,
        resizeMode: 'contain'
    },
    blackBoard: {
        position: 'absolute',
        left: ScreenUtils.scaleSize(-5),
        width: ScreenUtils.scaleSize(150),
        height: ScreenUtils.scaleSize(150),
    },
    blackBoardInfo: {
        position: 'absolute',
        width: ScreenUtils.screenW / 6.0 * 5,
        height: ScreenUtils.screenW / 6.0 * 5,
        resizeMode:'contain'
    },
    livingImage: {
        position: 'absolute',
        bottom: ScreenUtils.scaleSize(200),
        width: ScreenUtils.screenW * 0.9,
        height: ScreenUtils.screenW * 0.9,
        resizeMode:'contain'
    },
    livingIcon: {
        position: 'absolute',
        bottom: 0,
        width: ScreenUtils.scaleSize(160),
        height: ScreenUtils.scaleSize(160),
        resizeMode:'contain',
    },
    livingView: {
        alignItems: 'center',
        position: 'absolute',
        bottom: -10,
        height: ScreenUtils.screenH,
        width: ScreenUtils.screenW,
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
