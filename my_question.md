# 一定要注意 range是左开右闭的

# 1. Control Flow & Logical Operators (布尔逻辑与控制流)

## 1.1. Truthiness (真假值规则)
在 Python 中，所有对象都有布尔值。除了特定的“假值”外，**其他所有东西都被视为真 (True)**。

| 分类 | 包含的值 (Values) |
| :--- | :--- |
| **Falsy (假值)** | `False`, `None`, `0`, `0.0`, `""` (空字符串), `[]` (空列表), `()` |
| **Truthy (真值)** | **除了上述以外的所有值**。包括 `13`, `-5`, `"0"`, `"False"`, `[0]` |

---

## 1.2. Logical Operators (逻辑运算符)
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

## 1.3. Short-Circuiting (短路求值)
Python 一旦能够确定整个表达式的结果，就会停止计算后面的部分。这被称为**短路**。

* **`and` 的短路**：遇到第一个假值就停止。
    ```python
    False and (1 / 0)  # 不会报错！因为 (1/0) 根本没被执行。
    ```
* **`or` 的短路**：遇到第一个真值就停止。
    ```python
    True or (1 / 0)    # 不会报错！直接返回 True。
    ```



# 2. Lambda 调用逻辑

### 2.1. 匿名函数立即调用
**代码：** `(lambda: 3)()`
**返回值：** `3`

* **`(lambda: 3)`**: 这是一个**函数对象**。它像一个“黑盒子”，里面存着逻辑。
* **`()`**: 这是**开关**。只有加上括号，才会运行盒子里的逻辑。
* **注意**：`3()` 会报错，因为数字不能被调用。必须先通过 `lambda` 把 `3` 封装成函数，才能用 `()` 提取它。

---

### 2.2. 高阶 Lambda 参数匹配 (报错案例)
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


# 3.高阶函数进阶：逻辑预设与延迟执行 (Lazy Evaluation)

### 3.1. 思路模型：逻辑天平
我们可以将这种返回函数的高阶函数想象成一个**“逻辑天平”**。
* **搭天平 (定义逻辑)**：你规定了左盘放 $f(g(x))$，右盘放 $g(f(x))$。
* **放砝码 (注入数据)**：只有当你放进具体的 $x$ 时，天平才会告诉你平不平衡。

### 3.2. 代码实现
这种模式允许我们在不知道具体数值的情况下，先把“数学命题”写好：

```python
def make_commutative_checker(f, g):
    """
    预设逻辑：检查 f 和 g 是否满足交换律。
    返回：一个接收 x 并返回布尔值的检测器函数。
    """
    def checker(x):
              # 此时逻辑已定，只待 x 注入
​        return f(g(x)) == g(f(x))
​    return checker

# 案例：检查“平方”和“加一”

# f(x) = x^2, g(x) = x + 1

sq_plus_one = make_commutative_checker(lambda x: x*x, lambda x: x+1)

# 测试具体数值

print(sq_plus_one(2))   # f(g(2)) = 9, g(f(2)) = 5 -> False
print(sq_plus_one(0))   # f(g(0)) = 1, g(f(0)) = 1 -> True
```






# 4.CS61A 递归专题 (Recursion) 核心总结

递归的本质是：**专注于处理“当前一步”，并将“剩下的所有步”委托给同一个逻辑。**

---

## 4.1. 线性递归：序列的拆解与缩减
**代表题目：** `num_eights(n)`、`digit_distance(n)`

线性递归像剥洋葱，每一层递归只处理数据的一个“薄片”（如数字的最后一位）。

* **核心逻辑：**
    1.  **处理末尾**：处理当前最容易拿到的数据（如 `n % 10`）。
    2.  **缩小规模**：将剩余部分丢回递归（如 `n // 10`）。
    3.  **终止条件 (Base Case)**：定义最简单的情况（如 `n == 0`）。
* **关键公式：** `结果 = 当前步的贡献 + 递归处理(剩余部分)`



---

## 4.2. 相互递归 (Mutual Recursion)：逻辑的交替
**代表题目：** `interleaved_sum(n, odd_func, even_func)`

当任务需要在多个状态（如奇/偶、开关、步数）之间切换时，使用两个或多个函数互相调用。

