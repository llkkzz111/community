/**
 * Created by xiang on 2017/6/1.
 * 首页关键词搜索/分类页关键词搜索
 */
'use strict';
import React, {Component, PureComponent} from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableOpacity,
    TouchableHighlight,
    TextInput,
    ScrollView,
    FlatList,
    Platform,
    StatusBar,
} from 'react-native';
import {Actions} from 'react-native-router-flux';
import RecommendKeywordRequest from '../../../foundation/net/search/RecommendKeywordRequest';
import AutoWordListRequest from '../../../foundation/net/search/AutoWordListRequest';
import Colors from '../../config/colors'
import Fonts from '../../config/fonts'
import * as Storage from '../../../foundation/LocalStorage';
import * as ScreenUtil from '../../../foundation/utils/ScreenUtil';
import {getStatusHeightHome}from '../../../foundation/common/NavigationBar';
import PressTextColor from 'FOUNDATION/pressTextColor';

const Com = __DEV__ ? Component : PureComponent;
let autoWordListRequest;
var key = 0;
export default class KeywordSearchPage extends Com {
    constructor(props) {
        super(props);
        this.state = {
            searchKeyWord: '',
            history: [],
            recommend: [],
            autoWordArray: [],
            showAutoWordList: false,
            showCancelEditor: false,
        };
        this.renderSearchBar = this.renderSearchBar.bind(this);
        this.renderSearchRecommend = this.renderSearchRecommend.bind(this);
        this.renderSearchHistory = this.renderSearchHistory.bind(this);
        this.renderAutoWordList = this.renderAutoWordList.bind(this);
        this.onItemClicked = this.onItemClicked.bind(this);
    }

    componentDidMount() {
        //初始化历史搜索记录
        Storage.load('searchHistory',
            (result) => {
                this.setState({history: result});
            },
            (e) => {
                // console.log(e);
            });
        //初始化请求热门推荐
        new RecommendKeywordRequest(null, 'GET').showLoadingView().setShowMessage(false).start(
            (responseJson) => {
                this.setState({recommend: responseJson.data});
            },
            (e) => {
                // alert(e);
            });
        //初始化自动补全关键词列表请求
        autoWordListRequest = new AutoWordListRequest(null, 'GET');

        //检索列表页面返回的检索词
        if (this.props.searchKeyWord !== undefined && this.props.searchKeyWord !== null) {
            this.setState({
                searchKeyWord: this.props.searchKeyWord,
            });
        }
    }


    render() {
        return (
            <View style={styles.container}>
                {this.renderSearchBar()}
                {this.state.showAutoWordList ? this.renderAutoWordList(this.state.autoWordArray) :
                    <ScrollView>
                        <View style={{paddingLeft: 16, paddingRight: 16}}>
                            {this.state.recommend.length > 0 ? this.renderSearchRecommend(this.state.recommend) : null}
                            {this.state.history.length > 0 ? this.renderSearchHistory(this.state.history) : null}
                        </View>
                        <View style={styles.clearSearchHistoryRow}>
                            <PressTextColor style={styles.clearSearchHistory}
                                            onPress={() => {
                                                this.setState({history: []});
                                                Storage.save('searchHistory', [], null);
                                            }}>
                                <Image source={require('../../../foundation/Img/searchpage/Icon_ashcan_@3x.png')}
                                       style={styles.clearSearchImg}
                                />
                                <Text allowFontScaling={false} style={styles.clearSearchText}>清除搜索记录</Text>
                            </PressTextColor>
                        </View>
                    </ScrollView>
                }
            </View>
        )
    }

    //自动补全推荐词列表
    renderAutoWordList(data) {
        return (
            <FlatList
                data={data}
                renderItem={({item, index}) => {
                    return (
                        <View>
                            <TouchableHighlight
                                style={styles.autoWordItem}
                                underlayColor={Colors.background_grey}
                                onPress={() => {
                                    this.onItemClicked(item.key_word);
                                }}>
                                <Text allowFontScaling={false} style={styles.autoWordText}>{item.key_word}</Text>
                            </TouchableHighlight>
                            <View style={{
                                height: ScreenUtil.scaleSize(1),
                                backgroundColor: Colors.line_grey,
                                marginLeft: 16,
                                marginRight: 16
                            }}/>
                        </View>
                    );
                }}
            />
        )
    }

