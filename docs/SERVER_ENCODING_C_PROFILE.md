# CREATE DATABASE：服务端编码的有限 C 上下文

这是离线生成能力，不是建库执行授权或37种编码实机支持证明。

## 来源与边界

本地PDF V2.0-10.0.0集中式版，一般CREATE DATABASE正文表1-376逐行给出服务器端支持能力；L473—475允许C/POSIX与服务端编码搭配，L478—480给出template0/templatea对模板编码与locale匹配的例外。因此，剩余37种服务端编码不能统一归为“缺操作系统locale”。

原44个编码值及其validity不变：2个既有正向、5个客户端only负向、37个泛化conditional。新等价类只追加37个`*_c_template0`上下文值，逐个引用原值ID、原服务端事实与C/模板规则；不是把所有编码都改成valid。当前模型不支持同一维度混用classes和matrix，因此没有复制一份编码矩阵或改基础模型。

新manifest只变encoding一个维度，固定WITH、等号、-1，生成37条而不是额外展开笛卡尔积。示例由同一产生式渲染：

```sql
CREATE DATABASE b8_database WITH TEMPLATE = template0 ENCODING = 'GBK'
LC_COLLATE = 'C' LC_CTYPE = 'C' DBCOMPATIBILITY = 'PG' CONNECTION LIMIT = -1;
```

共享生成路径上的有限检查器核对原编码服务端属性与来源、真实SQL的template0/C/PG上下文、环境门禁和完整前后置。改变模板、locale、模式、服务端编码、去掉合同或清理，均不能继续沿用此valid profile。POSIX在文档中可行，但本次未生成POSIX分支；拒绝突变不表示产品不支持。

原37个泛化conditional缺口仍保留。别名、客户端转换、任意locale、其他模板/模式、数据库内部存储行为和目录结果，需要各自消费者与Oracle，不能由这37条语法候选推导已覆盖。

## 管理DDL生命周期

新fixture只读检查b8_database不存在；目标CREATE成功并取得归属回执之后，才能使用`DROP DATABASE b8_database;`清理。禁止预DROP、IF EXISTS、PURGE、自动断连或吞异常。库级回收站必须关闭，目标库没有连接；这些是门禁要求，不会擅自修改环境。

DROP DATABASE正文L14—22是连接/事务/回收站的依据，manifest跨包引用该章事实。原既存库fixture本就由ALTER与DROP两个包共用，现把它的owner标成null，保留兼容ID和原SQL，表示独立共享资产，不再人为形成CREATE→DROP→CREATE的包级环。没有删除依赖或关闭循环检测。旧共享fixture仍含PURGE，不被本次新候选复用，也未因此获得运行许可。

此批不进入普通schema执行准备批次。静态名称检查不能证明运行时归属、消除并发抢占、证明管理连接安全或清理成功。setup/目标失败时不能无条件执行清理；实际连接、创建、清理与失败处置须另行授权。

## 验收

专用测试检查37条唯一SQL、原conditional保全、真实上下文突变拒绝、缺门禁/清理拒绝、客户端编码伪装拒绝、缺合同/重复门禁拒绝及真实共享fixture依赖无环。

发布前还需逐字段比较原正向8条和负向5条，并核对ALTER/DROP DATABASE原快照、可行pair及来源hash。静态回归与PDF依据都不替代实机Oracle。
