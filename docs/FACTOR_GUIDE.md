# Legacy V0 单文件因子指南

状态：仅用于维护根目录 `factors/` 和旧版 `FactorRegistry`。新的产品文档抽取禁止使用本格式，必须按照 [Factor Package Schema V1](FACTOR_PACKAGE_SCHEMA_V1.md) 写入 `specs/<category>/<statement>/`。

## 为什么仍然保留

Web/API和部分旧测试仍会加载 `factors/`，所以当前不能直接删除。V0中的template、params、constraints和setup与V1存在职责重叠；继续双写会造成规则漂移。

维护原则：

- 只修复现有兼容功能，不在V0新增产品事实；
- 不把V1规则手工复制回V0；
- 新因子只创建Factor Package V1；
- 删除V0必须由单独迁移任务完成，并先消除所有运行时引用。

## V0最小示例

```yaml
id: select_basic
name: SELECT
category: DML
template: "SELECT {select_clause} FROM {table_name}"
params:
  select_clause:
    classes:
      - name: 全部列
        values: ["*"]
constants:
  table_name: t_factor_test
default_strategy: equivalence
```

这段示例只说明旧加载器的数据形状，不是当前抽取模板。V1中相同事实应拆分为source ledger、factor、syntax、manifest，并在需要时引用matrix、fixture和scenario。

## 当前入口

- V1字段规范：[Factor Package Schema V1](FACTOR_PACKAGE_SCHEMA_V1.md)
- V1抽取规则：[Doc2Spec Extraction Rules V1](DOC2SPEC_EXTRACTION_RULES_V1.md)
- V1示例：`specs/ddl/create_view/`、`specs/dml/select/`
