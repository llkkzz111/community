import React  from 'react'
import {connect} from 'react-redux'
import {
    StyleSheet,
    Modal,
    Image,
    Dimensions,
    TouchableOpacity,
    Animated,
    Easing,
} from 'react-native';
var {width, height, scale} = Dimensions.get('window');
var animationLoop = false;
/**
 * @author Xiang
 * 加载弹窗
 * 调用页面：
 *个人中心、购物车、商品详情
 * @example
 *<pre>
 * &lt;LoadingDialog
 *      display={this.state.showLoading}
 *      touchAvaliable={true}
 *      touchToDismiss={true}
 *      onTouch={()=>{
 *              alert('onTouch');
 *           }}
 *      toDismiss={() => {
 *              //关闭弹窗,如果touchToDismiss为false这里不被touch事件触发
 *              this.setState({showLoading: false});
 *           }}
 * /&gt;
 * &lt;View&gt;
 *       &lt;Text onPress={() => {
 *           this.setState({showLoading: true})
 *           }}>弹出loading&lt;/Text&gt;
 * &lt;/View&gt;
 *</pre>
 */
class LoadingDialog extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            bounceValue: new Animated.Value(1),
            rotateDegree: new Animated.Value(0),
        }
    }

    componentDidMount() {
        animationLoop = true;
        this.startAnimation();
    }

    componentWillUnmount() {
        animationLoop = false;
    }

    startAnimation() {
        this.state.rotateDegree.setValue(1);
        this.state.rotateDegree.setValue(0);
        Animated.parallel([
            //通过Animated.spring等函数设定动画参数
            //可选的基本动画类型: spring, decay, timing
            Animated.spring(this.state.bounceValue, {
                toValue: 1,      //变化目标值，也没有变化
                friction: 20,    //friction 摩擦系数，默认40
            }),
            Animated.timing(this.state.rotateDegree, {
                toValue: 1,  //角度从0变1
                duration: 1000,  //从0到1的时间
                easing: Easing.out(Easing.linear),//线性变化，匀速旋转
            }),
            //调用start启动动画,start可以回调一个函数,从而实现动画循环
        ]).start(() => {
            if (animationLoop) {
                this.startAnimation();
            }
        })

    }

    render() {
        return (
            <Modal
                onRequestClose={() => {
                    //安卓实体返回键触发
                    this.props.toDismiss();
                    animationLoop = false;
                }}
                onshow={animationLoop = true}
                animationType="fade"
                transparent={true}
                visible={this.props.display}
                style={loadingStyles.container}
            >
                <TouchableOpacity
                    activeOpacity={1}
                    style={loadingStyles.contentContainer}
                    disabled={!this.props.touchAvaliable}
                    onPress={() => {
                        // if (this.props.touchAvaliable) {
                        //     this.props.onTouch();
                        // }
                        // if (this.props.touchToDismiss) {
                            this.props.toDismiss();
                        //     animationLoop = false;
                        // }
                    }}
                >
                    <Image source={require('../Img/dialog/logo@3x.png')} style={loadingStyles.ocjImg}>
                    </Image>
                    <Animated.Image source={require('../Img/dialog/loading_img@3x.png')}
                                    style={{
                                        width: 80,
                                        height: 80,
                                        transform: [
                                            //将初始化值绑定到动画目标的style属性上
                                            {scale: this.state.bounceValue},
                                            //使用interpolate插值函数,实现了从数值单位的映/射转换,上面角度从0到1，这里把它变成0-360的变化
                                            {
                                                rotateZ: this.state.rotateDegree.interpolate({
                                                    inputRange: [0, 1],
                                                    outputRange: ['0deg', '360deg'],
                                                })
                                            },
                                        ]
                                    }}>
                    </Animated.Image>

                </TouchableOpacity>
            </Modal>
        )
    }
}
let loadingStyles = StyleSheet.create({
    container: {
        zIndex: 10,
        flex: 1,
        justifyContent: 'center',
    },
    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        width: width,
        height: height,
    },
    ocjImg: {
        position: 'absolute',
        height: 50,
        width: 50,
        justifyContent: 'center',
        alignItems: 'center',
    },
    rotateImg: {
        height: 80,
        width: 80,
    }
})
export default connect(
    state => ({}),
    dispatch => ({})
)(LoadingDialog)