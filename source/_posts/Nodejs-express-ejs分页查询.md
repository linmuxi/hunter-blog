---
title: Nodejs+Express+ejs分页查询
date: 2016-01-19 11:58:06
tags: [Node.js]
categories: [技术]
---
学习Nodejs、express做的一个简单分页查询，前端分页控件用的是bootstrap-paginator
<!--more-->
** dbhelper **
~~~js
var mysql = require("mysql");
var pool = mysql.createPool({
	host:"localhost",
	user:"root",
	password:"root",
	database:"mydb",
	port:"3306",
	connectionLimit:10
});

var helper = function(){
	this.query = function(sql,callback){
		pool.getConnection(function(err,conn){
			if(err)console.log("获取连接失败,%s",err);

			conn.query(sql,function(err,rows,fields){
				if(err)console.log("查询失败,%s",err);
				callback(rows);
			});

			conn.release();
		});
	};
	this.insert = function(sql,callback){
		pool.getConnection(function(err,conn){
			if(err)console.log("获取连接失败,%s",err);

			conn.query(sql,function(err,res){
				if(err)console.log("新增失败,%s",err);				
				callback(res.insertId);
			});

			conn.release();
		});
	};
	this.update = function(sql,callback){
		pool.getConnection(function(err,conn){
			if(err)console.log("获取连接失败,%s",err);

			conn.query(sql,function(err,res){
				if(err)console.log("修改失败,%s",err);			
				//callback(res.changedRows);
				callback(res.affectedRows);
			});

			conn.release();
		})
	};
	this.delete = function(sql,callback){
		pool.getConnection(function(err,conn){
			if(err)console.log("获取连接失败,%s",err);

			conn.query(sql,function(err,res){
				if(err)console.log("删除失败,%s",err);
				callback(res.affectedRows);
			});

			conn.release();
		})
	}
}

exports.helper = helper;
~~~

** Controller **
~~~js
var fs = require("fs");

var express = require("express");
var app = express();
app.set("view engine","ejs");
app.set("views","../views");

var dbhelper = require("./dbhelper");
var helper = new dbhelper.helper();

var rootContext = "/test";

function wrapRootContextUrl(url){
	return rootContext+url;
}

//静态资源托管
app.use(wrapRootContextUrl("/user"),express.static("../../nodejs-paginator"));

app.get('/(test)?',function(req,res,next){
	res.send("welcome!");
});

app.get(wrapRootContextUrl("/user/userList"),function(req,res,next){
	var p = req.query.p;
	var limit = req.query.limit;

	var data = {currentPage:p,totalPages:0};
	helper.query("select count(1) count from user_info",function(result){
		if(result){
			data.totalPages = Math.ceil(result[0].count/limit);
			//console.log("获取总数："+data.totalPages);
		}

		helper.query("SELECT id,user_name userName,PASSWORD password FROM user_info LIMIT "+(p-1)*limit+","+limit,function(result){
			data.items = result;
			//console.log("返回前获取："+data.totalPages);
			res.render("index",data);
		});
	});

});

app.listen(3000,function(){
	console.log("服务启动");
});
~~~

** Ejs模版 **
~~~html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>用户列表</title>

    <link rel="stylesheet" href="css/bootstrap-responsive.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/documentation.css">
    <link rel="stylesheet" href="css/highlight.js/sunburst.css">

    <script src="lib/jquery.min.js"></script>
    <script src="lib/bootstrap.min.js"></script>
    <script src="lib/bootstrap-paginator.js"></script>
</head>
<body>
    <table border="1" style="width:300px;margin:0 auto;margin-top:10px;">
        <tr>
            <td>ID</td>
            <td>UserName</td>
            <td>Password</td>
        </tr>
        <%for(var i = 0;i<items.length;i++){ %>
            <tr>
                <td><%=items[i].id%></td>
                <td><%=items[i].userName%></td>
                <td><%=items[i].password%></td>
            </tr>
        <%}%>
    </table>

	<div id="example"></div>
	<script type="text/javascript">
		var options = {
			currentPage:"<%=currentPage%>",
			totalPages:"<%=totalPages%>",
            size:"large",
            alignment:"center",
            itemContainerClass: function (type, page, current) {
                return (page === current) ? "active" : "pointer-cursor";
            },
            onPageClicked: function(e,originalEvent,type,page){
				//alert("Page item clicked, type: "+type+" page: "+page);
            },
            onPageChanged: function(e,oldPage,newPage){
                //alert("Current page changed, old: "+oldPage+" new: "+newPage);
            },
            pageUrl:function(type,page,current){
            	return "/Test/user/userlist?p="+page+"&limit=5";
            }
		}

		$("#example").bootstrapPaginator(options);
	</script>
</body>
</html>
~~~