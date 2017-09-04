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
* 安卓版本img
**/
export class ImgAndroid extends Component {
    constructor() {
        super();
        this.state = {
            loadead: false
        };
        this.unmount = false;
    }
    async componentDidMount() {
        // 预加载图片
        const isDownLoad = await Image.prefetch(this.props.source.uri);
        isDownLoad && !this.unmount ? this.setState({
            loadead: true
        }) : null;
    }
    shouldComponentUpdate(nextProps, nextState) {
        return this.state.loadead !== nextState.loadead;
    }
    componentWillUnmount() {
        this.unmount = true;
    }
    render() {
        // return
        return !this.state.loadead ? (
            <Image {...{
                ...this.props,
                ...{
                    source: require("IMG/img_defaul.png")
                }
            }} />
        ) : (
            <Image {...this.props}/>
        );
    }
}
