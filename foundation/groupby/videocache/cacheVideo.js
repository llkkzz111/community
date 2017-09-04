

// var Video = class extends (require('react-native-video').default) {
//     cacheOptions() { return {size: 50, expiresIn: 3600, key: 'settings'} };
// }
// module.exports = Video;
//
// // LongClipPlayer.js
// var LongVideo = class extends (require('react-native-video').default) {
//     cacheOptions() { return {size: 50, expiresIn: 3600, key: 'longVideoCache'} };
// }
// module.exports = LongVideo;
//
// // ShortClipPlayer.js
// var ShortVideo = class extends (require('react-native-video').default) {
//     cacheOptions() { return {size: 10, expiresIn: 1200, key: 'shortVideoCache'} };
// }
// module.exports = ShortVideo;
//
// module.exports.cleanCache = function (cacheKey, time) {
//     const videos = readCache(cacheKey);
//     videos.forEach((video) => {
//
//         if (isMyVideoOld(video, time) {
//             deleteVideo(video);
//         }
//     });
// }