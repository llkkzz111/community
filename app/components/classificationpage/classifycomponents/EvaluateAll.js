/**
 * Created by wangwenliang on 2017/5/11.
 * 商品详情中的评价列表
 */
'use strict';
import {
    StyleSheet,
    View,
    Dimensions,
    Text,
    Image,
    TouchableOpacity,
    ScrollView,
    ART
} from 'react-native';

import {
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Actions,
} from '../../../config/UtilComponent';

import EvaluateAllRequest from '../../../../foundation/net/GoodsDetails/EvaluateAllRequest';
import ToastShow from '../../../../foundation/common/ToastShow';

const {width} = Dimensions.get('window');
const paddingBothSide = ScreenUtils.scaleSize(30);

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
*/
const Com = __DEV__ ? Component : PureComponent;

//内部类精品评价
class EvaluateClass extends Com {
    constructor(props) {
        super(props);
        this.state = {
            expend: false,
            show: false,
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
                        <Image style={styles.star}
                               source={require('../../../../foundation/Img/icons/icon_star_lighten_@3x.png')}/>
                    </View>
                );
            })
        )
    }

    //str:传入的展示内容字符串，size:字体的大小；
    getStrLength(str, size) {
        let realLength = 0, len = str.length, charCode = -1;
        for (let i = 0; i < len; i++) {
            charCode = str.charCodeAt(i);
            if (charCode >= 0 && charCode <= 128)
                realLength += 1;
            else
                realLength += 2;
        }
        return realLength * ScreenUtils.scaleSize(size);
    };

    render() {
        const path = ART.Path();
        path.moveTo(ScreenUtils.scaleSize(60), ScreenUtils.scaleSize(20));
        path.lineTo(ScreenUtils.scaleSize(77), 0);
        path.lineTo(ScreenUtils.scaleSize(94), ScreenUtils.scaleSize(20));
        path.close();

        let expendIcon = '';
        let text = '';
        if (this.state.expend) {
            expendIcon = require('../../../../foundation/Img/cart/gift_menu_up.png');
            text = '收起';
        } else {
            expendIcon = require('../../../../foundation/Img/cart/gift_menu.png');
            text = '展开';
        }


        let name = this.props.item.cust_name;
        let defaultPic = "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3666295712,2472972300&fm=23&gp=0.jpg";
        return (
            <View style={{
                borderBottomWidth: ScreenUtils.scaleSize(2),
                borderBottomColor: '#dddddd',
                paddingBottom: ScreenUtils.scaleSize(30)
            }}>
                <View style={styles.evaItemTop}>

                    <Image style={styles.evaItemTopIcon} source={{uri: this.props.item.headerImage}}
                           resizeMode={'stretch'}/>
                    <Text allowFontScaling={false}
                        style={styles.evaItemTopName}>{name.substr(0, 1) + "**" + name.substr(name.length - 1, 1)}</Text>
                    {this.renderStars(this.props.item.grade)}
                    <Text allowFontScaling={false} style={styles.evaItemTopIime}>{this.props.item.insert_date}</Text>
                </View>

                <Text allowFontScaling={false} style={styles.evaContent}
                      onLayout={({nativeEvent: e}) => {
                          // console.log("#### text：" + e.layout.width * 4);
                          if (this.getStrLength(this.props.item.contents, 26) > (e.layout.width * 4 - ScreenUtils.scaleSize(12))) {
                              this.setState({show: true});
                          }
                      }}
                      numberOfLines={this.state.expend ? 0 : 2}>{this.props.item.contents}</Text>


                <View style={{flexDirection: 'row'}}>
                    {this.props.item.sizeAndColor != null && this.props.item.sizeAndColor != 'null' &&
                    <View style={styles.evaStretch1}><Text allowFontScaling={false} style={{
                        fontSize: ScreenUtils.setSpText(24),
                        color: '#666'
                    }}>{this.props.item.sizeAndColor}</Text></View>
                    }

                    {this.state.show &&
                    <TouchableOpacity activeOpacity={1} onPress={() => {
                        this.setState({expend: !this.state.expend});
                    }} style={styles.evaStretch}>
                        <Text allowFontScaling={false} style={styles.evaStretchT}>{text}</Text>
                        <Image style={styles.evaStretchImage} resizeMode={'contain'} source={expendIcon}/>
                    </TouchableOpacity>
                    }
                </View>


                {this.props.item.answer != null &&
                <View >
                    <ART.Surface width={width} height={ScreenUtils.scaleSize(20)}>
                        <ART.Shape d={path} fill={"#eee"}/>
                    </ART.Surface>
                    <Text allowFontScaling={false} style={{
                        padding: ScreenUtils.scaleSize(20),
                        color: '#666',
                        fontSize: ScreenUtils.setSpText(24),
                        backgroundColor: "#eee"
                    }}>东东回复：{this.props.item.answer}</Text>
                </View>
                }


                <ScrollView style={styles.evaSV} horizontal={true}>
                    {this.props.item.pics.length>0 && this.props.item.pics.map((item2, j) => {
                        return (
                            <TouchableOpacity
                                onPress={() => {
                                    Actions.SingleEvaluationPage({
                                        page: 'EvaluateAll',
                                        allDatas: this.props.allDatas,
                                        i: this.props.i,
                                        item: this.props.item
                                    });
                                }}
                                activeOpacity={1}
                                key={j}>
                                <Image style={styles.evaSVImage} source={{uri: item2}}
                                       resizeMode={'stretch'}/>
                            </TouchableOpacity>
                        );
                    })}
                </ScrollView>

            </View>
        );
    }
}

