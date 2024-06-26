from dataclasses import dataclass


@dataclass
class Location:
    region
    location
    sublocation

    def __post_init__(self) -> None:
        pass
