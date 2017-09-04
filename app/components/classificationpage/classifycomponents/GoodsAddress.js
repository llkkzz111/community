/**
 * Created by wangwenliang on 2017/5/18.
 * 商品详情中的商品配送地址浮框
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
    Platform,
} from 'react-native';
import {
    routeConfig,
    RouteManager,
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Colors,
} from '../../../config/UtilComponent';

const {width, height} = Dimensions.get('window');

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

export default class GoodsAddress extends Com {
//     setStateAddress={this.state.address}
// setStateAddressCode={this.state.addressCode}
    constructor(props) {
        super(props);
        this.state = {
            show: this.props.show,
            dataSource: this.props.datas.treceivers,
            refresh: false,
            id: -1,
            defaultAddress: this.props.datas.defaultTreceiver,
            selectedAddress: (this.props.setStateAddress != null && this.props.setStateAddressCode) ? this.props.setStateAddress : null,
            addressCode: (this.props.setStateAddress != null && this.props.setStateAddressCode) ? this.props.setStateAddressCode : "",
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({show: nextProps.show});
    }

    renderItem(item, index) {
        let iconLoc = index == this.state.id ? require('../../../../foundation/Img/cart/location_red.png') : require('../../../../foundation/Img/cart/location_gray.png');
        let iconGet = index == this.state.id ? require('../../../../foundation/Img/cart/Icon_right_red_@2x.png') : null;
        return (
            <TouchableOpacity
                onPress={() => {
                    if (index == this.state.id) {
                        this.setState({id: -1});
                    } else {
                        this.setState({id: index});
                    }
                }}
                activeOpacity={1}
                style={{
                    height: 50, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                    borderBottomColor: Colors.line_grey,
                    borderBottomWidth: ScreenUtils.scaleSize(1)
                }}>
                <Image style={{width: 12, height: 15}} resizeMode={'contain'} source={iconLoc}/>
                <Text allowFontScaling={false} style={{
                    marginLeft: 20,
                    flex: 1,
                    fontSize: ScreenUtils.setSpText(28),
                    color: Colors.text_black
                }}>{item.addr_m}</Text>
                <View style={{width: 50, height: 50, justifyContent: 'center', alignItems: 'flex-end'}}>
                    <Image style={styles.topImage} resizeMode={'contain'} source={iconGet}/>
                </View>
            </TouchableOpacity>
        )
    }

    getSelectAddress() {
        let address = "";
        if (this.state.selectedAddress == null) {
            if (this.state.defaultAddress != null) {
                address = this.state.id == -1 ? this.state.defaultAddress.addr_m : this.state.dataSource[this.state.id].addr_m;
            }
        } else {

            if (this.state.id != -1) {
                address = this.state.dataSource[this.state.id].addr_m;
            } else {
                address = this.state.selectedAddress;
            }
        }
        return address;
    }

    render() {
        return (
            <Modal animationType="fade"
                   onrequestclose={() => {
                   }}
                   transparent={true}
                   style={styles.container}
                   visible={this.state.show}>
                <View style={styles.contentContainer}>
                    <Text allowFontScaling={false} style={{flex: 1}} onPress={() => {
                        this.props.close(false);
                    }}/>
                    <View style={styles.showContent}>

                        <View style={styles.topTitleItem1}>
                            <Text style={styles.topTitleText} allowFontScaling={false}>请选择配送地址</Text>
                            <TouchableOpacity style={{
                                width: ScreenUtils.scaleSize(66),
                                height: ScreenUtils.scaleSize(66),
                                justifyContent: 'center',
                                alignItems: 'center'
                            }} activeOpacity={1} onPress={() => {
                                {/*this.setState({show: false});*/
                                }
                                this.props.close(false);
                            }}>
                                <Image style={styles.topImage}
                                       source={require('../../../../foundation/Img/dialog/icon_close_@3x.png')}/>
                            </TouchableOpacity>
                        </View>

                        <ScrollView
                            style={(this.state.dataSource != null && this.state.dataSource.length > 0) ? styles.listStyle : {height: 0}}>
                            {this.state.dataSource != null && this.state.dataSource.map((item, id) => {
                                return (
                                    <View>
                                        {this.renderItem(item, id)}
                                    </View>
                                )
                            })}
                        </ScrollView>
                        <TouchableOpacity
                            onPress={() => {
                                {/*if (Global.token === '' || Global.tokenType === 'guest') {*/
                                }
                                {/*RnConnect.pushs({page: routeConfig.MePageocj_Login}, ((event) => {*/
                                }
                                {/*if (event.tokenType==="self"){*/
                                }
                                {/*this.props.close(false);*/
                                }
                                {/*this.props.refreshGoodsDetailDatas();*/
                                }
                                {/*}*/
                                }
                                {/*}));*/
                                }
                                {/*} else {*/
                                }
                                RouteManager.routeJump({
                                    page: routeConfig.SelectArea,
                                    param: {action: 'addAddress'}
                                }, (events) => {
                                    let object = {};

                                    if (Platform.OS === "android") {
                                        object = events;
                                        if (object != null) {
                                            if (object != null && object.addrDetail != null && object.provinceCode != null && object.cityCode != null && object.districtCode != null) {
                                                //获取相关信息
                                                //     {console.log("###### 地址信息a"+object.provinceCode);}
                                                // todo 把地址信息传入
                                                this.setState({
                                                    selectedAddress: object.addrDetail,
                                                    addressCode: {
                                                        provinceCode: object.provinceCode || "",
                                                        cityCode: object.cityCode || "",
                                                        districtCode: object.districtCode || "",
                                                    },
                                                    id: -1
                                                })
                                            }
                                        } else {
                                        }
                                    } else {
                                        let object = JSON.parse(events);
                                        // console.log("###### 地址信息a"+JSON.stringify(events));
                                        // {"district":"闵行区","proveniceCode":"10","provenice":"上海市","districtCode":"001","city":"上海市","cityCode":"001"}
                                        // "{\n  \"district\" : \"闵行区\",\n  \"proveniceCode\" : \"10\",\n  \"provenice\" : \"上海市\",\n  \"districtCode\" : \"001\",\n  \"city\" : \"上海市\",\n  \"cityCode\" : \"001\"\n}"
                                        if (object != null) {
                                            if (object != null && object.proveniceCode != null && object.cityCode != null && object.districtCode != null) {
                                                this.setState({
                                                    selectedAddress: object.provenice + object.city + object.district || "",
                                                    addressCode: {
                                                        provinceCode: object.proveniceCode || "",
                                                        cityCode: object.cityCode || "",
                                                        districtCode: object.districtCode || "",
                                                    },
                                                    id: -1
                                                })
                                            }
                                        } else {
                                        }
                                    }
                                });
                                {/*}*/
                                }
                            }}
                            activeOpacity={1}
                            style={styles.selectView}>
                            <Text allowFontScaling={false} style={styles.selectViewText}>其他地址选择</Text>
                            <Image
                                resizeMode={'stretch'}
                                style={[styles.topImage, {
                                    width: ScreenUtils.scaleSize(16),
                                    height: ScreenUtils.scaleSize(24)
                                }]}
                                source={require('../../../../foundation/Img/home/store/icon_view_more_.png')}/>
                        </TouchableOpacity>
                        <Text allowFontScaling={false}
                              style={styles.addressText}>{this.getSelectAddress()}</Text>
                    </View>
                    <View style={{flexDirection: 'row'}}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                this.props.close(false);
                            }}
                            style={styles.btnCancel}>
                            <Image
                                style={styles.addressBtn}
                                source={require('../../../../foundation/Img/goodsdetail/cancel_background@3x.png')}>
                                <Text allowFontScaling={false}
                                      style={{fontSize: ScreenUtils.setSpText(30), color: 'white', textAlign: 'center'}}>取消</Text>
                            </Image>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                //回传地址
                                if (this.state.id != -1) {
                                    let da = this.state.dataSource[this.state.id];
                                    this.props.setAddressCode({
                                        provinceCode: da.area_lgroup || "",
                                        cityCode: da.area_mgroup || "",
                                        districtCode: da.area_sgroup || "",
                                    });
                                } else if (this.state.addressCode != "") {
                                    this.props.setAddressCode(this.state.addressCode);
                                }

                                this.props.setAddress(this.getSelectAddress());
                                this.props.close(false);
                            }}
                            style={styles.btnSure}>
                            <Image
                                style={styles.addressBtn}
                                source={require('../../../../foundation/Img/goodsdetail/determine_background@3x.png')}>
                                <Text allowFontScaling={false}
                                      style={{fontSize: ScreenUtils.setSpText(30), color: 'white', textAlign: 'center'}}>确定</Text>
                            </Image>
                        </TouchableOpacity>
                    </View>
                </View>
            </Modal>
        );
    }
}
const bottomHeight = ScreenUtils.scaleSize(88);
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
        padding: ScreenUtils.scaleSize(33)
    },
    btnCancel: {
        height: bottomHeight,
        flex: 1,
        //  backgroundColor: "#ffb000",
        justifyContent: 'center',
        alignItems: 'center'
    },
    btnSure: {
        height: bottomHeight,
        flex: 1,
        //  backgroundColor: "#E5290D",
        justifyContent: 'center',
        alignItems: 'center',
    },
    addressBtn: {
        width: ScreenUtils.screenW * 0.5,
        height: bottomHeight,
        flexDirection: 'row',
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
        color: Colors.text_dark_grey,
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
        height: height * 0.2,
    },
    selectView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        height: 30,
        marginBottom: 15,
        alignItems: 'center',
    },
    selectViewText: {
        fontSize: ScreenUtils.setSpText(28),
        color: Colors.text_dark_grey,
    },
    addressText: {
        fontSize: ScreenUtils.setSpText(28),
        color: Colors.text_black,
        paddingBottom: 30,
    },
});
