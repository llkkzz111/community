/**
 * Created by dhy on 2017/8/18.
 */
import {
    View,
    Text,
    Image,
    StyleSheet,
} from 'react-native';
import {
    Component,
    React,
    ScreenUtils,
    Colors,
} from '../../app/config/UtilComponent';
export default class TimeLimitItem extends Component{
    static propTypes = {
      distance:React.PropTypes.number,
    };
    static defaultProps = {
        distance: 0,
    };
    constructor(props){
        super(props);
        // 初始状态
        this.state = {
            times: ['00', '00', '00', '00', '00', '00'],
        };
    }
    componentDidMount() {
        let distance = this.props.distance;
        this.timeStart(distance);
    }

    timeStart(distance) {
        if (distance > 0) {
            this.interval = setInterval(() => {
                if (distance <= 0) {
                    clearInterval(this.interval);
                }else {
                    this.setState({
                        times: ScreenUtils.getRemainingimeDistance(distance),//获取时间数组
                    });
                    distance--;
                }
            }, 1000);
        }
    }
    render(){
        return (
            <View style={styles.remainingTime}>
                <Image
                    source={require('../Img/groupbuy/icon_time_@3x.png')}
                    style={{
                        width:ScreenUtils.scaleSize(20),
                        height:ScreenUtils.scaleSize(20),
                        marginRight:ScreenUtils.scaleSize(5)
                    }}
                />
                <Text style={styles.countdown} allowFontScaling={false}>剩余
                    {this.state.times[2]+'天'}
                    {this.state.times[3]+'时'}
                    {this.state.times[4]+'分'}
                    {this.state.times[5]+'秒'}
                </Text>
            </View>
        )
    }
    componentWillUnmount(){
        clearInterval(this.interval);
    }

}

const styles = StyleSheet.create({
    remainingTime:{
        height:ScreenUtils.scaleSize(40),
        flexDirection:"row",
        position:"absolute",
        bottom:0,
        alignItems:"center",
        zIndex:20,
        justifyContent:"center",
        left:0,
        right:0
    },
    countdown:{
        color:Colors.text_white,
        fontSize:ScreenUtils.setSpText(20),
        backgroundColor:"transparent",
    }
});
// TimeLimitItem.defaultProps = {
//     distance:0,
// };
// TimeLimitItem.propTypes = {
//     distance:React.PropTypes.number,
// };