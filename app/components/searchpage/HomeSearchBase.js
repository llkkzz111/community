/**
 * Created by 张龚 on 2017/5/13.
 * 搜索列表
 */
'use strict';
import React, {Component, PureComponent} from 'react';

import {
    View,
    StyleSheet,
    FlatList,
    Text,
    Platform,
    NetInfo
} from 'react-native';
import SearchTitle from '../../../foundation/Search/SearchTitle';
import SearchProductListRequest from '../../../foundation/net/search/SearchProductListRequest';
import SearchItem from '../../../foundation/Search/SearchItem';
import * as ScreenUtil from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
import FilterDialog from '../../../foundation/dialog/FilterDialog';
import BrandDialog from '../../../foundation/dialog/BrandDialog';
import Toast, {DURATION} from 'react-native-easy-toast';
import NetErro from '../../components/error/NetErro';
import Global from '../../../app/config/global';
import {connect} from 'react-redux';

// const Com = __DEV__ ? Component : PureComponent;

// const actions = [];

let searchProductListRequest;
let requestBody = {
    callback: '',
    searchItem: '',
    c_code: Global.config.X_region_cd,
    propertyG: '',
    sortName: '0',
    filterName: '',
    sale_price_pr: '',
    sale_price_end: '',
    currPageNo: '1',
};

class HomeSearchBase extends Component {
    constructor(props) {
        super(props);
        this.state = {
            displayColumn: true,//true: column;false:row
            titleHintText: '',
            dataList: [],//结果list + 推荐list
            resultList: [],//结果list
            tjList: [],//推荐list
            brandinfo: [],//品牌信息
            sxlist: [],//筛选list
            showBrandinfo: [],//筛选页面显示的品牌信息
            firstLoad: true,
            openFilter: false,
            openBrand: false,
            showErro: false,
            noNet: false,
        };
        this._flatList = {};
        this.tabView = {};
        this.page = 1;
        this.renderHeader = this.renderHeader.bind(this);
        this._onRefresh = this._onRefresh.bind(this);//下拉刷新
        this._nextPage = this._nextPage.bind(this);//请求下一页数据
        this.getDataFromRequest = this.getDataFromRequest.bind(this);//请求数据
        this.confirmClick = this.confirmClick.bind(this);//筛选pop点确定
        this.openBrandDialog = this.openBrandDialog.bind(this);//打开品牌pop
        this.closeBrandDialog = this.closeBrandDialog.bind(this);//关闭品牌pop
        this.closeAll = this.closeAll.bind(this);
        this.okClick = this.okClick.bind(this);//品牌pop点确定
        this.selectedLogoCodeArry = [];//上次选中品牌code
        this.selectedLogoNameArry = [];//上次选中品牌name
        this.selectedProductType = [0, 0, 0, 0];//上次选中商品类型
        this.otherSelects = [];//上次选中的其他分类

    }

    renderHeader() {
        return (
            <View style={{backgroundColor: '#D4D4D4'}}>
                <NetErro
                    style={{height: ScreenUtil.scaleSize(460), backgroundColor: '#D4D4D4'}}
                    icon={require('../../../foundation/Img/searchpage/img_no_search_result_2x.png')}
                    title={'真心找不到呀！'}
                    titleStyle={{fontSize: ScreenUtil.setSpText(32), color: Colors.text_black}}
                    desc={'要不要考虑换个关键词'}
                    descStyle={{fontSize: ScreenUtil.setSpText(26), color: Colors.text_light_grey}}
                />
                <View style={{
                    alignItems: 'center',
                    justifyContent: 'center',
                    backgroundColor: '#D4D4D4',
                    height: ScreenUtil.scaleSize(100)
                }}>
                    <Text allowFontScaling={false} style={{fontSize: ScreenUtil.setSpText(28),}}>·推荐商品·</Text>
                </View>
            </View>
        )
    }

    //品牌pop点确定
    okClick(codes, names) {
        this.selectedLogoCodeArry = codes;
        this.selectedLogoNameArry = names;
        this.setState({
            openFilter: true,
            openBrand: false,
        });
    }

