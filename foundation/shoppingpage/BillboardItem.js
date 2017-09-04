/**
 * Created by Administrator on 2017/5/25.
 */
//视频主页榜单ITEM
import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    FlatList,
    TouchableOpacity,
    Image,
} from 'react-native';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import {Actions} from 'react-native-router-flux';
import * as ScreenUtil from '../utils/ScreenUtil';
import * as RouteManager from '../../app/config/PlatformRouteManager';
import RnConnect from '../../app/config/rnConnect';
import * as routeConfig from '../../app/config/routeConfig'
import * as NativeRouter from '../../app/config/NativeRouter';

export default class BillboardItem extends React.PureComponent {

    constructor(props) {
        super(props);
        this.state = {}
    }

    moreClick() {
        Actions.allVideoListPage({select: 1001});
    }


    render() {
        let {billboardItem} = this.props;
        let tabs = [];
        let labelName = '';
        if (billboardItem && billboardItem.componentList && billboardItem.componentList[0]) {
            labelName = billboardItem.componentList[0].labelName;
            tabs = billboardItem.componentList[0].componentList;
        }
        return (
            <View style={{borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: '#dddddd'}}>
                <View style={styles.titleView}>
                    <View style={styles.dotStyle}></View>
                    <Text style={styles.titleText} allowFontScaling={false}> {labelName} </Text>
                </View>
                <FlatList data={tabs}
                          showsHorizontalScrollIndicator={false}
                          horizontal={true}
                    //ItemSeparatorComponent={{marginLeft:15}}
                    //numColumns={2}
                          renderItem={({item, index}) => {

                              return (
                                  <TouchableOpacity
                                      style={{
                                          marginLeft: ScreenUtil.scaleSize(30),
                                          width: ScreenUtil.scaleSize(300),
                                          marginBottom: ScreenUtil.scaleSize(30)
                                      }}
                                      activeOpacity={1}
                                      onPress={() => {
                                          this.props.pressbtn({
                                              id: item.contentCode,
                                              type: item.liveSource,
                                              url: item.videoPlayBackUrl,
                                              codeValue: item.codeValue
                                          })
                                      }}>

                                      <Image source={{uri: item.firstImgUrl ? item.firstImgUrl : '123'}}
                                             style={styles.videoImgStyle}/>

                                      <Text numberOfLines={1}
                                            style={{
                                                marginTop: ScreenUtil.scaleSize(20),
                                                fontSize: ScreenUtil.setSpText(28),
                                                color: '#333',
                                            }} allowFontScaling={false}>{item.title}</Text>

                                  </TouchableOpacity>
                              )
                          }}
                          ListFooterComponent={() => {
                              return (
                                  <View>
                                      {
                                          tabs && tabs.length > 4 ?
                                              <TouchableOpacity style={styles.moreStyle} activeOpacity={1}
                                                                onPress={() => {
                                                                    this.moreClick()
                                                                }}>
                                                  <Text allowFontScaling={false} style={{}}
                                                  >查看更多</Text>
                                              </TouchableOpacity>
                                              : <View></View>
                                      }
                                  </View>
                              )
                          }}
                >
                </FlatList>

            </View>
        )
    }

}

const styles = StyleSheet.create({

    titleView: {
        padding: 10,
        flexDirection: 'row',
        alignItems: 'center'
    },
    titleText: {
        fontSize: Fonts.page_normal_font(),
        color: Colors.text_black
    },
    dotStyle: {
        borderRadius: 2,
        height: 4,
        width: 4,
        backgroundColor: Colors.main_color,
        justifyContent: 'center',
        alignItems: 'center'
    },
    videoImgStyle: {
        height: ScreenUtil.scaleSize(314),
        width: ScreenUtil.scaleSize(314),
        resizeMode:'contain'
    },
    moreStyle: {
        width: ScreenUtil.scaleSize(30),
        paddingTop: ScreenUtil.scaleSize(70),
        marginLeft: ScreenUtil.scaleSize(40),
        marginRight: ScreenUtil.scaleSize(30),
        justifyContent: 'center'
    },

});
