/**
 * Created by YASIN on 2017/6/5.
 * 200元购遍全球listitem
 */
import React from 'react';
import {
    View,
    StyleSheet,
    Image,
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
export default class GlobalShoppingList extends React.Component {
    static propTypes = {
        icon: PropTypes.string,
        nationIcon: Image.propTypes.source,
        title: PropTypes.string,
        price: PropTypes.string
    };

    render() {
        return (
            <View style={styles.container}>

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