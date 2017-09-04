/**
 * Created by Xiang on 2017/6/25.
 * 分类频道页，底部
 */
import React from 'react'
import {
    StyleSheet,
    View,
    Text,
    ScrollView,
    Dimensions,
    TouchableOpacity,
} from 'react-native';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtil from "../../foundation/utils/ScreenUtil";
const {width} = Dimensions.get('window');
export default class TabTitle extends React.PureComponent {
    constructor(props) {
        super(props)
        this.state = {
            tabSelectIndex: 0,
            tabPosition: [],
        }
    }

    selectPosition(index) {
        this.setState({
            tabSelectIndex: index,
        });
    }

    render() {
        if (!this.props.data) {
            return null;
        }
        if (this.props.data.length === 0) {
            return null;
        }
        let itemWidth = this.props.data.length < 4 ? width / this.props.data.length : 100;
        return (
            <ScrollView
                ref="tabScrollView"
                style={{marginBottom: 1}}
                horizontal={true}
            >
                {
                    this.props.data.map((item, index) => {
                        if (!item.title) {
                            return;
                        }
                        return (
                            <TouchableOpacity
                                activeOpacity={1}
                                style={[styles.tabTitle, {width: itemWidth}]}
                                onPress={() => {
                                    this.setState({tabSelectIndex: index});
                                    this.props.onFirstClassSelect(index, item.lgroup);
                                }}
                            >
                                <Text
                                    style={[styles.tabTitleText, {color: index === this.state.tabSelectIndex ? Colors.main_color : Colors.text_dark_grey}]} allowFontScaling={false}>{item.title}</Text>

                                {
                                    this.state.tabSelectIndex === index ?
                                        <View style={{
                                            position: 'absolute',
                                            bottom: 0,
                                            height: 2,
                                            backgroundColor: Colors.main_color,
                                            width: itemWidth,
                                        }}/> : null
                                }
                            </TouchableOpacity>)
                    })
                }
            </ScrollView>
        )
    }
}
const styles = StyleSheet.create({
        tabTitleText: {
            fontSize:ScreenUtil.setSpText(28),
        },
        tabTitle: {
            marginTop: 10,
            height: 40,
            width: 200,
            justifyContent: 'center',
            alignItems: 'center',
            backgroundColor: Colors.background_white
        }
    }
)