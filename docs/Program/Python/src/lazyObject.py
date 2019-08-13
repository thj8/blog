# coding=utf-8

empty = object()


def new_method_proxy(func):
    def inner(self, *args):
        if self._wrapped is empty:
            self._setup()
        return func(self._wrapped, *args)
    return inner


class LazyObject(object):
    """
    A wrapper for another class that can be used to delay instantiation of the
    wrapped class.

    By subclassing, you have to the opportunity to intercept and alter the
    instantiation. If you don't need to do that, use SimpleLazyObject.
    """
    _wrapped = None

    def __init__(self):
        self._wrapped = empty

    def __setattr__(self, name, value):
        if name == "_wrapped":
            # Assign to __dict__ to avoid infinite __setattr__ loops.
            self.__dict__["_wrapped"] = value
        else:
            if self._wrapped is empty:
                self._setup()
            setattr(self._wrapped, name, value)

    __getattr__ = new_method_proxy(getattr)

    def _setup(self):
        """
        Must be implemented bt subclassed to initialize the wrapped object.
        """
        raise NotImplementedError('subclass of LazyObject must provide a _setup() method')


class SimpleLazyObject(LazyObject):
    def __init__(self, func):
        self.__dict__['_setupfunc'] = func
        super(SimpleLazyObject, self).__init__()

    def _setup(self):
        print("_setup in SimpleLazyObject")
        self._wrapped = self._setupfunc()


class TestObj(object):
    tmp = "Test attr"

    def __init__(self):
        print("__init__ in ")


print("before SimpleLazyObject")
a = SimpleLazyObject(lambda: TestObj())
print("after SimpleLazyObject")
print a
print("before print a.tmp")
print a.tmp
a.thj = "thj"
print(a.thj)
