/**
 * @file 滑动分页
 * @author 魏毅
 * @version 0.0.2
 * @license 东方购物 2017
 * @see {@link weiyi@ocj.com.cn}
 */
"use strict";
import React, {Component} from 'react';
import {
    FlatList,
    Text
} from 'react-native';
import { connect } from 'react-redux';
import {
  List, Seq, Map, is
} from 'immutable';
import { Action as ScrollAction, selector } from 'REDUX/common/Page/ScrollPage';
import ListFooterComponent from './ListFooterComponent';

/**
* @description
* 接口声明
**/
type renderItemType = (info: {item: Item, index: number}) => ?React.Element<any>;
/**
* @description
* 必须的props
*/
type RequiredProps = {
    // 需要渲染的Item
    renderItem: renderItemType,
    // 传入的命名空间
    namespace: String
};
/**
* @description
* 非强制的porps
**/
type OptionalProps = {
    /**@extends FlatList*/
    // 分页时候回调
    change?: Function,
    // 默认分页
    page?: Number,
    getRedux?: Function
};
/**
* @description
* 混合2个接口
**/
type Props = RequiredProps & OptionalProps;


/**
* @classdesc
* 滑动分页
**/
@connect(state => ({
    getScrollPage: () => selector.getScrollPage(state)
}), ScrollAction)
export default class ScrollPage extends Component {
    props: Props;
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            list: [] || this.props.data
        };
    }
    componentWillMount() {
        const {namespace, putTableReducer, changeTableReducer, getRedux, page} = this.props;
        // 初始化redux
        putTableReducer({
            namespace,
            data: [],
            page: page || 1
        });
        // 翻到下一页逻辑, 给外层组件action逻辑
        const getReduxAction = data => {
            const {namespace, addTableReducer} = this.props;
            data.length !== 0 ? addTableReducer({
                // 存入数据
                namespace,
                data: data,
                isEnd: false,
                isFirst: false
            }) : addTableReducer({
                // 最后页数据
                namespace,
                isEnd: true,
                isFirst: false
            });
        };
        // 修改数据
        const changeTableAction = data => {
            const {namespace, changeTableReducer} = this.props;
            changeTableReducer({
                // 存入数据
                namespace,
                data: data
            });
        };
        getRedux ? getRedux(getReduxAction, changeTableAction) : null;
    }
    componentWillReceiveProps(nextProps) {
        const {namespace} = this.props;
        const {getScrollPage} = nextProps;
        getScrollPage && namespace && getScrollPage()[namespace] ? this.setState({
            list: getScrollPage()[namespace].data
        }) : console.warn("分页组件组册失败！");
    }
    shouldComponentUpdate(newProps, newState) {
        // 判断是否需要更新,更新只和state和extraData有关。
        return !this.equal(this.state.list, newState.list)
            || (newProps.extraData !== this.props.extraData)
    }
    equal (val1, val2) {
        return is(Seq(val1.map(data => Map(data))), Seq(val2.map(data => Map(data))));
    }
    // 拼装props
    propsFactory() {
        const {
            namespace,
            onEndReachedThreshold,
            onEndReached,
            change,
            getScrollPage,
            onEndReachedDefault
        } = this.props;
        const data = getScrollPage()[namespace] || [];
        const pageNext = onEndReachedDefault ? {
            // 默认分页策略
            onEndReachedThreshold: 0.1,
            onEndReached: (...args) => {
                change ? change(data.page + 1, namespace, ...args) : null;
            }
        } : {
            // 自定义分页策略
            onEndReachedThreshold: onEndReachedThreshold || 0.1,
            onEndReached: (...args) => {
                onEndReached ? onEndReached(...args) : null;
                change ? change(data.page + 1, namespace, ...args) : null;
            }
        };
        return {
            ...this.props,
            ...pageNext,
            ...{
                ListFooterComponent: ()=><ListFooterComponent namespace={this.props.namespace}/>,
                data: data.data
            }
        };
    }
    render() {
        return (
            this.props.namespace ? (
                <FlatList
                    ref={e => {
                        // 获取ref
                        this.props.getRef ?
                            this.props.getRef(e) : null
                    }}
                    {...this.propsFactory()}
                />
            ) : (
                <Text style={styles.red}>命名空间丢失</Text>
            )
        );
    }
}
