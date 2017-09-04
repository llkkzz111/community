/**
 * Created by Administrator on 2017/5/9.
 *   ExchangeDetail: 换货详情 退货详情 查看物流  公共页面
 *   pageID:        exchange return  logistics
 */
'use strict';

import React from 'react'

import NetErro from '../../app/components/error/NetErro';

import {
    TouchableOpacity,
    View,
    Text,
    FlatList,
    StyleSheet,
    ScrollView,
    Dimensions,
    Image,
    Platform
} from 'react-native'
import Fonts from  '../../app/config/fonts';
import LoadingDialog from '../dialog/LoadingDialog'
const {width, height} = Dimensions.get('window');
import * as OrderAction from '../../app/actions/orderaction/orderAction'
import GetChangeDetail from '../net/mine/GetChangeDetail';
import GetLogisticsDetail from '../net/mine/GetLogisticsDetail'
import NavigationBar from '../../foundation/common/NavigationBar';
import Colors from '../../app/config/colors';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
const datas = ['row1', 'row2', 'row3', 'row4'];
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
//eventCodeValue AP1706C034D003002C003001 物流 AP1706C035F008001O008001 退货 AP1706C036F008001O008001 换货
//codeValue AP1706C034D003001C003001 物流  AP1706C035D003001C003001 退货  AP1706C036D003001C003001 换货
let eventCodeValue = 'AP1706C034D003002C003001';
let codeValue = 'AP1706C034D003001C003001';
let pageVersionName = 'V1';
import KeFuRequest from '../net/GoodsDetails/KeFuRequest';
import {Actions} from 'react-native-router-flux';

