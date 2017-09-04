/**
 * Created by YASIN on 2017/5/27.
 * 热销tab view
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
export default class HotTabView extends React.Component {
    static propTypes = {
        selected: PropTypes.number,
        datas: PropTypes.array,
        onItemClick: PropTypes.func,
        selectedColor: PropTypes.string
    }
    static defaultProps = {
        selectedColor: 'rgba(0,0,0,0.2)',
        selected: 0,
        datas: [
            {
                icon: require('../../../../foundation/Img/home/hotsale/Icon_all_.png'),
                title: '全部分类',
                showIndicator: true
            },
            {
                icon: require('../../../../foundation/Img/home/hotsale/Icon_anchorrecommend_.png'),
                title: '主播推荐',
                showIndicator: false
            },
            {
                icon: require('../../../../foundation/Img/home/hotsale/Icon_mobile_.png'),
                title: '手机专享',
                showIndicator: false
            },
            {
                icon: require('../../../../foundation/Img/home/hotsale/Icon_groupbuy_.png'),
                title: '团购',
                showIndicator: false
            },
            {
                icon: require('../../../../foundation/Img/home/hotsale/Icon_globalbuy_.png'),
                title: '全球购',
                showIndicator: false
            }
        ]
    }
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this._renderTab = this._renderTab.bind(this);
    }

    render() {
        return (
            <Image source={require('../../../../foundation/Img/home/hotsale/Icon_title_bg_.png')}
                   style={styles.bgStyle}>
                {this.props.datas.map(this._renderTab)}
            </Image>
        );
    }

    /**
     *渲染tab
     * @private
     */
    _renderTab(item, index) {
        let indicatorView = null;
        if (item.showIndicator) {
            indicatorView = (
                <Image
                    source={require('../../../../foundation/Img/home/hotsale/Icon_unfold_.png')}
                    style={styles.indicatorStyle}
                />
            );
        }
        let style = [styles.tabContainer];
        let {selectedColor}=this.props;
        if (this.props.selected === index) {
            style.push({backgroundColor: selectedColor});
        }
        return (
            <TouchableOpacity onPress={this.props.onItemClick.bind(this,index)} style={style} key={index} activeOpacity={1}>
                {indicatorView}
                <Image source={item.icon} style={styles.tabIcon}/>
                <Text allowFontScaling={false} style={styles.tabTitleStyle}>{item.title}</Text>
            </TouchableOpacity>
        );
    }
}
const styles = StyleSheet.create({
    tabContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        alignSelf: 'stretch'
    },
    tabIcon: {
        backgroundColor: 'transparent'
    },
    tabTitleStyle: {
        fontSize: ScreenUtils.setSpText(24),
        color: Colors.text_white,
        backgroundColor: 'transparent',
        marginTop: ScreenUtils.scaleSize(12)
    },
    bgStyle: {
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        alignItems: 'center',
        height: ScreenUtils.scaleSize(110)
    },
    indicatorStyle: {
        position: 'absolute',
        right: ScreenUtils.scaleSize(4),
        bottom: ScreenUtils.scaleSize(4)
    }
});
