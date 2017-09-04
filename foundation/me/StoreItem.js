/**
 * Created by lume on 2017/6/1.
 */
/**
 * @author lu weiguo
 *
 * 收藏夹
 */
import React, {Component} from 'react'
import {
    StyleSheet,
    View,
    Text,
    Image,
    Dimensions,
    ScrollView,
    TouchableOpacity,
} from 'react-native';

// 适屏
import * as ScreenUtils from '../utils/ScreenUtil';
import Swipeable from 'react-native-swipeable';
var {width, height, scale} = Dimensions.get('window');


export default class FavoritePage extends Component {
    state = {
        currentlyOpenSwipeable: null
    };

    handleScroll = () => {
        const {currentlyOpenSwipeable} = this.state;
        if (currentlyOpenSwipeable) {
            currentlyOpenSwipeable.recenter();
        }
    };

    render() {
        const {currentlyOpenSwipeable} = this.state;
        const itemProps = {
            onOpen: (event, gestureState, swipeable) => {
                if (currentlyOpenSwipeable && currentlyOpenSwipeable !== swipeable) {
                    currentlyOpenSwipeable.recenter();
                }

                this.setState({currentlyOpenSwipeable: swipeable});
            },
            onClose: () => this.setState({currentlyOpenSwipeable: null})
        };

        return (
            <ScrollView onScroll={this.handleScroll} style={styles.container}>
                <FavoriteItem {...itemProps}/>
                <FavoriteItem {...itemProps}/>
                <FavoriteItem {...itemProps}/>
                <FavoriteItem {...itemProps}/>
                <FavoriteItem {...itemProps}/>
                <FavoriteItem {...itemProps}/>
            </ScrollView>
        );
    }
}

function FavoriteItem({onOpen, onClose}) {
    return (
        <Swipeable
            onRef={ref => this.swipeable = ref}
            rightButtons={[
                <TouchableOpacity activeOpacity={1} style={[styles.rightSwipeItem, {backgroundColor: '#E5290D'}]}>
                    <Text allowFontScaling={false} style={styles.deleteBtn}>删除</Text>
                </TouchableOpacity>
            ]}
            onRightButtonsOpenRelease={onOpen}
            onRightButtonsCloseRelease={onClose}
        >
            <TouchableOpacity activeOpacity={1} style={[styles.listItem]}>
                <View style={styles.listItemImgBox}>
                    <Image style={styles.listItemImg} source={require("../Img/me/order.jpg")}/>
                </View>
                <View style={styles.listItemInfo}>
                    <Text allowFontScaling={false} numberOfLines={1} style={styles.itemName}>典匠官方旗舰店</Text>
                    <Text allowFontScaling={false} numberOfLines={1} style={styles.introduction}>匠人手艺打造美好生活</Text>
                </View>
            </TouchableOpacity>
        </Swipeable>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingTop: ScreenUtils.scaleSize(20)
    },
    listItem: {
        flexDirection: "row",
        alignItems: 'center',
        justifyContent: "space-between",
        backgroundColor: "#ffffff",
        borderBottomWidth: 1,
        borderBottomColor: '#DDDDDD',
        paddingLeft: ScreenUtils.scaleSize(30),
        paddingBottom: ScreenUtils.scaleSize(20),
        paddingTop: ScreenUtils.scaleSize(20)
    },
    leftSwipeItem: {
        flex: 1,
        alignItems: 'flex-end',
        justifyContent: 'center',
        paddingRight: ScreenUtils.scaleSize(20)
    },
    rightSwipeItem: {
        flex: 1,
        justifyContent: 'center',
        paddingLeft: ScreenUtils.scaleSize(40)
    },
    deleteBtn: {
        color: "#FFFFFF",
        fontSize: ScreenUtils.setSpText(28),
    },


    listItemImgBox: {
        width: ScreenUtils.scaleSize(90),
        height: ScreenUtils.scaleSize(90),
    },
    listItemImg: {
        width: ScreenUtils.scaleSize(90),
        height: ScreenUtils.scaleSize(90),
        resizeMode: "contain"
    },
    listItemInfo: {
        flex: 1,
        marginLeft: ScreenUtils.scaleSize(20),
        paddingRight: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(90),
    },
    listItemInfoHead: {
        flexDirection: "row",
        alignItems: "flex-end",
    },
    redColor: {
        color: "#E5290D"
    },
    itemName: {
        fontSize: ScreenUtils.setSpText(30),
        color: "#333333",
    },
    introduction: {
        fontSize: ScreenUtils.setSpText(28),
        color: "#666666",
        marginTop: ScreenUtils.scaleSize(25)
    }


});