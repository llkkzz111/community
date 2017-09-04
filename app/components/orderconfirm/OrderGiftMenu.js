/**
 * Created by YASIN on 2017/6/10.
 * 填写订单 商品的赠品menu
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import MutiRowText from '../../../foundation/common/MutiRowText';
const icons = {
    'down': require('../../../foundation/Img/order/Icon_down_gray_.png'),
    'up': require('../../../foundation/Img/cart/Icon_up_grey_.png')
};
export default class OrderGiftMenu extends React.Component {
    static propTypes = {
        ...View.propTypes.style,
        coupous: PropTypes.array,//赠品list
        onlyOne: PropTypes.bool,//是否是单商品
        otherDesc: PropTypes.array,//其它描述信息
    }
    static defaultProps = {
        onlyOne: true
    }
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            giftExtend: false,
        };
    }

    render() {
        let topArrow = null;
        let bottomComponent = null;
        //如果是单一商品需要显示下三角
        if (this.props.onlyOne) {
            topArrow = (
                <Image
                    style={styles.topArrow}
                    source={require('../../../foundation/Img/order/icon_gift_top_.png')}
                />
            );
        }
        //如果有买一赠一等提示
        if (this.props.otherDesc && this.props.otherDesc.length > 0) {
            bottomComponent = (
                <View style={styles.otherDescContainer}>
                    {
                        this.props.coupous && this.props.coupous.length > 0 ?
                            <Image
                                style={{height: ScreenUtils.scaleSize(1)}}
                                source={require('../../../foundation/Img/order/icon_gift_dotted_.png')}
                            />
                            :
                            null
                    }
                    {this.props.otherDesc.map((gift, index)=> {
                        return (<MoreComponent key={index}>{gift}</MoreComponent>);
                    })}
                </View>
            );
        }
        let coupous = this.props.coupous;
        //如果为单商品时，当赠品》=2个的时候，显示下三角，并且截取前两个
        if (this.props.onlyOne) {
            coupous = [];
            if (this.props.coupous.length > 2 && !this.state.giftExtend) {
                for (let i = 0; i < 2; i++) {
                    coupous.push(this.props.coupous[i]);
                }
            } else {
                coupous = this.props.coupous;
            }
        }
        return (
            <View style={[styles.container, this.props.style]}>
                {topArrow}
                <View style={[styles.itemOuterContainer, this.props.onlyOne ? {backgroundColor: '#FFF1F4'} : null]}>
                    {coupous.map((item, index)=> {
                        return (
                            <View style={styles.itemContainer} key={index}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.giftTextStyle} numberOfLines={1}>{item.item_name}</Text>
                                {/*是否显示展开*/}
                                {(index === 0 && this.props.coupous.length > 2 && this.props.onlyOne) ? (
                                    <TouchableOpacity
                                        activeOpacity={1}
                                        style={styles.expandStyle}
                                        onPress={this._onExtendClick.bind(this)}
                                    >
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.giftTextStyle}>展开</Text>
                                        <Image style={styles.extendImageStyle}
                                               source={this.state.giftExtend ? icons.up : icons.down}/>
                                    </TouchableOpacity>
                                ) : null}
                            </View>
                        );
                    })}
                    {bottomComponent}
                </View>
            </View>
        );
    }

    /**
     * 展开点击
     * @private
     */
    _onExtendClick() {
        this.setState({
            giftExtend: !this.state.giftExtend
        });
    }
}
class MoreComponent extends React.Component {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isMuti: false,
            numLines: 2,
        };
    }

    render() {
        let moreComponent = null;
        if (this.state.isMuti) {
            moreComponent = (
                <TouchableOpacity
                    activeOpacity={1}
                    style={styles.expandStyle}
                    onPress={()=>{
                        if(this.state.numLines===null){
                            this.setState({
                                numLines:2,
                            });
                        }else{
                            this.setState({
                                numLines:null,
                            });
                        }
                    }}
                >
                    <Text
                        allowFontScaling={false}
                        style={styles.giftTextStyle}>展开</Text>
                    <Image style={styles.extendImageStyle}
                           source={this.state.numLines===null ? icons.up : icons.down}/>
                </TouchableOpacity>
            );
        }
        return (
            <View style={{flexDirection:'row',alignItems:'flex-start'}}>
                <MutiRowText
                    style={{flex:1}}
                    numLines={this.state.numLines}
                    onMutiCallBack={()=>{
                        if(!this.state.isMuti){
                            this.setState({
                                isMuti:true,
                            });
                        }
                    }}
                >
                    {this.props.children}
                </MutiRowText>
                {moreComponent}
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.text_white
    },
    topArrow: {
        width: ScreenUtils.scaleSize(34),
        height: ScreenUtils.scaleSize(20),
        marginLeft: ScreenUtils.scaleSize(30)
    },
    itemOuterContainer: {
        paddingVertical: ScreenUtils.scaleSize(10)
    },
    itemContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: ScreenUtils.scaleSize(20)
    },
    giftTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(22),
    },
    expandStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        marginRight: ScreenUtils.scaleSize(10)
    },
    extendImageStyle: {
        width: ScreenUtils.scaleSize(17),
        height: ScreenUtils.scaleSize(12)
    },
    otherDescContainer: {
        paddingLeft: ScreenUtils.scaleSize(20),
        paddingRight: ScreenUtils.scaleSize(20),
    },
    otherDesc: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(26),
        marginTop: ScreenUtils.scaleSize(10)
    }
});