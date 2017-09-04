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
//自适应
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
/**
 * 跨境综合税弹窗
 */
export default class TaxDescriptionDialog extends React.PureComponent {

    constructor(props) {
        super(props)
    }

    static propTypes = {
        closeDialog: React.PropTypes.func,
        show:React.PropTypes.bool,
    }

    render() {

        return (
            <CommonDialog show={this.props.show} closeDialog={() => this.props.closeDialog()} title='跨境综合税'
                          buttons={[]}>
                <View style={styles.content}>
                    <Text style={styles.registorTitle} allowFontScaling={false}>实名认证</Text>
                    <View style={styles.separat}/>
                    <Text style={styles.registorContent} allowFontScaling={false}>
                        个人消费者在本网站购买进境保税商品的，应当提供收件人真实姓名和身份证号码，同意委托本网站或者其他代理企业代表收件人向海关办理通关申报和税款缴纳手续。个人消费者需要正确填写订单信息，禁止虚假信息，购买商品符合个人自用合理数量，禁止二次销售。若个人消费者购买商品超出个人自用原则，将受执法部门核查，情节严重者，将依法追究刑事责任。
                    </Text>
                    <Text style={styles.taxTitle} allowFontScaling={false}>通关关税</Text>
                    <View style={styles.separat}/>
                    <Text style={styles.taxContent} allowFontScaling={false}>
                        东方购物所销售的跨境保税商品，依据中华人民共和国海关总署公告，跨境电商零售进口商品由原来征收的行邮税（海关对入境旅客行李物品和个人邮递物品征收的进口税）改为由关税、增值税、消费税组合而成的综合税负，进口商品的单次交易限额也从1000元（港澳台地区为800元）调整为2000元，同时将设置个人年度交易限值为20000元。限额内免收关税，进口环节增值税、消费税按照法定应纳税额的70%征收；限额之外则按照一般贸易方式全额征税。
                    </Text>
                </View>
            </CommonDialog>
        );
    }
}
const styles = StyleSheet.create({
    content: {
        padding: 8,
    },
    registorTitle: {
        marginLeft: ScreenUtils.scaleSize(30),
        fontSize: ScreenUtils.setSpText(28),
        color: "#333333",
    },
    separat: {
        flex:1,
        height: ScreenUtils.scaleSize(3),
        backgroundColor: "#DDDDDD",
        marginTop:ScreenUtils.scaleSize(10)
    },
    registorContent:{
        flexWrap:'wrap',
        marginTop:ScreenUtils.scaleSize(30),
        marginHorizontal:ScreenUtils.scaleSize(30),
        marginBottom:ScreenUtils.scaleSize(50)
    },
    taxTitle: {
        marginLeft: ScreenUtils.scaleSize(30),
        fontSize: ScreenUtils.setSpText(28),
        color: "#333333",
    },
    taxContent:{
        flexWrap:'wrap',
        marginTop:ScreenUtils.scaleSize(30),
        marginHorizontal:ScreenUtils.scaleSize(30),
        marginBottom:ScreenUtils.scaleSize(50)
    },

})