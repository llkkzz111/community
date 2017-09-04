/**
 * Created by MASTERMIAO on 2017/5/23.
 * 今日团购页面通用商品展示组件
 */
'use strict'

import React, {
    PureComponent,
    PropTypes
} from 'react'

import {
    View,
    Text,
    Image,
    Dimensions,
    StyleSheet,
    TouchableOpacity,
    ListView,
    ScrollView

} from 'react-native'

const { width } = Dimensions.get('window')

import { Actions } from 'react-native-router-flux'

export default class ProductDisplayGeneralModule extends PureComponent {
    constructor(props) {
        super(props)
        let pptv = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2})
        this.state = {
            dataSource: pptv.cloneWithRows(['row 1', 'row 2'])

        }
    }

    render() {
        let icons = {
            'popularity': require('../Img/groupby/icon_popularity_@2x.png'),
            'discount': require('../Img/groupby/icon_discount_@2x.png'),
            'brand': require('../Img/groupby/icon_brandbtn_@2x.png')
        }
        let { activity, action, type } = this.props
        let icon
        if (type === 'popularity') {
            icon = icons['popularity']
        } else if (type === 'discount') {
            icon = icons['discount']
        } else if (type === 'brand') {
            icon = icons['brand']
        }
        return (
            <View style={styles.containers}>
                <View style={styles.line}>
                    <View style={styles.lineLine}>
                        <Image style={styles.logo} source={icon} />
                        <Text style={styles.activity} allowFontScaling={false}>{activity}</Text>
                    </View>
                    <TouchableOpacity activeOpacity={1} onPress={this._click} style={styles.actionBg}>
                        <Text style={styles.actionDesc} allowFontScaling={false}>{action}</Text>
                        <Image style={styles.actionLogo} source={require('../Img/arrow_right.png')} />
                    </TouchableOpacity>
                </View>
                <ListView dataSource={this.state.dataSource}
                          renderRow={this._renderRow} />
            </View>
        )
    }

    _renderRow = () => {
        return (
            <View style={{flexDirection: 'row'}}>
                <Image style={{width: width / 2, height: 200}} source={{uri: 'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317991028,3199387370&fm=117&gp=0.jpg'}} />
                <Image style={{width: width / 2, height: 200}} source={{uri: 'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317991028,3199387370&fm=117&gp=0.jpg'}} />
            </View>
        )
    }

    _click = () => {
        Actions.BrandGroup();
    }
}

const styles = StyleSheet.create({
    containers: {
        flex: 1,
        marginTop: 10,
        flexDirection: 'column'
    },
    line: {
        width: width,
        height: 40,
        backgroundColor: 'white',
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row'
    },
    activity: {
        fontSize: 13,
        color: 'black'
    },
    logo: {
        width: 20,
        height: 20,
        position: 'absolute',
        left: -25 // TODO ???
    },
    lineLine: {
        flexDirection: 'row'
    },
    actionLogo: {
        width: 16,
        height: 16
    },
    actionDesc: {
        fontSize: 11
    },
    actionBg: {
        position: 'absolute',
        right: 10,
        flexDirection: 'row'
    }





})

ProductDisplayGeneralModule.propTypes = {
    activity: PropTypes.string,
    action: PropTypes.string,
    type: PropTypes.string
}
