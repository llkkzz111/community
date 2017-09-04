/**
 * Created by MASTERMIAO on 2017/5/12.
 * 订单评价页面的选择图片上传组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    Dimensions,
    StyleSheet,
    Platform,
    ScrollView,
    TouchableOpacity
} from 'react-native';

const { width } = Dimensions.get('window');

// import ImagePicker from 'react-native-image-picker';
var photoOptions = {
    title: '选择图片',
    maxWidth: 500,
    maxHeight: 500,
    cancelButtonTitle: '取消',
    takePhotoButtonTitle: '相机拍摄',
    chooseFromLibraryButtonTitle: '手机相册',
    quality: 0.75,
    allowsEditing: true,
    noData: false,
    storageOptions: {
        skipBackup: true,
        path: 'images'
    },
    mediaType: 'photo',
    videoQuality: 'high'
}

let imgArray = [];

let imgNumber = 0;

export default class AddEvaluateImage extends React.PureComponent {
    constructor() {
        super();
        this.state = {
            title: '亲，双击可以旋转图片哦，快来试试吧！（最多可上传9张）',
            addImg: '添加照片',
            maxImgNo: 0
        }
    }

    render() {
        return (
            <ScrollView style={styles.containers} showsVerticalScrollIndicator={false}>
                <ScrollView style={{flex: 1, backgroundColor: 'white'}}>
                    {imgArray}
                </ScrollView>
                <View style={styles.imgBgStyle}>
                    <TouchableOpacity activeOpacity={1} onPress={this._selectImg} style={styles.selectImgStyle}>
                        <Text allowFontScaling={false} style={styles.addStyle}>＋</Text>
                        <Text allowFontScaling={false} style={styles.addImgTitle}>{this.state.addImg}</Text>
                    </TouchableOpacity>
                    <View style={{alignSelf: 'center', alignItems: 'center', justifyContent: 'center'}}>
                        <Text allowFontScaling={false}  numberOfLines={2}
                               onLayout={this._onLayoutChange}
                               style={styles.titleStyle}>
                            {this.state.title}
                        </Text>
                    </View>
                </View>
                <View style={styles.bgLineStyle} />
            </ScrollView>
        )
    }

    _selectImg = () => {
        if (imgNumber === 9) {
        } else {
            this._openImagePicker();
        }
    }

    _onLayoutChange = () => {

    }

    _openImagePicker = () => {
        // ImagePicker.showImagePicker(photoOptions, (response) => {
        //     if (response.didCancel) {
        //     } else if (response.error) {
        //     } else if (response.takePhotoButtonTitle) {
        //     } else if (response.chooseFromLibraryButtonTitle) {
        //     } else {
        //         let source;
        //         if (Platform.OS === 'android') {
        //             source = { uri: response.uri };
        //         } else {
        //             source = { uri: response.uri.replace('file://', ''), isStatic: true };
        //         }
        //         imgNumber++;
        //         imgArray.push(<Image style={styles.imgStyle} source={source} />);
        //         this.setState({
        //             maxImgNo: imgNumber, current_person_img: source
        //         });
        //     }
        // });
    }

    _openCamera = () => {
        // ImagePicker.launchCamera(photoOptions, (response)  => {
        //
        // });
    }

    _openImageCallery = () => {
        // ImagePicker.launchImageLibrary(photoOptions, (response)  => {
        //
        // });
    }
}

const styles = StyleSheet.create({
    containers: {
        width: width,
        flex: 1,
        backgroundColor: 'white',
        marginTop: 1
    },
    bgLineStyle: {
        width: width,
        height: 20,
        backgroundColor: '#DDDDDD'
    },
    imgStyle: {
        width: 180,
        height: 180,
        marginLeft: 10,
        marginTop: 10,
        borderColor: '#DDDDDD',
        borderRadius: 3,
        borderWidth: 1
    },
    imgBgStyle: {
        width: width,
        height: 100,
        flexDirection: 'row'
    },
    selectImgStyle: {
        width: 80,
        height: 80,
        borderRadius: 5,
        borderColor: '#EEEEEE',
        borderWidth: 1,
        flexDirection: 'column',
        marginTop: 10,
        marginLeft: 10,
        justifyContent: 'center',
        alignItems: 'center',
        // alignSelf: 'stretch'
    },
    addImgTitle: {
        color: '#999999',
        fontSize: 15,
        // paddingLeft: 10,
        // paddingRight: 10
    },
    addStyle: {
        fontSize: 18,
        color: '#999999'
    },
    titleStyle: {
        fontSize: 13,
        color: '#666666',
        alignSelf: 'flex-start'
    }
});

AddEvaluateImage.propTypes = {
    maxImageNumber: React.PropTypes.number,
    imgWidth: React.PropTypes.number,
    imgHeight: React.PropTypes.number
}
