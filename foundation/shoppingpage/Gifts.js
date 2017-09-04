/**
 * Created by Administrator on 2017/6/1.
 */
//直播頁面贈品信息


import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    FlatList,
} from 'react-native';


import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';

export default class Gifts extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {

            open : false
        }

    }


    componentDidMount() {

    }

    openClose(){
        this.setState({open: !this.state.open});
    }

    render() {

        let { allGifts,displayGifts } = this.props;
        return (
            <TouchableOpacity style={styles.giftsView} activeOpacity={1} onPress={() => {this.openClose()}}>

            <View>
                <Text style={styles.textStyle} allowFontScaling={false}>赠品信息</Text>
            </View>
            <View style={styles.giftsInforView}>
                {
                    this.state.open ?
                        <FlatList data={allGifts}
                                  renderItem={({ item, index }) => {
                                      return  (<Text style={styles.itemTextStyle} allowFontScaling={false}>{item}</Text>)
                                    }
                                  }
                        />
                        :
                        <FlatList data={displayGifts}
                                  renderItem={({ item, index }) => {
                                      return  (<Text style={styles.itemTextStyle} allowFontScaling={false}>{item}</Text>)
                                    }
                                  }
                        />
                }
            </View>
            {
                allGifts.length > 3 ?
                    this.state.open ?
                        <View style={styles.buttonView}>
                            <Text style={styles.itemTextStyle} allowFontScaling={false}>收起</Text>
                            <Image source={require('../Img/shoppingPage/Icon_up_@3x.png')} style={styles.selectionImg}/>
                        </View>
                        :
                        <View style={styles.buttonView}>
                            <Text style={styles.itemTextStyle} allowFontScaling={false}>展开</Text>
                            <Image source={require('../Img/shoppingPage/Icon_down_red_@3x.png')} style={styles.selectionImg}/>
                        </View>
                    :
                    null
            }
            </TouchableOpacity>

        )
    }


}

Gifts.propTypes = {
    displayGifts:React.PropTypes.array.isRequired,
    allGifts:React.PropTypes.array.isRequired,

};

Gifts.defaultProps = {

};


const styles = StyleSheet.create({
    giftsView:{
        flexDirection:'row',
        padding:ScreenUtil.scaleSize(30),
        marginBottom:ScreenUtil.scaleSize(10),
        backgroundColor:Colors.background_white,
    },
    buttonView:{
        flexDirection:'row',
        flex:1,
        justifyContent:'flex-end',

    },
    giftsInforView:{
        marginLeft:ScreenUtil.scaleSize(26),
    },
    selectionImg:{
        width:ScreenUtil.scaleSize(15),
        height:ScreenUtil.scaleSize(10),
        marginTop:ScreenUtil.scaleSize(10),

    },
    textStyle:{
        color:Colors.text_black,
        fontSize:Fonts.secondary_font()
    },
    itemTextStyle:{
        color:Colors.text_dark_grey,
        fontSize:Fonts.secondary_font()
    }
})