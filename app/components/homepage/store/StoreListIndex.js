/**
 * Created by YASIN on 2017/6/2.
 * 时尚大牌listview
 */
import React,{PropTypes} from 'react';

import {
    View,
    Image,
    StyleSheet,
    Text,
    FlatList,
    ScrollView
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import PopularBrandItem from './PopularBrandItem';

import Immutable from 'immutable';

export default class PopularBrandList extends React.Component {
    static propTypes = {
        ...View.propTypes.style,
        datas: React.PropTypes.array,
        onRefresh: PropTypes.func,
        onLoadMore: PropTypes.func,
        refreshing: PropTypes.bool,
        onScroll:PropTypes.func
    }

    constructor() {
        super();
        this._renderItem = this._renderItem.bind(this);
    }

    render() {
        let self = this;
        return (
            <View style={[styles.container, this.props.style]}>
                <FlatList
                    horizontal={false}
                    data={this.props.datas}
                    renderItem={this._renderItem}
                    overScrollMode={'never'}
                    onScroll={this._onScroll.bind(this)}
                    onRefresh={this.props.onRefresh}
                    refreshing={this.props.refreshing}
                />
            </View>
        );
    }

    _renderItem(item) {
        let object = Immutable.fromJS(item);
        let img=object.get('item').get('firstImgUrl')
        return (
            <PopularBrandItem
                key={object.get('index')}
                componentList={object.get('item').get('componentList')}
                title={object.get('item').get('title')}
                desc={object.get('item').get('subtitle')}
                storeAvatar={{uri:img===null?'':img }}
                contentCode={object.get('item').get('contentCode')}
            />
        )
    }

    /**
     * scrollview滑动的时候
     * @private
     */
    _onScroll(event) {
        this.props.onScroll&&this.props.onScroll(event);
        // console.log('onLoadMore1111');
        let y = event.nativeEvent.contentOffset.y;
        let height = event.nativeEvent.layoutMeasurement.height;
        let contentHeight = event.nativeEvent.contentSize.height;
        if (contentHeight > height && (y + height >= contentHeight - 20)) {
            //如果满足上啦条件，并且上一次子内容高度=这一次子内容高度说明没有数据了～
            if (this.originContentHeight === contentHeight) {
                return;
            }
            this.originContentHeight = contentHeight;
            // console.log('onLoadMore');
            this.props.onLoadMore();
        }
    }

    initContentHeight() {
        this.originContentHeight = -1;
    }

}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        alignItems: 'center',
        backgroundColor: Colors.text_white,
        flex:1
    }
});