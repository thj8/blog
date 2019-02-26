
## 动态地创建类

因为类也是对象，你可以在运行时动态的创建它们，就像其他任何对象一样。首先，你可以在函数中创建类，使用class关键字即可。

```python
>>> def choose_class(name):
…       if name == 'foo':
…           class Foo(object):
…               pass
…           return Foo     # 返回的是类，不是类的实例
…       else:
…           class Bar(object):
…               pass
…           return Bar
…
>>> MyClass = choose_class('foo')
>>> print MyClass              # 函数返回的是类，不是类的实例
<class '__main__'.Foo>
>>> print MyClass()            # 你可以通过这个类创建类实例，也就是对象
<__main__.Foo object at 0x89c6d4c>
```

但这还不够动态，因为你仍然需要自己编写整个类的代码。由于类也是对象，所以它们必须是通过什么东西来生成的才对。当你使用class关键字时，Python解释器自动创建这个对象。但就和Python中的大多数事情一样，Python仍然提供给你手动处理的方法。还记得内建函数type吗？这个古老但强大的函数能够让你知道一个对象的类型是什么，就像这样：

```python
>>> print type(1)
<type 'int'>
>>> print type("1")
<type 'str'>
>>> print type(ObjectCreator)
<type 'type'>
>>> print type(ObjectCreator())
<class '__main__.ObjectCreator'>
```

这里，type有一种完全不同的能力，它也能动态的创建类。type可以接受一个类的描述作为参数，然后返回一个类。（我知道，根据传入参数的不同，同一个函数拥有两种完全不同的用法是一件很傻的事情，但这在Python中是为了保持向后兼容性）

type可以像这样工作：

```python
type(类名, 父类的元组（针对继承的情况，可以为空），包含属性的字典（名称和值）)
```

比如下面的代码：

```python
>>> class MyShinyClass(object):
…       pass
```

可以手动像这样创建：

```python
>>> MyShinyClass = type('MyShinyClass', (), {})  # 返回一个类对象
>>> print MyShinyClass
<class '__main__.MyShinyClass'>
>>> print MyShinyClass()  #  创建一个该类的实例
<__main__.MyShinyClass object at 0x8997cec>
```

## 自定义元类
元类的主要目的就是为了当创建类时能够自动地改变类。通常，你会为API做这样的事情，你希望可以创建符合当前上下文的类。假想一个很傻的例子，你决定在你的模块里所有的类的属性都应该是大写形式。有好几种方法可以办到，但其中一种就是通过在模块级别设定__metaclass__。采用这种方法，这个模块中的所有类都会通过这个元类来创建，我们只需要告诉元类把所有的属性都改成大写形式就万事大吉了。

幸运的是，__metaclass__实际上可以被任意调用，它并不需要是一个正式的类（我知道，某些名字里带有‘class’的东西并不需要是一个class，画画图理解下，这很有帮助）。所以，我们这里就先以一个简单的函数作为例子开始。

```python
# coding=utf-8
def upper_attr(future_class_name, future_class_parents, future_class_attrr):
    print future_class_name
    attrs = ((name, value) for name, value in future_class_attrr.items() if not name.startswith('__'))

    uppercase_str = dict((name.upper(), value) for name, value in attrs)

    return type(future_class_name, future_class_parents, uppercase_str)

class Foo(object):
    __metaclass__ = upper_attr

    bar = "bip"

print hasattr(Foo, 'bar')
print hasattr(Foo, 'BAR')

f = Foo()
print f.BAR
```

## six
兼容python2和python3
```python
def with_metaclass(meta, *bases):
    """Create a base class with a metaclass."""
    # This requires a bit of explanation: the basic idea is to make a dummy
    # metaclass for one level of class instantiation that replaces itself with
    # the actual metaclass.
    class metaclass(meta):

        def __new__(cls, name, this_bases, d):
            return meta(name, bases, d)
    return type.__new__(metaclass, 'temporary_class', (), {})
```
