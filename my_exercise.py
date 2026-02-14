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

def countdown(k,n):
    if k>0:
        yield k 
        for x in countdown(k-1,n+1):
            print(f"我到了countdown({k},{n})")
            yield x
        # yield countdown(k-1)
# 等价于

def countdown_from(k):
    if k>0:
        yield k 
        yield from countdown_from(k-1)

class Account:
    def __init__(self,account_holder):
        self.balance = 0 
        self.holder = account_holder 
    def deposit(self,amount):
        self.balance += amount 
        return self.balance 
    def withdraw(self,amount):
        if amount > self.balance:
            return 'Insufficient funds'
        self.balance = self.balance - amount
        return self.balance


# 继承  找属性先找当前类的 再找base class的
# 继承是 is a的意思，组合是has a的意思 
class CheckingAccount(Account):
    withdraw_fee = 1
    interest = 0.01
    def withdraw(self, amount):
        # 这里为了实现封装原则，尽量不要直接用base class的属性，而是调用其方法借口
        return Account.withdraw(self,amount+self.withdraw_fee) #这里要自己提供self，因为不是在实例中找，而是在类中找