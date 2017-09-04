/**
 * Created by Xiang on 2017/5/23.
 */
import * as actionTypes from '../../actions/actionTypes'

export function showLoading(show) {
    return {
        type: actionTypes.DIALOG_LOADING,
        show:show,
    }
}
