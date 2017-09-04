/**
 * Created by lume on 2017/6/29.
 */
'use strict';

Object.defineProperty(exports, "__esModule", {
    value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _reactNative = require('react-native');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _objectWithoutProperties(obj, keys) { var target = {}; for (var i in obj) { if (keys.indexOf(i) >= 0) continue; if (!Object.prototype.hasOwnProperty.call(obj, i)) continue; target[i] = obj[i]; } return target; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

function noop() {}

var animationFnPropType = _react.PropTypes.oneOf([_reactNative.Animated.decay, _reactNative.Animated.spring, _reactNative.Animated.timing]);

var Swipeable = function (_PureComponent) {
    _inherits(Swipeable, _PureComponent);

    function Swipeable() {
        var _ref;

        var _temp, _this, _ret;

        _classCallCheck(this, Swipeable);

        for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
            args[_key] = arguments[_key];
        }

        return _ret = (_temp = (_this = _possibleConstructorReturn(this, (_ref = Swipeable.__proto__ || Object.getPrototypeOf(Swipeable)).call.apply(_ref, [this].concat(args))), _this), _this.state = {
            pan: new _reactNative.Animated.ValueXY(),
            width: 0,
            lastOffset: { x: 0, y: 0 },
            leftActionActivated: false,
            leftButtonsActivated: false,
            leftButtonsOpen: false,
            rightActionActivated: false,
            rightButtonsActivated: false,
            rightButtonsOpen: false
        }, _this.recenter = function () {
            var animationFn = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : _this.props.swipeReleaseAnimationFn;
            var animationConfig = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : _this.props.swipeReleaseAnimationConfig;
            var onDone = arguments[2];
            var pan = _this.state.pan;


            _this.setState({
                lastOffset: { x: 0, y: 0 },
                leftActionActivated: false,
                leftButtonsActivated: false,
                leftButtonsOpen: false,
                rightActionActivated: false,
                rightButtonsActivated: false,
                rightButtonsOpen: false
            });

            pan.flattenOffset();

            animationFn(pan, animationConfig).start(onDone);
        }, _this._unmounted = false, _this._handlePan = _reactNative.Animated.event([null, {
            dx: _this.state.pan.x,
            dy: 0
        }]), _this._handleMoveShouldSetPanResponder = function (event, gestureState) {
            return Math.abs(gestureState.dx) > _this.props.swipeStartMinDistance;
        }, _this._handlePanResponderStart = function (event, gestureState) {
            var _this$state = _this.state,
                lastOffset = _this$state.lastOffset,
                pan = _this$state.pan;


            pan.setOffset(lastOffset);
            _this.props.onSwipeStart(event, gestureState, _this);
        }, _this._handlePanResponderMove = function (event, gestureState) {
            var _this$props = _this.props,
                leftActionActivationDistance = _this$props.leftActionActivationDistance,
                leftButtonsActivationDistance = _this$props.leftButtonsActivationDistance,
                onLeftActionActivate = _this$props.onLeftActionActivate,
                onLeftActionDeactivate = _this$props.onLeftActionDeactivate,
                onLeftButtonsActivate = _this$props.onLeftButtonsActivate,
                onLeftButtonsDeactivate = _this$props.onLeftButtonsDeactivate,
                rightActionActivationDistance = _this$props.rightActionActivationDistance,
                rightButtonsActivationDistance = _this$props.rightButtonsActivationDistance,
                onRightActionActivate = _this$props.onRightActionActivate,
                onRightActionDeactivate = _this$props.onRightActionDeactivate,
                onRightButtonsActivate = _this$props.onRightButtonsActivate,
                onRightButtonsDeactivate = _this$props.onRightButtonsDeactivate,
                onSwipeMove = _this$props.onSwipeMove;
            var _this$state2 = _this.state,
                lastOffset = _this$state2.lastOffset,
                leftActionActivated = _this$state2.leftActionActivated,
                leftButtonsActivated = _this$state2.leftButtonsActivated,
                rightActionActivated = _this$state2.rightActionActivated,
                rightButtonsActivated = _this$state2.rightButtonsActivated;
            var dx = gestureState.dx,
                vx = gestureState.vx;

            var x = dx + lastOffset.x;
            var canSwipeRight = _this._canSwipeRight();
            var canSwipeLeft = _this._canSwipeLeft();
            var hasLeftButtons = _this._hasLeftButtons();
            var hasRightButtons = _this._hasRightButtons();
            var isSwipingLeft = vx < 0;
            var isSwipingRight = vx > 0;
            var nextLeftActionActivated = leftActionActivated;
            var nextLeftButtonsActivated = leftButtonsActivated;
            var nextRightActionActivated = rightActionActivated;
            var nextRightButtonsActivated = rightButtonsActivated;

            _this._handlePan(event, gestureState);
            onSwipeMove(event, gestureState, _this);

            if (!leftActionActivated && canSwipeRight && x >= leftActionActivationDistance) {
                nextLeftActionActivated = true;
                onLeftActionActivate(event, gestureState, _this);
            }

            if (leftActionActivated && canSwipeRight && x < leftActionActivationDistance) {
                nextLeftActionActivated = false;
                onLeftActionDeactivate(event, gestureState, _this);
            }

            if (!rightActionActivated && canSwipeLeft && x <= -rightActionActivationDistance) {
                nextRightActionActivated = true;
                onRightActionActivate(event, gestureState, _this);
            }

            if (rightActionActivated && canSwipeLeft && x > -rightActionActivationDistance) {
                nextRightActionActivated = false;
                onRightActionDeactivate(event, gestureState, _this);
            }

            if (!leftButtonsActivated && hasLeftButtons && !isSwipingLeft && x >= leftButtonsActivationDistance) {
                nextLeftButtonsActivated = true;
                onLeftButtonsActivate(event, gestureState, _this);
            }

            if (leftButtonsActivated && hasLeftButtons && isSwipingLeft) {
                nextLeftButtonsActivated = false;
                onLeftButtonsDeactivate(event, gestureState, _this);
            }

            if (!rightButtonsActivated && hasRightButtons && !isSwipingRight && x <= -rightButtonsActivationDistance) {
                nextRightButtonsActivated = true;
                onRightButtonsActivate(event, gestureState, _this);
            }

            if (rightButtonsActivated && hasRightButtons && isSwipingRight) {
                nextRightButtonsActivated = false;
                onRightButtonsDeactivate(event, gestureState, _this);
            }

            var needsUpdate = nextLeftActionActivated !== leftActionActivated || nextLeftButtonsActivated !== leftButtonsActivated || nextRightActionActivated !== rightActionActivated || nextRightButtonsActivated !== rightButtonsActivated;

            if (needsUpdate) {
                _this.setState({
                    leftActionActivated: nextLeftActionActivated,
                    leftButtonsActivated: nextLeftButtonsActivated,
                    rightActionActivated: nextRightActionActivated,
                    rightButtonsActivated: nextRightButtonsActivated
                });
            }
        }, _this._handlePanResponderEnd = function (event, gestureState) {
            var _this$props2 = _this.props,
                onLeftActionRelease = _this$props2.onLeftActionRelease,
                onLeftActionDeactivate = _this$props2.onLeftActionDeactivate,
                onLeftButtonsOpenRelease = _this$props2.onLeftButtonsOpenRelease,
                onLeftButtonsCloseRelease = _this$props2.onLeftButtonsCloseRelease,
                onRightActionRelease = _this$props2.onRightActionRelease,
                onRightActionDeactivate = _this$props2.onRightActionDeactivate,
                onRightButtonsOpenRelease = _this$props2.onRightButtonsOpenRelease,
                onRightButtonsCloseRelease = _this$props2.onRightButtonsCloseRelease,
                onSwipeRelease = _this$props2.onSwipeRelease;
            var _this$state3 = _this.state,
                leftActionActivated = _this$state3.leftActionActivated,
                leftButtonsOpen = _this$state3.leftButtonsOpen,
                leftButtonsActivated = _this$state3.leftButtonsActivated,
                rightActionActivated = _this$state3.rightActionActivated,
                rightButtonsOpen = _this$state3.rightButtonsOpen,
                rightButtonsActivated = _this$state3.rightButtonsActivated,
                pan = _this$state3.pan;

            var animationFn = _this._getReleaseAnimationFn();
            var animationConfig = _this._getReleaseAnimationConfig();

            onSwipeRelease(event, gestureState, _this);

            if (leftActionActivated) {
                onLeftActionRelease(event, gestureState, _this);
            }

            if (rightActionActivated) {
                onRightActionRelease(event, gestureState, _this);
            }

            if (leftButtonsActivated && !leftButtonsOpen) {
                onLeftButtonsOpenRelease(event, gestureState, _this);
            }

            if (!leftButtonsActivated && leftButtonsOpen) {
                onLeftButtonsCloseRelease(event, gestureState, _this);
            }

            if (rightButtonsActivated && !rightButtonsOpen) {
                onRightButtonsOpenRelease(event, gestureState, _this);
            }

            if (!rightButtonsActivated && rightButtonsOpen) {
                onRightButtonsCloseRelease(event, gestureState, _this);
            }

            _this.setState({
                lastOffset: { x: animationConfig.toValue.x, y: animationConfig.toValue.y },
                leftActionActivated: false,
                rightActionActivated: false,
                leftButtonsOpen: leftButtonsActivated,
                rightButtonsOpen: rightButtonsActivated
            });

            pan.flattenOffset();

            animationFn(pan, animationConfig).start(function () {
                if (_this._unmounted) {
                    return;
                }

                var _this$props3 = _this.props,
                    onLeftActionComplete = _this$props3.onLeftActionComplete,
                    onLeftButtonsOpenComplete = _this$props3.onLeftButtonsOpenComplete,
                    onLeftButtonsCloseComplete = _this$props3.onLeftButtonsCloseComplete,
                    onRightActionComplete = _this$props3.onRightActionComplete,
                    onRightButtonsOpenComplete = _this$props3.onRightButtonsOpenComplete,
                    onRightButtonsCloseComplete = _this$props3.onRightButtonsCloseComplete,
                    onSwipeComplete = _this$props3.onSwipeComplete;


                onSwipeComplete(event, gestureState, _this);

                if (leftActionActivated) {
                    onLeftActionComplete(event, gestureState, _this);
                    onLeftActionDeactivate(event, gestureState, _this);
                }

                if (rightActionActivated) {
                    onRightActionComplete(event, gestureState, _this);
                    onRightActionDeactivate(event, gestureState, _this);
                }

                if (leftButtonsActivated && !leftButtonsOpen) {
                    onLeftButtonsOpenComplete(event, gestureState, _this);
                }

                if (!leftButtonsActivated && leftButtonsOpen) {
                    onLeftButtonsCloseComplete(event, gestureState, _this);
                }

                if (rightButtonsActivated && !rightButtonsOpen) {
                    onRightButtonsOpenComplete(event, gestureState, _this);
                }

                if (!rightButtonsActivated && rightButtonsOpen) {
                    onRightButtonsCloseComplete(event, gestureState, _this);
                }
            });
        }, _this._panResponder = _reactNative.PanResponder.create({
            onMoveShouldSetPanResponder: _this._handleMoveShouldSetPanResponder,
            //onMoveShouldSetPanResponderCapture: _this._handleMoveShouldSetPanResponder,
            onPanResponderGrant: _this._handlePanResponderStart,
            onPanResponderMove: _this._handlePanResponderMove,
            onPanResponderRelease: _this._handlePanResponderEnd,
            onPanResponderTerminate: _this._handlePanResponderEnd,
            //  onPanResponderTerminationRequest: _this._handlePanResponderEnd
        }), _this._handleLayout = function (_ref2) {
            var width = _ref2.nativeEvent.layout.width;
            return _this.setState({ width: width });
        }, _temp), _possibleConstructorReturn(_this, _ret);
    }

    _createClass(Swipeable, [{
        key: 'componentWillMount',
        value: function componentWillMount() {
            var _props = this.props,
                onPanAnimatedValueRef = _props.onPanAnimatedValueRef,
                onRef = _props.onRef;


            onRef(this);
            onPanAnimatedValueRef(this.state.pan);
        }
    }, {
        key: 'componentWillUnmount',
        value: function componentWillUnmount() {
            this._unmounted = true;
        }
    }, {
        key: '_canSwipeRight',
        value: function _canSwipeRight() {
            return this.props.leftContent || this._hasLeftButtons();
        }
    }, {
        key: '_canSwipeLeft',
        value: function _canSwipeLeft() {
            return this.props.rightContent || this._hasRightButtons();
        }
    }, {
        key: '_hasLeftButtons',
        value: function _hasLeftButtons() {
            var _props2 = this.props,
                leftButtons = _props2.leftButtons,
                leftContent = _props2.leftContent;


            return !leftContent && leftButtons && leftButtons.length;
        }
    }, {
        key: '_hasRightButtons',
        value: function _hasRightButtons() {
            var _props3 = this.props,
                rightButtons = _props3.rightButtons,
                rightContent = _props3.rightContent;


            return !rightContent && rightButtons && rightButtons.length;
        }
    }, {
        key: '_getReleaseAnimationFn',
        value: function _getReleaseAnimationFn() {
            var _props4 = this.props,
                leftActionReleaseAnimationFn = _props4.leftActionReleaseAnimationFn,
                leftButtonsOpenReleaseAnimationFn = _props4.leftButtonsOpenReleaseAnimationFn,
                leftButtonsCloseReleaseAnimationFn = _props4.leftButtonsCloseReleaseAnimationFn,
                rightActionReleaseAnimationFn = _props4.rightActionReleaseAnimationFn,
                rightButtonsOpenReleaseAnimationFn = _props4.rightButtonsOpenReleaseAnimationFn,
                rightButtonsCloseReleaseAnimationFn = _props4.rightButtonsCloseReleaseAnimationFn,
                swipeReleaseAnimationFn = _props4.swipeReleaseAnimationFn;
            var _state = this.state,
                leftActionActivated = _state.leftActionActivated,
                leftButtonsActivated = _state.leftButtonsActivated,
                leftButtonsOpen = _state.leftButtonsOpen,
                rightActionActivated = _state.rightActionActivated,
                rightButtonsActivated = _state.rightButtonsActivated,
                rightButtonsOpen = _state.rightButtonsOpen;


            if (leftActionActivated && leftActionReleaseAnimationFn) {
                return leftActionReleaseAnimationFn;
            }

            if (rightActionActivated && rightActionReleaseAnimationFn) {
                return rightActionReleaseAnimationFn;
            }

            if (leftButtonsActivated && leftButtonsOpenReleaseAnimationFn) {
                return leftButtonsOpenReleaseAnimationFn;
            }

            if (!leftButtonsActivated && leftButtonsOpen && leftButtonsCloseReleaseAnimationFn) {
                return leftButtonsCloseReleaseAnimationFn;
            }

            if (rightButtonsActivated && rightButtonsOpenReleaseAnimationFn) {
                return rightButtonsOpenReleaseAnimationFn;
            }

            if (!rightButtonsActivated && rightButtonsOpen && rightButtonsCloseReleaseAnimationFn) {
                return rightButtonsCloseReleaseAnimationFn;
            }

            return swipeReleaseAnimationFn;
        }
    }, {
        key: '_getReleaseAnimationConfig',
        value: function _getReleaseAnimationConfig() {
            var _props5 = this.props,
                leftActionReleaseAnimationConfig = _props5.leftActionReleaseAnimationConfig,
                leftButtons = _props5.leftButtons,
                leftButtonsOpenReleaseAnimationConfig = _props5.leftButtonsOpenReleaseAnimationConfig,
                leftButtonsCloseReleaseAnimationConfig = _props5.leftButtonsCloseReleaseAnimationConfig,
                leftButtonWidth = _props5.leftButtonWidth,
                rightActionReleaseAnimationConfig = _props5.rightActionReleaseAnimationConfig,
                rightButtons = _props5.rightButtons,
                rightButtonsOpenReleaseAnimationConfig = _props5.rightButtonsOpenReleaseAnimationConfig,
                rightButtonsCloseReleaseAnimationConfig = _props5.rightButtonsCloseReleaseAnimationConfig,
                rightButtonWidth = _props5.rightButtonWidth,
                swipeReleaseAnimationConfig = _props5.swipeReleaseAnimationConfig;
            var _state2 = this.state,
                leftActionActivated = _state2.leftActionActivated,
                leftButtonsActivated = _state2.leftButtonsActivated,
                leftButtonsOpen = _state2.leftButtonsOpen,
                rightActionActivated = _state2.rightActionActivated,
                rightButtonsActivated = _state2.rightButtonsActivated,
                rightButtonsOpen = _state2.rightButtonsOpen;


            if (leftActionActivated && leftActionReleaseAnimationConfig) {
                return leftActionReleaseAnimationConfig;
            }

            if (rightActionActivated && rightActionReleaseAnimationConfig) {
                return rightActionReleaseAnimationConfig;
            }

            if (leftButtonsActivated) {
                return _extends({}, swipeReleaseAnimationConfig, {
                    toValue: {
                        x: leftButtons.length * leftButtonWidth,
                        y: 0
                    }
                }, leftButtonsOpenReleaseAnimationConfig);
            }

            if (rightButtonsActivated) {
                return _extends({}, swipeReleaseAnimationConfig, {
                    toValue: {
                        x: rightButtons.length * rightButtonWidth * -1,
                        y: 0
                    }
                }, rightButtonsOpenReleaseAnimationConfig);
            }

            if (!leftButtonsActivated && leftButtonsOpen && leftButtonsCloseReleaseAnimationConfig) {
                return leftButtonsCloseReleaseAnimationConfig;
            }

            if (!rightButtonsActivated && rightButtonsOpen && rightButtonsCloseReleaseAnimationConfig) {
                return rightButtonsCloseReleaseAnimationConfig;
            }

            return swipeReleaseAnimationConfig;
        }
    }, {
        key: '_renderButtons',
        value: function _renderButtons(buttons, isLeftButtons) {
            var _props6 = this.props,
                leftButtonContainerStyle = _props6.leftButtonContainerStyle,
                rightButtonContainerStyle = _props6.rightButtonContainerStyle;
            var _state3 = this.state,
                pan = _state3.pan,
                width = _state3.width;

            var canSwipeLeft = this._canSwipeLeft();
            var canSwipeRight = this._canSwipeRight();
            var count = buttons.length;
            var leftEnd = canSwipeLeft ? -width : 0;
            var rightEnd = canSwipeRight ? width : 0;
            var inputRange = isLeftButtons ? [0, rightEnd] : [leftEnd, 0];

            return buttons.map(function (buttonContent, index) {
                var outputMultiplier = -index / count;
                var outputRange = isLeftButtons ? [0, rightEnd * outputMultiplier] : [leftEnd * outputMultiplier, 0];
                var transform = [{
                    translateX: pan.x.interpolate({
                        inputRange: inputRange,
                        outputRange: outputRange,
                        extrapolate: 'clamp'
                    })
                }];
                var buttonStyle = [_reactNative.StyleSheet.absoluteFill, { width: width, transform: transform }, isLeftButtons ? leftButtonContainerStyle : rightButtonContainerStyle];

                return _react2.default.createElement(
                    _reactNative.Animated.View,
                    { key: index, style: buttonStyle },
                    buttonContent
                );
            });
        }
    }, {
        key: 'render',
        value: function render() {
            var _props7 = this.props,
                children = _props7.children,
                contentContainerStyle = _props7.contentContainerStyle,
                leftButtons = _props7.leftButtons,
                leftContainerStyle = _props7.leftContainerStyle,
                leftContent = _props7.leftContent,
                rightButtons = _props7.rightButtons,
                rightContainerStyle = _props7.rightContainerStyle,
                rightContent = _props7.rightContent,
                style = _props7.style,
                props = _objectWithoutProperties(_props7, ['children', 'contentContainerStyle', 'leftButtons', 'leftContainerStyle', 'leftContent', 'rightButtons', 'rightContainerStyle', 'rightContent', 'style']);

            var _state4 = this.state,
                pan = _state4.pan,
                width = _state4.width;

            var canSwipeLeft = this._canSwipeLeft();
            var canSwipeRight = this._canSwipeRight();
            var transform = [{
                translateX: pan.x.interpolate({
                    inputRange: [canSwipeLeft ? -width : 0, canSwipeRight ? width : 0],
                    outputRange: [canSwipeLeft ? -width + _reactNative.StyleSheet.hairlineWidth : 0, canSwipeRight ? width - _reactNative.StyleSheet.hairlineWidth : 0],
                    extrapolate: 'clamp'
                })
            }];

            return _react2.default.createElement(
                _reactNative.View,
                _extends({ onLayout: this._handleLayout, style: [styles.container, style] }, this._panResponder.panHandlers, props),
                canSwipeRight && _react2.default.createElement(
                    _reactNative.Animated.View,
                    { style: [{ transform: transform, marginLeft: -width, width: width }, leftContainerStyle] },
                    leftContent || this._renderButtons(leftButtons, true)
                ),
                _react2.default.createElement(
                    _reactNative.Animated.View,
                    { style: [{ transform: transform }, styles.content, contentContainerStyle] },
                    children
                ),
                canSwipeLeft && _react2.default.createElement(
                    _reactNative.Animated.View,
                    { style: [{ transform: transform, marginRight: -width, width: width }, rightContainerStyle] },
                    rightContent || this._renderButtons(rightButtons, false)
                )
            );
        }
    }]);

    return Swipeable;
}(_react.PureComponent);

Swipeable.propTypes = {
    // elements
    children: _react.PropTypes.any,
    leftContent: _react.PropTypes.any,
    rightContent: _react.PropTypes.any,
    leftButtons: _react.PropTypes.array,
    rightButtons: _react.PropTypes.array,

    // left action lifecycle
    onLeftActionActivate: _react.PropTypes.func,
    onLeftActionDeactivate: _react.PropTypes.func,
    onLeftActionRelease: _react.PropTypes.func,
    onLeftActionComplete: _react.PropTypes.func,
    leftActionActivationDistance: _react.PropTypes.number,
    leftActionReleaseAnimationFn: animationFnPropType,
    leftActionReleaseAnimationConfig: _react.PropTypes.object,

    // right action lifecycle
    onRightActionActivate: _react.PropTypes.func,
    onRightActionDeactivate: _react.PropTypes.func,
    onRightActionRelease: _react.PropTypes.func,
    onRightActionComplete: _react.PropTypes.func,
    rightActionActivationDistance: _react.PropTypes.number,
    rightActionReleaseAnimationFn: animationFnPropType,
    rightActionReleaseAnimationConfig: _react.PropTypes.object,

    // left buttons lifecycle
    onLeftButtonsActivate: _react.PropTypes.func,
    onLeftButtonsDeactivate: _react.PropTypes.func,
    onLeftButtonsOpenRelease: _react.PropTypes.func,
    onLeftButtonsOpenComplete: _react.PropTypes.func,
    onLeftButtonsCloseRelease: _react.PropTypes.func,
    onLeftButtonsCloseComplete: _react.PropTypes.func,
    leftButtonWidth: _react.PropTypes.number,
    leftButtonsActivationDistance: _react.PropTypes.number,
    leftButtonsOpenReleaseAnimationFn: animationFnPropType,
    leftButtonsOpenReleaseAnimationConfig: _react.PropTypes.object,
    leftButtonsCloseReleaseAnimationFn: animationFnPropType,
    leftButtonsCloseReleaseAnimationConfig: _react.PropTypes.object,

    // right buttons lifecycle
    onRightButtonsActivate: _react.PropTypes.func,
    onRightButtonsDeactivate: _react.PropTypes.func,
    onRightButtonsOpenRelease: _react.PropTypes.func,
    onRightButtonsOpenComplete: _react.PropTypes.func,
    onRightButtonsCloseRelease: _react.PropTypes.func,
    onRightButtonsCloseComplete: _react.PropTypes.func,
    rightButtonWidth: _react.PropTypes.number,
    rightButtonsActivationDistance: _react.PropTypes.number,
    rightButtonsOpenReleaseAnimationFn: animationFnPropType,
    rightButtonsOpenReleaseAnimationConfig: _react.PropTypes.object,
    rightButtonsCloseReleaseAnimationFn: animationFnPropType,
    rightButtonsCloseReleaseAnimationConfig: _react.PropTypes.object,

    // base swipe lifecycle
    onSwipeStart: _react.PropTypes.func,
    onSwipeMove: _react.PropTypes.func,
    onSwipeRelease: _react.PropTypes.func,
    onSwipeComplete: _react.PropTypes.func,
    swipeReleaseAnimationFn: animationFnPropType,
    swipeReleaseAnimationConfig: _react.PropTypes.object,

    // misc
    onRef: _react.PropTypes.func,
    onPanAnimatedValueRef: _react.PropTypes.func,
    swipeStartMinDistance: _react.PropTypes.number,

    // styles
    style: _reactNative.View.propTypes.style,
    leftContainerStyle: _reactNative.View.propTypes.style,
    leftButtonContainerStyle: _reactNative.View.propTypes.style,
    rightContainerStyle: _reactNative.View.propTypes.style,
    rightButtonContainerStyle: _reactNative.View.propTypes.style,
    contentContainerStyle: _reactNative.View.propTypes.style
};
Swipeable.defaultProps = {
    leftContent: null,
    rightContent: null,
    leftButtons: null,
    rightButtons: null,

    // left action lifecycle
    onLeftActionActivate: noop,
    onLeftActionDeactivate: noop,
    onLeftActionRelease: noop,
    onLeftActionComplete: noop,
    leftActionActivationDistance: 125,
    leftActionReleaseAnimationFn: null,
    leftActionReleaseAnimationConfig: null,

    // right action lifecycle
    onRightActionActivate: noop,
    onRightActionDeactivate: noop,
    onRightActionRelease: noop,
    onRightActionComplete: noop,
    rightActionActivationDistance: 125,
    rightActionReleaseAnimationFn: null,
    rightActionReleaseAnimationConfig: null,

    // left buttons lifecycle
    onLeftButtonsActivate: noop,
    onLeftButtonsDeactivate: noop,
    onLeftButtonsOpenRelease: noop,
    onLeftButtonsOpenComplete: noop,
    onLeftButtonsCloseRelease: noop,
    onLeftButtonsCloseComplete: noop,
    leftButtonWidth: 75,
    leftButtonsActivationDistance: 75,
    leftButtonsOpenReleaseAnimationFn: null,
    leftButtonsOpenReleaseAnimationConfig: null,
    leftButtonsCloseReleaseAnimationFn: null,
    leftButtonsCloseReleaseAnimationConfig: null,

    // right buttons lifecycle
    onRightButtonsActivate: noop,
    onRightButtonsDeactivate: noop,
    onRightButtonsOpenRelease: noop,
    onRightButtonsOpenComplete: noop,
    onRightButtonsCloseRelease: noop,
    onRightButtonsCloseComplete: noop,
    rightButtonWidth: 75,
    rightButtonsActivationDistance: 75,
    rightButtonsOpenReleaseAnimationFn: null,
    rightButtonsOpenReleaseAnimationConfig: null,
    rightButtonsCloseReleaseAnimationFn: null,
    rightButtonsCloseReleaseAnimationConfig: null,

    // base swipe lifecycle
    onSwipeStart: noop,
    onSwipeMove: noop,
    onSwipeRelease: noop,
    onSwipeComplete: noop,
    swipeReleaseAnimationFn: _reactNative.Animated.timing,
    swipeReleaseAnimationConfig: {
        toValue: { x: 0, y: 0 },
        duration: 250,
        easing: _reactNative.Easing.elastic(0.5)
    },

    // misc
    onRef: noop,
    onPanAnimatedValueRef: noop,
    swipeStartMinDistance: 15
};
exports.default = Swipeable;


var styles = _reactNative.StyleSheet.create({
    container: {
        flexDirection: 'row'
    },
    content: {
        flex: 1
    }
});