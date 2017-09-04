/**
 * Created by admin-ocj on 2017/6/12.
 */
import React from 'react'
import {
    StyleSheet,
    View,
    Text,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    FlatList,
} from 'react-native';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
const {width} = Dimensions.get('window');
import * as ScreenUtil from "../../foundation/utils/ScreenUtil";

export default class GroupTag extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            selectIndex: 0,
            groupCollapse: true,
        }
    }

    onItemSelected(index) {
        this.setState({selectIndex: index});
        this.props.onSecondClassSelect(this.props.data[index].lgroup);
    }

    selectPosition(index) {
        this.setState({
            selectIndex: index,
        })
    }

    setCollapse(collapse) {
        this.setState({
            groupCollapse: collapse,
        })
    }

    render() {
        let groupData;
        if (this.props.data.length > 8) {
            groupData = this.state.groupCollapse ? this.props.data.slice(0, 8) : this.props.data;
        } else {
            groupData = this.props.data;
        }
        return (
            <View>
                <View style={{
                    flexDirection: 'row',
                    flexWrap: 'wrap',
                    backgroundColor: Colors.background_white,
                    paddingBottom: 10,
                }}>
                    {
                        groupData.map((item, index) => {
                            if (!item.title) {
                                return;
                            }
                            return (
                                <View>
                                    {
                                        index === this.state.selectIndex ?
                                            <View style={[styles.groupTagItem, {backgroundColor: '#FBE7EA'}]}>
                                                <Text
                                                    numberOfLines={1}
                                                    style={[styles.groupTagText, {color: Colors.magenta}]} allowFontScaling={false}>{item.title}</Text>
                                                <Image style={{
                                                    width: 15,
                                                    height: 15,
                                                    resizeMode: 'contain',
                                                    position: 'absolute',
                                                    right: 0,
                                                    bottom: 0
                                                }}
                                                       source={require('../../foundation/Img/searchpage/Icon_label_@3x.png')}/>
                                            </View> :
                                            <TouchableOpacity activeOpacity={1} style={styles.groupTagItem} onPress={() => {
                                                this.onItemSelected(index);
                                            }}>
                                                <Text
                                                    numberOfLines={1}
                                                    style={styles.groupTagText} allowFontScaling={false}>{item.title}</Text>
                                            </TouchableOpacity>
                                    }
                                </View>
                            )
                        })
                    }
                </View>
                {this.props.data.length > 8 ?
                    <View style={{
                        flexDirection: 'row',
                        backgroundColor: Colors.background_white,
                        justifyContent: 'flex-end',
                        paddingBottom: 10,
                        paddingRight: 10,
                    }}>
                        
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                this.setState({groupCollapse: !this.state.groupCollapse})
                            }}
                            style={{flexDirection: 'row', alignItems: 'center'}}>
                            <Text allowFontScaling={false} style={styles.groupCollapseText}>{this.state.groupCollapse ? '更多' : '收起'}</Text>
                            {
                                this.state.groupCollapse
                                    ? <Image
                                        style={styles.groupCollapseImg}
                                        source={require('../../foundation/Img/dialog/collapse_down@3x.png')}/>
                                    : <Image
                                        style={styles.groupCollapseImg}
                                        source={require('../../foundation/Img/dialog/collapse_up@3x.png')}/>
                            }
                        </TouchableOpacity>
                    </View> : null}
                <View style={{height: 1, backgroundColor: Colors.line_grey}}/>
            </View>
        );
    }
}
const styles = StyleSheet.create({
        groupTagText: {
            fontSize: Fonts.secondary_font(),
            color: Colors.text_black,
            paddingLeft: 5,
            paddingRight: 5,
            paddingTop: 3,
            paddingBottom: 3,
        },
        groupTagItem: {
            marginTop: 10,
            marginLeft: 10,
            marginRight: 10,
            borderRadius: 3,
            backgroundColor: Colors.background_grey,
            width: width / 4 - 20,
            padding: 5,
            justifyContent: 'center',
            alignItems: 'center',
        },
        groupCollapseText: {
            color: Colors.text_dark_grey,
            fontSize: Fonts.standard_normal_font()
        },
        groupCollapseImg: {
            width: ScreenUtil.scaleSize(24),
            height: ScreenUtil.scaleSize(16),
            marginLeft: ScreenUtil.scaleSize(10),
        }
    }
)