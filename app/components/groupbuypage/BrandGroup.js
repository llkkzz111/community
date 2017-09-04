/**
 * Created by MASTERMIAO on 2017/5/20.
 * 品牌团购页面
 */
'use strict';
import {
    View,
    ScrollView,
    StyleSheet,
    FlatList,
    Platform,
    TouchableOpacity,
    Image,
    LayoutAnimation
} from 'react-native';

import {
    React,
    ScreenUtils,
    Colors,
    NavigationBar,
    DataAnalyticsModule,
} from '../../config/UtilComponent';

import BrandGroupListItem,{ItemHeight} from '../../../foundation/groupby/BrandGroupListItem';
import BrandGroupTitle from '../../../foundation/Search/BrandGroupTitle';
import BrandGroupRequest from '../../../foundation/net/group/BrandGroupRequest.js';

let codeValue = '';
let pageVersionName = '';
export  default  class BrandGroup extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            data:[],
            selectedIndex: 0,
            showBackTop: false,
        };
        this.high = [];
        this.titles = [];
    }
    componentDidMount() {
        this._getBrandGroup();
    }
    render() {
        return (
            <View style={styles.containers}>
                <NavigationBar
                    title={'品牌团购'}
                    navigationBarBackgroundImage={require('../../../foundation/Img/groupbuy/Icon_brand_bg_@2x.png')}
                    navigationStyle={styles.nav}
                    titleStyle={styles.navTitleStyle}
                    leftButton={require('../../../foundation/Img/home/store/icon_back_white_.png')}
                />
                {this.titles.length>0?
                <BrandGroupTitle
                    key={new Date().getTime()}
                    titleData={this.titles}
                    selectedIndex={this.state.selectedIndex}
                    selectAction={(index) => {
                        //选中标题调到指定偏移类别
                        this._scrollToOffset(this._calculateOffSet(index),false);
                }}>
                </BrandGroupTitle>:null}
                {this.state.data?
                    <FlatList
                        ref={(scrollView) => { this._scrollView = scrollView;}}
                        scrollEventThrottle={50}
                        onScroll={(event)=>{
                            this._onScroll(event);
                        }}
                        horizontal={false}
                        style={{backgroundColor:Colors.background_grey}}
                        data={this.state.data}
                        getItemLayout={(data, index) => ({length: ItemHeight, offset: ItemHeight * index, index})}
                        renderItem={({item,index}) => (
                            <BrandGroupListItem
                                key={index}
                                data={item}
                                codeValue={codeValue}
                                pageVersionName={pageVersionName}
                            />
                        )}
                    />:null}
                {
                    this.state.showBackTop && this.state.data ?
                        <TouchableOpacity ref='backTopView'
                                          style={styles.backTopView}
                                          activeOpacity={1}
                                          onPress={() => {this._scrollView && this._scrollToOffset()}}>
                            <Image style={styles.backTopImg}
                                   source={require('../../../foundation/Img/channel/classification_channel_icon_back_top.png')}>
                            </Image>
                        </TouchableOpacity>
                        :
                        null
                }
            </View>
        )
    }

    /**
     * 获取品牌团数据
     * @private
     */
    _getBrandGroup() {
        let self = this;
        if (this.BrandGroupRequest) {
            this.BrandGroupRequest.setCancled(true);
        }
        this.BrandGroupRequest = new BrandGroupRequest({id:'AP1706A014'}, 'GET');
        this.BrandGroupRequest.showLoadingView().start(
            (response) => {
                // console.log('-----' + response.code);
                let datas = [];
                if(response.data.packageList[0].packageList && response.data.packageList[0].packageList.length>0){
                    let list = response.data.packageList[0].packageList
                    list.forEach((item,index) => {
                        if(item.componentList[1].componentList && item.componentList[1].componentList.length>0){

                            let items = item.componentList[1].componentList;
                            this.titles[index] = item.componentList[0].title;
                            this.high[index] = items.length*ItemHeight;
                            datas.push(...items);
                        }
                    })
                }
                LayoutAnimation.configureNext({
                    duration: 700, //持续时间
                    create: { // 视图创建
                        type: LayoutAnimation.Types.spring,
                        property: LayoutAnimation.Properties.scaleXY,// opacity、scaleXY
                    },
                    update: { // 视图更新
                        type: LayoutAnimation.Types.spring,
                    },
                });

                requestAnimationFrame(()=>{
                    self.setState({
                        data: datas,//三种类型 数据对象
                    });
                });
                codeValue = response.data.codeValue;
                pageVersionName = response.data.pageVersionName;
                //页面埋点
                DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
            }, (erro) => {
                // console.log(erro);
            });
    }
    /**
     * 计算偏移
     * @private
     */
    _calculateOffSet(index:Number) {
        let offset=0;
        switch (Number(index)) {
            case 0:
                offset = 0;
                break;
            case 1:
                offset = this.high[0];
                break;
            case 2:
                offset = this.high[1]+this.high[0];//偏移前面两个View的高度
                break;
            default:
                break;
        }
        return offset;
    }
    /**
     * 手动滚动标题重新定位
     * @private
     */
    _onScroll(event) {
        let y = event.nativeEvent.contentOffset.y;
        if (y > ScreenUtils.screenH) {
            this.setState({
                showBackTop: true
            })
        } else {
            this.setState({
                showBackTop: false
            })
        }
        if(y < Number(this.high[0])){
            this.setState({
                selectedIndex: 0,
            });
        }else if(y >= Number(this.high[0]) && y < (Number(this.high[0]) + Number(this.high[1]))){
            this.setState({
                selectedIndex: 1,
            });
        }else if(y >= (Number(this.high[0]) + Number(this.high[1])-50)){
            this.setState({
                selectedIndex: 2,
            });
        }
    }
    _scrollToOffset(offset = 0,animated = true) {
        if (this._scrollView) {
            this._scrollView.scrollToOffset({
                offset: offset,
                animated: animated,
            });
        }
    }
}

const styles = StyleSheet.create({
    nav:{
        height: ScreenUtils.scaleSize(128),
        ...Platform.select(
            {
                ios: {
                    marginTop: -22
                }
            }
        )
    },
    navTitleStyle:{
        color: Colors.text_white,
        backgroundColor: 'transparent',
        fontSize: ScreenUtils.scaleSize(36)
    },
    containers: {
        flex:1,
        backgroundColor:Colors.background_grey,
    },
    backTopView: {
        position: 'absolute',
        top: ScreenUtils.screenH - ScreenUtils.scaleSize(240),
        left: ScreenUtils.screenW - ScreenUtils.scaleSize(120),
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
    backTopImg: {
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
});