* **核心思维：**
    * **函数名代表状态**：`odd(n)` 专门处理奇数逻辑，`even(n)` 专门处理偶数逻辑。
    * **接力赛跑**：`odd` 执行完自己的任务后，把 `n+1` 传给 `even`；`even` 处理完后再传回 `odd`。
* **优势：** 这种设计避免了在函数内部写复杂的 `if/else` 判断。逻辑跳转由函数调用自动完成。

---

## 4.3. 树递归 (Tree Recursion)：决策树的探索
**代表题目：** `count_dollars(total)`（整数划分/找零钱问题）

这是递归最强大的形态。当你的每一步都面临**分叉选择**（选或不选、走或不走）时，递归会生长成一棵“决策树”。

* **核心模型：选或不选 (Keep or Explore)**
    以找零钱为例，对于当前最大面额（如 100元）：
    1.  **使用它 (With)**：目标金额减少，但我**还可以继续尝试**使用这个面额（`total - up`）。
    2.  **跳过它 (Without)**：目标金额不变，但我**彻底放弃**这个面额，尝试更小的面额（`next_smaller(up)`）。
* **结果统计（叶子节点）：**
    - `total == 0`：成功方案！返回 `1`。
    - `total < 0` 或 `面额用尽`：此路不通，返回 `0`。



---

## 4.4. 递归设计对比表

| 递归类型 | 典型结构 | 适用场景 | 关键点 |
| :--- | :--- | :--- | :--- |
| **线性递归** | `f(n)` 调用 `f(n-1)` | 遍历、求和、计数 | 找准 Base Case |
| **相互递归** | `f` 调用 `g`，`g` 调用 `f` | 奇偶交替、状态机逻辑 | 防止循环死锁 |
| **树递归** | `f` 调用两次 `f` (分叉) | 找零、路径搜索、组合 | 二分决策 (选/不选) |

---

## 4.5. 学习总结：向上还是向下？
在 `count_dollars` 中，无论我们是从 **最大面额往下找**（100 -> 50 -> ...），还是从 **最小面额往上找**（1 -> 5 -> ...），其本质都是在遍历同一棵决策树的不同镜像。只要我们的分叉逻辑（选或不选）是一致的，最终得到的方案总数（叶子节点数量）完全相同。



# 5.Python 装饰器 (Decorators) 核心笔记

## 5.1. 核心定义
装饰器本质上是一个**高阶函数 (Higher-order Function)**。
它接收一个函数作为参数，并返回一个新的函数。

> **核心公式：** `新函数 = 装饰函数(旧函数)`

---

## 5.2. 语法糖与底层逻辑
使用 `@` 符号是 Python 的便捷写法（Syntactic Sugar）。

### 写法 A（常用语法糖）
```python
@timer
def square(x):
    return x * x
```

### 写法 B（底层原理）

```python
def square(x):
    return x * x

# 这一步是装饰器的灵魂：
# 将旧函数传入，经过 timer 加工，生成新函数，再赋值回给变量 square
square = timer(square)

```

---

## 5.3. 标准构造模板 (Wrapper Pattern)

为了让装饰器能适配任意参数的函数，标准写法必须包含 `*args` 和 `**kwargs`，并利用闭包 (Closure) 保存原函数。

```python
def my_decorator(func):
    """
    func: 被传入的旧函数
    """
    def wrapper(*args, **kwargs):
        # [1] 执行前的额外操作 (副作用 / Side Effects)
        print(">>> 🔴 Before calling the function")
        
        # [2] 执行原函数 (Core Logic)
        # 必须传入 args 和 kwargs，并捕获返回值
        result = func(*args, **kwargs)
        
        # [3] 执行后的额外操作
        print(">>> 🟢 After calling the function")
        
        # [4] 返回原函数的结果
        return result
        
    return wrapper # 返回包装好的新函数

```

---

## 5.4. 形象比喻：手机壳模式

* **旧函数 (Original)**：一部裸机（核心功能：打电话）。
* **装饰器 (Decorator)**：手机壳加工厂。
* **包装函数 (Wrapper)**：套上壳的手机。
* **功能增强**：多了防摔、磁吸功能。
* **核心不变**：打电话的功能没变，内部电路没拆。
* **透明性**：用户依然是拿“手机”在用，感觉不到被包装过。



