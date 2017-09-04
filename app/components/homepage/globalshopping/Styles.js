/**
 * Created by YASIN on 2017/6/1.
 * 首页公共styles
 */
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
export default {
    swiper: {
        dot: {
            backgroundColor: '#fff',
            width: ScreenUtils.scaleSize(10),
            height: ScreenUtils.scaleSize(10),
            borderRadius: ScreenUtils.scaleSize(5),
            marginLeft: 5,
            marginRight: 5,
            marginTop: 5,
            marginBottom: 5,
            borderWidth: 0.5,
            borderColor: '#fff'
        },
        activeDot: {
            backgroundColor: '#E5290D',
            width: ScreenUtils.scaleSize(10),
            height: ScreenUtils.scaleSize(10),
            borderRadius: ScreenUtils.scaleSize(5),
            marginLeft: 5,
            marginRight: 5,
            marginTop: 5,
            marginBottom: 5,
            borderWidth: 0.5,
            borderColor: '#E5290D'
        }
    }
}