/**
 * Created by dongfanggouwu-xiong on 2017/7/9.
 */
'use strict';

import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Platform,
    Dimensions
} from 'react-native';
import {
    Component,
    React,
    ScreenUtils,
    Colors,
    NavigationBar,
    Actions,
    NetErro,
    DataAnalyticsModule,
} from '../../config/UtilComponent';

import GetElectronBill from '../../../foundation/net/mine/GetElectronBill';
import {AndroidRouterModule}from '../../config/AndroidModules';

const {width} = Dimensions.get('window');
let codeValue = 'AP1706C049';
let pageVersionName = 'V1';
export default class ElectronBillPage extends Component {
    constructor(props) {
        super(props);
        this.state = {
            BillData: [{rcpt_date:''},{rcpt_no:''},{tax_title:''},{rcpt_type:''}],
        }
    }
    componentDidMount() {
        this._getElectronBillList();
    }
    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }
    _getElectronBillList(){
        let self = this;
        //当请求之前存在的时候，取消之前请求
        if (this.GetElectronBill) {
            this.GetElectronBill.setCancled(true);
        }
        //创建一个请求，参数（请求参数、请求方法）
        this.GetElectronBill = new GetElectronBill({order_no:this.props.order_no,order_g_seq:this.props.order_g_seq}, 'GET');
        //显示一个进度条showLoadingView()，默认不显示
        //失败后显示后台message，setShowMessage(true) 默认不显示
        this.GetElectronBill.showLoadingView().setShowMessage(true).start(
            (response) => {
                //接口请求成功
                // console.log(response);
                DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                self.setState({
                    BillData: response.data,
                });
            }, (erro) => {
                //接口请求失败
                // console.log(erro);
            });
    }
    render() {
        let data = this.state.BillData;
        return (
            <View style={styles.Electron}>
                <NavigationBar
                    title={'查看电子发票'}
                    navigationStyle={{height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                    titleStyle={{
                        color: Colors.text_black,
                        backgroundColor: 'transparent',
                        fontSize: ScreenUtils.scaleSize(36)
                    }}
                    barStyle={'dark-content'}
                />
                <View style={{width:width,height:1,backgroundColor:'#DDDDDD'}}/>
                {data.length>0?
                <View>
                <View style={styles.viewOne}>
                    <Text style={styles.textOne} allowFontScaling={false}>时间</Text>
                    <Text style={styles.textOne} allowFontScaling={false}>发票号码</Text>
                    <Text style={styles.textOne} allowFontScaling={false}>发票抬头</Text>
                    <Text style={styles.textOne} allowFontScaling={false}>发票状态</Text>
                </View>
                <View style={{width:width,height:1,backgroundColor:'#DDDDDD'}}/>
                <View style={styles.viewTwo}>
                    <Text style={styles.textTwo}numberOfLines={1} allowFontScaling={false}>{ScreenUtils.toDate(data[0].rcpt_date,'yyyy-MM-dd')}</Text>
                    <Text style={styles.textTwo}numberOfLines={1} allowFontScaling={false}>{String(data[0].rcpt_no).substring(12,20)}</Text>
                    <Text style={styles.textTwo}numberOfLines={1} allowFontScaling={false}>{data[0].tax_title}</Text>
                    <Text style={styles.textTwo}numberOfLines={1} allowFontScaling={false}>已开具</Text>
                </View>
                    <View style={{width:width,height:1,backgroundColor:'#DDDDDD'}}/>
                    <View style={styles.payBottom}>
                        <View><Text allowFontScaling={false}></Text></View>
                    <View style={styles.orderPriceRight}>
                        <TouchableOpacity
                            activeOpacity={1}
                             onPress={()=>this.goBillDetail(data[0].rcpt_url)}
                        >
                            <Text style={[styles.btnCommonStyle, styles.paymentBottom]} allowFontScaling={false}>查看发票</Text>
                        </TouchableOpacity>
                    </View>
                    </View>
                </View>
                    :<NetErro
                        style={{flex: 1}}
                        icon={require('../../../foundation/Img/order/img_DD_2x.png')}
                        title={'您还没有电子发票信息！'}
                    />}
            </View>
        )
    }
    goBillDetail(url){
        if (url !== undefined && url !==null){
            if (Platform.OS === 'ios'){
                Actions.BillListDetailPage(url);
            }else {
                AndroidRouterModule.startSystemBrowser(url);
            }
        }

    }
}



const styles = StyleSheet.create({
    Electron:{
        flex:1
    },
    viewOne:{
        flexDirection: 'row',
        justifyContent: 'space-around',
        margin:10,
        height:20,
        alignItems:'center'
    },
    textOne:{
        color:'#666666',
        fontSize:13,
        textAlign:'center',
        width:ScreenUtils.screenW/4,
    },
    viewTwo:{
        flexDirection: 'row',
        justifyContent: 'space-around',
        margin:10,
        height:30,
        alignItems:'center'
    },
    textTwo:{
        color:'#333333',
        fontSize:13,
        textAlign:'center',
        width:ScreenUtils.screenW/4,
    },
    orderPriceRight: {
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "center"
    },
    btnCommonStyle: {
        borderRadius: 4,
        borderWidth: 0.5,
        alignSelf: "center",
        paddingRight: 10,
        paddingLeft: 10,
        paddingTop: 5,
        paddingBottom: 5,
        marginLeft: 10
    },
    paymentBottom: {
        color: "#333333",
        borderColor: "#999999",
    },
    payBottom: {
        flexDirection: "row",
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
        justifyContent: "space-between",
        height: 55,
        paddingLeft: 15,
        paddingRight: 15,
        alignItems: "center"
    },
});