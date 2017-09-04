/**
 * @author YASIN1
 * @description app常量类
 */
export const DEBUG_MODE = true;
let AppConst = {
    version: '1.0.0',
};
if (DEBUG_MODE) {
    Object.assign(AppConst, {
        H5_BASE_URL: 'http://rm.ocj.com.cn',
        //首页接口地址
        BASE_URL: 'http://10.22.218.162' //测试环境
        //BASE_URL: 'http://ocj-mdemo.ocj.com.cn'//测试环境
        // BASE_URL: 'https://m1.ocj.com.cn:443' //生产环境
        //BASE_URL:'10.22.218.164:9109'         //崔阳测试地址
        //BASE_URL:'http://10.23.19.178:9102'   //刘珂江测试地址
    });
} else {
    Object.assign(AppConst, {
        H5_BASE_URL: 'http://m.ocj.com.cn',
        BASE_URL: 'https://m1.ocj.com.cn:443'     //生产环境
    });
}
export default AppConst;
