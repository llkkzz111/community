Example:

```javascript
//第一步：倒入ScreenUtil.js
import * as ScreenUtils from '../../Util/ScreenUtil';

//第二步：
style中或者其它地方调用： 直接传入设计稿上的px值
const styles = StyleSheet.create({
        commContainer: {
            paddingLeft: ScreenUtils.scaleSize(25),
            paddingRight: ScreenUtils.scaleSize(0),
            paddingTop: ScreenUtils.scaleSize(10),
            paddingBottom: ScreenUtils.scaleSize(10),
        }
    }
//字体设置
ScreenUtils.setSpText(40) //直接传入设计稿上的px值，转换成sp值（考虑到android上的字体适配）
```