//物流记录Item
class Item extends React.PureComponent {
    render() {
        let data = this.props.data.item;
        let status; //未通过红色  通过绿色   没有到那一步灰色
        let distans = Number(this.props.length) - Number(this.props.index);//等于length-1是最后一个
        //对于未完成流程部分
        if(this.props.pageID === 'return')
        {
            //退货默认是空心绿边框
            status = styles.midCircleColorEmpty;
        }else
        {
            //其他默认是实心灰
            status = styles.midCircleColor;
        }
        //对于已完成流程部分 1.退换货时后台应返回退换货状态所有流程 2.流程到达那一步来判断标签颜色
        //当前逻辑是默认返回流程都通过
        if (Number(this.props.index) < Number(this.props.length))
        {
            //开始是正常实心绿
            status = styles.midCircleColorOK;
        }else if(this.props.data.item.detail.indexOf('未通过') >= 0)
        {
            //未通过是实心红
            status = styles.midCircleColorAttention;
        }

        return (
            <View style={styles.rowContainer}>
                <View style={styles.logContainer}>
                    {/*控制上边线*/}
                    <View style={[styles.topLine, Number(this.props.index) > 0 ? styles.progressLineColor : {}]}/>
                    {/*控制中间圆心*/}
                    <View style={[styles.midCircle, status]}/>
                    {/*控制下边线*/}
                    <View style={[styles.bottomLine,distans > 1 ? styles.progressLineColor : {}]}/>
                </View>
                <View style={[styles.logisticImgText, distans > 1 ? styles.buttomBorder : {}]}>
                    <View style={styles.logisticTopTextView}>
                        {/*文字描述*/}
                        <Text allowFontScaling={false}
                            style={[styles.logisticText, Number(this.props.index) === 0 ? styles.textSpecColor : {}]}>{data.detail}</Text>
                        {/*时间描述*/}
                        <Text allowFontScaling={false} style={styles.logisticText}>{data.date + ' ' + data.time} </Text>
                    </View>
                </View>
            </View>
        );
    }
}
Item.defaultProps = {
    index: 0,
    data: '',
    length: 0,
};
//查看物流header
// class Logistics extends React.PureComponent {
//     render() {
//         let data = this.props.data;
//         return (
//             <View>
//
//             </View>
//         );
//     }
// }
// Logistics.defaultProps = {
//     data: [],
// };
//退换货商品详情
class ExchangeGoodsDetail extends React.PureComponent {
    render() {
        let data = this.props.data;
        let pageID = this.props.pageID;
        return (
            <View style={styles.container}>
                <View style={[styles.logisticListTop, styles.buttomBorder]}>
                    <Text allowFontScaling={false} style={styles.logisticText}>换货信息</Text>
                </View>
                <View style={[styles.logisticStatus, styles.buttomBorder]}>
                    <View style={styles.logisticImgView}>
                        <Image
                            source={{uri: 'http://cdnimg.ocj.com.cn/item_images/item/15/08/6226/15086226L.jpg'}}
                            style={styles.imageSize}/>
                    </View>
                    <View style={styles.logisticImgText}>
                        <View style={styles.logisticTopView}>
                            <Text allowFontScaling={false} style={styles.logisticTopText}>博朗（Braun）HD580家用便携大功率离子电吹风 吹风机 </Text>
                        </View>
                        <Text allowFontScaling={false} style={styles.logisticColor}>颜色分类：白色</Text>
                        <View style={styles.logisticNum}>
                            <Text allowFontScaling={false} style={styles.red}>¥</Text>
                            <Text allowFontScaling={false} style={styles.priceText}>500 </Text>
                            <Text allowFontScaling={false} style={styles.scoreText}>积分 </Text>
                            <Text allowFontScaling={false} style={styles.scoreNum}>5 </Text>
                            <Text allowFontScaling={false} style={styles.count}>x1 </Text>
                        </View>
                    </View>
                </View>
                {pageID === 'exchange' ?
                    <View style={styles.containerList}>
                        <Text allowFontScaling={false} style={styles.textH}>换货类型：</Text>
                        <Text allowFontScaling={false} style={styles.textH}>换货原因：</Text>
                        <Text allowFontScaling={false} style={styles.textH}>申请时间：</Text>
                        <Text allowFontScaling={false} style={styles.textH}>换货编号：</Text>
                    </View> : <View />}
                {pageID === 'return' ?
                    <View style={styles.containerList}>
                        <Text allowFontScaling={false} style={styles.textH}>退款类型：</Text>
                        <Text allowFontScaling={false} style={styles.textH}>退款原因：</Text>
                        <Text allowFontScaling={false} style={styles.textH}>退款金额：</Text>
                        <Text allowFontScaling={false} style={styles.textH}>申请时间：</Text>
                        <Text allowFontScaling={false} style={styles.textH}>退款编号：</Text>
                    </View> : <View />}
            </View>
        );
    }
}
ExchangeGoodsDetail.defaultProps = {
    data: [],
    pageID: 'exchange',
};
//物流列表
class LogisticsDetail extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            showLoading: true,
            dataItem: [],
            LogisticsDatas: [],
            docList: []
        }
    }

    componentDidMount() {
        // let {Data} = this.props._data;
        this._getLogisticsDetail()

    }

    //获取物流详情
    _getLogisticsDetail() {
        let self = this;
        let orderno = this.props.data.item.order_no;
        let ordername = this.props.data.item.items[0].item_name;
        //当请求之前存在的时候，取消之前请求
        if (this.GetLogisticsDetail) {
            this.GetLogisticsDetail.setCancled(true);
        }
        //创建一个请求，参数（请求参数、请求方法）
        this.GetLogisticsDetail = new GetLogisticsDetail({order_no: this.props.data.item.order_no}, 'GET');
        //显示一个进度条showLoadingView()，默认不显示
        //失败后显示后台message，setShowMessage(true) 默认不显示
        this.GetLogisticsDetail.showLoadingView().setShowMessage(true).start(
            (response) => {
                //接口请求成功
                console.log(response);
                self.setState({
                    LogisticsDatas: response.data.orderlogistics
                });
            }, (erro) => {
                //接口请求失败
                // console.log(erro);
            });
    }

    render() {
        let dataItem = this.state.LogisticsDatas
        for (var item_name in dataItem) {  //通过定义一个局部变量k遍历获取到了map中所有的key值
            this.state.docList = dataItem[item_name]; //获取到了key所对应的value的值！

        }
        return (
            <View>
                {this.state.docList.length>0?
                <View style={styles.containerLogistics}>
                    <View style={[styles.logisticListTop, styles.buttomBorder]}>
                        <Text allowFontScaling={false} style={styles.logisticText}>{this.props.pageID==='logistics'?'物流跟踪':'退换货流程'}</Text>
                    </View>

                    <FlatList
                        horizontal={false}
                        data={this.state.docList}
                        renderItem={(item) =>
                            <Item pageID={this.props.pageID} data={item} index={item.index} length={this.state.docList.length}/>
                        }
                    />
                </View>:<NetErro
                style={{flex: 1, backgroundColor: '#dddddd', marginTop: width / 2 - 44}}
                icon={require('../../foundation/Img/order/img_DD_2x.png')}
                title={'您还没有物流信息！'}
            />}
            </View>);
    }
}
LogisticsDetail.defaultProps = {
    data: [],
    title: '',//pageID !== 'logistics' ? '退换货流程' : '物流跟踪'
};