---

## 5.5. CS61A 实战应用：记忆化 (Memoization)

这是装饰器在递归中的顶级应用，用于优化算法复杂度（从指数级  降到线性级 ）。

```python
def memoize(f):
    cache = {}  # 闭包状态：用于存储计算过的结果 {参数: 结果}
    
    def helper(n):
        if n not in cache:
            # 如果没算过，计算并存入 cache
            cache[n] = f(n)
        return cache[n] # 如果算过，直接返回
        
    return helper

@memoize
def fib(n):
    if n <= 1: return n
    return fib(n-1) + fib(n-2)

```

---

## 5.6. 装饰器的关键特性 (Summary)

1. **高阶函数**：输入是函数，输出也是函数。
2. **闭包 (Closure)**：内部的 `wrapper` 函数记住了外部传入的 `func`。
3. **透明性**：调用者不需要修改调用代码（依然是 `f(x)`），但功能已被扩展。
4. **解耦**：将辅助功能（日志、计时、缓存）与业务逻辑（计算、处理）分离

# 6.CS61A Lecture 10: Sequences (序列)

本节课核心聚焦于 Python 中的序列类型（Lists, Ranges）以及处理序列的高效工具——列表推导式。

---

## 6.1. Ranges (范围对象)
`range` 是一个表示**连续整数序列**的类型。

### 核心特性
* **半开区间**：包含起始值 (start)，**不包含**结束值 (end)。
* **懒加载**：它不直接存储所有数字，而是存储“计算规则”。只有转换成 `list` 时才会展开。

6.1]构造与计算

* **构造函数**：`range(start, end)` 或 `range(end)` (默认 start=0)。
* **长度计算**：`Length = end - start`
* **元素选择**：`Element = start + index`

### 代码示例 
```python
# 1. 基础用法 (-2 到 1)
r = range(-2, 2)
print(list(r))  # -> [-2, -1, 0, 1]

# 2. 默认从 0 开始
print(list(range(4))) # -> [0, 1, 2, 3]

# 3. 索引访问 (虽然看起来像 List，但它是 Range 对象)
r[2] # -> 0
```

------

## 2. List Comprehensions (列表推导式)

这是 Python 中处理序列最强大的工具，用于在一行代码中完成 **Map (映射)** 和 **Filter (过滤)**。

语法结构 

Python

```
[<map exp> for <name> in <iter exp> if <filter exp>]
```

- **iter exp**: 要遍历的序列。
- **filter exp**: 筛选条件（可选）。如果为 True，则保留。
- **map exp**: 对保留下来的元素做什么处理（生成新值）。

实战：双列表关联过滤 

场景：有两个相关联的列表 `xs` 和 `ys`（`y` 是 `x` 的函数计算结果），找出所有 `y < 10` 对应的 `x`。

Python

```
xs = range(-10, 11)
# ys 是根据 xs 算出来的
ys = [x*x - 2*x + 1 for x in xs] 

# 目标：找出 ys < 10 时对应的 xs
# 注意：这里不能直接写 if y < 10，因为 y 不在当前的变量作用域里
# 我们需要重新计算逻辑，或者用 zip (虽然 slides 没提 zip，但这是工程写法)

# Slides 的逻辑推导：
result = [x for x in xs if (x*x - 2*x + 1) < 10]
# 结果: [-2, -1, 0, 1, 2, 3, 4]
```

------

## 3. 序列处理模式：Promoted (元素提升)

这是一个经典的面试/考试题型：**重新排序列表**，将满足特定条件的元素移到前面，同时保持其原始相对顺序。

问题描述 

实现 `promoted(s, f)`：

- 输入：序列 `s`，判断函数 `f`。
- 输出：一个新列表。所有 `f(e)` 为 True 的元素排在前面，False 的排在后面。

解决方案 

利用列表推导式的**拼接**特性，代替复杂的循环。

Python

```
def promoted(s, f):
    """
    >>> promoted(range(10), lambda x: x % 2 != 0)
    [1, 3, 5, 7, 9, 0, 2, 4, 6, 8]
    """
    # 1. 挑出满足条件的 (True)
    front = [x for x in s if f(x)]
    
    # 2. 挑出不满足条件的 (False)
    back = [x for x in s if not f(x)]
    
    # 3. 拼接
    return front + back
```

