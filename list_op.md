这是一份基于我们刚才讨论内容的 **Python & CS61A 核心知识点笔记**，采用了 Markdown 格式，非常适合直接复制到 Typora 中保存复习。

---

# CS61A Python 核心知识点复习笔记

## 1. 面向对象编程 (OOP) 与 继承 (Inheritance)

### 1.1 实例属性 vs 类属性 (Instance vs Class Attributes)

* **查找顺序**：Instance (实例自己) -> Class (创建实例的类) -> Parent Class (父类)。
* **遮蔽 (Shadowing)**：如果给实例的属性赋值 (`obj.x = 1`)，它会在实例身上新建一个属性，**不会**改变类属性，但会“遮住”类属性。

```python
class A:
    x = 0  # 类属性

obj = A()
obj.x = 1  # 实例属性，遮蔽了 A.x
print(obj.x) # 1
print(A.x)   # 0 (类属性没变)

```

### 1.2 `self` 的动态性

* **核心规则**：不管代码写在父类还是爷爷类里，只要是 `self.method()`，Python 永远从 **当前实例的最底层子类** 开始查找方法。
* **应用**：`Ant.add_to` 调用 `self.can_contain`。如果 `self` 是 `BodyguardAnt`，它会自动调用 `BodyguardAnt` 重写的 `can_contain`。

### 1.3 `super()` 与 构造函数

子类重写 `__init__` 时，**必须**调用 `super().__init__()`，否则无法继承父类设定的实例属性（如 `health`, `place`）。

```python
class BodyguardAnt(ContainerAnt):
    def __init__(self, health=2):
        super().__init__(health) # 必须写！否则没有 self.ant_contained 属性

```

### 1.4 非绑定方法调用 (Unbound Method Call)

* **写法**：`ClassName.method(self, args)`
* **场景**：在子类中明确指定调用某个父类（或祖先类）的逻辑，而不是依赖默认的 `super()` 顺序。
* **例子**：`Insect.remove_from(self, place)` —— 强制执行 `Insect` 的移除逻辑（清空 `self.place`）。

---

## 2. 可变性 (Mutability)

### 2.1 Mutable vs Immutable

* **Immutable (不可变)**: `int`, `float`, `str`, `tuple`。修改意味着创建新对象（ID 改变）。
* **Mutable (可变)**: `list`, `dict`, `set`, **自定义对象**。原地修改，ID 不变。

### 2.2 默认参数陷阱 (Default Argument Trap)

* **原因**：函数的默认参数在 **定义时 (Definition Time)** 创建，且只创建一次。
* **后果**：如果是 Mutable 对象（如 `[]`），所有调用将共享同一个列表。
* **最佳实践**：使用 `None` 作为哨兵。

```python
# ✅ 正确写法
def append_to(num, target=None):
    if target is None:
        target = []  # 运行时创建新列表
    target.append(num)
    return target

```

### 2.3 列表的变异操作

* `append(x)`: 把 x 当作一个元素加进去。
* `extend(x)`: 把 x 拆开，元素一个个加进去。
* `s[i:j] = t` (**切片赋值**): 最强大的操作。可以将列表的某一段 **替换** 为另一个列表的内容（扁平化插入）。

---

## 3. 字符串表示 (`__repr__` vs `__str__`)

| 方法 | 目的 | 触发场景 | 例子 |
| --- | --- | --- | --- |
| `__str__` | **用户友好** | `print(s)`, `str(s)` | `Hello World` |
| `__repr__` | **开发者调试** (准确) | 交互式命令行直接输入变量, `repr(s)` | `'Hello World'` |

* **套娃现象**：交互式命令行显示字符串时，会调用 `repr()`，导致看到两层引号（如 `"'Hello'"`），表示“这是一个包含内容的字符串对象”。

---

## 4. 递归与装饰器 (Recursion & Decorators)

### 4.1 装饰器原理

装饰器本质是 **偷梁换柱**。它修改了函数名指向的对象。

```python
@count
def fib(n): ...

# 等价于
fib = count(fib)

```

### 4.2 递归函数的计数

为什么装饰器能统计递归调用的次数？

1. `fib` 这个名字被重新指向了 `counted` (包装函数)。
2. 原始函数内部写的是 `return fib(n-1) + ...`。
3. **名字查找 (Name Lookup)**：原始函数执行时，去全局作用域找 `fib`，找到的是 **包装后的函数**。
4. 结果：每一次递归调用都会重新经过计数器。

---

## 5. 链表与深拷贝 (Linked Lists & Deep Copy)

### 5.1 浅拷贝 (Shallow Copy)

* `list[:]` 或 `copy.copy()`。
* 只复制外壳。如果是嵌套对象（如链表 `Link(1, Link(2))`），**尾部节点会被共享**。修改副本的尾部会影响原件。

### 5.2 深拷贝 (Deep Copy)

* `copy.deepcopy()` 或手写递归。
* 递归地复制所有层级，创造完全独立的内存空间。

**手写链表深拷贝模板**：

```python
def deep_copy_link(lnk):
    if lnk is Link.empty:
        return Link.empty
    # 递归复制头和尾
    return Link(deep_copy_link(lnk.first) if isinstance(lnk.first, Link) else lnk.first,
                deep_copy_link(lnk.rest))

```

---

## 6. Ants 项目特有逻辑备忘

* **FireAnt**:
* **反伤 (Reflect)**: 受到多少伤害 `amount`，反弹多少（**不翻倍**）。
* **自爆**: 只有死的时候触发，伤害量等于 `self.damage`（**受 Double 增益影响**）。


* **ContainerAnt**:
* 移除时逻辑复杂：先让肚子里的蚂蚁占位 (`place.ant = inner`)，再把自己移除。
* **Hasattr 检查**: 使用 `hasattr(self.ant_contained, 'damage')` 安全地检查内部蚂蚁属性，防止 `NoneType` 报错。