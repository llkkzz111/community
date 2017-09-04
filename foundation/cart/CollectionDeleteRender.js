/**
 * Created by Zhang.xinchun on 2017/5/10.
 * 删除,移入收藏部分组件
 */
import React, {
    PropTypes
} from 'react';

import {
    Text,
    View,
    StyleSheet,
    TouchableOpacity
} from 'react-native';

export class CollectionDeleteRender extends React.PureComponent {
    constructor(props) {
        super(props)
        this.state = {
            data: this.props.dataSource,
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({data: nextProps.dataSource});
    }

    shouldComponentUpdate(nextProps, nextState) {
        return this.state.data.cart_seq !== nextState.data.cart_seq;
    }

    render() {
        return (
            <View style={[styles.backRightBtn]}>
                <TouchableOpacity activeOpacity={1} style={styles.backRightBtnRightColl} onPress={() => {
                    this.props.onCollection({
                        cart_seq: this.state.data.cart_seq,
                        item_code: this.state.data.item_code,
                    });
                }}>
                    <Text style={styles.backTextWhite} allowFontScaling={false}>移入</Text><Text style={styles.backTextWhite} allowFontScaling={false}>收藏</Text>
                </TouchableOpacity>
                <TouchableOpacity activeOpacity={1} style={styles.backRightBtnRight} onPress={() => {
                    this.props.onDelete({
                        cart_seq: this.state.data.cart_seq,
                        item_code: this.state.data.item_code,
                    });
                }}>
                    <Text style={styles.backTextWhite} allowFontScaling={false}>删除</Text>
                </TouchableOpacity>
            </View>
        )
    }
}
//样式定义
const styles = StyleSheet.create({
        backRightBtn: {
            bottom: 0,
            position: 'absolute',
            top: 0,
            width: 100,
            right: 0,
            flex: 1,
            flexDirection: 'row',
        },
        backRightBtnRightColl: {
            backgroundColor: '#DDDDDD',
            right: 0,
            flex: 1,
            alignItems: 'center',
            justifyContent: 'center',
        },
        backRightBtnRight: {
            alignItems: 'center',
            justifyContent: 'center',
            right: 0,
            flex: 1,
            backgroundColor: "#ED1C41",
        },
        backTextWhite: {
            color: 'white',
            fontSize: 13,
            textAlign: "center"
        },
    }
)
CollectionDeleteRender.propTypes = {
    onCollection: PropTypes.func,
    onDelete: PropTypes.func,
};
export default CollectionDeleteRender
