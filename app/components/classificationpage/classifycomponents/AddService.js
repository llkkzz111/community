/**
 * Created by wangwenliang on 2017/5/20.
 * 商品详情中的增值服务弹窗
 */

import {
    View,
    Text,
    StyleSheet,
    Image,
    Dimensions,
    Modal,
    FlatList,
    TouchableOpacity,
} from 'react-native';
import {
    Component,
    PureComponent,
    React,
    ScreenUtils,
} from '../../../config/UtilComponent';

const {width, height} = Dimensions.get('window');

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
*/
const Com = __DEV__ ? Component : PureComponent;

export default class AddService extends Com {

    constructor(props) {
        super(props);
        this.state = {
            show: this.props.show,
            dataSource:this.props.datas,
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({show:nextProps.show});
    }

    renderItem = (item, index)=>{
        return(
            <View style={styles.listItem}>
                <Text
                    allowFontScaling={false}
                    style={styles.listItemT1}>{item.tips_title}</Text>
                <Text
                    allowFontScaling={false}
                    style={styles.listItemT2}>{item.tips_content}</Text>
            </View>
        )
    };

    render() {
        return (
            <Modal animationType="fade"
                   onrequestclose={() => {
                   }}
                   transparent={true}
                   visible={this.state.show}>
                <View style={styles.contentContainer}>
                    <Text
                        allowFontScaling={false}
                        style={{flex:1}} onPress={()=>{ this.props.closeDialog();}}/>
                    <View style={styles.showContent}>
                        <View style={styles.topTitleItem1}>
                            <Text
                                allowFontScaling={false}
                                style={styles.topTitleText}>增值服务</Text>
                            <TouchableOpacity
                                style={{width:30,height:30,justifyContent:'center',alignItems:'center'}}
                                activeOpacity={1} onPress={() => {
                                this.props.closeDialog();
                            }}>
                                <Image style={styles.topImage}
                                       source={require('../../../../foundation/Img/dialog/icon_close_@3x.png')}/>
                            </TouchableOpacity>
                        </View>

                        <FlatList
                            horizontal={false}
                            data={this.state.dataSource}
                            renderItem={({item, index}) => (this.renderItem(item, index))}
                            style={styles.listStyle}
                        />


                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={()=>{
                                {/*this.setState({show: false});*/}
                                this.props.closeDialog();
                            }}
                            style={styles.btnClose}>
                            <Image style={styles.btnImage}
                                   source={require('../../../../foundation/Img/home/globalshopping/icon_statusbg_@3x.png')}
                                   resizeMode={'cover'}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.btnText}>关闭</Text>
                            </Image>
                            {/*<Text style={styles.btnText}>关闭</Text>*/}
                        </TouchableOpacity>

                    </View>

                </View>
            </Modal>
        );
    }
}
const styles = StyleSheet.create({

    container: {
        flex: 1,
        justifyContent: 'center',
    },

    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        width: width,
        height: height,
    },
    showContent: {
        width:width,
        height:height*0.5,
        backgroundColor: 'white',
        padding:ScreenUtils.scaleSize(33),
    },
    btnClose:{
        position:'absolute',
        left:0,
        bottom:0,
        height:50,
        width:width,
    //    backgroundColor:'#FF6048',
        justifyContent:'center',
        alignItems:'center',
    },
    btnImage: {
        height:50,
        width: width,
    },
    btnText:{
        fontSize:ScreenUtils.scaleSize(30),
        height:50,
        color:'white',
        textAlign: 'center',
        lineHeight: 35
    },

    topTitleItem1: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
      //  height: 40,
        marginBottom:ScreenUtils.scaleSize(28),
    },
    topTitleText: {
        fontSize: ScreenUtils.scaleSize(30),
        color: '#333',
        marginLeft:15,
        flex:1,
        textAlign:'center',
    },
    topImage: {
        width: ScreenUtils.scaleSize(22),
        height: ScreenUtils.scaleSize(22),
        flex:0,
    },

    listStyle:{
        marginBottom:55,
        // height:height*0.5-40-70,
    },
    listItem:{
        flexDirection:'row',
        alignItems:'flex-start',
        borderBottomWidth:ScreenUtils.scaleSize(1),
        borderColor:'#dddddd',
        paddingTop:ScreenUtils.scaleSize(20),
        paddingBottom:ScreenUtils.scaleSize(20),

    },
    listItemT1:{
        fontSize:ScreenUtils.scaleSize(26),
        color:'#333',
    },
    listItemT2:{
        fontSize:ScreenUtils.scaleSize(24),
        color:'#666',
        marginLeft:ScreenUtils.scaleSize(20),
        flex:1,
    }

});

