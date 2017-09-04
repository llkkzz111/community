/**
 * Created by zhenzhen on 2017/7/25.
 * 订单中心待发货页面
 */
import React, {Component} from 'react';
import {
    View,
    StyleSheet,
    FlatList,
    DeviceEventEmitter,
    Platform,
    Text,
    Dimensions
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
import OrderCenterItem from './OrderCenterItem';
import GetOderListRequest from '../../../foundation/net/mine/GetOderListRequest';
import NetErro from '../error/NetErro';
import { Actions } from 'react-native-router-flux';
var key=0;
export default class OrderRequireSend extends Component{
    constructor(props) {
        super(props);
        this.state={
            pageNum:1,
            pageSize:20,
            isShowEmpty:false,
            isRefresh:false,
            datas:[],
        }
        this._renderItem = this._renderItem.bind(this);
        this._goHomePage = this._goHomePage.bind(this);
    }

    render() {
        let content=null;
        if(this.state.isShowEmpty){
            if(this.state.datas.length>0){
                content=(
                    <FlatList
                        key={key}
                        data={this.state.datas}
                        renderItem={this._renderItem}
                        refreshing={this.state.isRefresh}
                        onRefresh={() => {
                            this.setState({
                                isRefresh: true
                            }, () => {
                                this.refresh(false);
                            });
                        }}
                        onEndReachedThreshold={0.1}
                        onEndReached={()=>{
                            this.state.pageNum++;
                            this._doPost(false);
                        }}
                    />
                );
            }else{
                content=(
                    <NetErro
                        style={{flex:1}}
                        icon={require('../../../foundation/Img/order/img_DD_2x.png')}
                        title={'您还没有相关订单'}
                        confirmText={'去逛逛'}
                        onButtonClick={this._goHomePage}
                    />
                );
            }
        }
        return (
            <View style={styles.container}>
                {content}
            </View>
        );
    }

    /**
     * 渲染list
     * @param item
     * @param index
     * @returns {XML}
     * @private
     */
    _renderItem({item, index}) {
        let orderPicList=[];
        let state='';
        let itemOne={};
        if(item.items&&item.items.length>0){
            let items=item.items;
            state=items[0].proc_state_str;
            items.map((picItem,index)=>{
                orderPicList.push(picItem.contentImage);
            });
        }
        if(item.items&&item.items.length===1){
            itemOne=item.items[0];
        }
        return (
            <OrderCenterItem
                key={index}
                style={{marginTop:ScreenUtils.scaleSize(20)}}
                orderNo={''+item.order_no}
                orderState={state}
                orderPicList={orderPicList}
                goodsCount={''+item.order_qty}
                title={itemOne.item_name}
                color={itemOne.dt_info}
                type={''}
                integral={''+itemOne.save_amt}
                price={''+itemOne.sale_price}
                payAmt={''+item.sum_amt}
                freight={''}
            />
        )
    }

    /**
     * 渲染完毕
     */
    componentDidMount(){
        this.state.pageNum=1;
        this._doPost(true);
    }

    /**
     *请求数据
     * @private
     */
    _doPost(showLoading=true) {
        let self=this;
        if(this.getOderListRequest)this.getOderListRequest.setCancled(true);
        let param={
            select_type: "all_year",
            proc_state: 'payover',
            page_currPageNo: this.state.pageNum,
        };
        this.getOderListRequest=new GetOderListRequest(param,'GET');
        if(showLoading)this.getOderListRequest.showLoadingView();
        this.getOderListRequest.start((response)=>{
            this.setState({
                isShowEmpty:true,
                isRefresh:false,
            });
            if(response.data&&response.data.orderItems){
                let orderItems=response.data.orderItems;
                if(this.state.pageNum===1){
                    if(orderItems.length>=0){
                        key++;
                        this.setState({
                            datas:orderItems
                        });
                    }
                }else{
                    if(orderItems.length>0){
                        self.state.datas.push(...orderItems);
                        this.setState({
                            datas:self.state.datas
                        });
                    }else{
                        this.state.pageNum--;
                    }
                }
            }
        },(erro)=>{
            if(this.state.pageNum!==1)this.state.pageNum--;
            this.setState({
                isShowEmpty:true,
                isRefresh:false,
            });
        })
    }

    /**
     * 下拉刷新
     */
    refresh(refresh=false) {
        this.state.pageNum=1;
        this._doPost(refresh);
    }

    /**
     * 跳转到首页
     * @private
     */
    _goHomePage() {
        Actions.pop();
        setTimeout(() => {
            Actions.popTo('Home')
        }, 100);
    }
}

const styles=StyleSheet.create({
    container:{
        width:ScreenUtils.screenW,
        flex:1,
    }
});