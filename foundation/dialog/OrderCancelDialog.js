/**
 * @author Xiang
 *
 * 订单取消弹窗
 */
import React from 'react'
import {connect} from 'react-redux'
import CommonDialog from './CommonDialog';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Image,
    TouchableOpacity,

} from 'react-native'
let data = ['现在不想购买', '等待时间过长', '支付不成功', '更换或添加新商品', '配送地址变更', '其他'];

class OrderCancelDialog extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            index: 0,
        }
    }

    render() {
        return (
            <CommonDialog
                show={true}
                buttons={[{
                    flex: 1, text: '确定', color: 'white', bg: '#E5290D', onClicked: () => {
                    }
                }]}>
                <ScrollView style={styles.scrollView}>
                    {
                        data.map((item, i) => {
                            let reasonColor = this.state.index === i ? '#333333' : '#999999'
                            return (
                                <View>
                                    <TouchableOpacity style={styles.reasonRow}
                                                      activeOpacity={1}
                                                      onPress={() => {
                                                          this.setState({index: i});
                                                      }}>
                                        <Text style={[styles.reasonText, {color: reasonColor}]} allowFontScaling={false}>{item}</Text>
                                        {
                                            this.state.index === i ? (<Image style={styles.reasonChecked}
                                                                             source={require('../Img/dialog/item_selected@2x.png')}/>    ) : (null)
                                        }
                                    </TouchableOpacity>
                                    <View style={styles.divideLine}/>
                                </View>
                            )
                        })
                    }
                </ScrollView>
            </CommonDialog>
        );
    }
}
let styles = StyleSheet.create({
    scrollView: {
        height: 300,
    },
    reasonRow: {
        flexDirection: 'row',
        padding: 13,
        alignItems: 'center',
        justifyContent: 'center',
    },
    reasonText: {
        flex: 1,
    },
    reasonChecked: {
        height: 15,
        width: 20,
        resizeMode: 'contain',
    },

    divideLine: {
        backgroundColor: '#DDDDDD',
        height: 1,
    },
})
export default connect(state => ({}),
    dispatch => ({})
)(OrderCancelDialog)