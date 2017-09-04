/**
 * @author Xiang
 *
 * 没有领取赠品Toast
 */
import React from 'react'
import {
    View,
    Text,
    StyleSheet,
    Dimensions,
    Modal,
} from 'react-native'
const {width, height} = Dimensions.get('window');

class ConfirmDialog extends React.PureComponent {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <Modal animationType="fade"
                   onRequestClose={() => {
                   }}
                   transparent={true}
                   style={styles.container}
                   visible={this.props.show}>
                <View style={styles.contentContainer}>
                    <View style={styles.content}>
                        <View style={styles.titleContainer}>
                            <Text style={styles.title} allowFontScaling={false}>您是否要使用员工折扣?</Text>
                        </View>
                        <View style={styles.verticalDivide}/>
                        <View style={styles.buttonContainer}>
                            <View style={styles.bottonInner}>
                                <Text style={styles.button} onPress={() => {
                                    this.props.clickUseEmpDiscount({resword: '1'});
                                }} allowFontScaling={false}>使用</Text>
                            </View>
                            <View style={styles.horizentalDivide}/>
                            <View style={styles.bottonInner}>
                                <Text style={styles.button} onPress={() => {
                                    this.props.clickUseEmpDiscount({resword: '0'});
                                }} allowFontScaling={false}>不用</Text>
                            </View>
                        </View>
                    </View>
                </View>
            </Modal>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
    },

    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        justifyContent: 'center',
        width: width,
        height: height,
    },
    content: {
        justifyContent: 'center',
        backgroundColor: 'white',
        borderRadius: 10,
        marginLeft: 50,
        marginRight: 50,
    },
    titleContainer: {
        height: 80,
        justifyContent: 'center'
    },
    title: {
        textAlign: 'center',
        fontWeight: 'bold',
        fontSize: 20,
        color: '#333333',
    },
    buttonContainer: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    button: {
        fontWeight: 'bold',
        fontSize: 16,
        color: '#333333',
    },
    bottonInner:{
        height: 50,
        flex: 1,
        alignItems:'center',
        justifyContent:'center'
    },
    verticalDivide: {
        height: 1,
        backgroundColor: '#F5A99E',
    },
    horizentalDivide: {
        height: 50,
        width: 1,
        backgroundColor: '#F5A99E',
    }
});
ConfirmDialog.propTypes = {
    btnYes: React.PropTypes.func,
    btnNo: React.PropTypes.func,
}
export default ConfirmDialog