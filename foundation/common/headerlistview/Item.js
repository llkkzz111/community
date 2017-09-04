/**
 * Created by jiajiewang on 2017/6/30.
 */
import React from 'react';
import {
    Text,
    View,
} from 'react-native';
export default class Item extends React.Component {
    shouldComponentUpdate(nextProps, nextState) {
        return nextProps.toRenderItem
    }

    render() {
        const {renderItem, item, bingo} = this.props
        return item ? renderItem(item) : renderItem()
    }
}
