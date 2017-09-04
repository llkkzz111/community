/**
 * Created by jiajiewang on 2017/6/27.
 */

import React from 'react';
import {
    Text,
    View,
} from 'react-native';
import * as ScreenUtils from'../../utils/ScreenUtil';
export default class HeaderView extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            percent: this.props.percent,
            headerHeight: this.props.headerHeight,
        }
    }

    shouldComponentUpdate(nextProps, nextState) {
        return false
    }

    render() {
        console.log('----> render HeaderView');
        return (
            <View style={{
                justifyContent: 'center',
                alignItems: 'center',
                alignSelf: 'flex-end',
                width: ScreenUtils.screenW,
                height: this.props.headerHeight,
                backgroundColor: '#FFB000',
            }}>
            </View>
        );
    }
}