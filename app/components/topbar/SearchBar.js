/**
 * 自定义分类模块的导航栏
 */
/**
 * <TouchableHighlight style={styles.touchable} underlayColor="transparent"
 onPress={this._onPressHightlight}>
 <View style={styles.searchBar}>

 <Text style={styles.text}>搜索</Text>
 </View>
 </TouchableHighlight>
 */
import React from 'react'
import Colors from '../../config/colors'
import {Actions} from 'react-native-router-flux';
import {getStatusHeight}from '../../../foundation/common/NavigationBar';
import * as RouteManager from '../../config/PlatformRouteManager';
import {
    StyleSheet,
    View,
    Image,
    Text,
    TouchableOpacity,
    StatusBar,
    DeviceEventEmitter,
    Platform,
} from 'react-native'
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import * as routeConfig from '../../config/routeConfig';
import RnConnect from '../../config/rnConnect';
import ClassificationGetSearchKeyRequest from '../../../foundation/net/classification/ClassificationGetSearchKeyRequest';
let key = 0;
export default class SearchBar extends React.PureComponent {
    static defaultProps = {};
    static propTypes = {
        onPressHightlight: React.PropTypes.func,
        city: React.PropTypes.string,
    };

    componentDidMount() {
        let searchKeyRequest = new ClassificationGetSearchKeyRequest({search_key: ''}, 'GET');
        this.searchText = '';
        searchKeyRequest.setShowMessage(true).start(
            (jsonResponse) => {
                if (jsonResponse.code === 200) {
                    this.setState({
                        searchText: jsonResponse.data.searchValue,
                    });
                } else {

                }
            },
            (e) => {

            }
        );
        DeviceEventEmitter.addListener('refreshClassificationStatus', () => {
            this.setState({
                barStyle: 'dark-content',
                refresh: !this.state.refresh,
            })
        })
    }

    _renderStatus() {
        return (
            <StatusBar
                ref="statusBar"
                key={++key}
                translucent={true}
                barStyle={this.state.barStyle}
                backgroundColor={'transparent'}
            />
        );
    }

    constructor(props) {
        super(props);
        this.state = {
            text: '',
            searchText: '',
            barStyle: 'dark-content',
            refresh: false,
        };
    }

    render() {
        return (
            <View style={{
                ...Platform.select({ios: {marginTop: -22}})
            }}>
                {this._renderStatus()}
                <View style={styles.headBox}>
                    <TouchableOpacity activeOpacity={1} onPress={() => {
                        // RnConnect.pushs({page: routeConfig.Homeocj_Sweep});
                        RouteManager.routeJump({
                            page: routeConfig.Sweep,
                            fromRNPage: routeConfig.Home,
                        })
                    }}>
                        <View style={styles.searchBarImgView}>
                            <Image style={styles.scanIcon}
                                   source={require('../../../foundation/Img/home/icon_scan_black_.png')}/>
                            <Text allowFontScaling={false} style={styles.searchBarText}>扫一扫</Text>
                        </View>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.searchBox}
                                      activeOpacity={1}
                                      onPress={() => {
                                          Actions.KeywordSearchPage({
                                              fromPage: 'ClassificationPage',
                                              searchText: this.state.searchText
                                          });
                                      }}>
                        <Image source={require('../../../foundation/Img/home/Icon_search_.png')}
                               style={styles.searchIcon}/>
                        <Text allowFontScaling={false} style={styles.searchText}>{this.state.searchText}</Text>
                    </TouchableOpacity>

                    <TouchableOpacity activeOpacity={1} onPress={() => {
                        Actions.MessageFromClassification({fromPage: 'Classification'})
                    }}>
                        <View style={[styles.searchBarImgView]}>
                            <Image style={styles.scanIcon}
                                   source={require('../../../foundation/Img/home/Icon_Message_Black.png')}/>
                            <Text allowFontScaling={false} style={styles.searchBarText}>消息</Text>
                        </View>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    headBox: {
        flexDirection: "row",
        paddingTop: getStatusHeight(),
        justifyContent: 'space-around',
        backgroundColor: Colors.background_white,
        borderBottomWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.background_grey,
        width: ScreenUtils.screenW,
        alignItems: 'center',
        paddingBottom: ScreenUtils.scaleSize(5)
    },
    searchBox: {
        flexDirection: 'row',
        flex: 1,  // 类似于android中的layout_weight,设置为1即自动拉伸填充
        borderWidth: 1,
        borderRadius: 2,  // 设置圆角边
        borderColor: Colors.line_grey,
        // backgroundColor: '#F8F8F8',
        alignItems: 'center',
        width: ScreenUtils.scaleSize(550),
        height: ScreenUtils.scaleSize(50),
        //paddingRight: 8,
    },
    scanIcon: {
        resizeMode: 'contain',
        height: ScreenUtils.scaleSize(44),
        width: ScreenUtils.scaleSize(44),
    },
    searchIcon: {
        width: ScreenUtils.scaleSize(22.5),
        height: ScreenUtils.scaleSize(21),
        marginHorizontal: ScreenUtils.scaleSize(10),
    },
    searchText: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(22),
        flex: 1,
        padding: 0

    },
    listMessageIcon: {
        resizeMode: 'contain',
        height: ScreenUtils.scaleSize(45),
        width: ScreenUtils.scaleSize(45),
        marginTop: ScreenUtils.scaleSize(30),
    },
    inputText: {
        flex: 1,
        backgroundColor: 'transparent',
        fontSize: 14,
        paddingTop: 5,
        paddingBottom: 5
    },
    searchBarImgView: {
        width: ScreenUtils.scaleSize(100),
        justifyContent: 'space-around',
        alignItems: 'center',
    },
    marginLeft30: {
        marginLeft: ScreenUtils.scaleSize(30),
    },
    searchBarText: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(20),
        backgroundColor: 'transparent',
        marginTop: ScreenUtils.scaleSize(5),
    }
});