export default class EvaluateAll extends Com {
    constructor(props) {
        super(props);
        this.state = {
            expend: false,
            currentPage: 1,
            refresh: false,
            datas: {
                currpage: "0",
                cntStar: 0,
                totalPages: 0,
                comm_total: 0,
                pic_yn: "N",
                contentList: [
                    {
                        sizeAndColor: "",//缺失字段
                        item_code: "",
                        answer: null,//结构不清楚
                        contents: "",
                        headerImage: "",//缺失字段
                        insert_date: "",//格式需要修改
                        grade: 0,
                        cust_name: "",
                        pics: []
                    }
                ]
            },
            contentList: [
                {
                    sizeAndColor: "",//缺失字段
                    item_code: "",
                    answer: null,//结构不清楚
                    contents: "",
                    headerImage: "",//缺失字段
                    insert_date: "",//格式需要修改
                    grade: 0,
                    cust_name: "",
                    pics: []
                }
            ],
        }

        this.getDatas(true, 1);
    }


    getDatas(first, pageNum) {
        if (this.evaAllR) {
            this.evaAllR.setCancled(true)
        }
        let req = {
            // item_Code:'6107382014',
            item_Code: this.props.allDatas != null && this.props.allDatas.goodsDetail != null && this.props.allDatas.goodsDetail.item_code,
            currpage: pageNum + ""
        };
        this.evaAllR = new EvaluateAllRequest(req, "GET");
        this.evaAllR.showLoadingView(true).start((response) => {

            if (response.code !== null && response.code === 200 && response.data !== null) {
                // console.log("####### 全部评价aa："+JSON.stringify(response));
                this.setState({datas: response.data});

                if (first) {
                    this.setState({contentList: response.data.contentList});
                } else {
                    let old = this.state.contentList;
                    let newarry = response.data.contentList;
                    for (let i = 0; i < newarry.length; i++) {
                        old.push(newarry[i]);
                    }
                    this.setState({contentList: old});
                    // console.log("####### 全部评价："+JSON.stringify(old));
                }
                this.setState({refresh: !this.state.refresh});
            }
        }, (err) => {
            ToastShow.toast(JSON.stringify(err));
            // console.log("##### 错误："+JSON.stringify(this.state.contentList));
            // console.log(JSON.stringify(err));
        });
    }

    //根据传入的数据来显示几颗星
    renderStars1(num) {
        let arry = [];
        for (let i = 0; i < parseInt(num); i++) {
            arry[i] = i;
        }
        return (
            arry.map((item, i) => {
                return (
                    <View key={i}>
                        <Image style={styles.star1}
                               source={require('../../../../foundation/Img/icons/icon_star_lighten_@3x.png')}/>
                    </View>
                );
            })
        )
    }