------

# 7.List and range 

---

## 7.1. Lists (列表)

操作 

```python
>>> suits = ['coin','string','myriad']
>>> original_suits = suits
>>> suits.pop() #弹出最后一个元素 这个是有返回值的
'myriad'
>>> suits.remove('string') #移除对应的最后一个元素
>>> suits
['coin']
>>> suits.append('cup') #添加一个元素
>>> suits.extend(['sword','club']) #添加一个元素
>>> suits 
['coin', 'cup', 'sword', 'club']
>>> original_suits
['coin', 'cup', 'sword', 'club']


s.insert(0,9) #第0个位置插入9

#append返回的是None，但是还是会进行对应的append操作
>>> s = [3,4,5]
>>> s.extend([s.append(9),s.append(10)])
>>> s
[3, 4, 5, 9, 10, None, None]
```

#### Python 的可变 (Mutable) 与不可变 (Immutable) 机制

在这段代码中，`original_suits` 之所以跟着改变，是因为**变量只是便利贴，而不是盒子**。

#### 7.1.1. 案情回顾：为什么跟着变了？
当你执行 `original_suits = suits` 时，Python **并没有**把这个列表复制一份。它只是拿了一张写着 `original_suits` 的新便利贴，贴在了 `suits` 已经贴着的那个**同一个物理列表**上。



随后，你调用的 `.pop()`, `.remove()`, `.append()`, `.extend()` 全部都是**突变方法 (Mutating Methods)**。它们在“原地”修改了这个列表。
因为两张便利贴贴在同一个东西上，所以不管你看哪张便利贴，底下的列表都已经是修改后的样子了。

---

#### 7.1.2. 什么是“可变”与“不可变”？

在 Python 中，所有的数据类型都被严格分为两大阵营：

##### 🟢 可变对象 (Mutable Objects)
**定义**：对象被创建后，**可以**在原地改变其内部的值，而不需要改变它在内存中的地址（身份证号 `id` 不变）。
* **代表人物**：`list` (列表)、`dict` (字典)、`set` (集合)，迭代器(iter)。
* **特征**：它们通常有诸如 `.append()`, `.pop()`, `[0] = "new"` 这种直接修改自身的方法。

##### 🔴 不可变对象 (Immutable Objects)
**定义**：对象一旦被创建，就**绝对不能**再被改变。如果你想改变它，Python 只能在内存里**偷偷新建**一个对象，然后把便利贴（变量名）撕下来贴到新对象上。
* **代表人物**：`int` (数字)、`float` (浮点数)、`str` (字符串)、`tuple` (元组)、`bool` (布尔值)。
* **特征**：任何看似修改的操作，其实都是创建了新对象。

---

##### 7.1.3. 代码对比：一眼看穿两者的区别

你可以用 Python 的 `id()` 函数（查看对象的内存地址/身份证号）来验证这一点：

**【不可变对象的表现：数字】**
```python
x = 10
print(id(x))  # 假设地址是 1000

x = x + 1     # 看起来 x 变了
print(x)      # 输出 11
print(id(x))  # 地址变成了 1032！
# 结论：原来的那个数字 10 并没有变成 11，而是产生了一个全新的 11。
```

**定义**：一种数据结构，可以容纳有序的元素集合。元素可以是任意类型（数字、字符串、甚至其他列表）。

##### 基础操作
* **创建**：使用方括号 `[]`，元素间用逗号分隔。
    ```python
    list_of_values = [2, 1, 3, True, 3]
    nested_list = [2, [1, 3], [True, [3]]] # 嵌套列表
    ```
* **合并**：使用 `+` 符号可以将两个列表拼接成一个新列表。
    ```python
    [1, 2] + [3] + [4, 5]  # 结果: [1, 2, 3, 4, 5]
    ```

##### 索引 (Indexing)
* **正向索引**：从 **0** 开始（最左边的元素）。
  
    ```python
    list_of_values[0]  # 结果: 2
    ```
* **反向索引**：从 **-1** 开始（最右边的元素）。
    ```python
    nested_list[-1]    # 结果: [True, [3]] (获取最后一个元素)
    ```

---

