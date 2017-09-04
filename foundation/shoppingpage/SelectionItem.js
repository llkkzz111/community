/**
 * Created by Administrator on 2017/5/25.
 */
//视频主页分类精选栏目ITEM

import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableWithoutFeedback,
    Image,
} from 'react-native';

import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';

export default class SelectionItem extends React.PureComponent {
    constructor(props) {
        super(props);
    }

    componentDidMount() {

    }

    render() {
        let {selectionItem} = this.props;
        return (
            <TouchableWithoutFeedback onPress={() => {
                this.props.selectionItemClick({
                    id: selectionItem.contentCode,
                    type: selectionItem.liveSource,
                    url: selectionItem.videoPlayBackUrl,
                    codeValue: selectionItem.codeValue
                })
            }}>
                <View style={styles.programItem}>
                    <Image
                        source={{uri: selectionItem.firstImgUrl ? selectionItem.firstImgUrl : '1'}}
                        style={styles.programImg}/>

                    <View style={styles.contents}>
                        <Text style={styles.programItemName} numberOfLines={3}
                              allowFontScaling={false}>{selectionItem.title}</Text>
                        <View style={styles.countAndAuthor}>
                            <Image
                                source={require('../../foundation/Img/shoppingPage/icon_eye_gray_.png')}
                                style={styles.smallPlay}/>
                            <Text style={styles.counter} allowFontScaling={false}>{selectionItem.watchNumber} 观看</Text>
                        </View>
                    </View></View>
            </TouchableWithoutFeedback>
        )
    }
}

const styles = StyleSheet.create({
    programItem: {
        padding: ScreenUtil.scaleSize(20),
        backgroundColor: Colors.background_white,
        flexDirection: 'row',
        justifyContent: 'flex-start'
    },
    programImg: {
        width: ScreenUtil.scaleSize(174),
        height: ScreenUtil.scaleSize(176),
    },

    smallPlay: {
        width: ScreenUtil.scaleSize(23),
        height: ScreenUtil.scaleSize(23),
        resizeMode: 'contain'
    },

    contents: {
        paddingLeft: ScreenUtil.scaleSize(20),
        flex: 1,
        justifyContent: 'space-between',
        //flexDirection:'row',
        //alignItems:'flex-between',
    },
    countAndAuthor: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    programItemName: {
        color: Colors.text_black,
        fontSize: Fonts.standard_normal_font(),
    },
    onLiveTime: {
        color: Colors.line_type,
        fontSize: Fonts.secondary_font(),

    },
    counter: {
        color: Colors.line_type,
        fontSize: Fonts.secondary_font(),
        marginLeft: ScreenUtil.scaleSize(10),
    },

});
