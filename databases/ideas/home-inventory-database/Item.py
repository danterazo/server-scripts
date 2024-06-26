from dataclasses import dataclass, field
from datetime import date
from enum import Enum
from typing import ClassVar, Dict, Any, Type, TypeVar
from __future__ import annotations

from enums.Location import Location


@dataclass
class Item:
    # IDEA: enforce format with assert() or regex?
    # primary key
    id: str

    # metadata
    location: Location

    # metadata
    quantity: int
    serial: str

    # dates
    purchased: date
    expires: date

    # descriptive attributes
    intention: str
    notes: str

    # derived attribute
    location_str: str = field(init=False)

    def __post_init__(self) -> None:
        pass