## 7.2. Ranges (范围)
**定义**：一种表示**整数序列**的数据结构，通常用于循环。

### 构造方式
1.  **`range(stop)`**: 包含 `0, 1, ..., stop - 1`。
2.  **`range(start, stop)`**: 包含 `start, start + 1, ..., stop - 1`。

> **注意**：Range **不包含** `stop` 值本身（即左闭右开区间）。

### 特性
* **类型区别**：Range 对象与 List 不同。
* **转换**：虽然 `range` 是序列，但直接打印只会显示对象信息。如果需要看到具体数字，需要使用 `list()` 进行转换。
    ```python
    range(3, 6)       # 输出: range(3, 6)
    list(range(3, 6)) # 输出: [3, 4, 5]
    max(range(10),key=lambdax:7-(x-4)*(x-2)) #找到让后面那个式子对应最大值的x
    ```

---

## 7.3. For Statements (For 循环)
**定义**：用于遍历序列（如 list 或 range）中的每个元素并执行代码块。

### 语法结构
```python
for <name> in <expression>:
    <suite>
```

### 执行流程

1. **求值**：计算 `<expression>`，它必须是一个序列。
2. **迭代**：按顺序取出序列中的每个元素。
   - 将 `<name>` 绑定到当前元素。
   - 执行 `<suite>` 代码块。

### 示例

Python

```
for x in [-1, 4, 2, 0, 5]:
    print("Current elem:", x)
# 依次打印 -1, 4, 2, 0, 5
```

------

## 7.4. List Comprehensions (列表推导式)

**定义**：一种在一行代码中根据现有序列创建新列表的简洁方法。

### 语法形式

Python

```
# 形式 1: 基础映射
[<expression> for <element> in <sequence>]

# 形式 2: 带过滤条件的映射
[<expression> for <element> in <sequence> if <conditional>]
```

### 执行逻辑解析

以 `[i*i for i in [1, 2, 3, 4] if i % 2 == 0]` 为例：

1. **遍历**：`for i in [1, 2, 3, 4]` (取出每个元素)。
2. **过滤**：`if i % 2 == 0` (检查是否为偶数，保留 2 和 4)。
3. **计算**：`i*i` (对保留下来的元素求平方)。
4. **结果**：生成新列表 `[4, 16]`。

### 等价的 For 循环

列表推导式本质上是以下代码的语法糖：

Python

```
result = []
for i in [1, 2, 3, 4]:
    if i % 2 == 0:
        result = result + [i*i]
```

**[[1] + s for s in [[4], [5, 6]]]**

**结果**

[1,4],[1,5,6]

## 7.5 String

Len(字符串) 字符串的长度 'str' 这个是3。'i meet you' 这个是10



min或者max函数是有key的

Try using `max` or `min` with the optional `key` argument (which takes in a one-argument function). For example, `max([-7, 2, -1], key=abs)` would return `-7` since `abs(-7)` is greater than `abs(2)` and `abs(-1)`.



## 7.6 字典

定义字典 

```python
{}
{3:4}
{'string':3}
# key不能是列表（即key一定要是可哈希的） key不能重复
dict = {'I':1,'V':2,"X":3}
list(dict) # ['I','V','X']
dict.values() #得到所有的value
dict.get(key,default) #这个有个default参数，没有就取这个

>>> numerals = {'I':5,'X':10}
>>> 
>>> 
>>> numerals['X']
10
>>> numerals.pop('X')
10

def divide(quotients, divisors):
    """Return a dictonary in which each quotient q is a key for the list of
    divisors that it divides evenly.

    >>> divide([3, 4, 5], [8, 9, 10, 11, 12])
    {3: [9, 12], 4: [8, 12], 5: [10]}
    >>> divide(range(1, 5), range(20, 25))
    {1: [20, 21, 22, 23, 24], 2: [20, 22, 24], 3: [21, 24], 4: [20, 24]}
    """
    # return {____: ____ for ____ in ____}
    return {x:[y for y in divisors if y % x == 0] for x in quotients }
  
 #字典的推导式子，可以加入列表的推导式子

```

# 8 Tree

8.1 Python 如何实现一颗树

定义构造函数 

Tree(3,[tree(1),tree(2),[tree(1),tree(1)])]). 

