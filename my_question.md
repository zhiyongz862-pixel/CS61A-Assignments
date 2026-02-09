# CS61A: Control Flow & Logical Operators (布尔逻辑与控制流)

## 1. Truthiness (真假值规则)
在 Python 中，所有对象都有布尔值。除了特定的“假值”外，**其他所有东西都被视为真 (True)**。

| 分类 | 包含的值 (Values) |
| :--- | :--- |
| **Falsy (假值)** | `False`, `None`, `0`, `0.0`, `""` (空字符串), `[]` (空列表), `()` |
| **Truthy (真值)** | **除了上述以外的所有值**。包括 `13`, `-5`, `"0"`, `"False"`, `[0]` |

---

## 2. Logical Operators (逻辑运算符)
**核心原则：** `and` 和 `or` 并不一定返回 `True/False`，而是返回**参与运算的那个值**（操作数）。

### A. `and` 运算 (找假值)
> **规则：** 从左向右看。如果左边是 **假 (Falsy)**，直接返回左边；否则返回右边。

* **口诀**：Keep going until you find a False value (or the end).
* **示例**：
    ```python
    True and 13      # 返回 13 (左真，取右)
    0 and 13         # 返回 0  (左假，取左)
    13 and "Hello"   # 返回 "Hello"
    ```

### B. `or` 运算 (找真值)
> **规则：** 从左向右看。如果左边是 **真 (Truthy)**，直接返回左边；否则返回右边。

* **口诀**：Keep going until you find a True value (or the end).
* **示例**：
    ```python
    13 or 5          # 返回 13 (左真，取左)
    0 or 5           # 返回 5  (左假，取右)
    None or "Guest"  # 返回 "Guest" (常用于设置默认值)
    ```

### C. `not` 运算
> **规则：** 唯一总是返回布尔值 (`True` / `False`) 的运算符。

* `not 13`  → `False`
* `not None` → `True`

---

## 3. Short-Circuiting (短路求值)
Python 一旦能够确定整个表达式的结果，就会停止计算后面的部分。这被称为**短路**。

* **`and` 的短路**：遇到第一个假值就停止。
    ```python
    False and (1 / 0)  # 不会报错！因为 (1/0) 根本没被执行。
    ```
* **`or` 的短路**：遇到第一个真值就停止。
    ```python
    True or (1 / 0)    # 不会报错！直接返回 True。
    ```



# Python Lambda 调用逻辑

### 1. 匿名函数立即调用
**代码：** `(lambda: 3)()`
**返回值：** `3`

* **`(lambda: 3)`**: 这是一个**函数对象**。它像一个“黑盒子”，里面存着逻辑。
* **`()`**: 这是**开关**。只有加上括号，才会运行盒子里的逻辑。
* **注意**：`3()` 会报错，因为数字不能被调用。必须先通过 `lambda` 把 `3` 封装成函数，才能用 `()` 提取它。

---

### 2. 高阶 Lambda 参数匹配 (报错案例)
**代码：** `(lambda f: lambda x: f(x))(2)(g)`
**结果：** `TypeError: 'int' object is not callable`

**错误追踪：**
1.  `(lambda f: ...)(2)` $\rightarrow$ 第一步把 `2` 给了 `f`。
2.  `(...)(g)` $\rightarrow$ 第二步把函数 `g` 给了 `x`。
3.  **核心逻辑执行**：试图运行 `f(x)`，即 `2(g)`。
4.  **报错原因**：数字 `2` 被当成了函数来用，这在 Python 中是非法的。

**修正方法：**
交换参数顺序：`(lambda f: lambda x: f(x))(g)(2)` 
* 这样才会执行 `g(2)`，返回 `4`。


# 高阶函数进阶：逻辑预设与延迟执行 (Lazy Evaluation)

### 1. 思路模型：逻辑天平
我们可以将这种返回函数的高阶函数想象成一个**“逻辑天平”**。
* **搭天平 (定义逻辑)**：你规定了左盘放 $f(g(x))$，右盘放 $g(f(x))$。
* **放砝码 (注入数据)**：只有当你放进具体的 $x$ 时，天平才会告诉你平不平衡。

### 2. 代码实现
这种模式允许我们在不知道具体数值的情况下，先把“数学命题”写好：

```python
def make_commutative_checker(f, g):
    """
    预设逻辑：检查 f 和 g 是否满足交换律。
    返回：一个接收 x 并返回布尔值的检测器函数。
    """
    def checker(x):
        # 此时逻辑已定，只待 x 注入
        return f(g(x)) == g(f(x))
    return checker

# 案例：检查“平方”和“加一”
# f(x) = x^2, g(x) = x + 1
sq_plus_one = make_commutative_checker(lambda x: x*x, lambda x: x+1)

# 测试具体数值
print(sq_plus_one(2))   # f(g(2)) = 9, g(f(2)) = 5 -> False
print(sq_plus_one(0))   # f(g(0)) = 1, g(f(0)) = 1 -> True