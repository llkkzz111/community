/**
 * Created by Zhang.xinchun on 2017/5/10.
 * 购物车的底部删除,移入收藏组件
 */

import React, {PropTypes} from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
} from 'react-native';
//自适应
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
export class AllCheckAndAccount extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            allSelected: this.props.allSelected,
            accountDisable: this.props.accountDisable,
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            allSelected: nextProps.allSelected,
            accountDisable: nextProps.accountDisable,
        });
    }

    render() {
        let imgSource = this.state.allSelected ? require('../Img/cart/selected.png') : require('../Img/cart/unselected.png');
        return (
            <View style={styles.accountViewStyle}>
                <TouchableOpacity style={styles.allCheckViewStyle} activeOpacity={1} onPress={() => {
                    this.props.onAllShoppingSelected({selected: this.state.allSelected});
                }}>
                    <View style={styles.imgViewStyle}>
                        <Image source={imgSource} style={styles.imgStyle}/>
                    </View>
                    <View style={styles.chooseViewStyle}>
                        <Text style={styles.allCheckTextStyle} allowFontScaling={false}>全选</Text>
                    </View>
                </TouchableOpacity>
                <View style={styles.btnLayout}>
                    <TouchableOpacity activeOpacity={1} style={styles.allCollectionViewStyle} onPress={() => {
                        this.props.onCollectionSelectItem && this.props.onCollectionSelectItem();
                    }}>
                        <Text style={{color: '#4A4A4A',}} allowFontScaling={false}>移入收藏</Text>
                    </TouchableOpacity>
                </View>
                <TouchableOpacity activeOpacity={1} style={styles.allDeleteViewStyle} onPress={() => {
                    this.props.onDeleteSelectItem && this.props.onDeleteSelectItem();
                }}>
                    <Text style={{color: '#4A4A4A',}} allowFontScaling={false}>删除</Text>
                </TouchableOpacity>
            </View>
        )
    }
}
AllCheckAndAccount.propTypes = {
    onAllShoppingSelected: PropTypes.func,
    onCollectionSelectItem: PropTypes.func,
    onDeleteSelectItem: PropTypes.func,
};

const styles = StyleSheet.create({
    accountViewStyle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        backgroundColor: "#ffffff",
        alignItems: 'center',
        borderTopWidth: ScreenUtils.scaleSize(1),
        borderColor: "#dddddd"
    },
    allCheckViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        flex: 1,
        height: 50,
        paddingLeft: ScreenUtils.scaleSize(30),
    },
    allCollectionViewStyle: {
        alignItems: 'center',
        flex: 1,
        height: 50,
        justifyContent: 'center',

    },
    allDeleteViewStyle: {
        justifyContent: 'center',
        alignItems: 'center',
        flex: 1,
        height: 50,
        flexDirection: 'row',
        paddingRight: 15,

    },
    imgStyle: {
        width: 18,
        height: 18,
    },
    chooseViewStyle: {
        marginLeft: 5
    },

    allCheckTextStyle: {
        fontSize: 13,
        color: '#4A4A4A',
    },
    btnLayout: {
        flex: 1,
        borderLeftWidth: 1,
        borderRightWidth: 1,
        borderColor: '#DDDDDD',
    }
});

export default AllCheckAndAccount