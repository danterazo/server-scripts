from dataclasses import dataclass
from datetime import date
from enum import Enum
from typing import ClassVar, Dict, Any, Type, TypeVar
from __future__ import annotations

from enums.regions import apartment, car, office


@dataclass
class Container:
    # primary key
    # NOTE: consider renaming, or make unique from Item IDs
    id: str

    # location
    # region: Region
    # room: Room
    # subloc: Sublocation

    # a good idea, but hard to implement in SQL
    contents: list[str]

    # metadata
    quantity: int
    serial: str

    # dates
    # NOTE: use datetime?
    purchased: date
    expires: date

    # descriptions
    intention: str
    notes: str


# WIP: create concrete example
# IDEA: use Jupyter instead?

# TODO: binary data ideas:
# purchase date, receipt printout, item iamage

# TODO: binary data storage ideas:
# relative paths, BLOB data & object store
