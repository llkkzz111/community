/**
 * Created by Administrator on 2017/5/26.
 */


import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    FlatList,
    Image,
    Dimensions
} from 'react-native';


import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';

const {height, width} = Dimensions.get('window');

export default class ColumnList extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            showDialog: this.props.showDialog,
            arrays: this.props.arrays,
        }

    }

    // componentWillReceiveProps(nextProps){
    //     this.setState({
    //         showDialog:this.props.showDialog,
    //         arrays:this.props.arrays
    //     });
    //
    // }

    componentDidMount() {
        //this.setState({arrays:this.props.arrays});
    }


    CreateChildContents() {

        return (
            <FlatList data={this.props.arrays} renderItem={({item, index}) => {
                return (
                    <TouchableOpacity activeOpacity={1} onPress={() => {
                        this.props.clickChildContent(item, index)
                    }} style={styles.childView}>
                        <Text allowFontScaling={false}>{item}</Text>
                    </TouchableOpacity>
                )
            }}>
            </FlatList>
        )
    }


    render() {
        let list = this.props.list;
        return (
            <View style={ styles.dialogView }>
                <View>
                    {
                        React.Children.map(list, (item, index) => {
                            <TouchableOpacity activeOpacity={1}>
                                <View>
                                    <Text allowFontScaling={false}>{item}</Text>
                                </View></TouchableOpacity>
                        })
                    }
                </View>
                <View style={styles.bottomView}/>
            </View>
        )
    }


}

/*ColumnList.propTypes = {
 showDialog:React.PropTypes.bool.isRequired,
 arrays:React.PropTypes.array,
 CreateChildContents:React.PropTypes.func.isRequired,
 clickChildContent:React.PropTypes.func.isRequired,
 };

 ColumnList.defaultProps = {

 };*/


const styles = StyleSheet.create({
    dialogView: {
        height: height - 40,
        width: width,
        position: 'absolute',
        top: 100,
        left: 0,
        zIndex: 10,
        //backgroundColor:'black'
    },

    modal: {
        //height:250,
        //backgroundColor:Colors.background_grey,
        //opacity:0.4
    },
    selections: {
        //marginTop:100,
        height: 220,
        flexDirection: 'row',
        backgroundColor: Colors.background_white,
        opacity: 1
    },
    contents: {},
    itemView: {
        height: 44,
        flexDirection: 'row',
        //justifyContent:'center',
        alignItems: 'center',
        paddingLeft: 20
    },
    childView: {
        height: 44,
        flexDirection: 'row',
        //justifyContent:'center',
        alignItems: 'center',
        paddingLeft: 20,
        borderBottomWidth: 1,
        borderBottomColor: Colors.line_grey,

    },
    onLiveTime: {
        color: Colors.line_type,
        fontSize: Fonts.secondary_font(),

    },
    bottomView: {
        opacity: 0.4,
        flex: 1,
        backgroundColor: Colors.background_black,
    },

});