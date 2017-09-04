/**
 * Created by lu weiguo on 2017/6月3号.
 * 今日团购页面
 */

'use strict';
import React from 'react';
import {
    View,
    Text,
    StyleSheet,
    Platform,
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
// 导航栏
import NavigationBar from '../../../foundation/common/NavigationBar';
// 零点上新品
import NewProduct from '../../../foundation/groupby/NewProduct' ;
// 请求数据
import RecommendRequest from '../../../foundation/net/group/totayGroup/RecommendRequest' ;

import {DataAnalyticsModule} from '../../config/AndroidModules';
let codeValue = 'AP1706A051';
let pageVersionName = 'V1';

export default class Ranking extends React.PureComponent {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            title:"人气推荐",
            name:"超低折扣",
            recommend:[],

            singleProductions:2
        };
        this.page = 1;
    }

    render() {
        return (
            <View style={styles.containers}>
                {this._renderTodayGroupTitle()}
                <NewProduct
                    codeValue={codeValue}
                    pageVersionName={pageVersionName}
                    dataSource={this.state.recommend}
                    onEndReached={this._nextPage.bind(this)}
                />
            </View>
        )
    }

    /**
     * 渲染 今日团购顶部 title 导航
     * @private
     */
    _renderTodayGroupTitle() {
        return (
            <NavigationBar
                renderTitle={()=>{
                    return(
                        <Text allowFontScaling={false} style={{
                            color:Colors.text_black,
                            fontSize:ScreenUtils.setSpText(34)}}
                        >{this.state.singleProductions===2?this.state.title:this.state.name}</Text>
                    )
                }}
                barStyle={'dark-content'}
                navigationStyle={{...Platform.select({ios:{marginTop:ScreenUtils.scaleSize(-44)}}),height:ScreenUtils.scaleSize(128)}}
            />
        );
    }


    componentDidMount() {
        let self = this;
        self.requestUrlData(self.props.id,self.props.singleProductitions,1,20);
    }

    requestUrlData(id,singleProductitions,pageNum,pageSize){
        let recommendRequest = new RecommendRequest({id:id,singleProductitions:singleProductitions,pageNum:pageNum,pageSize:pageSize}, 'GET');
        recommendRequest.showLoadingView().setShowMessage(false).start(
            (response) => {
                if( recommendRequest.currTime !== "" ){
                    let currTime = recommendRequest.currTime ;
                    this.currTime=currTime;
                }
                let lists = response.data.list;
                lists.forEach((item,index)=>{
                    if( item.curruntDateLong ){
                        item.curruntDateLong = this.currTime;
                    }
                })
                if(response.data){
                    this.setState({recommend:response.data.list});
                    console.log('000000000000000 === ' + this.state.recommend.length);
                    //页面埋点
                    DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                }
            }, (erro) => {
                 // console.log(erro);
            }
        );
    }

    /**
     * 刷新加载更多数据
     * @param id
     * @param singleProductitions
     * @param pageNum
     * @param pageSize
     */

    _nextPage(){
        let id = this.props.id;
        let singleProductitions = this.props.singleProductitions;
        let pageSize = 20;

        let self = this;
        this.page = this.page + 1;
        if (this.RecommendRequest) {
            this.RecommendRequest.setCancled(true);
        }
     //   let url = "/pages/relation/nextPage?id="+id+"&"+"singleProductitions="+singleProductitions+"&"+"pageNum="+this.page+"&"+"pageSize="+pageSize;
        let recommendRequest = new RecommendRequest({
            id:id,
            singleProductitions:singleProductitions,
            pageNum:this.page,
            pageSize:pageSize
        }, 'GET');
        // recommendRequest.requestUrl=(url)=>{
        //     return url;
        // }
        recommendRequest.showLoadingView().setShowMessage(false).start(
            (response) => {
                if(response.data){
                    self.setState({
                        recommend:this.state.recommend.concat(response.data.list)
                    });
                    console.log('000000000000000 === ' + this.state.recommend.length);
                }
            }, (erro) => {
                // console.log(erro);
            }
        );
    }

    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }

}
const styles = StyleSheet.create({
    containers: {
        backgroundColor:Colors.text_white,
        flex:1
    },
})