    //品牌pop
    openBrandDialog(logos, names, types, others) {
        this.selectedLogoCodeArry = logos;
        this.selectedLogoNameArry = names;
        this.selectedProductType = types;
        this.otherSelects = others;
        this.setState({
            openFilter: false,
            openBrand: true,
        });
    }


    closeAll() {
        this.confirmClick(this.selectedLogoCodeArry,
            this.otherSelects,
            this.selectedProductType,
            requestBody.sale_price_pr,
            requestBody.sale_price_end,
            this.selectedLogoNameArry);
    }

    //关闭品牌pop
    closeBrandDialog() {
        this.setState({
            openFilter: true,
            openBrand: false,
        });
    }

    //筛选pop点确定
    confirmClick(selectedCodeArry, selectsArray, productTypes, low, high, names) {
        this.setState({
            openFilter: false,
            openBrand: false,
        });
        let types = '';
        let tmpStr = '';
        let tmpStr1 = '';
        let tmpStr2 = '';
        let changed = false;
        let select = false;

        for (let i = 0; i < productTypes.length; i++) {
            if (i === productTypes.length - 1) {
                types = types + productTypes[i];
            } else {
                types = types + productTypes[i] + ",";
            }
            if (productTypes[i] === 1) {
                select = true;
            }
        }
        this.selectedProductType = productTypes;
        if (!select) {
            types = '';
        }
        //商品类型
        if (requestBody.filterName !== types) {
            changed = true;
        }

        //最低价
        if (requestBody.sale_price_pr !== low) {
            changed = true;
        }

        //最高价
        if (requestBody.sale_price_end !== high) {
            changed = true;
        }

        //品牌
        if (selectedCodeArry.length > 0) {
            for (let i = 0; i < selectedCodeArry.length; i++) {
                if (i === selectedCodeArry.length - 1) {
                    tmpStr = tmpStr + "品牌:" + selectedCodeArry[i];
                } else {
                    tmpStr = tmpStr + "品牌:" + selectedCodeArry[i] + ",";
                }
            }
        }

        this.selectedLogoCodeArry = selectedCodeArry;
        this.selectedLogoNameArry = names;

        //其他分类
        for (let i = 0; i < selectsArray.length; i++) {
            tmpStr1 = selectsArray[i].propertyName;
            if (selectsArray[i].propertyValue.length > 0) {
                for (let j = 0; j < selectsArray[i].propertyValue.length; j++) {
                    tmpStr2 = tmpStr2 + tmpStr1 + ":" + selectsArray[i].propertyValue[j] + ",";
                }
            }

        }
        let propertyG = '';
        if (tmpStr === '' && tmpStr2 === '') {

        } else if (tmpStr !== '' && tmpStr2 === '') {
            propertyG = tmpStr;
        } else if (tmpStr === '' && tmpStr2 !== '') {
            propertyG = tmpStr2.substring(0, tmpStr2.length - 1);
        } else {
            propertyG = tmpStr + "," + tmpStr2.substring(0, tmpStr2.length - 1);
        }

        if (requestBody.propertyG !== propertyG) {
            changed = true;
        }
        this.otherSelects = selectsArray;
        if (changed) {
            requestBody.currPageNo = '1';
            requestBody.propertyG = propertyG;
            requestBody.sale_price_pr = low;
            requestBody.sale_price_end = high;
            requestBody.filterName = types;
            this.getDataFromRequest();
        }
    }

    componentWillMount() {
        this.page = 1;
        requestBody.sortName = 0;
        requestBody.searchItem = this.props.searchKeyWord;
        requestBody.propertyG = '';
        requestBody.filterName = '';
        requestBody.sale_price_pr = '';
        requestBody.sale_price_end = '';
        requestBody.currPageNo = 1;
        this.getDataFromRequest();
    }

    //上拉刷新
    _onRefresh() {
        this.page = 1;
        requestBody.currPageNo = '1';
        this.getDataFromRequest();
    }

