/**
* @file 远程图片加载，用来显示默认图
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import React, { Component } from 'react';
import {
    Image
} from 'react-native';

/**
* @classdesc
* ios版本img
**/
export class ImgIos extends Component {
    constructor() {
        super();
        this.defaultSource = require("IMG/img_defaul.png") || this.props.defaultSource;
    }
    shouldComponentUpdate() {
        return false;
    }
    render() {
        return (
            <Image {...this.props} defaultSource={this.defaultSource}/>
        );
    }
}
