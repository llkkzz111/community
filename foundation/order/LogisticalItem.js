/**
 * Created by MASTERMIAO on 2017/5/7.
 * 个人中心物流状态条目组件
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    Text,
    StyleSheet,
    TouchableOpacity,
    ART
} from 'react-native';
const {Surface, Shape, Path} = ART;

let path;
export default class LogisticalItem extends React.PureComponent {
    constructor() {
        super();
        this.state = {

           }
    }

    componentWillMount() {
        path = Path()
            .moveTo(1, 1)
            .lineTo(220, 1);
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            dataSource:nextProps.dataSource,
        })
    }


    render () {
        return (
            <View style={styles.containertt}>
                <View style={styles.statusLineStyle}>
                    <View style={styles.greyPointStyle} />
                    <Text allowFontScaling={false} style={styles.dateStyle}>最新物流</Text>
                    <Text allowFontScaling={false} style={styles.dateStyle2}>
                        {this.props.dataSource.logistics[0].date}
                    </Text>
                </View>
                <Surface width={220} height={1}>
                    <Shape d={path} stroke="#DDDDDD" strokeWidth={1} strokeDash={[8, 8]} />
                </Surface>
                    <View style={styles.itemLine}>
                        <Image style={styles.img} source={{uri:this.props.dataSource.itemPath}} />
                        <View style={styles.statusLine}>
                            <Text allowFontScaling={false} style={styles.statusDescStyle1}>
                                {this.props.dataSource.logistics[0].orderState}
                            </Text>
                            <Text allowFontScaling={false}
                                style={styles.statusDescStyle2}
                                numberOfLines={1}
                            >
                                {this.props.dataSource.logistics[0].detail}
                            </Text>
                        </View>
                    </View>
            </View>
        )
    }

    _click = () => {
    }



}

const styles = StyleSheet.create({
    containertt: {
        width: 220,
        backgroundColor: 'white',
        marginLeft: 10,
        marginRight: 10,
        marginBottom: 10,
        marginTop: 10,
        borderRadius: 6,
    },
    greyPointStyle: {
        flex: 0,
        width: 10,
        height: 10,
        backgroundColor: '#D0D0D0',
        borderRadius: 360
    },
    statusLineStyle: {
        flex:1,
        height: 30,
        backgroundColor: 'white',
        flexDirection: 'row',
        alignItems: 'center',
        paddingLeft:10,
        paddingRight:10,
        borderRadius: 6,
    },
    dateStyle: {
        flex: 1,
        fontSize: 15,
        color: '#666666',
        marginLeft: 5
    },
    dateStyle2: {
        marginRight: 5,
        fontSize: 15,
        color: '#666666'
    },
    dottedLine: {
        width: 180,
        height: 1,
        backgroundColor: '#DDDDDD'
    },
    itemLine: {
        flexDirection: 'row',
        margin:10,
    },
    img: {
        width: 60,
        height: 60,
    },
    statusLine: {
        marginLeft: 8,
        flex:1
    },
    statusDescStyle1: {
        fontSize: 16,
        color: 'black',
    },
    statusDescStyle2: {
        fontSize: 13,
        color: '#666666',
        flex:1,
        marginRight:10,
        flexWrap:'wrap',
        marginTop:20
    }
});

LogisticalItem.propTypes = {
    desc: React.PropTypes.string,
    status: React.PropTypes.string,
    date: React.PropTypes.string,
    item: React.PropTypes.string,
    img: React.PropTypes.string
}
