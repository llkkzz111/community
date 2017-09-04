/**
 * Created by admin-ocj on 2017/5/16.
 */
import {handleActions} from 'redux-actions';
import * as actionTypes from '../../actions/actionTypes'
const defaultState = {
    showLoading: false,
}
export  default function loadingReducer(state, action) {
    switch (action.type) {
        case actionTypes.DIALOG_LOADING:
            return {
                showLoading: action.show,
            }
        default:
            return defaultState
    }
}
