/**
 * Created by MASTERMIAO on 2017/5/13.
 * 首页导航栏组件
 */
'use strict';

import React, {
    PropTypes
} from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    TouchableOpacity,

} from 'react-native';
import {Actions} from 'react-native-router-flux';
import Colors from '../../app/config/colors';
import Fonts from '../../app/config/fonts';
const {width} = Dimensions.get('window');
import * as ScreenUtil from '../utils/ScreenUtil';
import {getStatusHeightHome}from '../common/NavigationBar';

export default class SearchTitle extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            selectedIndex: 0,
            sortIndex: 0,
            listTypeIsRow: true,
            priceSort:''
        }
        this.jump = this.jump.bind(this);
        this.jumpBack = this.jumpBack.bind(this);
    }

    jumpBack() {
        if (this.props.fromPage === 'Home') {
            Actions.refresh();
            Actions.popTo("Home");
        } else if (this.props.fromPage === 'ClassificationPage') {
            Actions.refresh();
            Actions.popTo("ClassificationPage");

        }

    }
    jump(){
        //去关键词搜索页面
        if (this.props.fromPage === 'Home') {
            Actions.KeywordSearchPageHome({searchKeyWord: this.props.hintText, fromPage: this.props.fromPage,searchText:this.props.searchText});
        } else if (this.props.fromPage === 'ClassificationPage') {
            Actions.KeywordSearchPage({searchKeyWord: this.props.hintText, fromPage: this.props.fromPage,searchText:this.props.searchText});
        }
    }

    render() {
        return (
            <View style = {styles.titleBar}>
                <View>
                    <View style={styles.searchRow}>
                        <TouchableOpacity activeOpacity={1} onPress={() => {
                            this.jumpBack();
                        }} style={{width:30,height:30,alignItems:"center",justifyContent:"center"}}>
                            <Image source={require('../../foundation/Img/searchpage/Icon_back_@3x.png')}
                                   style={styles.searchRowBackIcon}/>
                        </TouchableOpacity>
                        <TouchableOpacity activeOpacity={1} style={styles.searchEditorRow}
                                          onPress={() => this.jump()}>
                            <Image source={require('../../foundation/Img/header/Icon_search_@2x.png')}
                                   style={styles.searchIcon}/>
                            <Text style={styles.searchEditorText} allowFontScaling={false}>{this.props.hintText}</Text>
                        </TouchableOpacity>
                        <TouchableOpacity activeOpacity={1} onPress={() => {
                            this.setState({listTypeIsRow: !this.state.listTypeIsRow});
                            this.props.onListTypeChange(!this.state.listTypeIsRow);
                        }}>
                            <Image
                                source={this.state.listTypeIsRow ? require('../../foundation/Img/searchpage/Icon_listrow_@3x.png') : require('../../foundation/Img/searchpage/Icon_listcolumn_@3x.png')}
                                style={styles.listTypeBtnIcon}/>
                        </TouchableOpacity>
                    </View>
                    <View style={{height:  ScreenUtil.scaleSize(0.5), backgroundColor: Colors.line_grey}}/>
                </View>
                <View style={styles.titleRow}>
                    {
                        this.props.titleData !== '' && this.props.titleData !== null && this.props.titleData.map((titleItem, i) => {
                            return (
                                <View style={styles.titleRowItem}>
                                    <TouchableOpacity
                                        style={[styles.titleRowTouchableItem, {width: width / this.props.count,}]}
                                        activeOpacity={1}
                                        onPress={() => this._clickSelect(i)}>
                                        <View style={styles.titleItemTextContainer}>
                                            {
                                                i === 3 ?
                                                    this.state.selectedIndex === 3 ?
                                                        <Image source={require('../Img/searchpage/icon_filter_red_@2x.png')}
                                                               style={styles.filterStyle}/>
                                                        :
                                                        <Image source={require('../Img/searchpage/Icon_filter_@3x.png')}
                                                               style={styles.filterStyle}/>
                                                    :
                                                    null
                                            }
                                            <Text
                                                allowFontScaling={false} style={[styles.titleItemText, {color: i === this.state.selectedIndex ? Colors.main_color : Colors.text_dark_grey}]}>{titleItem.title}</Text>
                                            {
                                                i === 2 ?
                                                    this.state.selectedIndex === 2 ?
                                                        this.state.sortIndex=== 1 ?
                                                            <Image source={require('../Img/searchpage/Icon_sort_ltoh_@3x.png')}
                                                                   style={styles.sortStyle}/>
                                                            :
                                                            <Image
                                                                source={require('../Img/searchpage/icon_desc_@2x.png')}
                                                                style={styles.sortStyle}/>

                                                        :
                                                        <Image source={require('../Img/searchpage/Icon_sort_@3x.png')}
                                                               style={styles.sortStyle}/>
                                                    :
                                                    null
                                            }

                                        </View>
                                        <View
                                            style={[styles.indicatorLine, {
                                                width: width / this.props.count,
                                                backgroundColor: i === this.state.selectedIndex ? Colors.main_color : Colors.background_white
                                            }]}/>
                                    </TouchableOpacity>
                                    <View style={styles.divideLine}/>
                                </View>
                            )
                        })
                    }
                </View>
                <View style={{height: ScreenUtil.scaleSize(1), backgroundColor: Colors.line_grey}}/>
            </View>
        )
    }

    _clickSelect = (index) => {
        let tmp = 0;
        if ( index === 2) {
            if ( this.state.sortIndex === 0) {
                tmp = 1;
            } else if ( this.state.sortIndex === 1 ){
                tmp = 2;
            } else {
                tmp = 1;
            }
        }
        this.setState({
            sortIndex: tmp,
            selectedIndex: index,
        });
        this.props.changeSort(index);
    }
}

