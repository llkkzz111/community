/**
 * Created by YASIN on 2017/5/29.
 * 热销全部分类dialog
 */
import React, {PropTypes}from 'react';
import {
    View,
    Text,
    StyleSheet,
    Animated,
    FlatList,
    TouchableOpacity,
    TouchableWithoutFeedback
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
const ANIMA_DURATION = 100;
var key=0;
export default class HotVarietyDialog extends React.Component {
    static propTypes = {
        datas: PropTypes.array.isRequired,
        onItemClick: PropTypes.func,
        cancleble: PropTypes.bool,
        selectedFlag: PropTypes.string,
    }
    static defaultProps = {
        cancleble: true,
        showDialog: false
    }
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.dialogAni = new Animated.Value(props.showDialog ? 1 : 0);
        this._keyExtractor = (item, index) => index;
        this.state = {
            showDialog: props.showDialog
        };
    }

    render() {
        let {datas, onItemClick, showDialog}=this.props;
        return (
            <TouchableWithoutFeedback onPress={()=> {
                if (this.props.cancleble)this.disMissDialog(true);
            }}>
                <Animated.View
                    style={[
                        styles.container,
                        {
                            opacity: this.dialogAni
                        }
                    ]}
                    pointerEvents={this.state.showDialog ? 'auto' : 'none'}
                >
                    <View style={styles.itemWrapperContainer}>
                        <FlatList
                            key={++key}
                            data={this.props.datas}
                            renderItem={this._renderItem.bind(this)}
                            overScrollMode={'never'}
                            keyExtractor={this._keyExtractor}
                            numColumns={2}
                        />
                        <View style={styles.lineStyle}/>
                    </View>
                </Animated.View>
            </TouchableWithoutFeedback>
        );
    }

    /**
     * 渲染item
     * @private
     */
    _renderItem({item, index}) {
        return (
            <TouchableOpacity onPress={this.props.onItemClick.bind(this, index)} activeOpacity={1}>
                <View style={styles.itemContainer}>
                    <Text allowFontScaling={false}
                        style={[styles.itemTextStyle, this.props.selectedFlag === item.selectedClass ? {color: Colors.main_color} : null]}>
                        {item.title}
                    </Text>
                </View>
            </TouchableOpacity>
        );
    }

    /**
     * 显示dialog
     */
    showDialog(showAnim) {
        let self = this;
        if (this.dialogAni) {
            this.dialogAni.setValue(0)
            Animated.timing(this.dialogAni, {
                fromValue: 0,
                toValue: 1,
                duration: showAnim ? ANIMA_DURATION : 0
            }).start(()=> {
                self.setState({
                    showDialog: true
                });
            });
        }
    }

    /**
     * 消失dialog
     */
    disMissDialog(showAnim) {
        let self = this;
        if (this.dialogAni) {
            this.props.showDialog = false;
            this.dialogAni.setValue(1)
            Animated.timing(this.dialogAni, {
                fromValue: 1,
                toValue: 0,
                duration: showAnim ? ANIMA_DURATION : 0
            }).start(()=> {
                self.setState({
                    showDialog: false
                });
            });
        }
    }

    /**
     * 是否正在显示
     */
    isShowing() {
        return this.state.showDialog;
    }
}
const styles = StyleSheet.create({
    container: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        backgroundColor: 'rgba(0,0,0,0.2)',
        flexDirection: 'column'
    },
    itemContainer: {
        justifyContent: 'center',
        alignItems: 'center',
        width: ScreenUtils.screenW / 2,
        paddingTop: ScreenUtils.scaleSize(20),
        paddingBottom: ScreenUtils.scaleSize(20),
        backgroundColor: '#fff'

    },
    itemTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(28)
    },
    lineStyle: {
        width: ScreenUtils.screenW,
        height: StyleSheet.hairlineWidth,
        backgroundColor: Colors.text_light_grey,
        marginTop: ScreenUtils.scaleSize(20)
    },
    itemWrapperContainer: {
        backgroundColor: '#fff'
    }
});