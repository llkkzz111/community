/**
 * Created by xiongmeng on 2017/5/1.
 * 商品分类页
 */
import React from 'react';
import {
    StyleSheet,
    View,
    Dimensions,
    NetInfo,
} from 'react-native';
import ClassifyRightView from './ClassifyRightView';
import ClassifyLeftList from './ClassifyLeftList';
import {Actions} from 'react-native-router-flux';
const {width} = Dimensions.get('window');
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import ClassificationDataRequest from '../../../foundation/net/classification/ClassificationDataRequest';
import SearchBar from '../../components/topbar/SearchBar';
import Toast, {DURATION} from 'react-native-easy-toast';
import NetErro from '../../components/error/NetErro';
import {DataAnalyticsModule} from '../../config/AndroidModules';
let codeValue = 'AP1707A052';
let pageVersionName = 'V1';
export default class ClassificationPage extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            rightDatas: [],
            leftDatas: [],
            moreName: '',
            noNet: false,
            showErro: false,
        };
        this.getDataFromServer = this.getDataFromServer.bind(this);
    }

    componentDidMount() {
        NetInfo.isConnected.fetch().done((isConnected) => {
            if (isConnected) {
                //有网络
                this.getDataFromServer();
            } else {
                //无网络
                this.setState({
                    noNet: true,
                    showErro: false,
                });
            }
        });
    }

    getDataFromServer() {
        new ClassificationDataRequest(null, 'GET').showLoadingView(true).setShowMessage(true).start(
            (jsonResponse) => {
                if (jsonResponse.code === 200) {
                    try {
                        let leftDatas = jsonResponse.data[0].mobCateBarVos;
                        let rightDatas = leftDatas[0].mobCateBarVos;
                        this.setState({
                            rightDatas: rightDatas ? rightDatas : [],
                            leftDatas: leftDatas ? leftDatas : [],
                            moreName: leftDatas ? leftDatas[0] : '',
                            noNet: false,
                            showErro: false,
                        });
                        DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                    } catch (e) {
                        //this.refs.toast.show(e, DURATION.LENGTH_LONG);
                        //服务异常
                        this.setState({
                            noNet: false,
                            showErro: true,
                        });
                    }
                } else {
                    this.refs.toast.show(jsonResponse.message, DURATION.LENGTH_LONG);
                }
            },
            (e) => {
                //this.refs.toast.show("code:" + e.code + "; message: " + e.message, DURATION.LENGTH_LONG);
                //服务异常
                this.setState({
                    noNet: false,
                    showErro: true,
                });
            }
        );
    }

    render() {
        return (
            <View style={{flex: 1, width: ScreenUtils.screenW}}>
                <SearchBar/>
                <View style={styles.container}>
                    {
                        // 断网
                        this.state.noNet ?
                            <NetErro
                                style={{flex: 1}}
                                icon={require('../../../foundation/Img/searchpage/img_noNetWork_2x.png')}
                                title={'您的网络好像很傲娇'}
                                confirmText={'刷新试试'}
                                onButtonClick={() => {
                                    //根据不同的页面做不同的请求
                                    NetInfo.isConnected.fetch().done((isConnected) => {
                                        if (isConnected) {
                                            this.getDataFromServer();
                                        }
                                    });
                                }}
                            />
                            :
                            //接口异常
                            this.state.showErro ?
                                <NetErro
                                    style={{flex: 1}}
                                    title={'亲，服务崩溃啦，请稍后再试。'}
                                    confirmText={'刷新试试'}
                                    onButtonClick={() => {
                                        //根据不同的页面做不同的请求
                                        NetInfo.isConnected.fetch().done((isConnected) => {
                                            if (isConnected) {
                                                this.getDataFromServer();
                                            }
                                        });
                                    }}
                                />
                                :
                                null
                    }
                    {
                        !this.state.noNet && !this.state.showErro && this.state.leftDatas.length > 0 &&
                        <ClassifyLeftList
                            width={ScreenUtils.scaleSize(180)}
                            datas={this.state.leftDatas}
                            onItemClick={(item, index) => {
                                let rightDatas = this.state.leftDatas[index].mobCateBarVos;
                                this.setState({
                                    rightDatas: rightDatas ? rightDatas : [],
                                    moreName: item,
                                });
                                this.refs.ClassifyRightView && this.refs.ClassifyRightView.toTop();
                            }}/>

                    }
                    {
                        !this.state.noNet && !this.state.showErro && this.state.leftDatas.length > 0 &&
                        <ClassifyRightView
                            ref="ClassifyRightView"
                            datas={this.state.rightDatas}
                            moreName={this.state.moreName}
                            width={width - ScreenUtils.scaleSize(180)}
                            secondClassClick={(item, index) => {
                                Actions.ClassificationProductListPage({
                                    itemCode: item.id
                                });
                            }}
                            thirdClassClick={(item, index) => {
                                Actions.ClassificationProductListPage({
                                    shopCode: item.seqShopNum,
                                    itemCode: item.id
                                });
                            }}
                        />
                    }
                </View>
                <Toast ref="toast"/>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        borderTopWidth: ScreenUtils.scaleSize(1),
        borderTopColor: Colors.line_grey,
        backgroundColor: Colors.background_white,
        flex: 1
    },
});
