# Core Geometry Functions Wave 7-5 Extraction V1

## 目标

细抽 `1.6.10 几何函数和操作符`，覆盖几何操作、测量函数和几何类型转换。

## 当前规模

| 指标 | 当前值 |
|---|---:|
| Source chapter | 1 |
| 物理页 | 381–391，共11页 |
| 结构化 facts | 15 |
| Open questions | 2 |
| Source resolved | 1 / 1 |
| Facts bound to scope | 15 / 15 |

## 覆盖内容

### 几何操作符

- 平移与旋转：`+`、`-`、`*`、`/`
- 交面与顶点数：`#`
- 长度/周长、中心和距离：`@-@`、`@@`、`<->`
- 重叠与左右方位：`&&`、`<<`、`>>`、`&<`、`&>`
- 上下方位：`<<|`、`|>>`、`&<|`、`|&>`
- 相交、邻接、平行：`?#`、`?-`、`?|`、`?-|`、`?||`
- 包含、被包含和相同：`@>`、`<@`、`~=`

### 测量函数

- `area`
- `center`
- `diameter`
- `height`
- `isclosed`
- `isopen`
- `length`
- `npoints`
- `pclose`
- `popen`
- `radius`
- `width`

### 类型转换

- `box(circle)`、`box(point,point)`、`box(polygon)`
- `circle(box)`、`circle(point,double precision)`、`circle(polygon)`
- `lseg(box)`、`lseg(point,point)`
- `slope(point,point)`
- `path(polygon)`
- `point(double precision,double precision)`、`point(box)`、`point(circle)`、`point(lseg)`、`point(polygon)`
- `polygon(box)`、`polygon(circle)`、`polygon(npts,circle)`、`polygon(path)`

## Open questions

| ID | 内容 |
|---|---|
| `geometry_wave7_5_oq_operator_matrix` | 几何操作符在point、box、lseg、line、path、polygon、circle组合及退化图形/NULL下的支持矩阵 |
| `geometry_wave7_5_oq_conversion_precision` | 几何转换在旋转、圆近似多边形、路径闭合性和浮点精度边界下的输出矩阵 |

## 产物

```text
docs/compat_facts/core_geometry_wave7_5_v1.yaml
generated/core_geometry_wave7_5_v1/manifest.json
```

## 机器校验

```bash
python scripts/build_core_geometry_wave7_5.py
python scripts/build_core_geometry_wave7_5.py --check
python -m pytest -q tests/test_core_geometry_wave7_5.py
```

## 边界

- 本阶段只做原文事实抽取，不生成SQL。
- 不连接数据库、不构造几何对象、不执行几何运算或转换。
- 不宣称目标环境行为验证通过。
