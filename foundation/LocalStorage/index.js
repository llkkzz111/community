/**
 * Created by yinqingyang on 2017/5/24.
 * 本地持久化缓存工具类
 */
import {AsyncStorage} from 'react-native';
import global from '../../app/config/global';
import Storage from './storage';
/**
 * 缓存初始化
 */
export function init() {
    if (global && (typeof global.storage === 'undefined')) {
        global.storage = new Storage({
            // maximum capacity, default 1000
            size: 1000,
            // Use AsyncStorage for RN, or window.localStorage for web.
            // If not set, data would be lost after reload.
            storageBackend: AsyncStorage,

            // expire time, default 1 day(1000 * 3600 * 24 milliseconds).
            // can be null, which means never expire.
            defaultExpires: null,

            // cache data in the memory. default is true.
            enableCache: true,
        });
    }
};
/**
 * 保存数据至内存
 * @param key 数据的key
 * @param data 需要保存的数据
 * @param expires 保存的数据有效期，可以为null为永久（单位毫秒）
 */
export function save(key:string, data, expires:Number) {
    if (global && global.storage) {
        global.storage.save({
            key: key,   // Note: Do not use underscore("_") in key!
            data: data,
            // if not specified, the defaultExpires will be applied instead.
            // if set to null, then it will never expire.
            expires: expires
        });
    }
};
/**
 * 保存数据至内存
 * @param key 数据的key
 * @param data 需要保存的数据
 * @param expires 保存的数据有效期，可以为null为永久（单位毫秒）
 */
export function saveCms(key:string, data, expires=(global.cmsCacheTime*60*1000)) {
    if (global && global.storage) {
        global.storage.save({
            key: key,   // Note: Do not use underscore("_") in key!
            data: data,
            // if not specified, the defaultExpires will be applied instead.
            // if set to null, then it will never expire.
            expires: expires
        });
    }
};

/**
 *
 * @param key 获取数据的key
 * @param successCallBack 成功回调方法，返回值为data
 * @param erroCallBack 失败返回值（过了有效期、未找到等等）具体可以通过err.name或err.message查看
 */
export function load(key:string, successCallBack, erroCallBack) {
    if (global && global.storage) {
        global.storage.load({
            key: key
        }).then(ret => {
            // found data go to then()
            if (ret && successCallBack) {
                successCallBack(ret);
            }
        }).catch(err => {
            // any exception including data not found
            // goes to catch()
            if (err && erroCallBack) {
                erroCallBack(err);
            }
        })
    }
};
/**
 * 删除指定的数据
 * @param key 数据key值
 * @returns {boolean} 是否删除成功
 */
export function remove(key:string):Boolean {
    try {
        if (global && global.storage) {
            global.storage.remove({
                key: key
            });
            return true;
        }
        return false;
    } catch (erro) {
        return false;
    }
};
/**
 * 清除所有的key和data
 * @returns {boolean} 是否删除成功
 */
export function clearMap():Boolean {
    try {
        if (global && global.storage) {
            global.storage.clearMap();
            return true;
        }
        return false;
    } catch (erro) {
        return false;
    }
}
