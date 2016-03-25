var gulp = require('gulp');
var htmlmin = require('gulp-htmlmin');
var jsmin = require('gulp-jsmin');
var rename = require('gulp-rename');
var imagemin = require('gulp-imagemin');
var pngquant = require('imagemin-pngquant');
var csso = require('gulp-csso');

var root = "./public";
var buildDir = root;
var datas={
	html:[root+"/**/*.html"],
	image:[root+"/**/*.png"],
	css:[root+"/**/*.css"],
	js:[root+"/**/*.js",'!*min.js']
}

// 压缩html
gulp.task("htmlmin",function(){
	gulp.src(datas.html)
	.pipe(htmlmin({collapseWhitespace:true,minifyJS:true,minifyCSS:true,removeComments:true}))
	.pipe(gulp.dest(buildDir));
});

// png图片压缩
gulp.task("imagemin",function(){
	gulp.src(datas.image)
	.pipe(imagemin({
		progressive:true,
		svgoPlugins:[{removeViewBox:false}],
		use:[pngquant()] //压缩率64%
	}))
	.pipe(gulp.dest(buildDir));
});

// js压缩
gulp.task("jsmin",function(){
	gulp.src(datas.js)
	.pipe(jsmin())
	//.pipe(rename({suffix:'.min'}))
	.pipe(gulp.dest(buildDir));
});

// css压缩
gulp.task("cssmin",function(){
	gulp.src(datas.css)
	.pipe(csso())
	.pipe(gulp.dest(buildDir));
});

gulp.task("default",["htmlmin","imagemin","jsmin","cssmin"]);