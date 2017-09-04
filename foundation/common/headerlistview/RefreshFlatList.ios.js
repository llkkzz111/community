/**
 * Created by jiajiewang on 2017/6/27.
 */
import React, {PropTypes}  from 'react';
import {
    Text,
    View,
    FlatList,
    Dimensions,
    Animated,
    PanResponder,
    Easing,
} from 'react-native';
const {width} = Dimensions.get('window');

// 0: 未刷新; 1: 到达刷新点; 2: 刷新中; 3: 刷新完成
export const RefreshState = {
    pullToRefresh: 0,
    releaseToRefresh: 1,
    refreshing: 2,
    refreshdown: 3,
};

export const RefreshText = {
    pullToRefresh: 'pull to refresh',
    releaseToRefresh: 'release to refresh ',
    refreshing: 'refreshing...',
    refreshdown: 'refresh complete!'
};

export const FooterText = {
    pushToRefresh: 'pull to refresh',
    loading: 'refreshing...'
};

export const ViewType = {
    ListView: 'ListView',
    ScrollView: 'ScrollView'
};

export default class HeaderFlatList extends React.Component {

    static defaultProps = {
        refreshing: false,
        viewType: 'ScrollView',
        onScroll: PropTypes.func
    };

    static propTypes = {
        customRefreshView: React.PropTypes.func,
        refreshing: React.PropTypes.bool,
        viewType: React.PropTypes.oneOf(['ListView', 'ScrollView'])
    };

    constructor() {
        super();
        this.state = {
            _data: [],
            rotation: new Animated.Value(0),
            rotationNomal: new Animated.Value(0),
            refreshState: RefreshState.pullToRefresh,
            refreshText: RefreshText.pullToRefresh,
            percent: 0,
            footerMsg: 'load more',
        };
        this._scrollEndY = 0;
        this.headerHeight = 60;
        this.mTop = 0; // Record distance from top to top
        this.isOnMove = false; // Distinguish whether the finger is triggered Slip; Calculate the sliding percentage
        this.isAnimating = false; //Controls the same animation not many times during the sliding process
        this.beforeRefreshState = RefreshState.pullToRefresh
    }

    componentWillMount() {
        const {customRefreshView} = this.props;
        if (customRefreshView) {
            const {height} = customRefreshView(RefreshState.pullToRefresh).props.style
            this.headerHeight = height
        }

        this._panResponder = PanResponder.create({
            onStartShouldSetPanResponder: (event, gestureState) => true,
            onStartShouldSetPanResponderCapture: (event, gestureState) => true,
            onMoveShouldSetPanResponder: (event, gestureState) => false,
            onMoveShouldSetPanResponderCapture: (event, gestureState) => false,
            onPanResponderTerminationRequest: (event, gestureState) => true,
            onPanResponderGrant: (event, gestureState) => {
                this.onStart(event, gestureState);
            },
            onPanResponderMove: (event, gestureState) => {
                this.onMove(event, gestureState);
            },
            onPanResponderRelease: (event, gestureState) => {
                this.onEnd(event, gestureState);
            }
        })
    }

    componentDidMount() {
    }

    componentWillReceiveProps(nextProps, nextState) {
        this.setRefreshState(nextProps.isRefresh)
    }

    //演示动画
    shouldComponentUpdate(nextProps, nextState) {
        if (this.state.refreshState != RefreshState.refreshing
            && nextState.refreshState == RefreshState.refreshing) {
            this.initAnimated()
        }
        return true
    }

    //释放计时器
    componentWillUnmount() {
        this.t && clearTimeout(this.t);
        this.tt && clearTimeout(this.tt);
        this.timer1 && clearTimeout(this.timer1);
        this.timer2 && clearTimeout(this.timer2);
    }

    //初始化
    initAnimated() {
        this.state.rotation.setValue(0)
        this._an = Animated.timing(this.state.rotation, {
            toValue: 1,
            duration: 1000,
            easing: Easing.linear,
        }).start((r) => {
            if (this.state.refreshState == RefreshState.refreshing) {
                this.initAnimated()
            }
        })
    }

    // 刷新方法
    _onRefreshFun = () => {
        this.setRefreshState(true);
        this.timer1 = setTimeout(() => {
            this.setRefreshState(false)
        }, 2000)
    };

    setRefreshState(refreshing) {
        if (refreshing) {
            this.beforeRefreshState = RefreshState.refreshing;
            this.updateRefreshViewState(RefreshState.refreshing)
        } else {
            if (this.beforeRefreshState == RefreshState.refreshing) {
                this.beforeRefreshState = RefreshState.pullToRefresh;
                this.updateRefreshViewState(RefreshState.refreshdown)
            } else {

                //修复切换状态
               // this.updateRefreshViewState(RefreshState.pullToRefresh)
            }
        }
    }

