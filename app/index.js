import React from 'react';
import { Provider } from 'react-redux';
import App from './App';
import store from './createStore';

export default () => (
    <Provider store={store}>
        <App />
    </Provider>
);
