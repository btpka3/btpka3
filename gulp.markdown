
## 调试 gulp 匹配文件的目录

```js
const gulp = require('gulp');
const gutil = require('gulp-util');
const gulpIgnore = require('gulp-ignore');
const vinylPaths = require('vinyl-paths');

// 仅包含根目录下特定前缀的文件，和子目录中非js，css，less，map文件。
const libAssetsSrc = [
    'src/lib/?*/**/*',
    '!src/lib/?*/**/*.js',
    '!src/lib/?*/**/*.css',
    '!src/lib/?*/**/*.less',
    '!src/lib/?*/**/*.map',
    'src/lib/lib-min-*.js',
    'src/lib/lib-min-*.js.map',
    'src/lib/lib-min-*.css',
    'src/lib/lib-min-*.css.map'
];

gulp.task("testPath", function () {
    gulp.src(libAssetsSrc)
        .pipe(gulpIgnore.exclude({isDirectory: true}))
        .pipe(vinylPaths(paths => {
            gutil.log('Paths:', paths);
            return Promise.resolve();
        }))
        .pipe(gulpIgnore.exclude(true));
});
```