    //刷新页面属性
    updateRefreshViewState(refreshState = RefreshState.pullToRefresh) {
        switch (refreshState) {
            case RefreshState.pullToRefresh:
                this.setState({refreshState: RefreshState.pullToRefresh, refreshText: RefreshText.pullToRefresh});
                break;
            case RefreshState.releaseToRefresh:
                this.setState({refreshState: RefreshState.releaseToRefresh, refreshText: RefreshText.releaseToRefresh});
                break;
            case RefreshState.refreshing:
                this.setState({refreshState: RefreshState.refreshing, refreshText: RefreshText.refreshing}, () => {
                    this._flatList.scrollToOffset({animated: true, offset: -this.headerHeight})
                });
                break;
            case RefreshState.refreshdown:
                this.setState({
                    refreshState: RefreshState.refreshdown,
                    refreshText: RefreshText.refreshdown,
                    percent: 100
                }, () => {
                    // This delay is shown in order to show the refresh time to complete the refresh
                    this.t = setTimeout(() => {
                        this._flatList.scrollToOffset({animated: true, offset: 0});
                        this.tt = setTimeout(() => {
                            this.updateRefreshViewState(RefreshState.pullToRefresh)
                        }, 500)
                    }, 500)
                });
            default:

        }
    }

    //如果不要foot可以无视
    _onEndReached = () => {
        this.setState({footerMsg: 'loading'});
        this.timer2 = setTimeout(() => {
            this.setState({footerMsg: 'load more'})
        }, 1000)
    };

    //这个方法一定不能在flatlist里重写
    _onScroll = (e) => {
        this.props.onScroll && this.props.onScroll(e);
        let {y} = e.nativeEvent.contentOffset;
        this._scrollEndY = y
        //console.log(y)
        if (!this.isOnMove && -y >= 0) {
            //刷新状态下，上推列表依percent然显示100%
            let p = parseInt(( -y / (this.headerHeight)) * 100);
            if (p % 10 === 0) {
                this.setState({percent: (p > 100 ? 100 : p)})
            }
        }
    };

    scrollToY(y) {
        if (Number(y) && Number(y) >= 0) {
            this._flatList.scrollToOffset({animated: true, offset: y})
        }
    }

    onStart(e, g) {
        this.isOnMove = true
    }

    onMove(e, g) {
        this.mTop = g.dy;

        // console.log(g.dy)
        // if(!this.key && this._scrollEndY < -this.headerHeight) {
        //   this.key = true
        //   this.updateRefreshViewState(RefreshState.releaseToRefresh)
        // } else if(this.key && this._scrollEndY > -this.headerHeight) {
        //   this.key = false
        //   this.updateRefreshViewState(RefreshState.pullToRefresh)
        // }


        if (g.dy >= 0) {
            let p = parseInt(( g.dy / (2 * this.headerHeight)) * 100);
            p = p > 100 ? 100 : p;
            this.setState({percent: p});
            if (p < 100) {
                this.updateRefreshViewState(RefreshState.pullToRefresh)
            } else {
                this.updateRefreshViewState(RefreshState.releaseToRefresh)
            }
        }
    }

    onEnd(e, g) {
        this.isOnMove = false;
        if (this.props.contentOffsetY < -this.headerHeight * 0.6) {
            const {onRefreshFun} = this.props;
            onRefreshFun ? onRefreshFun() : this._onRefreshFun()
        }
    }

    _shouldItemUpdate(prev, next) {
        return prev.item.text !== next.item.text;
    }

    //假数据
    _renderItem = ({item}) => {
        return (
            <View style={{width: width, height: 100}}>
                <Text> {item.text} </Text>
            </View>
        )
    };

    //假数据
    _renderItemScrollView = () => {
        const {renderItem} = this.props;
        if (renderItem) {
            return renderItem()
        }
        return (
            <View style={{width: width, height: 100}}>
                <Text> {'This is a ScrollView'} </Text>
            </View>
        )
    };

