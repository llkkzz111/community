import React from 'react';
import {
    StyleSheet,
    View,
    ListView,
    Text,
} from 'react-native';
import {Dimensions} from 'react-native';

let window = {
    width: Dimensions.get('window').width,
    height: Dimensions.get('window').height,
}

import Buttom from './Buttom';

export default class ShoppingSelectList extends React.PureComponent {
    constructor(props) {
        super(props);
        // console.log(props)
        this._renderRow = this._renderRow.bind(this);
        this.state = {
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            shopData: ['test','test','test','test'],
            selectedStatus: [true, false, false, false],
            isSelectedAll: false, //是否全选
        };
    }
    //选中行
    rowPress(rowId) {
        let selectedStatus = this.state.selectedStatus;
        selectedStatus[rowId] = !this.state.selectedStatus[rowId];
        //赋值商品选中状态
        this.setState({
            items: selectedStatus
        });
        //设置下边全选状态  有没选的就不全选   isSelectedAll = false
        let j=0;
        for (let i=0; i<selectedStatus.length; i++){
           if(selectedStatus[i] == false) {
               j++;
           }
        }
        this.setState({
            isSelectedAll: j==0 ? true: false
        });
    }
    //选中全选按钮
    ButtomPress() {
        var selectedStatus = this.state.selectedStatus;
        //赋值商品选中状态
        for (var i=0; i<selectedStatus.length; i++){
            selectedStatus[i] = !this.state.isSelectedAll;
        }
        //设置下边全选状态
        this.setState({
            isSelectedAll: !this.state.isSelectedAll
        });
    }
    _renderRow(rowData,sectionId,rowId) {
        return (
            <View style={styles.row}>
                <View style={styles.cell}>
                    <Buttom
                        containerStyle = {{ backgroundColor: '#fcfcfc' }}
                      style={[{ fontSize: 16, textAlign: 'center', width: 40, padding:40 }, this.state.selectedStatus[rowId] ? { color: 'black' } : { color: 'gray' }]}
                        text={this.state.selectedStatus[rowId]?'√':''}
                        onPress={
                            () => this.rowPress(rowId)
                        }
                    />
                    <Text allowFontScaling={false}>{this.state.shopData[rowId]}</Text>
                </View>
                <View style={{ width: window.width, height: window.height / 70 }}></View>
            </View>
        );
    }

    render() {
        // alert(this.state.shopData.length);
        return (
            <View style={styles.StyleFor18}>
                <ListView
                    dataSource={this.state.dataSource.cloneWithRows(this.state.shopData) }
                    renderRow={this._renderRow}
                    // enableEmptySections={true}
                    style={styles.listView}
                />
                <Buttom
                    containerStyle = {{ backgroundColor: '#fcfcfc' }}
                    style={[{ fontSize: 16, textAlign: 'center', width: 40, padding:40, backgroundColor: 'red'}, this.state.isSelectedAll ? { color: 'black' } : { color: 'gray' }]}
                    text={this.state.isSelectedAll ?'√':''}
                    onPress={
                        () => this.ButtomPress()
                    }
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    row: {
        width: window.width,
        justifyContent: 'center',
        alignItems: 'center',
    },
    listView: {
        backgroundColor: 'rgb(230, 230, 230)',
    },
    StyleFor18: {
        flexDirection: 'column',
        height: window.height - 60 - 20 - 40 - 40,
        width: window.width,
    },
    cell: {
        flexDirection: 'row',
    },
    icon: {
        width: 35,
        height: 35,
    },
});














