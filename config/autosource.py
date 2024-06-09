#!/usr/bin/env python3
from dataclasses import InitVar, dataclass, field
from pyclbr import Class
from tkinter import N
from typing import ClassVar, Dict, Iterable, List, Optional, Sequence, Literal, Set, Union
import subprocess
from enum import Enum
import platform

# TODO: split structs, dataclasses, etc. into different files


@dataclass
class Arch:
    # input
    arch: str

    # defined after initialization
    machine_arch: str = field(init=False)
    bits: int = field(init=False)

    # TODO: find a better way to restrict values. Revisit Enums or Literals?
    # define allowed values
    allowed_arches: ClassVar[List[str]] = ["x64", "arm64"]

    def __post_init__(self) -> None:
        # assert name
        assert self.arch in self.allowed_arches

        # retrieve values
        self.machine_arch: str = platform.machine()
        self.bits: int = int(self.arch[-2:])


@dataclass
class System:
    # base metadata
    name: str
    shell: str
    os: str

    # attributes
    attributes: List[str]

    # only used in post_init()
    _arch: InitVar[str]

    # defined in post_init()
    arch: Arch = field(init=False)

    # class variable
    allowed_attributes: ClassVar[List[str]] = ["wsl", "virtual", "backup", "brew", "nvm", "pihole"]

    def __post_init__(self,
                      _arch: str):
        # restrict values
        assert [x in self.allowed_attributes for x in self.attributes]

        # infer values
        if not self.name:
            self.name: str = platform.node()

        # reassign types
        self.arch: Arch = Arch(_arch)

# TODO: test config


@dataclass
class Config:
    scope: str
    path: str = ""

    # TODO: refactor allowed values elsewhere
    # restrict values
    allowed_scopes: ClassVar[List[str]] = ["rc", "profile", "startup"]

    def __post_init__(self):
        # assert values
        assert self.scope in self.allowed_scopes

        # TODO: assert path exists
        # TODO: automatically generate path
        if not self.path:
            raise NotImplementedError

# TODO: implement
# TODO: link these names to "allowed values" variable.


class Policy():
    # TODO: add bash code to each policy
    wsl2 = None


# global variable
systems: Dict[str, Optional[System]] = {
    # wsl2
    "marigold": System(name="marigold",
                       shell="bash",
                       os="ubuntu",
                       _arch="x64",
                       attributes=["wsl", "brew"],
                       ),
    "ovedur": None,

    # servers
    "staralfur": None,
    "saeglopur":  None,
    "smaskifa":  None
}


class SystemConfigs(Enum):
    raise NotImplementedError


def load_config(sys: System,
                scope: str):
    raise NotImplementedError


""" testing """


# print(f"marigold.name (type {type(marigold.name)}: {marigold.name}")  # TEMP: remove
a: Arch = Arch("x64")
# TODO: pipx autocomplete for bash:  eval "$(register-python-argcomplete pipx)"
# TODO: proper shebang for this file
# TODO: resolve attributes in same order as provided. Or, sort in a default order
# TODO: write main. Accept args? Might be easier to just define in-line
# IDEA: just return paths of files to source. That way, environment variables will properly be set
