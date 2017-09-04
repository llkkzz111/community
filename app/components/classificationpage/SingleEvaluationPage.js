/**
 * Created by wangwenliang on 2017/6/19.
 */
import React from 'react';
import {
    StyleSheet,
    View,
    Dimensions,
    Text,
    Image,
    TouchableOpacity,
    StatusBar,
    Platform
} from 'react-native';
import {Actions} from 'react-native-router-flux';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import ViewPager from 'react-native-viewpager';
import * as routeConfig from '../../config/routeConfig';
import RnConnect from '../../config/rnConnect';
const {width, height} = Dimensions.get('window');
import * as RouteManager from '../../config/PlatformRouteManager';
// {
//     "sizeAndColor": "null",
//     "item_code": "15132799",
//     "answer": null,
//     "contents": "质量很好，买小了，立马给换大一号，赞一个",
//     "headerImage": "http://image1.ocj.com.cn/common/html5/images/user/flowers.jpg",
//     "insert_date": "2017-06-17",
//     "grade": 5,
//     "cust_name": "柯铭炜",
//     "pics": []
// }

export default class SingleEvaluationPage extends React.PureComponent {
    constructor(props) {
        super(props);
        //判断从哪过来
        let IMAGES = []
        if (this.props.page === "comment") {//精品评价
            IMAGES = this.props.item.comment_pics;
        } else if (this.props.page === 'EvaluateAll') {//全部评价
            IMAGES = this.props.item.pics;
        }
        // 用于构建DataSource对象
        let dataSource = new ViewPager.DataSource({
            pageHasChanged: (p1, p2) => p1 !== p2,
        });
        // 实际的DataSources存放在state中
        this.state = {
            dataSource: dataSource.cloneWithPages(IMAGES)
        }
    }

    //根据传入的数据来显示几颗星
    renderStars(num) {
        let arry = [];
        for (let i = 0; i < parseInt(num); i++) {
            arry[i] = i;
        }
        return (
            arry.map((item, i) => {
                return (
                    <View key={i}>
                        <Image style={styles.star1}
                               source={require('../../../foundation/Img/icons/icon_star_lighten_@3x.png')}/>
                    </View>
                );
            })
        )
    }

    //精品评价
    renderItem(item, index) {
        return (
            <View key={index}>
                <Image resizeMode={'stretch'} style={{width: width, height: height - ScreenUtils.scaleSize(150)}}
                       source={{uri: item.picUrl}}/>
            </View>
        )
    }

    //全部评价
    renderItem2(item, index) {
        // console.log("--------- 全部评价图片："+item);
        return (
            <View key={index}>
                <Image resizeMode={'stretch'} style={{width: width, height: height - ScreenUtils.scaleSize(150)}}
                       source={{uri: item}}/>
            </View>
        )
    }

    renderBottom(userpic, name) {
        if (this.props.page === "comment") {//精品评价
            return (
                <View style={styles.bottomView}>
                    <View style={styles.evaItemTop}>
                        <Image style={styles.evaItemTopIcon} source={userpic}
                               resizeMode={'stretch'}/>
                        <Text
                            allowFontScaling={false}
                            style={styles.evaItemTopName}>{name.substr(0, 1) + "**" + name.substr(name.length - 1, 1)}</Text>
                        {this.renderStars(this.props.item.comment_grade)}
                        <Text
                            allowFontScaling={false}
                            style={styles.evaItemTopIime}>{this.props.item.comment_time}</Text>
                    </View>
                    <Text
                        allowFontScaling={false}
                        style={styles.evaContent}>{this.props.item.comment_content}</Text>
                </View>
            )
        } else if (this.props.page === 'EvaluateAll') {//全部评价
            return (
                <View style={styles.bottomView}>
                    <View style={styles.evaItemTop}>
                        <Image style={styles.evaItemTopIcon} source={userpic}
                               resizeMode={'stretch'}/>
                        <Text
                            allowFontScaling={false}
                            style={styles.evaItemTopName}>{name.substr(0, 1) + "**" + name.substr(name.length - 1, 1)}</Text>
                        {this.renderStars(this.props.item.grade)}
                        <Text
                            allowFontScaling={false}
                            style={styles.evaItemTopIime}>{this.props.item.insert_date}</Text>
                    </View>

                    <Text
                        allowFontScaling={false}
                        style={styles.evaContent}>{this.props.item.contents}</Text>

                </View>
            )
        }
    }

