/**
 * Created by YASIN on 2017/6/5.
 * 全球购头部tabview
 */
import React, {PropTypes} from 'react';
import {
    View,
    StyleSheet,
    FlatList
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import HeaderTabItem from './HeaderTabItem';
export default class HeaderTab extends React.Component {
    static propTypes = {
        datas: PropTypes.array,
        onItemClick: PropTypes.func
    };

    render() {
        return (
            <View style={styles.container}>
                <FlatList
                    horizontal={true}
                    data={this.props.datas}
                    renderItem={({item, index}) => (
                        <HeaderTabItem
                            key={index}
                            icon={require('../../../../foundation/Img/home/googs1@2x.png')}
                            title={item.title}
                            flag={item.flag}
                            onItemClick={() => {
                                this.props.onItemClick && this.props.onItemClick(index)
                            }}
                        />
                    )}
                    overScrollMode={'never'}
                    showsHorizontalScrollIndicator={false}
                />
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        paddingVertical: ScreenUtils.scaleSize(20),
        backgroundColor: Colors.text_white,
        paddingHorizontal: ScreenUtils.scaleSize(15)
    }
});
