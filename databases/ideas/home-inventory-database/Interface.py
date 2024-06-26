from dataclasses import dataclass
from .Container import Container
from .Interface import Interface


# TODO: incorporate enums and dataclasses
# TODO: strong typing for functions and attributes
# TODO: package rename
# TODO: define SQL connection depending on library used
class Interface:
    def __init__(self) -> None:
        conn = self.establish_connection()

    def establish_connection(self):
        raise NotImplementedError

    def add_item(self):
        raise NotImplementedError

    def update_item(self):
        raise NotImplementedError
