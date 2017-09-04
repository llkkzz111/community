/**
 * Created by lume on 2017/6/9.
 */
import React, {
    PureComponent,
} from 'react'

import {
    View,
    StyleSheet,
} from 'react-native'
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';

// 引入外部组件 品牌标题
import BrandHead from './brandHead';
// 引入外部组件 商品 Item
import ScrollViewItem from './ScrollViewItem';

export default class BrandPavilion extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
    }

    render(){
        return (
            <View style={styles.ScrollViewBox}>
                {this._isBrandsData(this.props.brandsGoods.length)}
                <ScrollViewItem
                    codeValue={this.props.codeValue}
                    pageVersionName={this.props.pageVersionName}
                    dataSource={this.props.brandsGoods} />
            </View>
        )
    }


    _isBrandsData(index){
        if(index){
            return(
                <BrandHead
                    brandsGoods={this.props.brandsGoods}/>
            )
        }
    }
}

const styles = StyleSheet.create({
    ScrollViewBox:{
        marginTop:ScreenUtils.scaleSize(20),
        marginBottom:ScreenUtils.scaleSize(20),
    }
});