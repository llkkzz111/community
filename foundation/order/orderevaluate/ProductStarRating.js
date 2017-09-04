/**
 * Created by MASTERMIAO on 2017/5/12.
 * 订单评价页面的点评星星等级组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    Platform
} from 'react-native';

const { width } = Dimensions.get('window');

import StarRating from './StarRating';

export default class ProductStarRating extends React.PureComponent {
    constructor(props) {
        super(props);
    }

    render() {
        let { starNumber, ratingLevel } = this.props
        return (
            <View style={styles.containers}>
                <View style={styles.descBg}>
                    <Text allowFontScaling={false} style={styles.ratingTitleStyle}>
                        商品质量：
                    </Text>
                </View>
                <View style={styles.ratingBg}>
                    <StarRating starColor={'#FFC033'} stars={starNumber} total={5} starSize={21} starSpacing={5} />
                </View>
                <View style={styles.descBg}>
                    <Text allowFontScaling={false} style={styles.ratingTitleStyle2}>
                        {ratingLevel}
                    </Text>
                </View>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    containers: {
        width: width,
        height: 40,
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: 'white',
        // flex: 0
    },
    ratingTitleStyle: {
        fontSize: 12,
        color: '#666666',
        marginLeft: 10
    },
    ratingTitleStyle2: {
        fontSize: 12,
        color: '#666666',
        marginRight: 10
        // position: 'relative',
        // right: 10
    },
    descBg: {
        justifyContent: 'center',
        width: 70
    },
    ratingBg: {
        flex: 1,
        height: 40,
        justifyContent: 'center',
        marginLeft: 5
    }
});

ProductStarRating.defaultProps = {
    starNumber: 3,
    ratingLevel: '一般'
}

ProductStarRating.propTypes = {
    starNumber: React.PropTypes.number,
    ratingLevel: React.PropTypes.string
}