    //加载更多
    _nextPage() {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                if (this.state.resultList.length < 24) {
                    this.refs.toast.show("已经是最后一页，没有更多了。", DURATION.LENGTH_LONG);
                } else {
                    this.page = this.page + 1;
                    requestBody.currPageNo = this.page.toString();
                    searchProductListRequest = new SearchProductListRequest(requestBody, 'GET');
                    searchProductListRequest.showLoadingView().setShowMessage(true).start(
                        (jsonResponse) => {
                            if (jsonResponse.code === 200) {
                                // console.log('-----------------------------> ' + jsonResponse.data.searchItem);
                                if (jsonResponse.data.resultStr !== null && jsonResponse.data.resultStr.length > 0) {
                                    let tempRes = this.margeData(jsonResponse.data.resultStr, []);

                                    this.setState({
                                        titleHintText: this.props.searchKeyWord,
                                        resultList: jsonResponse.data.resultStr,//结果list
                                        dataList: this.state.dataList.concat(tempRes),
                                        brandinfo: jsonResponse.data.brandinfo,
                                        firstLoad: false,
                                    });
                                } else {
                                    this.refs.toast.show("已经是最后一页，没有更多了。", DURATION.LENGTH_LONG);
                                }

                            } else {
                                //this.refs.toast.show("code:" + jsonResponse.code + "; message: " + jsonResponse.message, DURATION.LENGTH_LONG);
                            }
                        },
                        (e) => {
                            //this.refs.toast.show("code:" + e.code + "; message: " + e.message, DURATION.LENGTH_LONG);
                            this.setState({
                                titleHintText: this.props.searchKeyWord,
                                showErro: true,
                                noNet: false,
                                dataList: [],
                            });
                        }
                    );
                }

            } else {
                //无网络
                this.setState({
                    titleHintText: this.props.searchKeyWord,
                    noNet: true,
                    showErro: false,
                });
            }
        });
    }


    //切换显示模式时的数据整合
    /*
     * param result 检索结果
     * param flag   切换的模式
     *           true  一行一个
     *           false 一行两个
     *
     * return resultArr 整合后的检索结果
     */
    margeDataList(result, flag) {
        let tmpArr = [];
        let resultArr = [];
        let k = 1;
        //一行一个
        if (flag) {
            for (let i = 0; i < result.length; i++) {
                //推荐商品抬头标识
                if (result[i].tjFlag) {
                    resultArr.push(result[i]);
                } else {
                    for (let j = 0; j < result[i].length; j++) {
                        resultArr.push(result[i][j]);
                    }
                }
            }
        } else {
            //一行两个
            for (let i = 0; i < result.length; i++) {
                //推荐商品抬头标识
                if (result[i].tjFlag) {
                    if (k === 2) {
                        resultArr.push(tmpArr);
                    }
                    resultArr.push(result[i]);
                    k = 1;
                } else {
                    if (k === 2) {
                        tmpArr.push(result[i]);
                        resultArr.push(tmpArr);
                    }
                    if (k === 1) {
                        tmpArr = new Array();
                        tmpArr.push(result[i]);
                    }
                    if (k === 1 && i === result.length - 1) {
                        resultArr.push(tmpArr);
                    }
                    if (k === 2) {
                        k--;
                    } else {
                        k++;
                    }
                }
            }
        }

        return resultArr;
    }

    //切换显示模式时的数据整合
    /*
     * param result 检索结果List
     * param tjList 推荐商品List
     *
     * return margeResult 整合后的检索结果
     */
    margeData(result, tjList) {
        let obj;
        let margeResult;
        let tmpArr = [];
        let resultArr = [];
        let j = 1;
        //一行一个
        if (this.state.displayColumn) {
            if (tjList !== null && tjList.length > 0) {
                //推荐商品抬头标识作成
                obj = new Object();
                obj.tjFlag = true;
                result.push(obj);
                result = result.concat(tjList);
            }
            margeResult = result;

        } else {
            //一行两个
            for (let i = 0; i < result.length; i++) {
                if (j === 2) {
                    tmpArr.push(result[i]);
                    resultArr.push(tmpArr);
                }
                if (j === 1) {
                    tmpArr = new Array();
                    tmpArr.push(result[i]);
                }
                if (j === 1 && i === result.length - 1) {
                    resultArr.push(tmpArr);
                }
                if (j === 2) {
                    j--;
                } else {
                    j++;
                }
            }

            if (tjList !== null && tjList.length > 0) {
                //推荐商品抬头标识作成
                obj = new Object();
                obj.tjFlag = true;
                resultArr.push(obj);
                j = 1;
                //推荐商品
                for (let i = 0; i < tjList.length; i++) {
                    if (j === 2) {
                        tmpArr.push(tjList[i]);
                        resultArr.push(tmpArr);
                    }
                    if (j === 1) {
                        tmpArr = new Array();
                        tmpArr.push(tjList[i]);
                    }
                    if (j === 1 && i === tjList.length - 1) {
                        resultArr.push(tmpArr);
                    }
                    if (j === 2) {
                        j--;
                    } else {
                        j++;
                    }
                }

            }

            margeResult = resultArr;
        }

        return margeResult;
    }

    renderContent(itemData, index) {
        if (this.state.displayColumn) {
            //推荐商品抬头标识
            if (itemData.tjFlag) {
                return (
                    <View style={{
                        alignItems: 'center',
                        justifyContent: 'center',
                        backgroundColor: '#D4D4D4',
                        height: ScreenUtil.scaleSize(100)
                    }}>
                        <Text allowFontScaling={false} style={{fontSize: ScreenUtil.setSpText(28),}}>·推荐商品·</Text>
                    </View>
                );
            } else {
                return (
                    <SearchItem searchItem={itemData}
                                fromPage={this.props.fromPage}
                                displayDirection={"column" }/>
                );
            }
        } else {
            //推荐商品抬头标识
            if (itemData.tjFlag) {
                return (
                    <View style={{
                        alignItems: 'center',
                        justifyContent: 'center',
                        backgroundColor: '#D4D4D4',
                        height: ScreenUtil.scaleSize(100)
                    }}>
                        <Text allowFontScaling={false} style={{fontSize: ScreenUtil.setSpText(28),}}>·推荐商品·</Text>
                    </View>
                );
            } else {
                return (
                    <View key={"searchItemView" + index} style={{flexDirection: 'row'}}>
                        {
                            itemData.map((item, i) => {
                                return (
                                    <SearchItem searchItem={item}
                                                key={"searchItem" + index + i}
                                                fromPage={this.props.fromPage}
                                                displayDirection={"row" }/>
                                );
                            })
                        }
                    </View>
                );
            }
        }
    }

    //请求后台取数据
    getDataFromRequest() {
        let tmpArr = [];
        let tmpRrs = [];
        let seeMore = new Object();
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                searchProductListRequest = new SearchProductListRequest(requestBody, 'GET');
                searchProductListRequest.showLoadingView().setShowMessage(true).start(
                    (jsonResponse) => {
                        if (jsonResponse.code === 200) {
                            // console.log('-----------------------------> ' + jsonResponse.data.searchItem);
                            if (jsonResponse.data.brandinfo !== null && jsonResponse.data.brandinfo.length > 0) {
                                if (jsonResponse.data.brandinfo.length > 8) {
                                    for (let i = 0; i < 8; i++) {
                                        tmpArr.push(jsonResponse.data.brandinfo[i]);
                                    }
                                    seeMore.propertyValue = '1';
                                    tmpArr.push(seeMore);
                                } else {
                                    tmpArr = jsonResponse.data.brandinfo;
                                }
                            }


                            //搜索结果存在
                            if (jsonResponse.data.resultStr !== null && jsonResponse.data.resultStr.length > 0) {
                                tmpRrs = this.margeData(jsonResponse.data.resultStr, jsonResponse.data.tjlist);
                            }

                            this.setState({
                                dataList: [],//clear搜索结果
                            });
                            this.setState({
                                titleHintText: this.props.searchKeyWord,
                                dataList: tmpRrs,//结果list + 推荐list
                                resultList: jsonResponse.data.resultStr,//结果list
                                tjList: jsonResponse.data.tjlist,//推荐list
                                brandinfo: jsonResponse.data.brandinfo,
                                showBrandinfo: tmpArr,
                                sxlist: jsonResponse.data.sxlist,//筛选list
                                firstLoad: false,
                                showErro: false,
                                noNet: false,
                            });
                        } else {
                            //this.refs.toast.show("code:" + jsonResponse.code + "; message: " + jsonResponse.message, DURATION.LENGTH_LONG);
                            this.setState({
                                titleHintText: this.props.searchKeyWord,
                                showErro: true,
                                noNet: false,
                                dataList: [],
                            });
                        }
                    },
                    (e) => {
                        //this.refs.toast.show("code:" + e.code + "; message: " + e.message, DURATION.LENGTH_LONG);
                        this.setState({
                            titleHintText: this.props.searchKeyWord,
                            showErro: true,
                            noNet: false,
                            dataList: [],
                        });
                    }
                );
            } else {
                //无网络
                this.setState({
                    titleHintText: this.props.searchKeyWord,
                    noNet: true,
                    showErro: false,
                });
            }

        });
    }

    //去顶部
    // toTop() {
    //     this._flatList.scrollToIndex({viewPosition: 0.5, index: 0});
    // }

    render() {
        return (
            <View style={styles.containers}>
                <SearchTitle
                    count={4}
                    fromPage={this.props.fromPage}
                    searchText={this.props.searchText}
                    hintText={this.state.titleHintText}
                    changeSort={(index) => {
                        if (index === 3) {
                            this.setState({
                                openFilter: true,
                            })
                        } else {
                            if (index === 0) {
                                requestBody.sortName = 0;
                            } else if (index === 1) {
                                requestBody.sortName = 2;
                            } else {
                                requestBody.sortName = requestBody.sortName === 3 ? 4 : 3;
                            }
                            //requestBody.sortName = index;
                            this.page = 1;
                            if (this.state.dataList.length > 0 && !this.state.showErro) {
                                this._flatList.scrollToIndex({viewPosition: 0.5, index: 0});
                            }
                            requestBody.currPageNo = '1';
                            this.getDataFromRequest();
                        }
                    }
                    }
                    onListTypeChange={(isRow) => {
                        let data = this.margeDataList(this.state.dataList, isRow);
                        this.setState({
                            displayColumn: isRow,
                            dataList: data,
                        });

                    }
                    }
                    titleData={[
                        {selectIndex: 0, title: '推荐', range: false, isSelected: true},
                        {selectIndex: 1, title: '销量', range: false, isSelected: false},
                        {selectIndex: 2, title: '价格', range: true, isSelected: false},
                        {selectIndex: 3, title: '筛选', range: false, isSelected: false},
                    ]}/>
                {
                    //断网
                    this.state.noNet ?
                        <NetErro
                            style={{flex: 1}}
                            icon={require('../../../foundation/Img/searchpage/img_noNetWork_2x.png')}
                            title={'您的网络好像很傲娇'}
                            confirmText={'刷新试试'}
                            onButtonClick={() => {
                                //根据不同的页面做不同的请求
                                this.getDataFromRequest();
                            }}
                        />
                        :
                        //接口异常
                        this.state.showErro ?
                            <NetErro
                                style={{flex: 1}}
                                icon={require('../../../foundation/Img/searchpage/img_no_search_result_2x.png')}
                                title={'真心找不到呀！'}
                                titleStyle={{fontSize: ScreenUtil.setSpText(32), color: Colors.text_black}}
                                desc={'要不要考虑换个关键词'}
                                descStyle={{
                                    fontSize: ScreenUtil.setSpText(26),
                                    color: Colors.text_light_grey
                                }}
                            />
                            :
                            this.state.firstLoad ?
                                null
                                :
                                this.state.resultList !== null && this.state.resultList.length > 0 ?
                                    <FlatList
                                        //extraData={this.state.dataList}
                                        data={ this.state.dataList }
                                        //contentContainerStyle={ this.state.displayColumn ? styles.columnGoods : styles.rowGoods}
                                        renderItem={({item, index}) => {
                                            return (
                                                this.renderContent(item, index)
                                            );
                                        }}
                                        ref={(flatList) => {
                                            this._flatList = flatList;
                                        }}
                                        refreshing={false}
                                        onRefresh={this._onRefresh}
                                        onEndReachedThreshold={0.1}
                                        onEndReached={this._nextPage}
                                    />
                                    :
                                    this.state.tjList === null || this.state.tjList.length === 0 ?
                                        <NetErro
                                            style={{flex: 1}}
                                            icon={require('../../../foundation/Img/searchpage/img_no_search_result_2x.png')}
                                            title={'真心找不到呀！'}
                                            titleStyle={{fontSize: ScreenUtil.setSpText(32), color: Colors.text_black}}
                                            desc={'要不要考虑换个关键词'}
                                            descStyle={{
                                                fontSize: ScreenUtil.setSpText(26),
                                                color: Colors.text_light_grey
                                            }}
                                        />

                                        :
                                        <FlatList
                                            //extraData={this.state.dataList}
                                            data={ this.state.tjList }
                                            numColumns={this.state.displayColumn ? 1 : 2}
                                            contentContainerStyle={ this.state.displayColumn ? styles.columnGoods : styles.rowGoods}
                                            renderItem={({item, index}) => {
                                                return (
                                                    <SearchItem searchItem={item}
                                                                fromPage={this.props.fromPage}
                                                                displayDirection={this.state.displayColumn ? "column" : "row" }/>
                                                );
                                            }}
                                            ListHeaderComponent={this.renderHeader}
                                        />
                }
                {/*商品属性筛选*/}
                <FilterDialog brandinfo={this.state.showBrandinfo}//显示品牌
                              open={this.state.openFilter}
                              confirmClick={(selectedCodeArry, selectsArray, productTypes, low, high, names) => this.confirmClick(selectedCodeArry, selectsArray, productTypes, low, high, names)}
                              sxlist={this.state.sxlist}//筛选列表
                              selectedLogoCodeArry={this.selectedLogoCodeArry}//上次选中品牌
                              selectedNameArry={this.selectedLogoNameArry}//上次选中品牌名称
                              selectedProductType={this.selectedProductType}//上次选中商品类型
                              otherSelects={this.otherSelects}//上次选中其他分类
                              openBrandDialog={ (logos, names, types, others) => {
                                  this.openBrandDialog(logos, names, types, others)
                              } }
                />
                {/*全部品牌列表筛选*/}
                <BrandDialog brandData={this.state.brandinfo}
                             open={this.state.openBrand}
                             closeBrandDialog={ this.closeBrandDialog }
                             okClick={(codes, names) => {
                                 this.okClick(codes, names)
                             }}
                             selectedLogoCodeArry={this.selectedLogoCodeArry}//上次选中品牌
                             selectedLogoNameArry={this.selectedLogoNameArry}//上次选中品牌名称
                             closeAll={this.closeAll}
                />
                <Toast ref="toast"/>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    containers: {
        //backgroundColor: '#EDEDED',
        flex: 1,
        ...Platform.select({ios: {marginTop: -22}}),
    },
    rowGoods: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        //paddingBottom: ScreenUtil.scaleSize(200),
    },
    columnGoods: {
        flexDirection: 'column',
        //paddingBottom: ScreenUtil.scaleSize(200),
    },
    toTopView: {
        height: ScreenUtil.scaleSize(80),
        width: ScreenUtil.scaleSize(80),
        position: 'absolute',
        bottom: ScreenUtil.scaleSize(30),
        right: ScreenUtil.scaleSize(24),
        backgroundColor: Colors.background_white,
        opacity: 0,
        alignItems: 'center',
        borderRadius: ScreenUtil.scaleSize(40),
        borderWidth: 1,
        borderColor: '#D4D4D4',
        justifyContent: 'center'
    },
    toTopImg: {
        height: ScreenUtil.scaleSize(22.6),
        width: ScreenUtil.scaleSize(32),
        marginLeft: ScreenUtil.scaleSize(6),
    },
    topText: {
        fontSize: ScreenUtil.setSpText(20),
        color: Colors.text_black,
    },
});

HomeSearchBase.propTypes = {};

export default connect()(HomeSearchBase);
