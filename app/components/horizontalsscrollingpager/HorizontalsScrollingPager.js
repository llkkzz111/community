'use strict';

import React, {
    PropTypes
} from 'react';

import {
    Image,
    StyleSheet,
    Dimensions,
    TouchableOpacity,
    ScrollView
} from 'react-native';
import ViewPager from 'react-native-viewpager';
const { width } = Dimensions.get('window');

export default class HorizontalsScrollingPager extends React.PureComponent {
    constructor(props) {
        super(props);
        let dataSource = new ViewPager.DataSource({
            pageHasChanged: (p1, p2) => p1 !== p2,
        });
        this.state = {
            dataSource: dataSource,
            topBackColor: 'rgba(225,225,225, 0)',
            showModal: false
        }
    }

    render() {
        return (
            <ScrollView style={styles.containers}>
                <ViewPager
                    dataSource={this.state.dataSource.cloneWithPages(this._getViewPagerDatas())}
                    renderPage={this._renderViewPagerItem}
                    isLoop={true}
                    autoPlay={true}
                />
            </ScrollView>
        )
    }

    _renderViewPagerItem = (pages, pageId) => {
        let { width, height } = this.props;
        return (
            <TouchableOpacity activeOpacity={1} onPress={this._click}>
                <Image style={{ width: width, height: height }}
                    source={{ uri: pages }}
                    resizeMode={'stretch'} />
            </TouchableOpacity>
        )
    };

    _getViewPagerDatas = () => {
        let { imgUrl } = this.props;
        return imgUrl;
    };

    _click = () => {

    }
}

const styles = StyleSheet.create({
    containers: {
        flex: 1,
        backgroundColor: 'transparent'
    }
});

HorizontalsScrollingPager.defaultProps = {
    imgNumber: 3,
    width: width,
    height: 200,
    durationTime: 2000,
    imgUrl: [
        'http://pic17.nipic.com/20111020/6337790_120550160000_2.jpg',
        'http://img05.tooopen.com/images/20150105/sy_78543795524.jpg',
        'http://pic17.nipic.com/20111122/6759425_152002413138_2.jpg'
    ]
};

HorizontalsScrollingPager.propTypes = {
    imgNumber: PropTypes.number,
    width: PropTypes.number,
    height: PropTypes.number,
    durationTime: PropTypes.number,
    imgUrl: PropTypes.array
};
