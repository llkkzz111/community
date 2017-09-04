import {handleActions} from 'redux-actions';

// import {} from '../actions/actionTypes'

const actionInitialState = {
    counters:[],
    selects:{
        title:'我的应用',
        functions:[]
    },
    homeSeparatorHide:true,
    iconNormal:true,
    funcArray:[],
}

export default handleActions({

}, actionInitialState);
