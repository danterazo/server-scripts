from dataclasses import dataclass, field
from enum import Enum
from typing import Optional, List
from __future__ import annotations


@dataclass
class ColorCode:
    # provided attributes
    color: str
    categories: List[str] = field(default_factory=list)

    # derived attributes
    categories_str: str = field(init=False)

    def __post_init__(self) -> None:
        # derive category string for use in SQL tables
        self.categories_str: str = "/".join(self.categories)


class Colors(Enum):
    # unique
    YELLOW: ColorCode = ColorCode(color="YELLOW",
                                  categories=["Books"])
    PINK: ColorCode = ColorCode(color="PINK",
                                categories=["Hobbies"])
    PURPLE: ColorCode = ColorCode(color="PURPLE",
                                  categories=["Home"])
    RED: ColorCode = ColorCode(color="RED",
                               categories=["Car"])

    # blues
    TEAL: ColorCode = ColorCode(color="TEAL",
                                categories=["Tech"])
    NAVY: ColorCode = ColorCode(color="NAVY",
                                categories=["Books"])
    BLUE: ColorCode = ColorCode(color="BLUE",
                                categories=["Clothing", "Wearables", "Fashion"]

    # oranges
    ORANGE: ColorCode=ColorCode(color="ORANGE",
                                  categories=["Office"])
    DARK_ORANGE: ColorCode=ColorCode(color="DARK_ORANGE",
                                       categories=["Backpack", "Keys", "Travel"])
