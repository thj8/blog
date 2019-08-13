#!/usr/bin/env python
# coding=utf-8


class lazy(object):
    def __init__(self, func):
        self.func = func

    def __get__(self, instance, cls):
        val = self.func(instance)
        setattr(instance, self.func.__name__, val)
        return val


class Circle(object):
    def __init__(self, radius):
        self.radius = radius

    @lazy
    def area(self):
        print("area...")
        return 3.14 * self.radius ** 2


def lazy_property(func):
    attr_name = "_lazt_" + func.__name__
   
    @property
    def _property(instance):
        if not hasattr(instance, attr_name):
            setattr(instance, attr_name, func(instance))
        return getattr(instance, attr_name)

    return _property


class Circle2(object):
    def __init__(self, radius):
        self.radius = radius

    @lazy_property
    def area(self):
        print("area...2")
        return 3.14 * self.radius ** 2


c = Circle(4)
print c.radius
print c.area
print c.area
print c.area

c = Circle2(4)
print c.radius
print c.area
print c.area
print c.area
