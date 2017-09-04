/**
 * @author Xiang
 *
 * 价格明细弹窗
 */
import React, {PropTypes} from 'react'
import {
    View,
    Text,
    StyleSheet,
} from 'react-native'
//共通Dialog
import CommonDialog from './CommonDialog'
/**
 * 价格明细弹窗
 */
export default class PriceDetailDialog extends React.PureComponent {

    constructor(props) {
        super(props)
        this.state = {
            data: this.props.datas,
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            data: nextProps.datas,
        });
    }

    render() {
        let total_price = 0;
        let total_postal_amt = 0;
        let dc_amt = 0;
        let total_real_price = 0;
        if (this.state.data) {
            total_price = this.state.data.total_price === null ? 0 : this.state.data.total_price;
            total_postal_amt = this.state.data.total_postal_amt === null ? 0 : this.state.data.total_postal_amt;
            dc_amt = this.state.data.dc_amt === null ? 0 : this.state.data.dc_amt;
            total_real_price = this.state.data.total_real_price === null ? 0 : this.state.data.total_real_price;
        }
        return (
            <CommonDialog show={this.props.show} closeDialog={() => this.props.closeDialog()} title='价格明细' buttons={[]}>
                <View style={styles.content}>
                    <View style={styles.priceRow}>
                        <Text style={styles.priceTitle} allowFontScaling={false}>总额：</Text>
                        <Text
                            style={styles.priceText} allowFontScaling={false}>￥{String(total_price)}</Text>
                    </View>
                    <View style={styles.priceRow}>
                        <Text style={styles.priceTitle} allowFontScaling={false}>跨境商品综合税：</Text>
                        <Text
                            style={styles.priceText} allowFontScaling={false}>￥{String(total_postal_amt)}</Text>
                    </View>
                    <View style={styles.priceRow}>
                        <Text style={styles.priceTitle} allowFontScaling={false}>优惠：</Text>
                        <Text
                            style={styles.priceText} allowFontScaling={false}>￥{String(dc_amt)}</Text>
                    </View>
                    <View style={styles.divideLine}/>
                    <View style={styles.priceRow}>
                        <Text style={[styles.priceTitle, styles.textStyle]} allowFontScaling={false}>合计：</Text>
                        <Text
                            style={[styles.priceText, styles.textStyle]}
                            allowFontScaling={false}>￥{String(total_real_price?total_real_price:0)}</Text>
                    </View>
                </View>
            </CommonDialog>
        );
    }
}
const styles = StyleSheet.create({
    content: {
        padding: 8,
    },
    priceRow: {
        padding: 8,
        flexDirection: 'row',
    },
    priceTitle: {
        fontSize: 14,
        color: '#333333',
        flex: 1,
    },
    priceText: {
        fontSize: 14,
        color: '#333333',
    },
    textStyle: {
        fontSize: 16,
        fontWeight: 'bold',
    },
    divideLine: {
        backgroundColor: '#DDDDDD',
        height: 1,
    }
})

PriceDetailDialog.propTypes = {
    show: PropTypes.bool,
    closeDialog: PropTypes.func.isRequired,
}
PriceDetailDialog.defaultProps = {
    show: false,
}