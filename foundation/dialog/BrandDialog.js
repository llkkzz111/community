/**
 * @author Xiang
 *
 * 品牌筛选弹窗
 */
import React from 'react'
import {connect} from 'react-redux'
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
    Modal,
    FlatList,
    Platform
} from 'react-native'

import AlphabetListView from 'react-native-alphabetlistview';
import  ScrollableTabView, {DefaultTabBar} from 'react-native-scrollable-tab-view'
import * as ScreenUtil from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
import Toast, {DURATION} from 'react-native-easy-toast';

class BrandDialog extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            open: this.props.open,
        };
        this.codeArr = [];
        this.nameArr = [];
    }

    componentWillReceiveProps(nextProps) {
        this.codeArr = new Array();
        this.nameArr = new Array();
        for (let i = 0; i < nextProps.selectedLogoCodeArry.length; i++) {
            this.codeArr.push(nextProps.selectedLogoCodeArry[i]);
        }

        for (let i = 0; i < nextProps.selectedLogoNameArry.length; i++) {
            this.nameArr.push(nextProps.selectedLogoNameArry[i]);
        }

        this.setState({
            open: nextProps.open,
        });
        // this.codeArr = new Array();
        // this.nameArr = new Array();

    }

    onPressItem(id, title) {
        let position = this.codeArr.indexOf(id);
        if (position > -1) {
            this.codeArr.splice(position, 1);
            this.nameArr.splice(position, 1);
            return true;
        } else {
            if (this.codeArr.length === 5) {
                this.refs.toast.show("筛选个数最多不超过5个", DURATION.LENGTH_LONG);
                return false;
            } else {
                this.codeArr.push(id);
                this.nameArr.push(title);
                return true;
            }
        }
    }

    // onLabelClick(text){
    //     this.codeArr = [];
    //     this.nameArr = [];
    // }
    closeBrandDialog() {
        this.codeArr = [];
        this.nameArr = [];
        this.props.closeBrandDialog();
    }

    okClick(codes, names) {
        this.props.okClick(codes, names);
    }

    render() {
        let {brandData} = this.props;
        return (
            <Modal
                animationType='fade'
                visible={this.state.open}
                transparent={true}
                style={styles.modal}
            >

                <View style={{flexDirection: 'row', flex: 1}}>
                    <TouchableOpacity activeOpacity={1} onPress={() => this.props.closeAll()}>
                        <View style={{
                            width: ScreenUtil.scaleSize(200),
                            height: ScreenUtil.screenH,
                            backgroundColor: '#DDDDDD',
                            opacity: 0.5
                        }}/>
                    </TouchableOpacity>
                    <View style={styles.container}>
                        <View style={styles.contentContainer}>
                            <View style={Platform.OS === 'ios' ? [styles.titleRow] : [styles.titleRowAndroid]}>
                                <TouchableOpacity activeOpacity={1} onPress={() => {
                                    this.closeBrandDialog()
                                }} style={styles.touchView}>
                                    <Image source={require('../Img/dialog/back@3x.png')} style={styles.titleArrow}/>
                                </TouchableOpacity>
                                <Text style={styles.titleTextContainer} allowFontScaling={false}>品牌</Text>
                            </View>
                            <ScrollableTabView
                                renderTabBar={() => <DefaultTabBar tabStyle={{
                                    borderRightWidth: 1,
                                    marginTop: ScreenUtil.scaleSize(20),
                                    borderRightColor: '#DDDDDD'
                                }}/>}
                                style={styles.scrollableTabView}
                                tabBarTextStyle={styles.tabBarText}
                                tabBarActiveTextColor='#E5290D'
                                tabBarUnderlineStyle={styles.tabBarUnderLine}
                                tabBarInactiveTextColor='#666666'
                                ref={(tabView) => {
                                    this.tabView = tabView;
                                }}
                            >
                                <View tabLabel='推荐品牌'>
                                    <BrandList
                                        style={styles.listView}
                                        data={brandData}
                                        onPressItem={(id, title) => {
                                            return this.onPressItem(id, title)
                                        }}
                                        selects={this.codeArr}
                                    />
                                </View>

                                {/*<View tabLabel='字母排序'>*/}
                                {/*<AlphabetList*/}
                                {/*style={{backgroundColor: 'red'}}*/}
                                {/*/>*/}
                                {/*</View>*/}
                            </ScrollableTabView>
                            <TouchableOpacity activeOpacity={1}
                                              onPress={() => this.okClick(this.codeArr, this.nameArr)}
                                              style={styles.btnRight}
                            >
                                <Image style={styles.rightBtn}
                                       source={require('../../foundation/Img/searchpage/icon_btn_@3x.png')}/>
                                <Text style={styles.confirmBtn} allowFontScaling={false}>确定</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </View>
                <Toast ref="toast"/>
            </Modal>
        )
    }
}