    render() {

        return (

            <View>
                <View style={styles.mainItemStyle}>
                    <View style={styles.evaluateTop}>
                        <Text allowFontScaling={false}
                            style={styles.evaluateTopT1}>商品评价（{String(this.state.datas.comm_total != null && this.state.datas.comm_total)}）</Text>
                        <Text allowFontScaling={false} style={styles.evaluateTopT2}>综合评分</Text>
                        <View style={styles.evaluateTopRightStars}>
                            {this.renderStars1(this.state.datas.cntStar != null && Math.round(this.state.datas.cntStar))}
                        </View>
                    </View>


                    {this.state.contentList != null && this.state.contentList.map((item, index) => {
                        return (
                            <View key={index}>
                                <EvaluateClass item={item} i={index} allDatas={this.props.allDatas}/>
                            </View>

                        )
                    })

                    }


                </View>

                {this.state.datas.totalPages > parseInt(this.state.currentPage) ?
                    <TouchableOpacity
                        activeOpacity={1}
                        style={styles.evaluateBottom}>
                        <Text allowFontScaling={false}
                            style={styles.evaluateBottomText}
                            onPress={() => {
                                this.getDatas(false, (parseInt(this.state.currentPage) + 1));
                                this.setState({currentPage: parseInt(this.state.currentPage) + 1});
                            }}>点击加载更多哦～</Text>
                    </TouchableOpacity>
                    :
                    <View style={styles.evaluateBottom}>
                        <Text allowFontScaling={false}
                            style={styles.evaluateBottomText}
                        >已经没有更多啦～</Text>
                    </View>

                }

            </View>
        );
    }
}

const ts12 = 12;
const ts14 = 14;
const ts16 = 16;
const ts18 = 18;
const ts20 = 20;
const ts22 = 22;
const ts24 = 24;
const cb = '#333';
const cg = '#666666';
const cr = '#E5290D';
const cy = '#ffb001';


const styles = StyleSheet.create({

    mainItemStyle: {
        minHeight: Dimensions.get('window').height - 120,
        padding: paddingBothSide,
        // borderBottomWidth: ScreenUtils.scaleSize(20),
        // borderBottomColor: '#dedede',
        overflow: 'hidden',
    },
    evaluateTop: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottomWidth: 1,
        borderBottomColor: '#dedede',
        paddingTop: ScreenUtils.scaleSize(20),
        paddingBottom: 20,
    },
    evaluateTopT1: {
        color: '#444',
        flex: 0,
        fontSize: ScreenUtils.setSpText(28),
    },
    evaluateTopT2: {
        color: cr,
        flex: 1,
        textAlign: 'right',
        marginRight: 3,
        fontSize: ScreenUtils.setSpText(28),
    },
    evaluateTopRightStars: {
        width: ScreenUtils.scaleSize(190),
        flex: 0,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
    },
    star: {
        width: ScreenUtils.scaleSize(20),
        height: ScreenUtils.scaleSize(20),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    star1: {
        width: ScreenUtils.scaleSize(26),
        height: ScreenUtils.scaleSize(26),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    evaluateBottom: {
        backgroundColor: '#ededed',
        height: ScreenUtils.scaleSize(97),
        width: ScreenUtils.screenW,
        justifyContent: 'center',
        alignItems: 'center'
    },
    evaluateBottomText: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#999'
    },
    evaItemTop: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(20),
        marginBottom: ScreenUtils.scaleSize(20),
    },
    evaItemTopIcon: {
        width: ScreenUtils.scaleSize(50),
        height: ScreenUtils.scaleSize(50),
        flex: 0,
        borderRadius: 15,
    },
    evaItemTopName: {
        color: '#444',
        fontSize: ScreenUtils.setSpText(26),
        marginLeft: ScreenUtils.scaleSize(20),
        flex: 0,
    },
    evaItemTopIime: {
        flex: 1,
        fontSize: ScreenUtils.setSpText(26),
        color: '#666',
        textAlign: 'right',
    },
    evaContent: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#444',
        lineHeight: 20,
    },
    evaStretch: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(10),
        marginBottom: ScreenUtils.scaleSize(10),
        flex: 1,
    },
    evaStretch1: {
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(10),
        marginBottom: ScreenUtils.scaleSize(10),
        flex: 1,
    },
    evaStretchT: {
        color: cg,
        fontSize: ts12,
        // lineHeight:60,
    },
    evaStretchImage: {
        width: ScreenUtils.scaleSize(20),
        height: ScreenUtils.scaleSize(20),
    },
    evaSV: {
        width: width - paddingBothSide * 2,
        // height:90,
    },
    evaSVImage: {
        width: ScreenUtils.scaleSize(220),
        height: ScreenUtils.scaleSize(220),
        margin: ScreenUtils.scaleSize(10),
    },
});

// export default connect(state=>({
//     // resultDatas:state.ClassificationPageReducer.result
//     resultDatas:state.ClassificationPageReducer
// }),dispatch=>({
//     // getDatas:(data)=>dispatch(ClassificationPagaAction.getEvaluateDatas(data)),
// }))(EvaluateAll)