//pageID = 'logistics'=查看物流,'return'=退货详情,'exchange'=换货详情
export default class ExchangeDetail extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            showLoading: true,
            dataItem: [],
            LogisticsDatas: [],
            docList: []
        }
    }

    componentWillUnmount() {
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }

    componentDidMount() {
        switch (this.props.pageID){
            case 'logistics':
                codeValue = 'AP1706C034D003001C003001';
                eventCodeValue = 'AP1706C034D003002C003001';
                break;
            case 'return':
                codeValue = 'AP1706C035D003001C003001';
                eventCodeValue = 'AP1706C035F008001O008001';
                break;
            case 'exchange':
                codeValue = 'AP1706C036D003001C003001';
                eventCodeValue = 'AP1706C036F008001O008001';
                break;
            default:
                break;
        }
        DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);

        // let {_data} = this.props;
        // if (_data.pageID === 'logistics'){
        //     this._getLogisticsDetail()
        // }else {
        //     this._getChangeDetail();
        // }
    }

    //获取退换货详情
    _getChangeDetail() {
        let self = this;
        let {_data} = this.props;
        //当请求之前存在的时候，取消之前请求
        if (this.GetChangeDetail) {
            this.GetChangeDetail.setCancled(true);
        }
        //创建一个请求，参数（请求参数、请求方法）
        this.GetChangeDetail = new GetChangeDetail({
            orderNo: _data.data.item.order_no,
            order_g_seq: _data.data.item.items[0].o_order_g_seq,
            c_code: _data.data.item.c_code
        }, 'GET');
        //显示一个进度条showLoadingView()，默认不显示
        //失败后显示后台message，setShowMessage(true) 默认不显示
        this.GetChangeDetail.showLoadingView().setShowMessage(true).start(
            (response) => {
                //接口请求成功
                // console.log(response);
                self.setState({
                    Datas: response.data,
                });
            }, (erro) => {
                //接口请求失败
                // console.log(erro);
            });
    }

    render() {
        let pageID = this.props._data.pageID;
        return (
            <View style={styles.containers}>
                <NavigationBar
                    title={'查看物流'}
                    navigationStyle={{height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                    titleStyle={{
                        color: Colors.text_black,
                        backgroundColor: 'transparent',
                        fontSize: ScreenUtils.scaleSize(36)
                    }}
                    barStyle={'dark-content'}
                />
                <View style={{width:width,height:1,backgroundColor:'#DDDDDD'}}/>
                <ScrollView showsVerticalScrollIndicator={false}>
                    {/*<LoadingDialog*/}
                    {/*display={this.state.showLoading}*/}
                    {/*touchAvaliable={true}*/}
                    {/*touchToDismiss={true}*/}
                    {/*toDismiss={() => {*/}
                    {/*this.setState({showLoading: false});*/}
                    {/*}}*/}
                    {/*/>*/}
                    {/*退换货受理状态*/}
                    {pageID !== 'logistics' ?
                        <View style={styles.orderStatus}>
                            <Text allowFontScaling={false} style={styles.orderSTextTop}>订单状态：申请已提交</Text>
                            <Text allowFontScaling={false} style={styles.logisticText}>2017.03.29 23:30</Text>
                        </View> : <View />}
                    {/*查看物流 的商品和个人信息*/}
                    {/*{pageID === 'logistics' ?*/}
                    {/*<Logistics data={datas} /> : <View />}*/}
                    {/*商品物流*/}
                    <LogisticsDetail data={this.props._data.data} pageID={pageID}/>
                    {/*退换货商品 的详情*/}
                    {pageID !== 'logistics' ?
                        <ExchangeGoodsDetail data="" pageID={pageID}/> : <View />}
                    {/*退换货商品的联系客服服务*/}
                    {pageID !== 'logistics' ?
                        <TouchableOpacity style={styles.rowBtn} activeOpacity={1} onPress={()=>{
                            DataAnalyticsModule.trackEvent3(eventCodeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                            this.goService();
                        }
                        }>
                            <View style={styles.btn}>
                                <Text >联系客服</Text>
                            </View>
                        </TouchableOpacity> : <View/>
                    }
                </ScrollView>
            </View>
        )
    }

    // 跳转到H5东东客服
    goService = () => {
        // Actions.orderDetail({_data:dataItem});
        if (this.kefuR) {
            this.kefuR.setCancled(true)
        }
        this.kefuR = new KeFuRequest({
            order_no: "",
            item_code: "",
            imsource: "",
            last_sale_price: "",
        }, "GET");
        this.kefuR.showLoadingView(true).start((response) => {
            if (response.code !== null && response.code === 200 && response.data !== null && response.data.url) {
                Actions.VipPromotionGoodsDetail({value: response.data.url});
            } else {
                // alert("东东客服：" + JSON.stringify(response));
            }
        }, (err) => {
            // console.log(JSON.stringify(err));
        });

    }

}
ExchangeDetail.defaultProps = {
    data: datas,            //数组数据
    length: datas.length,   //数组长度
    pageID: 'exchange',//'logistics'=查看物流,'return'=退货详情,'exchange'=换货详情
};

const styles = StyleSheet.create({
    red: {
        color: '#E5290D',
        width: 60,
    },
    priceText: {
        position: 'absolute',
        left: 20,
        fontSize: 20,
        bottom: 0,
        color: '#E5290D',
    },
    scoreText: {
        fontSize: 14,
        color: '#FEFEFE',
        backgroundColor: '#FFC033',
    },
    scoreNum: {
        fontSize: 14,
        color: '#FFC033',
    },
    count: {
        position: 'absolute',
        right: 10,
        fontSize: 14,
        color: '#333333',
    },
    list: {
        marginBottom: 10,
    },
    rowContainer: {
        backgroundColor: 'white',
        flexDirection: 'row',
        height: 100,
    },
    logisticListTop: {
        height: 60,
        flexDirection: 'column',
        justifyContent: 'center',
        backgroundColor: 'white',
        paddingLeft: 10,
    },
    buttomBorder: {
        borderBottomWidth: 0.5,
        borderColor: '#DDDDDD',
    },
    logContainer: {
        flex: 1,
        width: 70,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'white',
    },
    midCircle: {
        width: 20,
        height: 20,
        borderRadius: 10,
    },
    midCircleColorOK: {
        backgroundColor: '#88D795',
    },
    midCircleColorAttention: {
        backgroundColor: '#E5290D',
    },
    textSpecColor: {
        color: '#88D795',
    },
    midCircleColor: {
        backgroundColor: '#D8D8D8',
    },
    midCircleColorEmpty: {
        borderColor: '#88D795',
        borderWidth: 1,
    },
    topLine: {
        height: 40,
        width: 1,
    },
    bottomLine: {
        height: 40,
        width: 1,
    },
    progressLineColor: {
        backgroundColor: '#88D695',
    },
    listFirst: {
        color: '#F2C062',
        // height: 25,
        fontSize: Fonts.page_normal_font(),
    },
    telColor: {
        color: 'blue',
    },
    container: {
        flexDirection: 'column',
    },
    containerLogistics: {
        flexDirection: 'column',
        marginBottom: 10,
    },
    containerList: {
        paddingTop: 20,
        paddingLeft: 20,
        paddingBottom: 10,
        flexDirection: 'column',
        backgroundColor: 'white',
        justifyContent: 'space-between',
        marginBottom: 10,
    },
    orderStatus: {
        height: 80,
        flexDirection: 'column',
        justifyContent: 'center',
        backgroundColor: 'white',
        paddingLeft: 10,
        marginBottom: 10,
    },
    logisticStatus: {
        height: 140,
        flexDirection: 'row',
        backgroundColor: 'white',
        paddingLeft: 10,
    },
    logisticStatusTel: {
        width: width,
        height: 100,
        flexDirection: 'row',
        backgroundColor: 'white',
        paddingLeft: 10,
        marginBottom: 10,
    },
    logisticImgView: {
        width: 100,
        height: 100,
        marginTop: 20,
        marginLeft: 10,
        marginRight: 10,
        marginBottom: 20,
        justifyContent: 'center',
        alignItems: 'center',
        borderColor: '#DDDDDD',
        borderWidth: 0.5,
    },
    logisticImgText: {
        flex: 4,
        paddingLeft: 10,
        justifyContent: 'center',
        backgroundColor: 'white',
    },
    logisticImgLeft: {
        width: 80,
        height: 80,
        marginTop: 10,
        marginLeft: 10,
        justifyContent: 'center',
        alignItems: 'center',
    },
    logisticImgRight: {
        position: 'absolute',
        right: 10,
        width: 40,
        height: 40,
        top: 30,
        justifyContent: 'center',
        alignItems: 'center',
    },
    logisticTopTextView: {
        // flexWrap: 'wrap',
        // height: 40,
        marginBottom: 5,
        flexDirection: 'column',
    },
    logisticTopView: {
        position: 'absolute',
        top: 20,
        paddingLeft: 10,
        flexDirection: 'row',
    },
    logisticNum: {
        width: width - 140,
        position: 'absolute',
        paddingLeft: 10,
        bottom: 20,
        flexDirection: 'row',
    },
    logisticTopText: {
        fontSize: Fonts.page_normal_font(),
        flexWrap: 'wrap',
    },
    logisticColor: {
        marginTop: 10,
    },
    logisticTopTextRight: {
        fontSize: 18,
        color: '#F2C062',
    },
    logisticText: {
        marginTop: 5,
        fontSize: 15,
        marginRight:10
    },
    largeText: {
        flexWrap: 'wrap',
    },
    orderSTextTop: {
        fontSize: 18,
        marginBottom: 5,
    },
    textH: {
        fontSize: Fonts.standard_normal_font(),
        marginBottom: 15,
        // height:25,
    },
    rowBtn: {
        height: 50,
        width: width,
        backgroundColor: 'white',
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
    },
    btn: {
        height: 30,
        width: 80,
        color: '#333333',
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: 20,
        borderColor: '#999999',
        borderWidth: 0.5,
        borderRadius: 2,
    },
    containers: {
        flex: 1,
        backgroundColor: '#DDDDDD'
    },
    imageSize: {
        height: 80,
        width: 80,
        zIndex: 0,
    },
});

