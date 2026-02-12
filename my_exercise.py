def even(start,end):
    even = start + (start % 2) #确保第一个数是基数字 
    while even < end:
        print("开始调用")
        yield even
        print("调用结束")
        even+=2 


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


# # >>> t = countdown(10)
# >>> next(t)
# 10
# >>> next(t)
# 我到了
# 9
# >>> next(t)
# 我到了
# 我到了
# 8
# >>> next(t)
# 我到了
# 我到了
# 我到了
# 7

def countdown(k):
    if k>0:
        yield k 
        for x in countdown(k-1):
            print("我到了")
            yield x
        # yield countdown(k-1)
# 等价于

def countdown_from(k):
    if k>0:
        yield k 
        yield from countdown_from(k-1)