const styles = StyleSheet.create({
    titleBar:{
        width: ScreenUtil.screenW,
        paddingTop: getStatusHeightHome(),
    },
    searchRow: {
        height: ScreenUtil.scaleSize(110),
        backgroundColor: Colors.background_white,
        flexDirection: 'row',
        alignItems: 'center',
        paddingLeft: ScreenUtil.scaleSize(20),
        paddingRight: ScreenUtil.scaleSize(20),
    },
    searchRowBackIcon: {
        height: ScreenUtil.scaleSize(32),
        width: ScreenUtil.scaleSize(20),
        resizeMode: 'contain',
    },
    searchRowCancelIcon: {
        height: ScreenUtil.scaleSize(32),
        width: ScreenUtil.scaleSize(32),
        resizeMode: 'contain',
    },
    searchEditorRow: {
        marginLeft: 10,
        marginRight: 10,
        height: 35,
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.background_grey,
        borderRadius: 3,
        paddingLeft: 10,
        paddingRight: 10,
    },
    searchIcon: {
        width: ScreenUtil.scaleSize(30),
        height: ScreenUtil.scaleSize(32),
        resizeMode: 'contain'
    },
    listTypeBtnIcon: {
        width: ScreenUtil.scaleSize(44),
        height: ScreenUtil.scaleSize(40),
        resizeMode: 'contain',
    },
    searchEditorText: {
        flex: 1,
        backgroundColor: 'transparent',
        color: Colors.text_black,
        fontSize: 14,
        marginLeft: 3,
        paddingTop: 5,
        paddingBottom: 5
    },
    searchHint: {
        marginLeft: 16,
        color: Colors.text_light_grey,
        fontSize: Fonts.page_normal_font(),
    },
    searchBtnText: {
        marginLeft: 16,
        color: Colors.text_dark_grey,
        fontSize: Fonts.page_normal_font(),
    },
    titleRow: {
        width: width,
        backgroundColor: 'white',
        //marginTop: 1,
        flexDirection: 'row'
    },
    titleRowItem: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    titleRowTouchableItem: {
        justifyContent: 'center',
        alignItems: 'center',
    },
    titleItemTextContainer: {
        height: ScreenUtil.scaleSize(76),
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row'
    },
    titleItemText: {
        color: Colors.text_dark_grey,
        fontSize: Fonts.standard_normal_font()
    },
    sortStyle: {
        height: ScreenUtil.scaleSize(24),
        width: ScreenUtil.scaleSize(24),
        marginTop:1,
        marginRight:1,
        resizeMode: 'contain',
    },

    filterStyle: {
        height: ScreenUtil.scaleSize(26),
        width: ScreenUtil.scaleSize(24),
        marginTop:1,
        marginRight:1,
        resizeMode: 'contain'
    },
    indicatorLine: {
        backgroundColor: Colors.main_color,
        height: 2,
    },
    divideLine: {
        height: 20,
        width:  ScreenUtil.scaleSize(1),
        backgroundColor: Colors.line_grey
    },
});

SearchTitle.propTypes = {
    titleData: PropTypes.array,
    count: PropTypes.number
}
