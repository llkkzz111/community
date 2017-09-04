/**
 * Created by YASIN on 2017/5/31.
 * 导航栏view
 */
import React, {Component, PureComponent, PropTypes}from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableOpacity,
    TouchableWithoutFeedback,
    StatusBar,
    NativeModules,
    Platform
}from 'react-native';
import {Actions} from 'react-native-router-flux';
import Colors from 'CONFIG/colors';
import * as ScreenUtils from 'UTILS/ScreenUtil';

const Com = __DEV__ ? Component : PureComponent;
var key = 0;
export default class NavigationBar extends Com {
    static propTypes = {
        showLeft: PropTypes.bool,
        renderLeft: PropTypes.any,
        onLeftPress: PropTypes.func,
        leftContainerStyle: View.propTypes.style,
        leftButtonStyle: View.propTypes.style,
        leftButton: Image.propTypes.source,
        showTitle: PropTypes.bool,
        renderTitle: PropTypes.any,
        titleContainerStyle: View.propTypes.style,
        titleStyle: Text.propTypes.style,
        title: PropTypes.string,
        showRight: PropTypes.bool,
        renderRight: PropTypes.any,
        rightContainerStyle: View.propTypes.style,
        rightStyle: Text.propTypes.style,
        rightText: PropTypes.string,
        onRightPress: PropTypes.func,
        showContainer: PropTypes.bool,
        rightButton: Image.propTypes.source
    }
    static defaultProps = {
        showLeft: true,
        showTitle: true,
        showRight: true,
        showStatusBar: true,
        statusBarColor: 'transparent',
        statusBarTransparent: true,
        barStyle: 'light-content',
        showContainer: true
    }

    constructor(props) {
        super(props);
        this._renderRight = this._renderRight.bind(this);
        this._renderLeft = this._renderLeft.bind(this);
        this._renderTitle = this._renderTitle.bind(this);
        this._renderStatusBar = this._renderStatusBar.bind(this);
    }

    _renderStatusBar() {
        let {showStatusBar, statusBarColor, statusBarTransparent, barStyle}=this.props;
        if (showStatusBar) {
            return (
                <StatusBar
                    key={++key}
                    translucent={statusBarTransparent}
                    barStyle={barStyle}
                    backgroundColor={(statusBarColor != null) ? statusBarColor : 'rgba(255,255,255,0.1)'}
                />
            )
        }
        return null;
    }

    _renderLeft() {
        let {showLeft, renderLeft, onLeftPress, leftContainerStyle, leftButtonStyle, leftButton}=this.props;
        if (!onLeftPress) {
            onLeftPress = Actions.pop;
        }
        let LeftComponent = null;
        if (showLeft) {
            LeftComponent = (renderLeft && renderLeft()) || (
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={onLeftPress}
                        style={leftContainerStyle || styles.leftContainerDefaultStyle}
                    >
                        <Image
                            style={leftButtonStyle || styles.leftArrowDefaultStyle}
                            source={leftButton || require('IMG/icons/Icon_back_@2x.png')}
                        />
                    </TouchableOpacity>
                );
        } else {
            LeftComponent = (<View style={styles.leftContainerDefaultStyle}/>);
        }
        return LeftComponent;
    }

    _renderTitle() {
        let {showTitle, renderTitle, titleContainerStyle, titleStyle, title}=this.props;
        let TitleComponent = null;
        if (showTitle) {
            TitleComponent = (renderTitle && renderTitle()) || (
                    <View style={titleContainerStyle}>
                        <Text style={[styles.titleDefaltStyle, titleStyle]} allowFontScaling={false}>{title}</Text>
                    </View>
                );
        } else {
            TitleComponent = (<View/>);
        }
        return TitleComponent;
    }

