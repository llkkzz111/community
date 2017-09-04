/**
 * Created by admin-ocj on 2017/5/12.
 */
import React from 'react'
import {connect} from 'react-redux'
import CommonDialog from './CommonDialog';
import * as classificationPageAction from '../../app/actions/classificationpageaction/ClassificationPageAction';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Image,
    Dimensions,
} from 'react-native';
const {width} = Dimensions.get('window');
export default class PromotionDialog extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            index: 0,
            show: this.props.show,
            datas:this.props.datas||[{promo_title:"",promo_name:""}],
        }
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.show != this.state.show){
            this.setState({show: nextProps.show});
        }
        if (nextProps.datas != this.state.datas){
            this.setState({datas:nextProps.datas});
        }
    }


    render() {
        return (
            <CommonDialog title='促销活动'
                          show={this.state.show}
                          closeDialog={()=>{
                              this.props.close(false);
                          }}
                          buttons={[
                              {
                                  flex: 1,
                                  text: '关闭',
                                  color: 'white',
                                  bg: '#E5290D',
                                  autoClose: false,
                                  height: ScreenUtils.scaleSize(88),
                                  onClicked: () => {
                                      this.props.close(false);
                                  }
                              }
                          ]}>
                <ScrollView style={styles.scrollView}>
                    {
                        this.state.datas.map((item, i) => {
                            return (
                                <View>
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

    renderGiftRow = (item, rowId) => {
        // console.log("======== 促销item:"+JSON.stringify(item));
        return (
            <View style={styles.itemStyle}>

                <View style={{alignItems:'flex-start',flex:1}}>
                    <Text style={styles.itemTitle} allowFontScaling={false}>{item.promo_title}</Text>
                    <Text style={styles.itemSimple} numberOfLines={1} allowFontScaling={false}>{item.promo_name}</Text>
                </View>

                {/*<Image style={styles.itemImage} resizeMode={'stretch'}*/}
                       {/*source={require('../../foundation/Img/dialog/Icon_right_hui_@2x.png')}/>*/}

            </View>
        );
    }
}
const paddingBothSide = ScreenUtils.scaleSize(30);
let styles = StyleSheet.create({
    scrollView: {
        height: ScreenUtils.scaleSize(500),
        marginRight: paddingBothSide,
        marginLeft: paddingBothSide,
        marginTop:ScreenUtils.scaleSize(50)
    },
    itemStyle: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        // height: ScreenUtils.scaleSize(100),
        borderBottomWidth: ScreenUtils.scaleSize(2),
        borderBottomColor: '#ddd',
        flex:1,
        width:width-paddingBothSide*2,
        paddingLeft:ScreenUtils.scaleSize(30)
    },
    itemTitle: {
        fontSize: ScreenUtils.scaleSize(28),
        color: '#333',
        marginTop:ScreenUtils.scaleSize(30)
    },
    itemSimple: {
        fontSize: ScreenUtils.scaleSize(24),
        color: '#666',
        marginTop:ScreenUtils.scaleSize(10),
        marginBottom:ScreenUtils.scaleSize(20),
    },
    itemImage: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
    },

})
// export default connect(state => ({
//         show:state.ClassificationPageReducer.promotionDialogShow
//     }),
//     dispatch => ({
//         closeDialog: () => dispatch(classificationPageAction.promotionDialogShow(false))
//     })
// )(PromotionDialog)
