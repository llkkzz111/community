/**
 * Created by Administrator on 2017/5/15.
 */

'use strict';
import React from 'react';

import {
    StyleSheet,
    Text,
    View,
    ScrollView,
    TouchableOpacity,
} from 'react-native';

export default class HotSearchWords extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            hotSearchWords: props.hotSearchWords,//热门推荐
            historySearchWords: props.historySearchWords,//历史检索
        };
    }

    CreateSearchWordsView(searchWords) {
        let views = [];
        let item = null;
        let text = null;
        if (searchWords == null || searchWords.length < 1) {
            return null;
        }
        for (let i = 0; i < searchWords.length; i++) {
            text = searchWords[i];
            item =
                <TouchableOpacity activeOpacity={1} onPress={() => {
                    alert(searchWords[i]);
                }}>
                    <View style={styles.searchWordsView}>
                        <Text style={styles.searchWordsText} allowFontScaling={false}>{searchWords[i]}</Text>
                    </View>
                </TouchableOpacity>
            ;
            views.push(item);
        }
        return views;
    }

    render() {
        let {hotSearchWords, historySearchWords} = this.props;
        return (
            <ScrollView>
                <View style={styles.hotWordsView}>
                    <View>
                        <Text style={styles.hotWordsText} allowFontScaling={false}>热门推荐</Text>
                    </View>
                    <View style={styles.allSearchWordsView}>
                        {this.CreateSearchWordsView(hotSearchWords)}
                    </View>
                    <View style={styles.historyWordsView}>
                        <Text style={styles.hotWordsText} allowFontScaling={false}>历史检索</Text>
                    </View>
                    <View style={styles.allSearchWordsView}>
                        {this.CreateSearchWordsView(historySearchWords)}
                    </View>
                    <View style={styles.clearSearchWordsView}>
                        <TouchableOpacity activeOpacity={1}>
                            <Text style={styles.clearSearchWordsText} allowFontScaling={false}>清除搜索记录</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </ScrollView>
        )
    }
}

HotSearchWords.propTypes = {
    hotSearchWords: React.PropTypes.Array, //热门推荐
    historySearchWords: React.PropTypes.Array, //历史检索
};

HotSearchWords.defaultProps = {};

const styles = StyleSheet.create({
    hotWordsText: {
        color: '#333333'
    },
    hotWordsView: {
        backgroundColor: '#FFFFFF',
        padding: 10

    },
    allSearchWordsView: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'flex-start',
        flexWrap: "wrap",

    },
    historyWordsView: {
        marginTop: 20,
    },
    searchWordsView: {
        height: 30,
        borderRadius: 10,
        backgroundColor: '#ededed',
        justifyContent: 'center',
        marginRight: 15,
        marginTop: 20,
    },
    searchWordsText: {
        textAlign: 'center',
        paddingLeft: 5,
        paddingRight: 5
    },
    clearSearchWordsView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 60,

    },
    clearSearchWordsText: {
        borderColor: '#DDDDDD',
        borderWidth: 1,
        width: 180,
        textAlign: 'center',
        height: 30,
        textAlignVertical: 'center',
        color: '#666666'
    },
});