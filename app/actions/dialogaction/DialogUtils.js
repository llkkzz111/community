/**
 * Created by Xiang on 2017/5/23.
 */
import store from '../../createStore'
import * as dialogAction from './DialogAction'

export default function showLoadingDialog(show){
    store.dispatch(dialogAction.showLoading(show))
}