class BrandList extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            selected: (new Map(): Map<string, boolean>)
        };
    }

    componentWillMount() {
        let selects = this.props.selects;
        let tmpMap = new Map();
        for (let i = 0; i < selects.length; i++) {
            tmpMap.set(selects[i], true);
        }
        this.setState({
            selected: tmpMap
        });
    }

    _keyExtractor = (item, index) => item.propertyName;

    _onPressItem = (id: string, title: string) => {

        let flag = this.props.onPressItem(id, title);
        if (flag) {
            // updater functions are preferred for transactional updates
            this.setState((state) => {
                // copy the map rather than modifying state.
                const selected = new Map(state.selected);
                selected.set(id, !selected.get(id)); // toggle
                return {selected};
            });
        }
    };

    _renderItem = ({item}) => (
        <ListItem
            id={item.propertyName}
            onPressItem={this._onPressItem}
            selected={this.state.selected.get(item.propertyName)}
            title={item.propertyValue}
        />
    );

    render() {
        return (
            <FlatList
                data={this.props.data}
                extraData={this.state}
                keyExtractor={this._keyExtractor}
                renderItem={this._renderItem}
                style={{paddingLeft: ScreenUtil.scaleSize(20)}}
            />
        );
    }
}

class ListItem extends React.PureComponent {
    _onPress = () => {
        this.props.onPressItem(this.props.id, this.props.title);
    };

    render() {
        let color = this.props.selected ? '#E5290D' : '#666666';
        let lineColor = this.props.selected ? '#DDDDDD' : '#DDDDDD';
        return (
            <TouchableOpacity onPress={this._onPress} activeOpacity={1}>
                <View style={styles.listItemContainer}>
                    <Text style={[styles.listItemText, {color: color}]} allowFontScaling={false}>
                        {this.props.title}
                    </Text>
                    {this.props.selected ? (<Image style={styles.listItemImg}
                                                   source={require('../Img/dialog/item_selected@2x.png')}/>    ) : (null)}
                </View>
                <View style={{height: ScreenUtil.scaleSize(1), backgroundColor: lineColor}}/>
            </TouchableOpacity>
        )
    }
}

class AlphabetList extends React.PureComponent {
    constructor(props) {
        super(props);

        this.state = {
            data: {
                '#': ['some', 'entries', 'are here'],
                A: ['some', 'entries', 'are here'],
                B: ['some', 'entries', 'are here'],
                C: ['some', 'entries', 'are here'],
                D: ['some', 'entries', 'are here'],
                E: ['some', 'entries', 'are here'],
                F: ['some', 'entries', 'are here'],
                G: ['some', 'entries', 'are here'],
                H: ['some', 'entries', 'are here'],
                I: ['some', 'entries', 'are here'],
                J: ['some', 'entries', 'are here'],
                K: ['some', 'entries', 'are here'],
            },
            selected: (new Map(): Map<string, boolean>),
        };
        let onCellClick = this.onCellClick;
        let onLabelClick = this.props.onLabelClick;
        this.cellProps = {
            onCellClick,
            onLabelClick,
        };
    }

    onCellClick(item) {
        // let flag = this.props.onPressItem(id,title);
        // if ( flag ) {
        //     // updater functions are preferred for transactional updates
        //     this.setState((state) => {
        //         // copy the map rather than modifying state.
        //         const selected = new Map(state.selected);
        //         selected.set(id, !selected.get(id)); // toggle
        //         return {selected};
        //     });
        // }
        this.onLabelClick(item);
    }

    render() {
        return (
            <View style={{height: 500}}>
                <AlphabetListView
                    data={this.state.data}
                    cell={Cell}
                    cellProps={this.cellProps}
                    cellHeight={ScreenUtil.scaleSize(60)}
                    sectionListItem={SectionItem}
                    sectionHeader={SectionHeader}
                    sectionHeaderHeight={ScreenUtil.scaleSize(45)}
                    sectionListStyle={{justifyContent: 'flex-start', marginTop: ScreenUtil.scaleSize(45)}}
                />
            </View>
        );
    }
}
class SectionHeader extends React.PureComponent {
    render() {
        // inline styles used for brevity, use a stylesheet when possible
        let textStyle = {
            textAlign: 'center',
            color: '#666666',
            //fontWeight: '700',
            fontSize: ScreenUtil.setSpText(24),
        };

        let viewStyle = {
            backgroundColor: '#EDEDED',
            marginRight: ScreenUtil.scaleSize(30),
        };

        return (
            <View style={viewStyle}>
                <Text style={textStyle} allowFontScaling={false}>{this.props.title}</Text>
            </View>
        );
    }
}
class SectionItem extends React.PureComponent {
    render() {
        return (
            <Text style={{color: '#666666', fontSize: ScreenUtil.setSpText(24)}} allowFontScaling={false}>{this.props.title}</Text>
        );
    }
}

class Cell extends React.PureComponent {
    constructor(props, context) {
        super(props, context);
        this.state = {
            selected: (new Map(): Map<string, boolean>),
        };
    }