    //自定义头
    customRefreshView = () => {
        const {customRefreshView} = this.props;
        const {refreshState, refreshText, percent} = this.state;
        if (customRefreshView) return customRefreshView(refreshState, percent)
        switch (refreshState) {
            case RefreshState.pullToRefresh:
                // this.isAnimating 这里是为了控制动画不被重复触发
                if (!this.isAnimating) {
                    this.isAnimating = true;
                    Animated.timing(this.state.rotationNomal, {
                        toValue: 0,
                        duration: 200,
                        easing: Easing.linear,
                    }).start(() => {
                        this.isAnimating = false
                    })
                }
                return (
                    <Animated.View style={{
                        flexDirection: 'row',
                        height: this.headerHeight,
                        justifyContent: 'center',
                        alignItems: 'center',
                        backgroundColor: 'pink',
                    }}>
                        <Animated.Image
                            style={{
                                width: 30, height: 30,
                                transform: [{
                                    rotateZ: this.state.rotationNomal.interpolate({
                                        inputRange: [0, 1],
                                        outputRange: ['0deg', '180deg']
                                    })
                                }]
                            }}
                        />
                        <Text>{ refreshText + ' ' + percent + '%'}</Text>
                    </Animated.View>
                );
            case RefreshState.releaseToRefresh:
                if (!this.isAnimating) {
                    this.isAnimating = true;
                    Animated.timing(this.state.rotationNomal, {
                        toValue: 1,
                        duration: 200,
                        easing: Easing.linear,
                    }).start(() => {
                        this.isAnimating = false
                    })
                }
                return (
                    <Animated.View style={{
                        flexDirection: 'row',
                        height: this.headerHeight,
                        justifyContent: 'center',
                        alignItems: 'center',
                        backgroundColor: 'pink',
                    }}>
                        <Animated.Image
                            style={{
                                width: 30, height: 30,
                                transform: [{
                                    rotateZ: this.state.rotationNomal.interpolate({
                                        inputRange: [0, 1],
                                        outputRange: ['0deg', '180deg']
                                    })
                                }]
                            }}
                            source={require('../../Img/common/load-down.png')}
                        />
                        <Text>{ refreshText + ' ' + percent + '%'}</Text>
                    </Animated.View>
                )
            case RefreshState.releaseToRefresh:
                return (
                    <Animated.View style={{
                        justifyContent: 'center',
                        alignItems: 'center',
                        width: width,
                        height: this.headerHeight,
                        backgroundColor: 'pink'
                    }}>
                    </Animated.View>
                );
            case RefreshState.refreshing:
                return (
                    <Animated.View style={{
                        flexDirection: 'row',
                        height: this.headerHeight,
                        justifyContent: 'center',
                        alignItems: 'center',
                        backgroundColor: 'pink',
                    }}>
                        <Animated.Image
                            style={{
                                width: 20, height: 20,
                                transform: [{
                                    rotateZ: this.state.rotation.interpolate({
                                        inputRange: [0, 1],
                                        outputRange: ['0deg', '360deg']
                                    })
                                }]
                            }}
                            source={require('../../Img/common/loading.png')}
                        />
                        <Text>{ refreshText }</Text>
                    </Animated.View>
                );
            case RefreshState.refreshdown:
                return (
                    <Animated.View style={{
                        flexDirection: 'row',
                        height: this.headerHeight,
                        justifyContent: 'center',
                        alignItems: 'center',
                        backgroundColor: 'pink',
                    }}>
                        <Text>{ refreshText + ' ' + percent + '%' }</Text>
                    </Animated.View>
                );
            default:

        }
    };

    _ListFooterComponent = () => {
        const {footerMsg} = this.state;
        const {listFooterComponent} = this.props;
        if (listFooterComponent) return listFooterComponent();
        return (
            <View style={{
                flex: 1,
                justifyContent: 'center',
                alignItems: 'center',
                width: width,
                height: 30,
                backgroundColor: 'pink'
            }}>
                <Text style={{textAlign: 'center',}} allowFontScaling={false}> { footerMsg } </Text>
            </View>
        )
    };

    render() {
        const {_data} = this.state;
        const {viewType, data} = this.props;
        if (viewType == 'ScrollView') {
            return (
                <FlatList
                    ref={ flatList => {
                        this._flatList = flatList
                    }}
                    {...this._panResponder.panHandlers}
                    onScroll={this._onScroll}
                    data={['1']}
                    renderItem={this._renderItemScrollView}
                    keyExtractor={(v, i) => i}
                    ListHeaderComponent={this.customRefreshView}
                    style={[{...this.props.style}, {marginTop: -this.headerHeight}]}
                />
            )
        } else {
            return (
                <FlatList
                    ref={ flatList => {
                        this._flatList = flatList
                    }}
                    {...this._panResponder.panHandlers}
                    onScroll={this._onScroll}
                    data={data || this.state._data}
                    renderItem={this._renderItem}
                    keyExtractor={(v, i) => i}
                    ListHeaderComponent={this.customRefreshView}
                    // ListFooterComponent={this._ListFooterComponent}
                    onEndReached={this._onEndReached}
                    onEndReachedThreshold={0.1}
                    {...this.props}
                    style={[{...this.props.style}, {marginTop: -this.headerHeight}]}
                />
            );
        }
    }
}

