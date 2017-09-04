/**
 * Created by dongfanggouwu-xiong on 2017/6/8.
 */
import React, {Component} from 'react'
import {
    StyleSheet,
    View,
    Text,
    Dimensions,
    ART,
    ScrollView,
    Platform
} from 'react-native'
var {
    Surface,
    Group,
    Shape,
    Path
} = ART;
var {width, height, scale} = Dimensions.get('window');
import NavigationBar from '../../foundation/common/NavigationBar';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
import Colors from '../../app/config/colors';
export default class MessageListDetailPage extends Component {
    constructor(props){
        super(props);
        this.state={
            messagesData:{}
        }
    }
    render() {
        const {item} = this.props;
        const path = Path()
            .moveTo(1,1)//移动起始点
            .lineTo(width,1);//绘制结束后的坐标点
        return (
            <View style={styles.container}>
                <NavigationBar
                    title={'消息详情'}
                    navigationStyle={{height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                    titleStyle={{
                        color: Colors.text_black,
                        backgroundColor: 'transparent',
                        fontSize: ScreenUtils.scaleSize(36)
                    }}
                    barStyle={'dark-content'}
                />
                <View style={{width:width,backgroundColor:'#DDDDDD',height:1}}/>
                <Text allowFontScaling={false} style={styles.timeSty}>{item.startDate}</Text>
                <ScrollView>
                <View style={styles.boxSty}>
                    <Text allowFontScaling={false} style={styles.textOne}>{item.subject}</Text>
                    <View style={{paddingTop:10}}>
                        <Surface width={width} height={1}>
                            <Shape d={path} stroke="#DDDDDD" strokeWidth={1} />
                        </Surface>
                    </View>
                    <Text allowFontScaling={false} style={styles.textTwo}>{item.subText}</Text>
                </View>
            </ScrollView>
            </View>

        )
    }
}
const styles = StyleSheet.create({
    container:{
        flex: 1,
        backgroundColor: '#ededed'
    },
    timeSty:{
        padding:5,
        fontSize:12,
        textAlign:'center',
    },
    textOne:{
        marginTop:5,
        marginLeft:8,
        fontSize:16
    },
    textTwo:{
        marginTop:5,
        marginLeft:5,
        fontSize:14,
        padding:10
    },
    boxSty:{
        paddingTop:5,
        backgroundColor:'#FFFFFF',
        marginLeft:10,
        marginRight:10,
    }
})
