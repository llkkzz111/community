/**
 * Created by xuzw on 2017/2/23.
 */
import {handleActions} from 'redux-actions'
import {Actions} from 'react-native-router-flux'
import * as actionTypes from '../../actions/actionTypes'
import {Alert} from 'react-native'

const userState = {
    homeSearchBaseShow:false,//显示搜索页面

    hotWordRecommend:null,//热词推荐接口
    hotWordSearch:null,//搜索热词接口
    searchResult:null,//搜索接口
}

export default handleActions({
    [actionTypes.HOME_SEARCH_BASE_SHOW]:(state,action)=>{
        return{
            ...state,
            homeSearchBaseShow:true,//action.show,
        }
    },
    [actionTypes.SearchDataAction]: (state, action) => {
        const { payload: {
            data
            } } = action
        switch (data.type) {
            case actionTypes.HOT_WORD_RECOMMEND:
            {
                if (data.success) {
                    return {
                        ...state,
                        hotWordRecommend: data.result,
                    }
                }
                else {
                    return {
                        ...state,
                        //hotWordRecommend: {}
                    }
                }
            }
                break;
            case actionTypes.HOT_WORD_SEARCH:
            {
                if (data.success) {
                    return {
                        ...state,
                        hotWordSearch: data.result,
                    }
                }
                else {
                    return {
                        ...state,
                        //hotWordSearch: {}
                    }
                }
            }
                break;
            case actionTypes.SEARCH_RESULT:
            {
                if (data.success) {
                    return {
                        ...state,
                        searchResult: data.result,
                    }
                }
                else {
                    return {
                        ...state,
                    }
                }
            }
                break;
        }
    },
},userState)