    //确认搜索词
    onItemClicked(keyword) {
        if (keyword.trim().length === 0) {
            if (this.props.searchText && this.props.searchText.length > 0) {
                keyword = this.props.searchText;
            } else {
                return;
            }
        }
        if (this.state.history.indexOf(keyword) === -1) {
            let preHistory = this.state.history;
            preHistory.push(keyword);
            Storage.save('searchHistory', preHistory, null);
            this.setState({
                history: preHistory,
                searchKeyWord: keyword,
                showAutoWordList: false,
                showCancelEditor: true,
            })
        } else {
            this.setState({
                searchKeyWord: keyword,
                showAutoWordList: false,
                showCancelEditor: true,
            })
        }

        if (this.props.fromPage === 'ClassificationPage') {
            Actions.HomeSearchBase({
                searchKeyWord: keyword,
                fromPage: this.props.fromPage,
                searchText: this.props.searchText
            });
        } else if (this.props.fromPage === 'Home') {
            Actions.HomeSearchBaseFromHomeSearch({
                searchKeyWord: keyword,
                fromPage: this.props.fromPage,
                searchText: this.props.searchText
            });
        } else if (this.props.fromPage === 'StoreDetails') {
            Actions.HomeStoreDetails({
                searchKeyWord: keyword,
                fromPage: this.props.fromPage,
                searchText: this.props.searchText
            });
        }
    }

    //热门推荐
    renderSearchRecommend(data) {
        return (
            <View>
                <Text allowFontScaling={false} style={styles.keywordRowTitle}>热门推荐</Text>
                <KeywordItem data={data} onItemClicked={(item) => this.onItemClicked(item)}/>
            </View>
        )
    }

    //搜索历史
    renderSearchHistory(data) {
        return (
            <View>
                <Text allowFontScaling={false} style={styles.keywordRowTitle}>搜索历史</Text>
                <KeywordItem data={data} onItemClicked={(item) => this.onItemClicked(item)}/>
            </View>
        )

    }

    _renderStatus() {
        return (
            <StatusBar
                key={++key}
                translucent={true}
                barStyle={'dark-content'}
                backgroundColor={'transparent'}
            />
        );
    }

