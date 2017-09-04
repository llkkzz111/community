/**
 * Created by wangwenliang on 2017/5/11.
 * 商品详情中的规格参数
 */
import React, { Component, PureComponent } from 'react';
import {
    StyleSheet,
    View,
    Dimensions,
    Text,
    Image,
    ListView,
    ScrollView,
    TouchableOpacity
} from 'react-native'
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import StandardNumRequest from '../../../../foundation/net/GoodsDetails/StandardNumRequest';

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
*/
const Com = __DEV__ ? Component : PureComponent;

class MainItemClass extends Com {
    constructor(props) {
        super(props);
        const dataSource3 = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            dataSource3: dataSource3,
            show: false,
        }
    }

    componentDidMount() {
        if (this.props.id === 0) {
            this.setState({show: true});
        }
    }

    renderItem(rowData, rowId) {
        // console.log("##### standardnum item:"+JSON.stringify(rowData))
        {
            return (rowData.explainNote && rowData.explainMname) ?

                <View key={rowId} style={[styles.itemChildView]}>
                    <Image style={styles.itemChildImage}
                           source={require('../../../../foundation/Img/goodsdetail/icon_listtag_@3x.png')}/>
                    <Text
                        allowFontScaling={false}
                        style={styles.itemChildTitle}>{rowData.explainMname + "：" + rowData.explainNote}</Text>
                </View>

                :
                <View/>
        }

    }

    render() {
        // console.log("######## 这里是规格参数item render");
        let icon = this.state.show ? require('../../../../foundation/Img/cart/Icon_minus_@3x.png') : require('../../../../foundation/Img/cart/Icon_add_@3x.png');
        return (
            <TouchableOpacity
                activeOpacity={1}
                onPress={() => {
                    this.setState({show: !this.state.show})
                }}>
                <View style={styles.mainItemStyle} key={this.props.id}>
                    <TouchableOpacity
                        onPress={() => {
                            this.setState({show: !this.state.show})
                        }}
                        activeOpacity={1}
                        style={styles.itemTitle}>
                        <Text
                            allowFontScaling={false}
                            style={styles.title}>{this.props.item.explainLname}</Text>
                        <Image style={{
                            width: ScreenUtils.scaleSize(24),
                            height: this.state.show ? ScreenUtils.scaleSize(1) : ScreenUtils.scaleSize(24)
                        }} source={icon}/>
                    </TouchableOpacity>
                    <View>
                        {this.state.show ? (

                            this.props.item.explainChildName.map((item,i)=>{
                                return(
                                    <View key={i}>
                                        {this.renderItem(item, i)}
                                    </View>
                                )

                            })


                        ) : <View/>}
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
}

export default class StandardNum extends Com {
    constructor(props) {
        super(props);
        this.state = {
            datas: [
                {
                    explainLname: "商品概要",
                    explainChildName: [
                        {
                            modelCode: "43",
                            explainLname: "商品概要",
                            explainMname: "本商品配套",
                            explainNote: null,
                            itemCode: "6107382014"
                        }
                    ]
                }
            ]
        }
    }

    componentDidMount() {
        this.getDatas();
    }

    getDatas() {
        if (this.stanNumR) {
            this.stanNumR.setCancled(true)
        }
        let req = {
            item_code: this.props.allDatas !== null && this.props.allDatas.goodsDetail.item_code
        };
        this.stanNumR = new StandardNumRequest(req, "GET");
        this.stanNumR.start((response) => {
            if (response.code !== null && response.code === 200 && response.data !== null) {
                this.setState({datas: response.data});
                // console.log('++++++++ :'+JSON.stringify(response.data));
            }
        }, (err) => {
            // console.log(JSON.stringify(err));
        });
    }

    render() {
        return (
            <ScrollView>
                <View style={{
                    minHeight: Dimensions.get('window').height - 120
                }}>
                    {
                        this.state.datas.map((item, i) => {

                            //遍历 判断是否有数据
                            let show = false;
                            if (item.explainChildName === undefined || item.explainChildName == null || item.explainChildName.length === 0) {
                                show = false;
                            } else {
                                for (let i = 0; i < item.explainChildName.length; i++) {
                                    if (item.explainChildName[i].explainMname && item.explainChildName[i].explainNote) {
                                        show = true;
                                    }
                                }
                            }

                            if (show) {
                                return (
                                    <View key={i}>
                                        <MainItemClass item={item} id={i}/>
                                    </View>
                                );
                            } else {
                                return <View/>
                            }


                        })
                    }
                </View>
            </ScrollView>
        )
    }
}

const cb = '#333';
const cg = '#666666';

const styles = StyleSheet.create({
    container: {},
    mainItemStyle: {
        padding: ScreenUtils.scaleSize(30),
        borderBottomWidth: ScreenUtils.scaleSize(0),
        borderBottomColor: '#ddd',
        overflow: 'hidden',
    },
    itemTitle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        // paddingBottom: paddingBothSide,
    },
    title: {
        fontSize: ScreenUtils.setSpText(30),
        color: '#333',
    },
    expend: {
        fontSize: ScreenUtils.setSpText(60),
        color: cb,
        marginRight: 15,
    },
    itemChildView: {
        flexDirection: 'row',
        alignItems: 'flex-start',
        marginTop: 10,
    },
    itemChildImage: {
        width: 6,
        height: 6,
        marginTop: ScreenUtils.scaleSize(12),
    },
    itemChildTitle: {
        fontSize: ScreenUtils.setSpText(26),
        color: cg,
        marginLeft: 10,
        flex: 1,
    },
});
