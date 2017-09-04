/**
 * Created by wangwenliang on 2017/5/4.
 * Update by Wjj on 2017/5/14.
 */
import React from 'react'
import {
    StyleSheet,
    Text,
    TouchableOpacity,
    FlatList,
} from 'react-native'
import Fonts from '../../config/fonts';
import Colors from '../../config/colors';
import * as ScreenUtil from "../../../foundation/utils/ScreenUtil";
let mWidth = 0;
export default class ClassifyLeftList extends React.PureComponent {
    constructor(props) {
        super(props);
        // 默认索引
        this.state = {
            selectedItemId: 0,
        };
        mWidth = this.props.width;
    }

    render() {
        return (
            <FlatList
                style={{width: mWidth, alignSelf: 'stretch'}}
                horizontal={false}
                data={this.props.datas}
                legacyImplementation={true}
                getItemLayout={(data, index) => (
                    {length: ScreenUtil.scaleSize(100), offset: ScreenUtil.scaleSize(100) * index, index}
                )}
                renderItem={({item, index}) => {
                    return (
                        <TouchableOpacity
                            activeOpacity={1}
                            style={`${this.state.selectedItemId}` === `${index}` ? styles.itemSelected : styles.itemUnSelected}
                            onPress={() => {
                                this.setState({selectedItemId: index});
                                this.props.onItemClick(item, index);
                            }}
                        >
                            <Text
                                allowFontScaling={false}
                                style={`${this.state.selectedItemId}` === `${index}` ? styles.textSelected : styles.textUnSelected}>
                                {item.name}
                            </Text>
                        </TouchableOpacity>
                    );
                }}
            />
        );
    }
}
const styles = StyleSheet.create({
    itemSelected: {
        borderLeftWidth: 3,
        borderLeftColor: Colors.main_color,
        backgroundColor: Colors.background_white,
        justifyContent: 'center',
        alignItems: 'center',
        height: 50,
    },
    itemUnSelected: {
        borderTopWidth: 0.5,
        borderTopColor: Colors.background_white,
        justifyContent: 'center',
        alignItems: 'center',
        height: 50,
        borderLeftWidth: 2,
        borderLeftColor: '#f5f5f5',
        backgroundColor: '#f5f5f5',
        borderBottomWidth: 0.5,
        borderBottomColor: Colors.background_white,
    },
    textUnSelected: {
        marginLeft: 5,
        marginRight: 5,
        fontSize: Fonts.standard_normal_font(),
        color: Colors.text_black,
        backgroundColor: 'transparent',
    },
    textSelected: {
        marginLeft: 5,
        marginRight: 5,
        fontSize: Fonts.standard_normal_font(),
        color: Colors.main_color,
        backgroundColor: 'transparent',
    }
});
//组件引用说明
ClassifyLeftList.propTypes = {
    onItemClick: React.PropTypes.func, //条目点击事件
    width: React.PropTypes.number, //控件宽度
    datas: React.PropTypes.array, //数据
};
