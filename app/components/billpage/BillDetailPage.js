/**
 * @author Xiang
 *
 * 发票列表
 */
import {
    View,
    Dimensions,
    Platform,
    WebView
} from 'react-native';
import {
    React,
    ScreenUtils,
    Colors,
    NavigationBar,
    NetErro,
} from '../../config/UtilComponent';

import GetBillDetailRequest from '../../../foundation/net/mine/GetBillDetailRequest'
const {width, height} = Dimensions.get('window');

export default class BillListPage extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            BillDetailData: [],
            dataItem: []
        }
    }

    componentDidMount() {
        this._getBillDetailList();
    }

    _getBillDetailList() {
        let self = this;
        //当请求之前存在的时候，取消之前请求
        if (this.GetBillDetailRequest) {
            this.GetBillDetailRequest.setCancled(true);
        }
        //创建一个请求，参数（请求参数、请求方法）
        this.GetBillDetailRequest = new GetBillDetailRequest({order_no:this.props.order_no,order_g_seq:this.props.order_g_seq}, 'GET');
        //显示一个进度条showLoadingView()，默认不显示
        //失败后显示后台message，setShowMessage(true) 默认不显示
        this.GetBillDetailRequest.showLoadingView().setShowMessage(true).start(
            (response) => {
                //接口请求成功
                // console.log(response);
                self.setState({
                    BillDetailData: response.data,
                });
            }, (erro) => {
                //接口请求失败
                // console.log(erro);
            });
    }

    // render UI 组件
    render() {
        let dataItem = this.state.BillDetailData;
        let URL = this.props.data;
        return (
            <View style={{flex:1}}>
                <NavigationBar
                    title={'查看发票'}
                    navigationStyle={{height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                    titleStyle={{
                        color: Colors.text_black,
                        backgroundColor: 'transparent',
                        fontSize: ScreenUtils.scaleSize(36)
                    }}
                    barStyle={'dark-content'}
                />
                <View style={{width:width,height:1,backgroundColor:'#DDDDDD'}}/>
                {(dataItem.length > 0) || (URL !== undefined)?
                <View style={{flex: 1}}>
                    <WebView
                        style={{width:width,height:height-20,backgroundColor:'#DDDDDD'}}
                        source={URL?{uri:URL,method:'GET'}:{uri:dataItem[0].rcpt_url,method: 'GET'}}
                        javaScriptEnabled={true}
                        domStorageEnabled={true}
                        scalesPageToFit={true}
                    />
                </View> :
                <NetErro
                    style={{flex: 1}}
                    icon={require('../../../foundation/Img/order/img_DD_2x.png')}
                    title={'您还没有发票信息！'}
                />}
            </View>
        )
    }
}