/**
 * Created by wangwenliang on 2017/6/25.
 */

/**
 * Created by wangwenliang on 2017/6/10.
 * 商品详情中的积分
 */
import {
    View,
    Text,
    StyleSheet,
    Image,
    Dimensions,
    Modal,
    TouchableOpacity,
    ScrollView,
} from 'react-native';
import {
    Component,
    PureComponent,
    React,
    ScreenUtils,
} from '../../../config/UtilComponent';
const {width, height} = Dimensions.get('window');
import * as NoticeDatas from './NoticeDatas';

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
*/
const Com = __DEV__ ? Component : PureComponent;

export default class BuyNotice extends Com {
    constructor(props) {
        super(props);
        this.state = {
            show: this.props.show,
        }
    }
    componentWillReceiveProps(nextProps) {
        this.setState({show: nextProps.show});
    }

    renderText(){

        let globalData = (this.props.allDatas && this.props.allDatas.goodsDetail) ? this.props.allDatas.goodsDetail.global_type_trade_hint : "";
        if (globalData === undefined){

            let type='';
            if(this.props.allDatas&&this.props.allDatas.goodsDetail&&this.props.allDatas.goodsDetail.global_type){
                type=this.props.allDatas.goodsDetail.global_type;
            }
            if(type==='0'){ //直邮
                return NoticeDatas.getNoticeByType(NoticeDatas.TYPE_DIRECT_MAIL1);
            }else if(type==='1'){//行邮
                return NoticeDatas.getNoticeByType(NoticeDatas.TYPE_WORK_MAIL);
            }else if(type==='2'){// 桃浦 按照后台说法 就是自贸 105787
                return NoticeDatas.getNoticeByType(NoticeDatas.TYPE_SELF_4);
            }else if(type==='3'){//自贸 104615
                return NoticeDatas.getNoticeByType(NoticeDatas.TYPE_SELF);
            }else if(type==='4'){//自贸 105787 这个本身就是 桃浦 后台取消这个值了
                return "";
            }else if(type==='5'){//自贸 106137
                return NoticeDatas.getNoticeByType(NoticeDatas.TYPE_SELF_5);
            }

            return '';

        }else {
            return globalData ? globalData : "";
        }


    }

    render() {
        return (
            <Modal animationType="fade"
                   onrequestclose={() => {
                   }}
                   transparent={true}
                   visible={this.state.show}>
                <View
                    style={styles.contentContainer}
                    >
                    <Text allowFontScaling={false} style={{flex:1}} onPress={()=>{this._close()}}/>
                    <View style={styles.showContent}>
                        <View style={styles.topTitleItem1}>
                            <Text allowFontScaling={false} style={styles.topTitleText}>购买须知</Text>
                            <TouchableOpacity activeOpacity={1} onPress={() => {
                                this._close();
                            }}>
                                <Image style={styles.topImage}
                                       source={require('../../../../foundation/Img/dialog/icon_close_@3x.png')}/>
                            </TouchableOpacity>
                        </View>

                        <ScrollView style={styles.listStyle} showsVerticalScrollIndicator={false}>
                            <Text allowFontScaling={false} style={{color:'#666',fontSize:ScreenUtils.setSpText(26)}}>
                                {this.renderText()}
                            </Text>
                        </ScrollView>
                    </View>


                </View>
            </Modal>
        );
    }

    /**
     * 关闭dialog
     * @private
     */
    _close(){
        this.setState({
            show:false
        });
        this.props.onClose&&this.props.onClose();
    }
}
const styles = StyleSheet.create({

    container: {
        flex: 1,
        justifyContent: 'center',
    },

    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        width: width,
        height: height,
    },
    showContent: {
        width: width,
        // height:height*0.5,
        backgroundColor: 'white',
        // padding: 20,
        padding: ScreenUtils.scaleSize(33),
    },
    btnCancel: {
        height: 50,
        flex: 1,
        backgroundColor: "#ffb000",
        justifyContent: 'center',
        alignItems: 'center'
    },
    btnSure: {
        height: 50,
        flex: 1,
        backgroundColor: "#E5290D",
        justifyContent: 'center',
        alignItems: 'center',
    },
    topTitleItem1: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
       // height: 40,
        marginBottom: ScreenUtils.scaleSize(28)
    },
    topTitleText: {
        fontSize: ScreenUtils.setSpText(30),
        color: '#666',
        marginLeft: 15,
        flex: 1,
        textAlign: 'center',
    },
    topImage: {
        width: ScreenUtils.scaleSize(22),
        height: ScreenUtils.scaleSize(22),
        flex: 0,
    },
    listStyle: {
        maxHeight: height * 0.6,
        marginTop:ScreenUtils.scaleSize(30)
    },

});
