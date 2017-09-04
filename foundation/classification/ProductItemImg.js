/**
 * Created by Xiang on 2017/7/14.
 */
import React from 'react';
import {
    View,
    Image,
} from 'react-native';

import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';
export default class ProductItemImg extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = ({
            loadDefault: true,
        })
    }

    componentDidMount() {
        // if (this.props.imgUrl) {
        //     this.setState({
        //         loadDefault: false,
        //     })
        // } else {
        //     this.setState({
        //         loadDefault: true,
        //     })
        // }
    }

    render() {
        return (
            <View>
                {
                    this.state.loadDefault ?
                        <Image style={this.props.imgStyle} source={ require('../Img/img_defaul_@3x.png')}/> : null}
                {
                    this.state.loadDefault ? null :
                        <Image style={this.props.imgStyle}
                               source={{uri: this.props.imgUrl}}
                               onLoad={() => {
                                   //加载成功
                                   this.setState({
                                       loadDefault: false,
                                   })
                               }}
                               onLoadStart={() => {
                                   //开始
                                   this.setState({
                                       loadDefault: true,
                                   })
                               }}
                        />
                }
            </View>
        )
    }
}