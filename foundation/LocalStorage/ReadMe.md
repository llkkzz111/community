Example:

```javascript
//第一步：初始化LocalStorage
//在index.android.js跟index.ios.js或者程序入口处初始化
componentWillMount() {
        //初始化缓存
        LocalStorage.init();
    }
//第二步：
import * as Storage from '../foundation/LocalStorage';
    //查数据
  // Storage.load("home",(ret)=>{
        //     console.log("componentDidMount==>");
        //     console.log(ret);
        // },(erro)=>{
        //     console.log("componentDidMount==>");
        //     console.log(erro);
        // })
   //插入数据
   // Storage.save("home",{name:"yqy"},null);
```