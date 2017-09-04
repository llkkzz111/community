/**
* @file 修改触摸颜色
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
'use strict';
import React, { Component, PureComponent } from 'react';
import { TouchableOpacity, AsyncStorage } from 'react-native';
import PropTypes from 'prop-types';
import global from 'CONFIG/global';

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
**/
const Com = __DEV__ ? Component : PureComponent;

/**
* @classdesc
* 增加点击后的item中title颜色
* @deprecated
* 已经被PressStorage组件代替
* @extends TouchableOpacity {class}
* @param {function} onPress - 触摸回调
* @param {Array<object>} nativeRef - 想需要改变颜色Text
* @example
* import PressTextColor from 'FOUNDATION/pressTextColor';
* <PressTextColor onPress={() => this._jump({
*    id: 1,
*    value: advertisement.destinationUrl,
*    codeValue: advertisement.codeValue
*} )}>
*    <View style={styles.horizontalCenter}>
*        <Image style={{
*            resizeMode: 'cover',
*            width: ScreenUtils.screenW,
*            height: ScreenUtils.scaleSize(200)
*        }} source={{uri: advertisement.firstImgUrl}}/>
*    </View>
* </PressTextColor>
*/
export class PressTextColor extends Com {
    /**
    * @description
    * props
    * @static
    **/
    static propTypes = {
        onPress: PropTypes.func,
        nativeRef: PropTypes.array,
        namespace: PropTypes.string
    };
    /**
    * @description
    * 默认颜色
    * @static
    **/
    static _defaultColor = [];
    /**
    * @constructor
    * @this PressTextColor
    **/
    constructor() {
        super();
        this._addChangeColor = this._addChangeColor.bind(this);
        this._onPress = this._onPress.bind(this);
        this._propsFactory = this._propsFactory.bind(this);
    }
    componentDidMount() {
        /**
        * @description
        * 本地存储key,如果游客身份关闭
        * @static
        **/
        if (this._checkoutUseStorage()) {
            this._storageKey = `$$stirageLink$$${this.props.namespace}$$${global.tokenType}$$${global.config.userName}$$Link`;
            // 检查是否在storage内
            this._checkoutStorage();
        }
    }
    /**
    * @description
    * 验证是否需要开启存储
    * @static
    **/
    _checkoutUseStorage() {
        return this.props.namespace && this.props.itemKey && global.tokenType === 'self';
    }
    /**
    * @description
    * 获取storage
    * @static
    **/
    _getStirage() {
        return AsyncStorage.getItem(this._storageKey);
    }
    /**
    * @description
    * 存入storage
    * @static
    **/
    async _addStorage(addLink) {
        try {
            let link = await this._getStirage();
            if (link) {
                link = new Set(link.split('$'));
                link.add(addLink);
                link = Array.from(link).join('$');
            } else {
                link = `${addLink}$`;
            }
            AsyncStorage.setItem(this._storageKey, link);
        } catch (e) { console.error(e); }
    }
    /**
    * @description
    * 检查storage
    * @static
    **/
    async _checkoutStorage() {
        let link = await this._getStirage();
        if(link && link.split('$').includes(this.props.itemKey)) {
            try {
                this.props.nativeRef &&
                Object.prototype.toString.call(this.props.nativeRef).toLowerCase() === "[object array]" &&
                this.props.nativeRef.forEach(e => e && e.ref && e.touchColor && e.ref.setNativeProps({
                    style: {color: e.touchColor}
                }));
            } catch (erro) { console.error(erro); }
        }
    }
    /**
    * @description
    * 修改ref颜色 && 存入库
    * @public
    * @this PressTextColor
    **/
    _addChangeColor() {
        /**
        * @description
        * 容错
        **/
        try {
            this.props.nativeRef &&
            Object.prototype.toString.call(this.props.nativeRef).toLowerCase() === "[object array]" &&
            this.props.nativeRef.forEach(e => e && e.ref && e.touchColor && e.ref.setNativeProps({
                style: {color: e.touchColor}
            }));
            // 存入key
            this._checkoutUseStorage() ? this._addStorage(this.props.itemKey) : null;
        } catch (erro) { console.error(erro); }
    }

    /**
    * @description
    * 修改ref颜色
    * @public
    * @callback onPress
    * @fires _addChangeColor
    * @this PressTextColor
    **/
    _onPress() {
        this._addChangeColor();
        this.props.onPress && this.props.onPress();
    }

    /**
    * @description
    * 组装props
    * @public
    * @return {props} 返回组装的props
    * @this PressTextColor
    **/
    _propsFactory() {
        return {
            ...this.props,
            ...{onPress: this._onPress, activeOpacity: this.props.opacity || 1}
        };
    }

    /**
    * @description
    * 渲染
    * @public
    * @this PressTextColor
    **/
    render() {
        return (
            <TouchableOpacity {...this._propsFactory()}>
                { this.props.children }
            </TouchableOpacity>
        );
    }
}
