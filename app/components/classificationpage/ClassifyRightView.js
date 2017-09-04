/**
 * Created by wangwenliang on 2017/5/4.
 * update by Wjj on 2017/5/13
 * Optimization code
 * 分类页右侧侧列表
 */
'use strict';
import {
  StyleSheet,
  View,
  Text,
  Image,
  TouchableOpacity,
  FlatList,
} from 'react-native';
import {
    React,
    ScreenUtils,
    Colors,
    Fonts,
    Actions,
} from '../../config/UtilComponent';
let width;
export default class ClassifyRightView extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = {
      dataSource: this.props.datas,
    };
    width = this.props.width;
  }

  //当props改变时更新数据
  componentWillReceiveProps(nextProps) {
    this.setState({dataSource: nextProps.datas});
  }

  toTop(){
    this.refs.RightList&&this.refs.RightList.scrollToOffset(0);
  }

  toClassificationChannel(item){
      Actions.ChannelFromPage({
          title: item.name,
          destinationUrl: item.pageCodeValue,
          lgroup: item.id
      });
  }

  renderFooter(item){
      return (
          <View>
              {item.pageCodeValue?
              <TouchableOpacity style={styles.footerView} activeOpacity={1} onPress={()=>this.toClassificationChannel(item)}>
                <Text style={styles.footerText}>更多{item.name}</Text>
              </TouchableOpacity> : null}
          </View>
      )
  }

  //render主界面
  render() {
    return (
        <FlatList
            key={(new Date()).getTime()}
            ref="RightList"
            data={this.state.dataSource}
            style={[styles.container, {alignSelf: 'stretch', width: width}]}
            horizontal={false}
            renderItem={({item, index}) => (
                <View key={index}>
                  <View style={styles.mainItemStyle}>
                    <TouchableOpacity
                        style={styles.titleRowStyle}
                        activeOpacity={1}
                        onPress={() => {
                          this.props.secondClassClick(item, index);
                        }}>
                      <Text
                          allowFontScaling={false}
                          style={styles.itemTitleText}>
                        {item.name}
                      </Text>
                      <Image
                          style={styles.itemTitleArrow}
                          source={require('../../../foundation/Img/groupbuy/Icon_right_gray_@2x.png')}/>
                    </TouchableOpacity>
                    <View style={styles.itemGridRow}>
                      {item.mobCateBarVos && item.mobCateBarVos.map((childItem, thirdClassIndex) => {
                        return (
                            <TouchableOpacity
                                style={[styles.thirdClassItem, {
                                  //width: (ScreenUtils.scaleSize(570) - ScreenUtils.scaleSize(30) * 2) / 3 -5 ,
                                  // width: width / 3 - ScreenUtils.scaleSize(20),
                                  width: '33%'
                                }]}
                                activeOpacity={1}
                                onPress={() => {
                                  this.props.thirdClassClick(childItem, thirdClassIndex); // 具体每一个商品的点击事件
                                }}>
                              <Image
                                  style={styles.thirdClassItemImg}
                                  source={{uri: childItem.imageSrc?childItem.imageSrc:''}}/>
                              <Text
                                  allowFontScaling={false}
                                  style={styles.thirdClassItemName}>{childItem.name}</Text>
                            </TouchableOpacity>
                        );
                      })}
                    </View>
                    <View style={{height: ScreenUtils.scaleSize(1), backgroundColor: Colors.line_grey, marginTop: 12,}}/>
                  </View>
                </View>
            )}
            ListFooterComponent = {()=>this.renderFooter(this.props.moreName)}
        />
    );
  }
}

const styles = StyleSheet.create({
  container: {
    paddingLeft: ScreenUtils.scaleSize(30),
    paddingRight: ScreenUtils.scaleSize(30),
    backgroundColor: Colors.background_white,
  },
  titleRowStyle: {
    height: 50,
    flexDirection: 'row',
    alignItems: "center",
    justifyContent: 'center',
  },
  itemTitleText: {
    flex: 1,
    fontSize: Fonts.standard_normal_font(),
    color: Colors.text_black
  },
  itemTitleArrow: {
    width: ScreenUtils.scaleSize(16),
    height: ScreenUtils.scaleSize(24),
    resizeMode: 'contain'
  },
  itemGridRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    alignItems: 'center',
  },
  thirdClassItem: {
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 10,
  },
  thirdClassItemImg: {
    height: ScreenUtils.scaleSize(160),
    width: ScreenUtils.scaleSize(120),
    resizeMode: 'contain',
  },
  thirdClassItemName: {
    color: Colors.text_dark_grey,
    fontSize: Fonts.secondary_font(),
  },
  footerText:{
      color: Colors.text_dark_grey,
      fontSize: Fonts.secondary_font(),
      borderColor:Colors.line_grey,
      borderWidth:1,
      textAlign:'center',
      width:ScreenUtils.scaleSize(222),
      padding: ScreenUtils.scaleSize(16),
  },
  footerView:{
      justifyContent:'center',
      alignItems:'center',
      paddingTop:ScreenUtils.scaleSize(40),
      paddingBottom:ScreenUtils.scaleSize(40),
  },
});

//组件引用说明
ClassifyRightView.propTypes = {
  thirdClassClick: React.PropTypes.func, //具体商品的点击事件
  width: React.PropTypes.number, //控件宽度
  datas: React.PropTypes.array, //数据
  secondClassClick: React.PropTypes.func,//二级分类的点击事件
};