+ 每一个根后面带一个[] 
+ 兄弟之间逗号分隔
+ [3,[1],[2,[1],[1]]]

```python
def tree(label,branches = []):
  for branch in branches:
    	assert is_tree(branch)
  return [label] + list(branches)

def label(tree):
  return tree[0]

def branches(tree):
  return tree[1:]
```



# 9 迭代器

## 9.1 列表的迭代器

```python
>>> s = [3,4,5]
>>> t = iter(s) #创建一个迭代器，这个迭代器知道列表的内容,一个标记指示着s当中的某个元素，可以借助t访问改标记以及之后的元素
>>>  # 可以吧t看成一个位置 
>>> next(t)
3
>>> next(t)
4
>>> next(t)
5
>>> next(t) #超过限制了
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
    import platform
    ^^^^^^^
StopIteration


>>> b = iter(s)
>>> next(b)
3
>>> list(b) #可以把剩余元素组织成新的list
[4, 5]
```

## 9.2 字典的迭代器

```python
>>> d = {'one':1,'two':2,'three':3}
>>> d['zero'] = 0 #加到最后
>>> d
{'one': 1, 'two': 2, 'three': 3, 'zero': 0}
>>> k = iter(d.keys())
>>> next(k)
'one'
>>> v=iter(d.values())
>>> v
<dict_valueiterator object at 0x102ea72e0>
>>> next(v)
1
>>> i = iter(d.items())
>>> next(i)
('one', 1)

# 字典大小改变时，迭代器失效
>>> d = {'one':1,'two':2}
>>> k = iter(d)
>>> 
>>> 
>>> d = {'one':1,'two':2}
>>> k = iter(d) #默认是遍历key
>>> next(k)
'one'
>>> d['zero'] = 0
>>> next(k)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
    import platform
    ^^^^^^^
RuntimeError: dictionary changed size during iteration
>>> # 当列表/字典长度发生改变时，原来的迭代器失效，必须创建新的
```



## 9.3 for循环的作用

```python
>>> r =[3,4,5]
>>> for i in r:
...     print(i)
... 
3
4
5
>>> for i in r: #两次不变，证明这个是可变的
...     print(i)
... 
3
4
5
>>> ri = iter(r)
>>> ri
<list_iterator object at 0x102e9c7c0>
>>> next(r)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
    import platform
    ^^^^^^^
TypeError: 'list' object is not an iterator
>>> next(ri)
3
>>> for i in ri: #next之后就一去不复返了
...     print(i)
... 
4
5
```





# 10.build in function for iteration

##### Python 内置迭代函数 (Built-in Functions for Iteration)

这些函数接收一个“可迭代对象”（Iterable），并对其中的元素进行处理。

**1. 惰性求值函数 (Lazy Iterators) - 重点!**
在 Python 3 中，这些函数**不会**立刻计算结果，而是返回一个“迭代器对象”。你必须用 `list()` 转换或者用 `for` 循环遍历，才能看到里面的值。

* **`map(func, iterable)`**
    * **功能**：把函数 `func` 作用到 `iterable` 的**每一个**元素上。
    * **代码**：
        ```python
        nums = [1, 2, 3]
        m = map(lambda x: x*x, nums) 
        # m 是一个 map object，看不到值
        list(m) # -> [1, 4, 9]
        ```

* **`filter(func, iterable)`**
    * **功能**：只保留 `func(x)` 返回 `True` 的元素。
    * **代码**：
        ```python
        nums = [1, 2, 3, 4]
        f = filter(lambda x: x % 2 == 0, nums)
        list(f) # -> [2, 4]
        ```

* **`zip(*iterables)`**
    * **功能**：像拉链一样，把多个序列对应位置的元素打包成元组。**以最短的序列为准**。
    * **代码**：
        ```python
        names = ['Anna', 'Bob']
        ages = [18, 20, 22]
        z = zip(names, ages)
        list(z) # -> [('Anna', 18), ('Bob', 20)]
        ```

* **`reversed(sequence)`**
    * **功能**：返回一个倒序的迭代器。
    * **注意**：它不返回列表！
    * **代码**：
        ```python
        r = reversed([1, 2, 3])
        list(r) # -> [3, 2, 1]
        ```

---

