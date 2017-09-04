/**
 * @author Xiang
 *
 * 赠品选择弹窗
 */
import React from 'react';
import CommonDialog from './CommonDialog';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Image,
    TouchableOpacity,
    FlatList,
} from 'react-native'

class CartGiftPickUpDialog extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            index: 0,//默认选择
            giftData: [],
            frmDialogFlg: false,
            giftSeq: '',
        };
        this.select = this.select.bind(this);
    }

    componentWillMount() {
        this.setState({
            giftData: this.props.giftData.shopGiftArr,
            frmDialogFlg: this.props.frmDialogFlg,
            cartSeq: this.props.cartSeq,
            giftSeq: this.props.giftSeq
        })
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            giftData: nextProps.giftData.shopGiftArr,
            frmDialogFlg: nextProps.frmDialogFlg,
            cartSeq: nextProps.cartSeq,
            giftSeq: nextProps.giftSeq
        });
    }

    select(index) {
        //获取赠品总列表
        let selectGiftVal = this.state.giftData[index];
        return selectGiftVal;
    }

    render() {
        return (
            <CommonDialog title='选择赠品'
                          show={this.props.show}
                          closeDialog={() => {
                              this.props.closeGiftDialog()
                          }}
                          buttons={[{
                              flex: 1,
                              text: '确定',
                              color: 'white',
                              bg: '#E5290D',
                              onClicked: () => {
                                  this.props.ConfirmGiftDialog({
                                      selectedGift: this.select(this.state.index),
                                      fromPop: this.state.frmDialogFlg,
                                      cartSeq: this.props.cartSeq,
                                      giftSeq: this.props.giftSeq,
                                      itemQty: this.props.itemQty,
                                  });
                              }
                          }
                          ]}>
                <ScrollView style={styles.scrollView}>
                    {
                        this.state.giftData ? this.state.giftData.map((item, index) => {
                            return (
                                <View key={index}>
                                    {
                                        this.renderGiftRow(item, index)
                                    }
                                </View>
                            )
                        }) : null
                    }
                </ScrollView>
            </CommonDialog>
        );
    }

    renderGiftRow = (item, rowId) => {
        let ic = rowId === this.state.index ? require('../Img/cart/selected.png') : require('../Img/cart/unselected.png');
        return (
            <View key={rowId} style={styles.giftRow}>
                <TouchableOpacity activeOpacity={1} style={{justifyContent: 'center'}}
                                  onPress={() => {
                                      this.setState({index: rowId});
                                  }}>
                    <Image
                        style={styles.giftCheck}
                        source={ic}
                    />
                </TouchableOpacity>
                <Image
                    style={styles.giftImg}
                    source={{uri: item.gift_img}}
                />
                <View style={styles.giftContent}>
                    <Text style={styles.giftTextTitle} allowFontScaling={false}>{item.gift_item_name}</Text>
                    <Text style={styles.giftTextCategory} allowFontScaling={false}>{item.unit_code}</Text>
                    <View style={styles.giftPriceNum}>
                        <Text style={styles.price} allowFontScaling={false}/>
                        <Text style={styles.num} allowFontScaling={false}>x1</Text>
                    </View>
                </View>
            </View>

        )
    }
}
let styles = StyleSheet.create({
    scrollView: {
        height: 300,
    },
    giftRow: {
        flexDirection: 'row',
        padding: 16,
        justifyContent: 'center',
    },
    giftCheck: {
        height: 20,
        width: 20,
        marginRight: 10,
    },
    giftImg: {
        borderWidth: 1,
        borderColor: '#DDDDDD',
        borderRadius: 3,
        height: 100,
        width: 100,
    },
    giftContent: {
        flex: 1,
        paddingLeft: 10,
    },
    giftTextTitle: {
        fontSize: 16,
        color: '#333333',
    },
    giftTextCategory: {
        color: '#666666',
        flex: 1,
        marginTop: 5,
        marginBottom: 5,
    },
    giftPriceNum: {
        flexDirection: 'row',
    },
    price: {
        color: '#E5290D',
        flex: 1,
    },
    num: {
        color: '#333333'
    }
});

CartGiftPickUpDialog.propTypes = {
    giftData: React.PropTypes.object,
    giftPromoSeq: React.PropTypes.string,
    show: React.PropTypes.bool,
    closeGiftDialog: React.PropTypes.func,
    ConfirmGiftDialog: React.PropTypes.func,
};

export default CartGiftPickUpDialog