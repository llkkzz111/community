/**
* @file 修改触摸颜色
* @author 魏毅
* @version 0.0.3
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
'use strict';
import React, { Component, PureComponent } from 'react';
import { TouchableOpacity, AsyncStorage } from 'react-native';
import { connect } from 'react-redux';
import { Action as PressStorageAction, selector } from 'REDUX/common/PressStorage';
import global from 'CONFIG/global';

@connect(state => ({
    getPressCode: (namespace, username, itemKey) => selector.getPressStorage(state ,namespace, username, itemKey)
}), PressStorageAction)
class PressStorage extends Component {
    /**
    * @constructor
    * @this PressTextColor
    **/
    constructor() {
        super();
        this._onPress = this._onPress.bind(this);
        this._propsFactory = this._propsFactory.bind(this);
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
        const { name } = this.props.config;
        this.props.addStore({
            namespace: name,
            username: global.tokenType === 'self' ? `${global.config.userId}` : '$$guest$$',
            selectCode: this.props.itemKey
        });
        this.props.onPress && this.props.onPress();
    }
    /**
    * @description
    * 组装props
    * @public
    * @return {props} 返回组装的props
    **/
    _propsFactory() {
        return {
            ...this.props,
            ...{onPress: this._onPress, activeOpacity: this.props.opacity || 1}
        };
    }
    /**
    * @description
    * 过滤数据,判断是否需要增加颜色
    * @public
    **/
    _filterData() {
        const username = global.tokenType === 'self' ? `${global.config.userId}` : '$$guest$$';
        return this.props.getPressCode(this.props.config.name, username, this.props.itemKey);
    }
    /**
    * @description
    * 渲染
    * @public
    **/
    render() {
        return (
            <TouchableOpacity { ...this._propsFactory() }>
                <this.props.childCom { ...this.props } filter={ ::this._filterData }/>
            </TouchableOpacity>
        );
    }
}

/**
* @description
* HOC高阶组件用来记录用户访问的记录，改变访问过的颜色
* @params {Object} config - 设置
* @example
* {
*   namespace: '存入的key标识',
*   color: '访问过的颜色'
* }
**/
export const pressStorage = config => ChildCom => class extends Component {
    render() {
        return (
            <PressStorage config={ config } childCom={ ChildCom } { ...this.props } />
        );
    }
};