**2. 立即求值函数 (Eager Evaluation)**
这些函数会**立即**遍历整个序列，并返回一个具体的值或列表。

* **`sorted(iterable, key=None, reverse=False)`**
    * **功能**：返回一个新的**已排序列表**（List）。
    * **注意**：它和 `list.sort()` 不一样，`sorted` 不改变原列表，而是返回新的。
    * **代码**：
        ```python
        s = sorted([3, 1, 2]) # -> [1, 2, 3]
        ```

* **`min(iterable)` / `max(iterable)`**
    * **功能**：返回最小值/最大值。
    * **技巧**：可以加 `key` 参数。
    * **代码**：
        ```python
        max(['a', 'apple', 'z'], key=len) # -> 'apple' (按长度比)
        ```

* **`sum(iterable, start=0)`**
    * **功能**：求和。
    * **代码**：`sum([1, 2, 3])` -> 6

* **`all(iterable)` / `any(iterable)`**
    * **功能**：
        * `all`：所有元素都为真（Truthy）才返回 True。
        * `any`：只要有一个元素为真就返回 True。

---

**3. 实用工具**
* **`enumerate(iterable)`**
    * **功能**：同时给你 **索引 (Index)** 和 **值 (Value)**。
    * **代码**：
        ```python
        t = ['a', 'b']
        list(enumerate(t)) # -> [(0, 'a'), (1, 'b')]
        
        # 常用写法：
        for index, value in enumerate(t):
            print(index, value)
        ```

```python
>>> # 下面学习3个Bulid in Functions for Iteration
>>> bcd = ['b','c','d']
>>> x = map(lambda x:x.upper(),bcd)
>>> next(x)
'B'
>>> next(x)
'C'


# 证明是在惰性的计算，每次调用才计算 
>>> def double(x):
...     print('**','x','=>',2*x,'**')
... 
>>> li = [3,4,5]
>>> map(double,li)
<map object at 0x102e9ca60>
>>> m = map(double,li)
>>> next(m)
** x => 6 **
>>> next(m)
** x => 8 **
>>> next(m)
** x => 10 **



# iter可以作为可迭代对象 
>>> def double(x):
...     print('**',x,'=>',2*x,'**')
...     return 2*x
>>> li = [3,4,5,6,7]
>>> m = map(double,li)
>>> f = lambda y:y>=10
>>> t = filter(f,m) #相当于吧iter这个可迭代对象作为第二个参数，每个对象是一个函数 
>>> next(t) #这里会找到第一个符合条件的并返回，本质上还是值的比较，要返回，那个print只是方便寻迹而已
** 3 => 6 **
** 4 => 8 **
** 5 => 10 **
10

# 他会先找到符合条件的所有的，然后再整成list
>>> list(filter(f,map(double,range(3,7))))
** 3 => 6 **
** 4 => 8 **
** 5 => 10 **
** 6 => 12 **
[10, 12]


#list也会消耗掉迭代器
>>> x = map(double,li)
>>> list(x)
** 3 => 6 **
** 4 => 8 **
** 5 => 10 **
** 6 => 12 **
** 7 => 14 **
[6, 8, 10, 12, 14]
>>> list(x)
[]
```

# 11.生成器

```python
>>> def plus_minus(x):
...     yield x
...     yield -x
... 
>>> t = plus_minus(3) #当调用生成器函数时，会返回对应的迭代器
>>> next(t)
3
>>> next(t) #所以，这个不是return，而是产生
-3


#可以看到生成函数也是个惰性函数,yield相当于他的返回，每次执行会保留状态以便于下一次执行

def even(start,end):
    even = start + (start % 2) #确保第一个数是基数字 
    while even < end:
        print("开始调用")
        yield even
        print("调用结束")
        even+=2 

>>> t = even(2,10)
>>> next(t)
开始调用
2
>>> next(t)
调用结束
开始调用
4


# yield from 允许从可迭代对象中产生所有的值 
def a_then_b(a,b):
    for x in a:
        yield x
    for x in b:
        yield x
# euqal 
def a_then_b_from(a,b):
    yield from a 
    yield from b

>>> list(a_then_b([3,4],[5,6]))
[3, 4, 5, 6]
>>> list(a_then_b_from([3,4],[5,6]))
[3, 4, 5, 6]
```

