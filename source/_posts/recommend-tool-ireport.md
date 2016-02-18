---
title: '[推荐]报表设计工具iReport'
date: 2016-02-01 16:33:08
tags: [图形报表,iReport,推荐]
categories: [技术,工作]
---
这篇主要分享一款报表设计工具iReport，因为在项目中实际应用过，觉得好用，推荐给大家。本篇不做详细介绍，感兴趣和有需求的可以自行查阅相关资料进行了解，也可以留言进行交流
<!--more-->
其提供的可视化报表设计工具挺好用的，而且提供API供编程使用，可支持导出多种格式，例如PDF、HTML、EXCEL等。

** 下面是可视化报表设计工具的工作台截图：** 

![可视化报表设计工具](http://7xqlat.com1.z0.glb.clouddn.com/ireport_01.png)

** 下面是在项目中设计的报表模版：** 

![报表设计模版](http://7xqlat.com1.z0.glb.clouddn.com/ireport_02.png)
![报表设计模版](http://7xqlat.com1.z0.glb.clouddn.com/ireport_03.png)

** 利用提供的API导出报表到PDF **
~~~java
// 可视化工具设计的模版文件
String filePath = "E:\\demo\\iReport\\myReport.jasper";

// 通过模版文件实例化报表对象
JasperReport report = (JasperReport) JRLoader.loadObjectFromFile(filePath);
report.setWhenNoDataType(WhenNoDataTypeEnum.ALL_SECTIONS_NO_DETAIL);

// 下面是封装的数据实体对象
Map<String, Object> params = new HashMap<String, Object>();
// list集合对象
params.put("repaymentDetailDS", new JRBeanCollectionDataSource(getRepaymentDetailList()));
// 实体VO对象,可以直接在报表模版中通过vo对象来调用
params.put("vo", getParams());

// 利用提供的数据填充报表对象
JasperPrint print4 = JasperFillManager.fillReport(report, params,new JREmptyDataSource());

List<JasperPrint> printList = new ArrayList<JasperPrint>();
printList.add(print4);

// 设置导出格式为PDF
JRPdfExporter pdfExporter = new JRPdfExporter();
// 导入源
pdfExporter.setExporterInput(SimpleExporterInput.getInstance(printList));
// 导出源
pdfExporter.setExporterOutput(new SimpleOutputStreamExporterOutput("E:/myReport.pdf"));

// 可以进行PDF参数配置
SimplePdfExporterConfiguration spec = new SimplePdfExporterConfiguration();
/*spec.setEncrypted(true);
spec.setUserPassword("123456");*/

pdfExporter.setConfiguration(spec);
// 导出PDF对象
pdfExporter.exportReport();
~~~