/**
 * Created by MASTERMIAO on 2017/5/18.
 * 订单填写页面的发货时间提醒Dialog组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    StyleSheet,
    Dimensions,
    Modal,
} from 'react-native';

var {width, height} = Dimensions.get('window');


export default class DeliveryTimeDialog extends React.PureComponent {
    constructor(props){
        super(props)
        this.state = {
            show: this.props.show,
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({show: nextProps.show});
    }

    render() {
        return (
            <Modal animationType="fade"
                   onrequestclose={() => {
                   }}
                   transparent={true}
                   style={styles.container}
                   visible={this.state.show}>
                <View style={styles.contentContainer}>
                    <View style={styles.content}>
                        <View style={styles.titleContainer}>
                            <Text style={styles.title} allowFontScaling={false}>由于您修改地址，请重新选择配送时间</Text>
                        </View>
                        <View style={styles.verticalDivide}/>
                        <View style={styles.buttonContainer}>
                            <Text style={styles.button} onPress={() => {
                                this.setState({show: false})
                            }} allowFontScaling={false}>修改</Text>
                        </View>
                    </View>
                </View>
            </Modal>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center'
    },
    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        justifyContent: 'center',
        width: width,
        height: height
    },
    content: {
        justifyContent: 'center',
        backgroundColor: 'white',
        borderRadius: 10,
        marginLeft: 50,
        marginRight: 50
    },
    titleContainer: {
        height: 80,
        justifyContent: 'center'
    },
    title: {
        textAlign: 'center',
        fontWeight: 'bold',
        fontSize: 20,
        color: '#333333'
    },
    buttonContainer: {
        flexDirection: 'row'
    },
    button: {
        fontWeight: 'bold',
        height: 50,
        fontSize: 16,
        color: '#333333',
        flex: 1,
        textAlign: 'center',
        textAlignVertical: 'center'
    },
    verticalDivide: {
        height: 1,
        backgroundColor: '#F5A99E'
    },
    horizentalDivide: {
        width: 1,
        backgroundColor: '#F5A99E'
    }
});
