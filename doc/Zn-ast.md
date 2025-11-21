
| Node     | 解释    | 字符         | data index       | data type                 |
| -------- | ----- | ---------- | ---------------- | ------------------------- |
| Root     | 根节点   |            | steps            | List                      |
| Label    | 标签    | a          | label            | String                    |
| Lq       | 字面量   |            | value            | dynamic                   |
| Num      | 数字字面量 | 1          | value            | num                       |
| Str      | 字符字面量 | ""         | value            | String                    |
| Let      | 赋值    | =          | label value      | Label Node                |
| Exchange | 交换    | <-->       | a b              | Label/Node  Label/Node    |
| Vec      | 向量    | <>         | vec              | List< Label/Node/Lq>      |
| Map      | 表     | [ ]        | map              | Map<Node, Node>           |
| Index    | 访问    | .x  [1]    | obj index        | List/Map/Label  Lq/Node   |
| Fn       | 函数    | {} (){}... | parameters steps | List< Label>  List< Node> |
| If       | 条件分支  | ?? if :    | fn condition     | Fn/Label  Node  Fn/Label  |
| Loop     | 定次循环  | loop       | fn num           | Fn/Label  Num/Node/Label  |
| For      | 遍历循环  | for        | fn obj           | Fn/Label  Map/Vec/Label   |
| While    | 条件循环  | while      | fn condition     | Fn/Label  Node            |
| Call     | 函数调用  | ()         | fn arguments     | Fn/Label  List< Node>     |
| Add      | 加     | +          | a b              | Node Node                 |
| Sub      | 减     | -          | a b              | Node Node                 |
| Mul      | 乘     | *          | a b              | Node Node                 |
| Div      | 除     | /          | a b              | Node Node                 |
| Sec      | 次方    | ^          | a b              | Node Node                 |
| Or       | 或     | \|         | a b              | Node Node                 |
| Not      | 非     | ~          | a b              | Node Node                 |
| And      | 且     | &          | a b              | Node Node                 |
|          |       |            |                  |                           |




