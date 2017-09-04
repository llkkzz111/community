/**
 * @author Xiang
 *
 * 购物车满减列表
 */
import React from 'react'
import {connect} from 'react-redux'
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Image,
    Dimensions,
    Modal,
    TouchableOpacity,
} from 'react-native'
let {width, height} = Dimensions.get('window');

let data = [{items: ['', '', '']}, {items: ['', '', '', '', '', '', '', '',]}, {items: ['']}]

class GiftDialog extends React.PureComponent {
    constructor(props) {
        super(props)
    }

    render() {
        let popHeight = data.length * 200;
        if (data.length * 200 > height * 0.6) {
            popHeight *= 0.6
        }
        return (
            <Modal animationType="fade"
                   onrequestclose={() => {
                   }}
                   transparent={true}
                   style={styles.container}
                   visible={this.props.show}>
                <View style={styles.contentContainer}>
                    <View style={[styles.content, {height: popHeight}]}>
                        <TouchableOpacity activeOpacity={1} style={{
                            alignItems: 'flex-end',
                            paddingTop: 16,
                            paddingRight: 16,
                            justifyContent: 'flex-end'
                        }} onPress={() => {
                            alert('close')
                        }}>
                            <Image style={styles.close} source={require('../Img/dialog/icon_close_@3x.png')}/>
                        </TouchableOpacity>
                        <View style={styles.titleRow}>
                            <Text style={styles.textTag} allowFontScaling={false}>满500减50</Text>
                            <Text style={{marginLeft: 20, color: '#333333'}} allowFontScaling={false}>还差<Text
                                style={{color: '#E5290D'}} allowFontScaling={false}>￥50</Text>，可升级</Text>
                        </View>
                        <ScrollView>
                            {   data.map((row, i) => {
                                return (
                                    <View>
                                        {
                                            this.renderContentRow(row.items, i)
                                        }
                                    </View>
                                )
                            })
                            }
                        </ScrollView>
                    </View>
                </View>
            </Modal>
        );
    }

    renderContentRow(items, i) {
        return (
            <View>
                <View style={styles.contentRowTitle}>
                    <Text style={styles.textTag} allowFontScaling={false}>满200减20</Text>
                    <Text style={{marginLeft: 20, flex: 1, color: '#333333'}} allowFontScaling={false}>已满足</Text>
                    <TouchableOpacity activeOpacity={1} style={{flexDirection: 'row', alignItems: 'center'}} onPress={() => alert('再逛逛')}>
                        <Text style={styles.next} allowFontScaling={false}>再逛逛</Text>
                        <Image source={require('../Img/cart/goto.png')}
                               style={{width: 7, height: 10, marginLeft: 10,}}/>
                    </TouchableOpacity>

                </View>
                <ScrollView horizontal={true} style={styles.items}>
                    {
                        items.map((item, j) => {
                            let leftMargin = 20;
                            if (j === 0) {
                                leftMargin = 0;
                            } else {
                                leftMargin = 20;
                            }
                            return (
                                <Image style={[styles.item, {marginLeft: leftMargin}]}
                                       source={{uri: "https://imgsa.baidu.com/baike/c0%3Dbaike180%2C5%2C5%2C180%2C60/sign=ca5abb5b7bf0f736ccf344536b3cd87c/29381f30e924b899c83ff41c6d061d950a7bf697.jpg"}}/>
                            )
                        })
                    }
                </ScrollView>
                <View style={styles.divide}/>
            </View>
        );
    }
}

let styles = StyleSheet.create({

    container: {
        flex: 1,
        justifyContent: 'center',
    },

    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        justifyContent: 'flex-end',
        width: width,
        height: height,
    },
    content: {
        height: 400,
        backgroundColor: 'white',
    },
    close: {
        height: 20,
        width: 20,
    },
    titleRow: {
        paddingTop: 16,
        paddingLeft: 16,
        paddingRight: 16,
        flexDirection: 'row',
    },
    contentRowTitle: {
        marginTop: 16,
        marginLeft: 16,
        marginRight: 16,
        flexDirection: 'row',
    },
    items: {
        paddingLeft: 16,
        paddingRight: 16,
        flexDirection: 'row',
        paddingTop: 16,
        paddingBottom: 16,
    },
    next: {
        color: '#E5290D',
    },
    item: {
        width: 70,
        height: 70,
        borderWidth: 1,
        borderColor: '#DDDDDD',
        borderRadius: 3,
    },
    textTag: {
        borderWidth: 1,
        borderColor: '#E5290D',
        borderRadius: 3,
        color: 'red',
    },
    divide: {
        height: 1,
        backgroundColor: '#DDDDDD',
    }
});

export default connect(state => ({}),
    dispatch => ({})
)(GiftDialog)