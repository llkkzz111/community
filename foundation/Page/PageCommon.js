/**
 * @file 分页公共逻辑
 * @author 魏毅
 * @version 0.0.1
 * @license 东方购物 2017
 * @see {@link weiyi@ocj.com.cn}
 */
"use strict";
import React, {Component} from 'react';
import { Action as ScrollAction } from 'REDUX/common/Page/ScrollPage';

export default (Com) => class extends Component {
    render () {
        const {pageDown} = this;
        const otherProps = {
            //TODO:
        };
        return (
            <Com {...this.props} {...otherProps}/>
        );
    }
};
