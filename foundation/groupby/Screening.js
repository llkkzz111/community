/**
 * Created by lu weiguo on 2017/6月3号.
 * 今日团购页面导航栏组件
 */
'use strict';
import React, {
    PureComponent,
    PropTypes,
    Component
} from 'react'
import {
    View,
    Text,
    Image,
    Dimensions,
    TouchableOpacity,
    StyleSheet,
} from 'react-native'
let width = Dimensions.get('window').width;
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
// 导入外部 URL 请求
import SortingRequest from '../net/group/totayGroup/SortingRequest';
export default class Screening extends Component {
    static propTypes = {
        sortCallBack: PropTypes.func,
        selectedIndex: PropTypes.number,
    }
    static defaultProps = {
        selectedIndex: 0,
    }
    // 构造
    constructor(props) {
        super(props);
        this.state = {
            selectedIndex: this.props.selectedIndex,
            salesSortNum: -1,
        }
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.selectedIndex !== this.state.selectedIndex) {
            this.setState({
                selectedIndex: nextProps.selectedIndex,
            });
        }
        if (nextProps.salesSortNum !== this.state.salesSortNum) {
            this.setState({
                salesSortNum: nextProps.salesSortNum,
            });
        }
    }

    /**
     * 渲染页面
     * @returns {XML}
     */
    render() {
        return (
            <View style={styles.screeningStyle}>
                {
                    this.props.titleData !== '' && this.props.titleData !== null && this.props.titleData.map((item, i) => {
                        let sortComponent = null;
                        if (i == 2) {
                            if (this.state.salesSortNum === 0) {
                                sortComponent = (
                                    <Image
                                        source={require('../Img/groupbuy/icon_desc_@3x.png')}
                                        style={styles.sortStyle}
                                        resizeMode={'contain'}
                                    />
                                );
                            } else if (this.state.salesSortNum === 1) {
                                sortComponent = (
                                    <Image
                                        source={require('../Img/groupbuy/icon_asc_@3x.png')}
                                        style={styles.sortStyle}
                                        resizeMode={'contain'}
                                    />
                                );
                            } else {
                                sortComponent = (
                                    <Image
                                        source={require('../Img/groupbuy/Icon_sort_@2x.png')}
                                        style={styles.sortStyle}
                                        resizeMode={'contain'}
                                    />
                                );
                            }
                        }
                        return (
                            <TouchableOpacity
                                key={i}
                                onPress={() => this._clickSelect(i)}
                                activeOpacity={1}
                                style={styles.screeningItem}
                            >
                                <Text allowFontScaling={false}
                                      style={[styles.screeningSize, {color: i === this.state.selectedIndex ? Colors.main_color : Colors.text_dark_grey}]}>{item.title}</Text>
                                {sortComponent}
                            </TouchableOpacity>
                        )
                    })
                }
            </View>
        )
    }

    _clickSelect = (index) => {
        let sortIds = this.props.titleData[index].sortId;
        let sortId = '';
        if (sortIds.length === 1) {
            sortId = sortIds[0];
            this.state.salesSortNum = -1;
        } else if (sortIds.length === 2) {
            if (this.state.salesSortNum === 1) {
                this.state.salesSortNum = 0;
            } else if (this.state.salesSortNum === 0) {
                this.state.salesSortNum = 1;
            } else {
                this.state.salesSortNum = 0;
            }
            sortId = sortIds[this.state.salesSortNum];
        }
        this.setState({
            selectedIndex: index,
            salesSortNum: this.state.salesSortNum,
        }, () => {
            this.props.sortCallBack && this.props.sortCallBack(this.state.selectedIndex, this.state.salesSortNum, sortId);
        });
    };
}
const styles = StyleSheet.create({
    screeningStyle: {
        flexDirection: "row",
        width: width,
        paddingTop: ScreenUtils.scaleSize(24),
        paddingBottom: ScreenUtils.scaleSize(24),
        backgroundColor: Colors.text_white,
    },
    screeningItem: {
        height: ScreenUtils.scaleSize(32),
        alignItems: "center",
        justifyContent: "center",
        width: width / 4,
        borderRightColor: "#D4D4D4",
        borderRightWidth: 0.5,
        flexDirection: "row",
    },
    screeningSize: {
        fontSize: ScreenUtils.setSpText(26),
        color: Colors.text_dark_grey,
    },
    sortStyle: {
        height: ScreenUtils.scaleSize(24),
        width: ScreenUtils.scaleSize(20),
        marginLeft: 5
    },
});