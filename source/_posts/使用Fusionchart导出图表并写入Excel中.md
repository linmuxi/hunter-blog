---
title: 使用Fusionchart导出图表并写入Excel中
date: 2016-02-01 15:16:41
tags: [图表,Fusionchart]
categories: [技术]
---
本篇主要分享下如何将Fusionchart图表导出到Excel中，导出到Excel中的仅仅为一张图形图片，并不具备Excel图表编辑功能
<!--more-->
第一步：将fcexporter.jar、fcexporthandler.jar导入lib下

第二步：在classs下新建导出配置文件fusioncharts_export.properties
~~~prolog
#Please specify the path to a folder with write permissions relative to web application root
SAVEPATH=./images/
#This constant HTTP_URI stores the HTTP reference to 
#the folder where exported charts will be saved. 
#Please enter the HTTP representation of that folder 
#in this constant e.g., http://www.yourdomain.com/images/
HTTP_URI=http://www.yourdomain.com/images/
#OVERWRITEFILE sets whether the export handler will overwrite an existing file 
#the newly created exported file. If it is set to false the export handler will
#not overwrite. In this case if INTELLIGENTFILENAMING is set to true the handler
#will add a suffix to the new file name. The suffix is a randomly generated UUID.
#Additionally, you can add a timestamp or random number as additional prefix.
OVERWRITEFILE=false
INTELLIGENTFILENAMING=true
FILESUFFIXFORMAT=TIMESTAMP
~~~

第三步：修改web.xml
~~~xml
<servlet>
	<display-name>FCExporter</display-name>
	<servlet-name>FCExporter</servlet-name>
	<servlet-class>com.fusioncharts.exporter.servlet.FCExporter</servlet-class>
	<load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
	<servlet-name>FCExporter</servlet-name>
	<url-pattern>/JSP/ExportExample/FCExporter</url-pattern>  <!-- 这里配置根据自己应用需求来(请求jsp所在的文件目录) -->
</servlet-mapping>
~~~

第四步：编辑报表属性
~~~xml
<chart exportEnabled="1" exportAction="save" exportAtClient="0" exportFileName="fileName" exporthandler="FCExporter">
~~~

第五步：调用JS函数
~~~js
var chartObject = getChartFromId('myChart');
if( chartObject.hasRendered()) chartObject.exportChart();
~~~

第六步：将图片写入Excel中
~~~java
ByteArrayOutputStream allOutputStream = new ByteArrayOutputStream();
ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
Workbook book = WorkbookFactory.create(fileTransfer.getInputStream());
File file = new File(FusionChartsExportHelper.SAVEPATH+imageName+".jpg");
BufferedImage bufferImg = ImageIO.read(file);
ImageIO.write(bufferImg, "jpg", outputStream);
HSSFSheet sheet1 = (HSSFSheet) book.getSheetAt(0);
HSSFPatriarch patriarch = sheet1.createDrawingPatriarch();
HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0, 500, 255,(short) 0, 9, (short) 9, 23);
patriarch.createPicture(anchor, book.addPicture(outputStream.toByteArray(),HSSFWorkbook.PICTURE_TYPE_JPEG));
book.write(allOutputStream);
return new FileTransfer(new String("Excel标题.xls".getBytes("GBK"), "iso8859-1"), "application/xls", allOutputStream.toByteArray());
~~~