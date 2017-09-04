/**
 * Created by Zhang.xinchun on 2017/5/10.
 * 购物车的店铺组件
 */
import React, {
    PropTypes
} from 'react';

import {
    Text,
    View,
    Image,
    StyleSheet,
    TouchableOpacity
} from 'react-native';
//常量定义
import * as Constants from '../../app/constants/Constants'
import Immutable from 'immutable'
//自适应
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
export class SectionHeaderRender extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            data: this.props.sectionHeaderData,
            itemsByStore: this.props.shoppingItemsByStore,
        }
    }

    shouldComponentUpdate(nextProps, nextState) {
        return ((this.props.cartType !== nextProps.cartType)
        || (this.props.itemsByStore !== nextProps.itemsByStore)
        || !(Immutable.is(this.props.sectionHeaderData, nextProps.sectionHeaderData)));
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            data: nextProps.sectionHeaderData,
            itemsByStore: nextProps.shoppingItemsByStore,
            cartType: nextProps.cartType,
        })
    }

    render() {
        //选择按钮
        let imgSource = this.state.data.check_shop_yn === Constants.Selected ? require('../Img/cart/selected.png') : require('../Img/cart/unselected.png');
        //店铺logo
        let logoIcon = (this.state.data.logo_url === null || this.state.data.logo_url === undefined) ? require('../Img/cart/logoIcon.png') : {uri: this.state.data.logo_url};
        return (
            <View style={[styles.sectionHeaderViewStyle]}>
                <TouchableOpacity style={styles.sectionHeaderViewLeft} activeOpacity={1} onPress={() => {
                    this.props.onStoreSelected({
                        ven_code: this.state.data.ven_code,
                        check_shop_yn: this.state.data.check_shop_yn
                    });
                }}>
                    <Image source={imgSource}
                           style={styles.titleSelect} resizeMode={'contain'}/>
                    <Image source={logoIcon}
                           style={[styles.sectionHeaderImage]} resizeMode={'contain'} />
                    <Text style={styles.sectionHeaderTitle} allowFontScaling={false}>{this.state.data.alt_desc}</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.sectionHeaderViewRight} activeOpacity={1}>
                    {/*暂不开放的领券功能*/}
                    {/* <Text style={styles.rightTitle}>领券</Text>
                     <Image source={require('../Img/cart/Icon_right_grey_@3x.png')}
                     style={[styles.sectionIconRight]}/>*/}
                </TouchableOpacity>
            </View>
        )
    }
}
//样式定义
const styles = StyleSheet.create({
        sectionHeaderViewStyle: {
            flexDirection: 'row',
            alignItems: 'center',
            justifyContent: 'space-between',
            backgroundColor: '#FBFBFB',
            height: ScreenUtils.scaleSize(102),
            paddingHorizontal: ScreenUtils.scaleSize(30),
            borderBottomColor: '#dddddd',
            borderBottomWidth: ScreenUtils.scaleSize(1),
        },
        sectionHeaderViewLeft: {
            flexDirection: 'row',
            alignItems: 'center',
        },
        sectionHeaderViewRight: {
            flexDirection: 'row',
            alignItems: 'center',
        },
        titleSelect: {
            height: ScreenUtils.scaleSize(34),
            width: ScreenUtils.scaleSize(34)
        }, sectionHeaderImage: {
            height: ScreenUtils.scaleSize(34),
            width: ScreenUtils.scaleSize(34),
            marginLeft: ScreenUtils.scaleSize(30),
            marginRight: ScreenUtils.scaleSize(10),
        },
        sectionIconRight: {
            height: ScreenUtils.scaleSize(17),
            width: ScreenUtils.scaleSize(12),
            marginLeft: ScreenUtils.scaleSize(10),
        },
        sectionHeaderTitle: {
            fontSize: ScreenUtils.setSpText(30),
            color: "#333333"
        },
        rightTitle: {
            fontSize: ScreenUtils.setSpText(30),
            color: "#666666"
        }
    }
)

SectionHeaderRender.propTypes = {
    onStoreSelected: PropTypes.func
}
export default SectionHeaderRender

