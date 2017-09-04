/**
 * Created by wangwenliang on 2017/7/26.
 * 首页广告页
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
import AdvertisementPageRequest from '../../../foundation/net/home/AdvertisementPageRequest';

export default class AdvertisementPage extends React.Component {

    //构造方法
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isVisible: false,
            data:null,
        }
        //网络请求
        // this._adverRequest();
        this._firstCheck();
    }

    componentWillMount() {

    }

    componentWillUnmount() {
        this.setCloseTimer && clearTimeout(this.setCloseTimer);
    }

    //判断是不是第一次打开app
    _firstCheck(){
        AsyncStorage.getItem('IS_FIRST_OPEN', (error, object) => {
            if (object === 'NO') {
                //网络请求
                this._adverRequest();
            }else {
                AsyncStorage.setItem('IS_FIRST_OPEN', 'NO');
            }
        })
    }

    //网络请求
    _adverRequest(){
        if (this.adverR) {
            this.adverR.setCancled(true);
        }
        this.adverR = new AdvertisementPageRequest({
            id:'AP1706A050'
        }, "GET");
        this.adverR.start((response) => {
            try {

                if (response.code && response.code === 200 && response.data !=null && response.data ) {
                    let packageList = response.data.packageList;
                    if (packageList && packageList.length > 0 ){
                        //表明是图文类型
                        if (packageList[0].packageId &&
                            packageList[0].packageId === '10' &&
                            packageList[0].componentList &&
                            packageList[0].componentList.length>0){
                            let componentList = packageList[0].componentList;

                            for (let i=0 ; i<componentList.length ;i++){
                                let item = componentList[i];

                                if (item &&
                                    item.firstImgUrl &&
                                    item.firstImgUrl.length > 0 &&
                                    item.destinationUrl &&
                                    item.destinationUrl.length > 0){

                                    this.setCloseTimer = setTimeout(()=> {
                                        this.close()
                                        this.setCloseTimer && clearTimeout(this.setCloseTimer);
                                    },5000);

                                    if (item.title === '1'){//ios
                                        if (Platform.OS === 'ios'){
                                            this.setState({
                                                data:item,
                                                isVisible:true
                                            })
                                        }
                                    }else if (item.title === '2'){//android
                                        if (Platform.OS === 'android'){
                                            this.setState({
                                                data:item,
                                                isVisible:true
                                            })
                                        }
                                    }

                                }

                            }

                        }
                    }
                }

            }catch (err){
                console.log('首页中的广告页请求数据解析错误');
            }
        }, (err) => {
        });

    }

    //关闭
    close(){
        this.setState({isVisible:false});
    }

    //显示
    show(){
        this.setState({isVisible:true});
    }

    //跳转到原生webview
    jump(){
        if (this.state.data && this.state.data.destinationUrl && this.state.data.destinationUrl.length>0){
            this.props.jumpToWebView(this.state.data.destinationUrl);
            this.close();
        }
    }

    //主布局
    render(){

        return(
            <Modal
                transparent={true}
                style={styles.modal}
                visible={this.state.isVisible}
                animationType={'fade'}
                onRequestClose={() => this.close()}
            >
                <TouchableWithoutFeedback onPress={() => this.jump()}>
                    <Image style={styles.imge} resizeMode={'stretch'} source={{uri:this.state.data ? this.state.data.firstImgUrl : ""}}/>
                </TouchableWithoutFeedback>

                <TouchableWithoutFeedback style={styles.imgeCloseView} onPress={() => this.close()}>
                    <Image style={styles.imgeClose} resizeMode={'stretch'} source={require('../../../foundation/Img/home/ad_close.png')}/>
                </TouchableWithoutFeedback>

            </Modal>
        )
    }

}

const styles = StyleSheet.create({
    modal:{
        flex:1,
    },
    imge:{
        flex:1,
        height:ScreenUtils.screenH,
        width:ScreenUtils.screenW,
    },
    imgeClose:{
        height:ScreenUtils.scaleSize(48),
        width:ScreenUtils.scaleSize(48),
        position:'absolute',
        left:ScreenUtils.screenW*0.85,
        top:ScreenUtils.scaleSize(50),
    },
    imgeCloseView:{
        height:ScreenUtils.scaleSize(100),
        width:ScreenUtils.scaleSize(100),
        position:'absolute',
        left:ScreenUtils.screenW*0.85,
        top:ScreenUtils.scaleSize(50),
        justifyContent:'center',
        alignItems:'center',
    },
})


