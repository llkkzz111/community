/**
 * Created by xuzw on 2017/5/26.
 * 首页导航栏组件
 */
'use strict';

import React, {
    Component,
    PropTypes
} from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    TouchableOpacity,
    ListView,
    FlatList,
    ScrollView

} from 'react-native';
import {connect} from 'react-redux'
import GoodsClassifyItem from './GoodsClassifyItem';
import * as ClassificationPageAction from '../../app/actions/classificationpageaction/ClassificationPageAction'
const { width } = Dimensions.get('window');

export class GoodsClassifySearchTitle extends Component {
    constructor(props) {
        super(props);
        var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            selectedIndex: 0,
            dataSource: ds.cloneWithRows(['row 1', 'row 2', 'row 3', 'row 4', 'row 5']),
            displayColumn:this.props.displayColumn
        }
        //先在这初始化一下数据,不知道是否合适
        this.callGetGoodsClassify(0);
    }

    render() {
        let self = this.props.count;
        let bgStyle = {
            justifyContent: 'center',
            alignItems: 'center',
            width: width / self,
            height: 48
        }

        return (
            <View style={styles.google}>
                <View style={styles.containers}>
                    {
                       this.props.titleData !== '' && this.props.titleData !== null && this.props.titleData.map((v, i) => {
                            let { title } = v;
                            let viewer = <View />
                            if (i === this.state.selectedIndex) {
                                viewer = <TouchableOpacity style={styles.bgTable} activeOpacity={1} onPress={() => this._clickSelect(i)}>
                                    <View>
                                        <View style={bgStyle}>
                                            <Text style={styles.textStyle2} allowFontScaling={false}>{title}</Text>
                                        </View>
                                        <View  style={{backgroundColor: '#E5290D', height: 2}} />
                                    </View>
                                </TouchableOpacity>
                            } else {
                                viewer = <TouchableOpacity style={styles.bgTable} activeOpacity={1} onPress={() => this._clickSelect(i)}>
                                    <View>
                                        <View style={bgStyle}>
                                            <Text style={styles.textStyle} allowFontScaling={false}>{title}</Text>
                                        </View>
                                        <View  style={{backgroundColor: '#E1E1E3', height: 2}} />
                                    </View>
                                </TouchableOpacity>
                            }
                            return (viewer)
                        })
                    }
                </View>
                {
                    (this.props.goodsClassifyData != null && this.props.goodsClassifyData.data != null)?
                    <FlatList
                        data={this.props.goodsClassifyData.data.priList}
                        style={[styles.container, {width: this.props.width}]}
                        horizontal={false}
                        renderItem={({item, index}) => (
                                <TouchableOpacity
                                    activeOpacity={1}
                                    onPress={() => this._clickItem(item)}
                                >
                                    <View key={index} style={styles.mainClassify}>
                                        <GoodsClassifyItem displayDirection = 'column' goodsItem = {item} />
                                    </View>
                                </TouchableOpacity>
                            )}/>
                        :<View></View>
                }
            </View>
        )
    }

    _clickSelect = (index) => {
        this.setState({
            selectedIndex: index
        })
        this.callGetGoodsClassify(index);
    }
    _clickItem = (item) => {
        //先不在这处理了
    }

    callGetGoodsClassify(index){
        let searchField = "";
        switch(index){
            case 0://推荐
                searchField = "e_price";
                break;
            case 1://销量
                searchField = "e_price";
                break;
            case 2://价格
                searchField = "e_price";
                break;
            case 3://筛选
                searchField = "e_price";
                break;
        }
        this.props.getGoodsClassify({parentId:162,id:845,
            visitor_token:"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMDExMTIwMDU1ODkiLCJpc3MiOiJvY2otc3RhcnNreSIsImV4cCI6MTQ5Nzc1NDY0NiwiaWF0IjoxNDk1MTYyNjQ2fQ._uZUkXSVkRWgf5IaWPmJBZaq1yKmrncysp1vVBQv7ws",
            search:{searchField}
        });
    }
}

const styles = StyleSheet.create({
    containers: {
        width: width,
        height: 50,
        backgroundColor: 'white',
        marginTop: 1,
        flexDirection: 'row'
    },
    google: {
        flexDirection: 'column'
    },
    bgTable: {
        flexDirection: 'column',
    },
    textStyle: {
        color: '#6B6B6B',
        fontSize: 15
    },
    textStyle2: {
        color: '#E5290D',
        fontSize: 15,
        fontWeight: 'bold'
    }
});

GoodsClassifySearchTitle.propTypes = {
    titleData: PropTypes.array,
    count: PropTypes.number
}

////xuzw
let mapDispatchToProps = (dispatch) => {
    return ({
        getGoodsClassify:(data)=>dispatch(ClassificationPageAction.getGoodsClassifyShow(data))
    })
}

let mapStateToProps = (state) => {
    return ({
        goodsClassifyData: state.ClassificationPageReducer.goodsClassifyData,
    });
}
export default connect(state => mapStateToProps, dispatch => mapDispatchToProps)(GoodsClassifySearchTitle)