    _renderRight() {
        let {
            rightButton,
            showRight,
            renderRight,
            rightContainerStyle,
            rightStyle,
            rightText,
            onRightPress
        } = this.props;
        let RightComponent = null;
        if (rightButton) {
            /**
             * @description
             * 这块地方新加上的，组件原先功能不完善。
             **/
            RightComponent = (renderRight && renderRight()) || (
                    <TouchableOpacity activeOpacity={1} style={rightContainerStyle || styles.rightDefaultContainerStyle}
                                      onPress={onRightPress}>
                        <View style={rightStyle} allowFontScaling={false}>
                            <Image
                                source={rightButton}
                            />
                        </View>
                    </TouchableOpacity>
                )
        } else if (showRight) {
            RightComponent = (renderRight && renderRight()) || (
                    <TouchableOpacity activeOpacity={1} style={rightContainerStyle || styles.rightDefaultContainerStyle}
                                      onPress={onRightPress}>
                        <Text style={[styles.rightDefaltStyle, rightStyle]} allowFontScaling={false}>{rightText}</Text>
                    </TouchableOpacity>
                );
        } else {
            RightComponent = (<View style={styles.rightDefaultContainerStyle}/>);
        }
        ;
        return RightComponent;
    }

    render() {
        let LeftComponent = this._renderLeft();
        let TitleComponent = this._renderTitle();
        let RightComponent = this._renderRight();
        let StatusComponent = this._renderStatusBar();
        if (!this.props.showContainer) {
            return StatusComponent;
        }
        let navigationBarBackgroundImage = this.props.navigationBarBackgroundImage;

        let statusBarStyle = {};
        if (this.props.showStatusBar) {
            statusBarStyle = {
                paddingTop: getStatusHeight()
            };
        }
        let ContainerView = navigationBarBackgroundImage ? (
            <Image
                style={[styles.container, this.props.navigationStyle, statusBarStyle]}
                source={navigationBarBackgroundImage}
            >
                {LeftComponent}
                {TitleComponent}
                {RightComponent}
                {StatusComponent}
            </Image>
        ) : (
            <View style={[styles.container, this.props.navigationStyle, statusBarStyle]}>
                {LeftComponent}
                {TitleComponent}
                {RightComponent}
                {StatusComponent}
            </View>
        );
        return ContainerView;
    }
}
export const getStatusHeight = ()=> {
    let height = (Platform.OS === 'ios' ? ScreenUtils.scaleSize(44 + 20) :
        NativeModules.VersionAndroid.SDK_INT >= 21 ? StatusBar.currentHeight + ScreenUtils.scaleSize(15) : ScreenUtils.scaleSize(15));
    return height;
}
export const getStatusHeightHome = ()=> {
    let height = (Platform.OS === 'ios' ? ScreenUtils.scaleSize(44) :
        NativeModules.VersionAndroid.SDK_INT >= 21 ? StatusBar.currentHeight + ScreenUtils.scaleSize(5) : ScreenUtils.scaleSize(5));
    return height;
}
export const getAppHeight = ()=> {
    let height = (Platform.OS === 'ios' ? ScreenUtils.screenH :
        NativeModules.VersionAndroid.SDK_INT >= 21 ? ScreenUtils.screenH : ScreenUtils.screenH - StatusBar.currentHeight);
    return height;
}
const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.text_white,
        justifyContent: 'space-between',
        paddingBottom: ScreenUtils.scaleSize(15),
        paddingTop: ScreenUtils.scaleSize(15),
        width: ScreenUtils.screenW
    },
    leftContainerDefaultStyle: {
        width: ScreenUtils.scaleSize(120),
        height: ScreenUtils.scaleSize(40),
        justifyContent: 'center',
    },
    leftArrowDefaultStyle: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(31)
    },
    titleDefaltStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(36)
    },
    rightDefaltStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(28)
    },
    rightDefaultContainerStyle: {
        width: ScreenUtils.scaleSize(120),
        height: ScreenUtils.scaleSize(40),
        alignItems: 'center',
        justifyContent: 'center',
    }
});