    //头部搜索栏
    renderSearchBar() {
        // console.log("searchbar------------->" + this.props.searchText);
        return (
            <View style={styles.titleBar}>
                {this._renderStatus()}
                <View style={styles.searchRow}>
                    <View style={styles.searchEditorRow}>
                        <Image source={require('../../../foundation/Img/header/Icon_search_@2x.png')}
                               style={styles.searchIcon}/>
                        <TextInput underlineColorAndroid={'transparent'}
                                   returnKeyType="search"
                                   clearButtonMode="never"
                                   keyboardType='web-search'
                                   autoFocus={true}
                                   placeholder={this.props.searchText}
                                   onSubmitEditing={() => {
                                       this.onItemClicked(this.state.searchKeyWord);
                                   }}
                                   onChangeText={(text) => {
                                       if (text.length > 0) {
                                           this.setState({searchKeyWord: text, showCancelEditor: true});
                                           // 放弃上次请求结果，只取最新的结果
                                           autoWordListRequest.setCancled(true);
                                           autoWordListRequest = new AutoWordListRequest({key_word: text}, 'GET');
                                           autoWordListRequest.setShowMessage(false).start(
                                               (responseJson) => {
                                                   if (responseJson.code === 200) {
                                                       this.setState({
                                                           showAutoWordList: true,
                                                           autoWordArray: responseJson.data,
                                                           showCancelEditor: true,
                                                       });
                                                   } else {
                                                       //alert(responseJson.message);
                                                   }
                                               },
                                               (e) => {
                                                   // alert(e)
                                               })

                                       } else {
                                           autoWordListRequest.setCancled(true);
                                           this.setState({
                                               searchKeyWord: text,
                                               showAutoWordList: false,
                                               showCancelEditor: false,
                                           });
                                       }
                                   }}
                                   style={styles.searchEditor}
                                   value={this.state.searchKeyWord}
                        />
                        {
                            this.state.showCancelEditor ?
                                <TouchableOpacity activeOpacity={1} onPress={() => {
                                    this.setState({
                                        searchKeyWord: '',
                                        showAutoWordList: false,
                                        showCancelEditor: false
                                    });
                                }}>
                                    <Image source={require('../../../foundation/Img/searchpage/Icon_cancel_@3x.png')}
                                           style={styles.searchRowCancelIcon}/>
                                </TouchableOpacity>
                                : null
                        }
                    </View>
                    <Text allowFontScaling={false} style={styles.searchBtnText} onPress={() => {
                        this.setState({searchKeyWord: '', showAutoWordList: false});
                        Actions.pop();
                    }}>取消</Text>
                </View>
                <View style={{height: ScreenUtil.scaleSize(1), backgroundColor: Colors.line_grey}}/>
            </View>
        )
    }
}
//搜索关键词item按钮
class KeywordItem extends React.PureComponent {
    render() {
        return (
            <View style={styles.keywordRow}>
                {
                    this.props.data.map((item, index) => {
                        return (
                            <PressTextColor style={styles.keywordItem}
                                            key={index}
                                            onPress={() => {
                                                this.props.onItemClicked(item);
                                            }}>
                                <Text allowFontScaling={false} style={styles.keywordItemText}>{item}</Text>
                            </PressTextColor>
                        )
                    })

                }
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        //backgroundColor: Colors.background_grey,
        ...Platform.select({ios: {marginTop: -22}}),
    },
    titleBar: {
        width: ScreenUtil.screenW,
        //height: ScreenUtils.scaleSize(120),
        paddingTop: getStatusHeightHome(),
        backgroundColor: Colors.text_white

    },
    autoWordItem: {
        padding: 16,
    },
    autoWordText: {
        color: Colors.text_dark_grey,
        fontSize: Fonts.standard_normal_font(),
    },
    searchRow: {
        height: 55,
        flexDirection: 'row',
        alignItems: 'center',
        paddingLeft: 16,
        paddingRight: 16,
    },
    searchEditorRow: {
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
        width: ScreenUtil.scaleSize(25),
        height: ScreenUtil.scaleSize(23),
        resizeMode: 'contain'
    },
    searchRowCancelIcon: {
        width: 15,
        height: 15,
    },
    searchEditor: {
        flex: 1,
        backgroundColor: 'transparent',
        fontSize: 14,
        paddingTop: 5,
        paddingBottom: 5,
        paddingLeft: 5
    },
    searchHint: {
        marginLeft: 16,
        color: Colors.text_light_grey,
        fontSize: Fonts.standard_normal_font(),
    },
    searchBtnText: {
        marginLeft: 16,
        color: Colors.text_dark_grey,
        fontSize: Fonts.standard_normal_font(),
    },
    keywordRowTitle: {
        marginTop: 16,
        color: Colors.text_black,
        fontSize: Fonts.standard_normal_font(),
    },
    keywordRow: {
        flexWrap: 'wrap',
        flexDirection: 'row',
        alignItems: 'center',
    },
    keywordItem: {
        borderRadius: 4,//4px
        marginTop: 10,
        marginRight: 10,
        paddingLeft: 10,
        paddingRight: 10,
        paddingTop: 5,
        paddingBottom: 5,
        backgroundColor: Colors.background_grey,
    },
    keywordItemText: {
        color: Colors.text_dark_grey,
        fontSize: Fonts.standard_normal_font(),
    },
    clearSearchHistoryRow: {
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 60,
        marginBottom: 60,
    },
    clearSearchHistory: {
        padding: 12,
        width: 300,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        borderWidth: 1,
        borderColor: Colors.line_grey,
        borderRadius: 3,
    },
    clearSearchImg: {
        width: ScreenUtil.scaleSize(26),
        height: ScreenUtil.scaleSize(32),
        resizeMode: 'stretch'
    },
    clearSearchText: {
        marginLeft: 10,
        color: Colors.text_dark_grey,
        fontSize: Fonts.standard_normal_font(),
    }
});
