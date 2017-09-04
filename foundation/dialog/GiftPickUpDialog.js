/**
 * @author Xiang
 *
 * 赠品选择弹窗
 */
import React from 'react';
import {connect} from 'react-redux';
import CommonDialog from './CommonDialog';
import * as ClassificationPageAction from '../../app/actions/classificationpageaction/ClassificationPageAction';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Image,
    TouchableOpacity,
} from 'react-native'


class GiftPickUpDialog extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            index: 0,
            giftData:this.props.getGiftData,
        }
        // this.select = this.select.bind(this);
    }
    //     {
    //         "gift_img": "http://image1.ocj.com.cn/item_images/item/40/14/97/401497M.jpg",
    //         "bt": "2016/08/03 16:15",
    //         "gift_item_code": "4014972013",
    //         "qty": "1",
    //         "name": "赠品",
    //         "gift_gb": "10",
    //         "gift_item_name": "乐扣乐扣COOKPLUS厨房刀具七件套",
    //         "unit_code": "001",
    //         "id": "201608030007",
    //         "value": "",
    //         "et": "2017/08/03 23:59"
    //     }


    componentWillReceiveProps(nextProps) {
        this.setState({giftData:nextProps.getGiftData});
    }


    select() {
        //获取赠品总列表 todu
        let giftData = this.state.giftData;
        let giftList = this.props.giftList;

        if (giftData.length === 0){
            return giftList;
        }
        let giftSelected = giftData[this.state.index];
        for (let i=0; i < giftList.length; i++) {
            if (true) {
                // if (!giftList[i].select) {
                giftList[i] = {
                    //tudo 这里填写选择后的赠品信息
                    select:true,
                    text: giftSelected.gift_item_name,
                    nextAction: "更换赠品",
                    gift_item_codes:giftSelected.gift_item_code,//赠品编号
                    gift_unit_codes:giftSelected.unit_code,//赠品规格编号
                }
                // console.log("##### 点击赠品确定进入循环:"+giftList[i]);
                break;
            }
        }
        // return giftList;
        // console.log("####点击赠品确定 giftData:"+JSON.stringify(giftData));
        // console.log("####点击赠品确定 giftList:"+JSON.stringify(giftList));
        return giftList;
    }

    // giftList:[
    //     {
    //         select:false,
    //         text: "还有赠品未选择，请选择赠品",
    //         nextAction: "领取赠品",
    //         gift_item_codes:"",//赠品编号
    //         gift_unit_codes:"",//赠品规格编号
    //     }
    //     ],

    render() {
        return (
            <CommonDialog title='领取赠品'
                          show={true}
                          closeDialog={() => {
                              // this.props.giftShow(false);
                              this.props.openGiftPickUpDialogShow(false);
                              // this.props.copenCategoryShow(true);
                              this.props.openCategoryDialogShow(true);
                          }}
                          buttons={[
                              {
                                  flex: 1, text: '确定', color: 'white', bg: '#E5290D', onClicked: () => {

                                  this.props.setGiftList(this.select());
                                  this.props.openGiftPickUpDialogShow(false);
                                  this.props.openCategoryDialogShow(true);

                              }
                              }
                          ]}>
                <ScrollView style={styles.scrollView}>
                    {
                        this.state.giftData.map((item, i) => {
                            return (
                                <View key={i}>
                                    {
                                        this.renderGiftRow(item, i)
                                    }
                                </View>
                            )
                        })
                    }
                </ScrollView>
            </CommonDialog>
        );
    }

    //     {
    //         "gift_img": "http://image1.ocj.com.cn/item_images/item/40/14/97/401497M.jpg",
    //         "bt": "2016/08/03 16:15",
    //         "gift_item_code": "4014972013",
    //         "qty": "1",
    //         "name": "赠品",
    //         "gift_gb": "10",
    //         "gift_item_name": "乐扣乐扣COOKPLUS厨房刀具七件套",
    //         "unit_code": "001",
    //         "id": "201608030007",
    //         "value": "",
    //         "et": "2017/08/03 23:59"
    //     }

    renderGiftRow = (item, rowId) => {
        let ic = rowId === this.state.index ? require('../Img/cart/selected.png') : require('../Img/cart/unselected.png');
        return (
            <View key={rowId} style={styles.giftRow}>
                <TouchableOpacity style={{justifyContent: 'center'}}
                                  activeOpacity={1}
                                  onPress={() => {
                                      this.setState({index: rowId});
                                  }}>
                    <Image
                        style={styles.giftCheck}
                        source={ic}
                    />
                </TouchableOpacity>
                <Image
                    style={styles.giftImg}
                    source={{uri: item.gift_img}}
                />
                <View style={styles.giftContent}>
                    <Text style={styles.giftTextTitle} allowFontScaling={false}>{item.gift_item_name}</Text>
                    {/*<Text style={styles.giftTextCategory}>{item.giftCategory}</Text>*/}
                    {/*<View style={styles.giftPriceNum}>*/}
                        {/*<Text style={styles.price}>{item.price}</Text>*/}
                        {/*<Text style={styles.num}>{item.num}</Text>*/}
                    {/*</View>*/}
                </View>
            </View>

        )
    }
}
let styles = StyleSheet.create({
    scrollView: {
        height: 300,
    },
    giftRow: {
        flexDirection: 'row',
        padding: 16,
        justifyContent: 'center',
    },
    giftCheck: {
        height: 20,
        width: 20,
        marginRight: 10,
    },
    giftImg: {
        borderWidth: 1,
        borderColor: '#DDDDDD',
        borderRadius: 3,
        height: 100,
        width: 100,
    },
    giftContent: {
        flex: 1,
        paddingLeft: 10,
    },
    giftTextTitle: {
        fontSize: 16,
        color: '#333333',
    },
    giftTextCategory: {
        color: '#666666',
        flex: 1,
        marginTop: 5,
        marginBottom: 5,
    },
    giftPriceNum: {
        flexDirection: 'row',
    },
    price: {
        color: '#E5290D',
        flex: 1,
    },
    num: {
        color: '#333333'
    }
})
let onDialogClick = (dispatch) => {
    return ({
        // closeDialog: () => dispatch(ClassificationPageAction.giftPickUpDialogDatas({show: false})),
        // giftShow: (msg) => dispatch(ClassificationPageAction.giftShow(msg)),
        // openCategoryDialog: (data) => dispatch(ClassificationPageAction.categoryDialogDatas(data)),
        // copenCategoryShow:(data) => dispatch(ClassificationPageAction.categoryShow(data)),
    })
}
export default connect(
    state => ({
        // dialogVisible: state.DialogReducer
        datas: state.ClassificationPageReducer
    }),
    dispatch => onDialogClick
)(GiftPickUpDialog)