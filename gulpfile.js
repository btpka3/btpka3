require('shelljs/global');

var Vinyl = require('vinyl');
var vfs = require('vinyl-fs');

var fs = require("fs");
const gulp = require('gulp');
const gutil = require('gulp-util');
const pkg = require('./package.json');
const chalk = require('chalk');
const path = require('path');
const runSequence = require('run-sequence');
var map = require('map-stream');

// shelljs, [vinyl-fs], glob

console.log(__dirname);


var filsMaps = {
    // fileBaseName: [filePath1, filePath2]
};

// var ignoreDirs = [
//     "_book",
//     "_layouts",
//     ".git",
//     "node_modules"
// ];


// fs.readdirSync(__dirname).forEach((dirName) => {
//
//     if (ignoreDirs.indexOf(dirName) >= 0) {
//         return;
//     }
//
//     console.log(dirName);
// });

// find(__dirname).filter( (file) => {
//
//     return file.match(/\.js$/);
// });

// ls(__dirname)
//     .filter((file) => {
//         return ignoreDirs.indexOf(file) < 0;
//     })
//     .forEach((file)=> {
//         if (s.statSync(file).isDirectory()) {
//             ls("-R", path.join(__dirname,file,"")).forEach((file)=> {
//                 console.log()
//             });
//         }
//
//
//         ls("-R", path.join(filteredLvl1Files)).forEach((file)=> {
//             console.log()
//         });
//     })

// ls(__dirname, "*.md", "app", "apple").forEach((file)=> {
//     console.log(file);
// })


const checkSrc = [
    '**/*.md',
    '!_book/**/*',
    '!_layouts/**/*',
    '!.git/**/*',
    '!node_modules/**/*'
];

gulp.task('default', cb => {

    runSequence(
        "check.prepare",
        "check.report",
        ()=> {
            cb(); // 指示该任务已经执行完毕
        });

});


gulp.task("check.prepare", cb => {
    return vfs.src(checkSrc)
        .pipe(map((file, _cb)=> {
            // XXX: 如果使用3.x版本的gulp, 将会 Vinyl.isVinyl(file)===false。
            // 所以, 直接使用新版本的 vinyl-fs
            regMdFile(file.stem, file.relative);
            _cb(null, file);

            function regMdFile(baseName, path) {
                if (!filsMaps[baseName]) {
                    filsMaps[baseName] = []
                }
                filsMaps[baseName].push(path);
            }
        }))
        .on('finish', () => {
            cb();
        });
});


gulp.task("check.report", cb => {
    gutil.log(`文件名唯一性检查 : ${chalk.green('开始')} `);
    var count = 0;

    Object.keys(filsMaps).forEach(key => {

        if (!filsMaps.hasOwnProperty(key)) {
            return;
        }
        if (filsMaps[key].length > 1) {
            count++;
            gutil.log(`文件名唯一性检查 : ${chalk.yellow(key)} => ${chalk.red(filsMaps[key])}`);
        }
    });
    gutil.log(`文件名唯一性检查 : ${chalk.green('结束')} : ${count > 0 ? chalk.red('失败') : chalk.yellow('成功')} `);
    cb();
});