    onCellClick(item) {
        this.setState((state) => {
            // copy the map rather than modifying state.
            const selected = new Map(state.selected);
            selected.set(item, !selected.get(item)); // toggle
            return {selected};
        });
        this.props.onCellClick(item);
    }

    render() {
        let color = this.state.selected.get(this.props.item) ? '#E5290D' : '#666666';
        let lineColor = this.state.selected.get(this.props.item) ? '#DDDDDD' : '#DDDDDD';
        return (
            <TouchableOpacity onPress={() => this.onCellClick(this.props.item)} activeOpacity={1}>
                <View style={styles.listItemContainer}>
                    <Text style={[styles.listItemText, {color: color}]} allowFontScaling={false}>
                        {this.props.item}
                    </Text>
                    {this.state.selected.get(this.props.item) ? (<Image style={styles.listItemImg}
                                                                        source={require('../Img/dialog/item_selected@2x.png')}/>    ) : (null)}
                </View>
                <View style={{height: ScreenUtil.scaleSize(1), backgroundColor: lineColor}}/>
            </TouchableOpacity>
        )
    }
}

const styles = StyleSheet.create({
    modal: {
        height: ScreenUtil.screenH,
        width: ScreenUtil.screenW,
    },
    container: {
        backgroundColor: 'rgba(0,0,0,0.5)',
        flex: 1,
        //paddingLeft: ScreenUtil.scaleSize(300),
    },
    contentContainer: {
        backgroundColor: 'white',
        flex: 1,
    },
    titleTextContainer: {
        color: '#333333',
        fontSize: ScreenUtil.setSpText(32),
        marginLeft: ScreenUtil.scaleSize(170),
    },
    titleRow: {
        //padding: ScreenUtil.setSpText(30),
        marginTop: ScreenUtil.scaleSize(20),
        flexDirection: 'row',
        alignItems: 'center',
        borderBottomWidth: ScreenUtil.scaleSize(1),
        borderColor: "#DDDDDD",
        height: ScreenUtil.scaleSize(118)
    },
    touchView: {
        width: ScreenUtil.scaleSize(60),
        alignItems: 'center',
    },
    titleArrow: {
        resizeMode: 'contain',
        width: ScreenUtil.scaleSize(21.5),
        height: ScreenUtil.scaleSize(36.8),
    },
    titleText: {
        flex: 1,
        textAlign: 'center',
        color: '#333333',
        fontSize: ScreenUtil.setSpText(36),
    },
    tabBarText: {
        fontSize: ScreenUtil.setSpText(28),
    },
    tabBarUnderLine: {
        height: ScreenUtil.scaleSize(4),
        backgroundColor: '#E5290D',
        marginLeft: ScreenUtil.scaleSize(200),
        width: ScreenUtil.scaleSize(150),

    },
    scrollableTabView: {
        height: ScreenUtil.scaleSize(60),
    },
    listView: {
        flex: 1,
        backgroundColor: 'white',
        paddingLeft: ScreenUtil.scaleSize(20),
    },
    confirmBtn: {
        backgroundColor: 'transparent',
        textAlign: 'center',
        color: 'white',
        paddingTop: ScreenUtil.scaleSize(20),
        paddingBottom: ScreenUtil.scaleSize(20),
        fontSize: ScreenUtil.setSpText(36),
    },
    listItemContainer: {
        paddingTop: ScreenUtil.scaleSize(32),
        paddingBottom: ScreenUtil.scaleSize(32),
        paddingLeft: ScreenUtil.scaleSize(20),
        paddingRight: ScreenUtil.scaleSize(20),
        flexDirection: 'row',
        alignItems: 'center',
    },
    listItemText: {
        flex: 1,
        fontSize: ScreenUtil.setSpText(32),
    },
    listItemImg: {
        width: ScreenUtil.scaleSize(26),
        height: ScreenUtil.scaleSize(20),
    },
    typeList: {
        borderRightWidth: ScreenUtil.scaleSize(1),
        borderRightColor: '#DCDDE3',
        height: ScreenUtil.scaleSize(32),
    },
    rightBtn: {
        position: 'absolute',
        bottom: 0,
        resizeMode: 'cover',
        width: ScreenUtil.screenW - ScreenUtil.scaleSize(200),
        height: ScreenUtil.scaleSize(88),

    },
    titleRowAndroid: {
        //padding: ScreenUtil.setSpText(30),
        marginTop: ScreenUtil.scaleSize(0),
        flexDirection: 'row',
        alignItems: 'center',
        borderBottomWidth: ScreenUtil.scaleSize(1),
        borderColor: "#DDDDDD",
        height: ScreenUtil.scaleSize(118)
    },
    btnRight: {
        width: ScreenUtil.screenW - ScreenUtil.scaleSize(200),
    },
});
export default connect(state => ({}),
    dispatch => ({})
)(BrandDialog)