    render() {
        let name = "";
        let userpic = "";
        if (this.props.page === "comment") {//精品评价
            name = this.props.item.comment_custname;
            userpic = this.props.item.comment_image ? {uri: this.props.item.comment_image} : require('../../../foundation/Img/goodsdetail/Icon_user_red_@3x.png');
        } else if (this.props.page === 'EvaluateAll') {//全部评价
            name = this.props.item.cust_name;
            userpic = this.props.item.headerImage ? {uri: this.props.item.comment_userpic} : require('../../../foundation/Img/goodsdetail/Icon_user_red_@3x.png');
        }

        return (
            <View style={{width: width, height: height}}>
                <StatusBar
                    translucent={true}
                    barStyle={'dark-content'}
                    backgroundColor={'transparent'}
                />
                <View style={[styles.topBar, {
                    backgroundColor: "#fff",
                    marginTop: ScreenUtils.scaleSize(50),
                    height: ScreenUtils.scaleSize(100)
                }]}>
                    <View style={{flex: 1, marginLeft: 10}}>
                        <TouchableOpacity
                            style={{
                                width: 30,
                                height: 30,
                                justifyContent: 'center',
                                alignItems: 'center'
                            }}
                            activeOpacity={1}
                            onPress={() => {
                                Actions.pop()
                            }}>
                            <Image style={styles.topBarImage}
                                   source={require('../../../foundation/Img/goodsdetail/icon_back666_@3x.png')}
                                   resizeMode={'contain'}/>
                        </TouchableOpacity>
                    </View>


                    <TouchableOpacity
                        activeOpacity={1}
                        style={{
                            width: ScreenUtils.scaleSize(70),
                            height: ScreenUtils.scaleSize(70),
                            justifyContent: 'center',
                            alignItems: 'center',
                            marginRight: ScreenUtils.scaleSize(30)
                        }}
                        onPress={() => {
                            let content = {
                                title: "精选商品为您推荐：" + this.props.allDatas.goodsDetail.item_name,
                                image_url: this.props.allDatas.goodsDetail.shareImg,
                                target_url: "http://m.ocj.com.cn/detail/" + this.props.allDatas.goodsDetail.item_code,
                            }


                            if (Platform.OS === 'ios'){

                                RouteManager.routeJump({
                                    page: routeConfig.Share,
                                    param: {
                                        title: content.title,
                                        text: '',
                                        image: content.image_url,
                                        url: content.target_url
                                    },
                                    //fromRNPage: routeConfig.GoodsDetailMain,
                                })

                            }else {
                                RouteManager.routeJump({
                                    page: routeConfig.Share,
                                    param: {
                                        title: content.title,
                                        content: '',
                                        image_url: content.image_url,
                                        target_url: content.target_url
                                    },
                                    //fromRNPage: routeConfig.GoodsDetailMain,
                                })
                            }


                        }}>
                        <Image style={[styles.topBarImage]}
                               source={require('../../../foundation/Img/goodsdetail/icon_share666_@3x.png')}
                               resizeMode={'contain'}/>
                    </TouchableOpacity>
                </View>
                <ViewPager
                    style={{width: width, height: height, backgroundColor: '#f00'}}
                    dataSource={this.state.dataSource}
                    renderPage={this.props.page === 'comment' ? this.renderItem : this.renderItem2}
                    autoPlay={false}
                    isLoop={false}
                />
                {this.renderBottom(userpic, name)}
            </View>
        )
    }
}

const styles = StyleSheet.create({
    topBar: {
        flexDirection: 'row',
        // position: 'absolute',
        // top: 0,
        // left: 0,
        // backgroundColor:'#0f0',
        width: width,
        backgroundColor: 'rgba(225,225,225, 0)',
        alignItems: 'center',
        justifyContent: 'flex-end'
    },
    topBarImage: {
        width: 20,
        height: 20,
    },
    bottomView: {
        position: 'absolute',
        bottom: 0,
        width: width,
        backgroundColor: 'rgba(0,0,0,0.5)',
        padding: ScreenUtils.scaleSize(30)
    },

    evaItemTop: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: 10,
        marginBottom: 10,
    },
    evaItemTopIcon: {
        width: ScreenUtils.scaleSize(50),
        height: ScreenUtils.scaleSize(50),
        flex: 0,
        borderRadius: 15,
    },
    evaItemTopName: {
        color: '#fff',
        fontSize: ScreenUtils.setSpText(26),
        marginLeft: 10,
        flex: 0,
    },
    evaItemTopIime: {
        flex: 1,
        fontSize: ScreenUtils.setSpText(26),
        color: '#fff',
        textAlign: 'right',
    },
    evaContent: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#fff',
        lineHeight: 20,
    },
    star1: {
        width: ScreenUtils.scaleSize(26),
        height: ScreenUtils.scaleSize(26),
        marginLeft: 6,
    },
});