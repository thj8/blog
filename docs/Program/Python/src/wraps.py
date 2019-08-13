#!/usr/bin/env python
# coding=utf-8
from functools import wraps


def ttt(func):
    @wraps(func)
    def _wrpper(*args, **kw):
        "wrapper......"
        return func()
    return _wrpper


@ttt
def thj():
    "test thj function"
    print("THJ")
    return 2


print(thj)
print(thj.__doc__)
print(thj())
