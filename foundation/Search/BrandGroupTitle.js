/**
 * Created by MASTERMIAO on 2017/5/13.
 * 首页导航栏组件
 */
'use strict';
import React  from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
} from 'react-native';
import *as ScreenUtil from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
import Fonts from '../../app/config/fonts';
let key = 20;
export default class SearchTitle extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            selectedIndex: this.props.selectedIndex ? this.props.selectedIndex : 0,
        }
    }

    render() {
        let bgStyle = {
            justifyContent: 'center',
            alignItems: 'center',
            width: ScreenUtil.screenW / this.props.titleData.length,
            height: ScreenUtil.scaleSize(96)
        };

        return (
            <View style={styles.google}>
                <View style={styles.containers}>
                    {
                        this.props.titleData !== '' && this.props.titleData !== null && this.props.titleData.map((title, i) => {
                            let viewer = <View />;
                            if (i === this.state.selectedIndex) {
                                viewer = <TouchableOpacity key={++key} style={styles.bgTable} activeOpacity={1}
                                                           onPress={() => this._clickSelect(i)}>
                                    <View>
                                        <View style={bgStyle}>
                                            <Text style={[styles.textStyle2,{width:ScreenUtil.screenW / this.props.titleData.length,textAlign:'center'}]} allowFontScaling={false}>{title}</Text>
                                        </View>
                                        <View style={{backgroundColor: Colors.main_color, height: ScreenUtil.scaleSize(4)}}/>
                                    </View>
                                </TouchableOpacity>
                            } else {
                                viewer = <TouchableOpacity key={++key} style={styles.bgTable} activeOpacity={1}
                                                           onPress={() => this._clickSelect(i)}>
                                    <View>
                                        <View style={bgStyle}>
                                            <Text style={[styles.textStyle,{width:ScreenUtil.screenW / this.props.titleData.length,textAlign:'center'}]} allowFontScaling={false}>{title}</Text>
                                        </View>
                                        <View style={{backgroundColor: Colors.background_white, height: ScreenUtil.scaleSize(4)}}/>
                                    </View>
                                </TouchableOpacity>
                            }
                            return (viewer)
                        })
                    }
                </View>
            </View>
        )
    }

    _clickSelect = (index) => {
        this.setState({
            selectedIndex: index
        });
        this.props.selectAction(index);
    }
}
SearchTitle.propTypes = {
    titleData: React.PropTypes.array,
    selectedIndex: React.PropTypes.number,
    selectAction: React.PropTypes.func,
};

const styles = StyleSheet.create({
    containers: {
        width: ScreenUtil.screenW,
        height: ScreenUtil.scaleSize(100),
        backgroundColor: 'white',
        marginTop: 1,
        flexDirection: 'row'
    },
    google: {
        flexDirection: 'column'
    },
    bgTable: {
        flexDirection: 'column',
    },
    textStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtil.setSpText(28),
    },
    textStyle2: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(28),
        fontWeight: 'bold'
    }
});

