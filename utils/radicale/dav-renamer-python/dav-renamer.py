from pathlib import Path
# from unidecode import normalize
from os import rename, utime
from json import loads
from re import compile, IGNORECASE
from time import time, strptime, strftime, struct_time, mktime

# global config
verbose: bool = False


# global defaults
content_root: str = "/self-hosted/radicale/data/collections/collection-root"
uuid_pattern = compile(
    pattern=r'^[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}$',
    flags=IGNORECASE
)

# TODO: rename folders using props file values
# TODO: prints for progress reports if verbose flag is True


def rename_contacts(verbose: bool = False) -> None:
    # global contact config
    contact_data_path: str = f"{content_root}/dante/contacts"
    ext: str = "vcf"
    rename_map: dict[str, str] = {
        " ": "-",
        ":": "",
        ".": "",
        " & ": " ",
        "t-mobile": "tmobile",
        "to remove": "toremove",
        "í": "i",
        "ę": "e",
    }

    # get list of relevant files
    files_to_process: list[dict[str, str]] = get_file_list(ext=ext,
                                                           path=contact_data_path)

    # extend rename map
    # contact_map[uuid]

    # determine name sources (in order of preference)
    new_name_sources: list[str] = ["NICKNAME", "FN"]  # TODO: test w/ new source preference lists

    # rename files
    rename_files(ext=ext,
                 files_to_process=files_to_process,
                 rename_map=rename_map,
                 new_name_sources=new_name_sources)


def rename_caldav(verbose: bool = False) -> None:
    # global calDAV config
    data_root: str = f"{content_root}/dante"
    ext: str = "ics"
    rename_map: dict[str, str] = {
        " ": "_",
        # "@": "",
        " / ": " - ",
        ": ": "--",
        "VEVENT": "-cal",
        "VTODO": "-task",
    }

    # get list of relevant files
    files_to_process: list[dict[str, str]] = get_file_list(ext=ext,
                                                           path=data_root)

    # determine name sources (in order of preference)
    new_name_sources: list[str] = ["SUMMARY"]  # TODO: test w/ new source preference lists

    # rename files
    rename_files(ext=ext,
                 files_to_process=files_to_process,
                 rename_map=rename_map,
                 new_name_sources=new_name_sources)

# get files from content root, given path and extension


def get_file_list(ext: str, path: str = content_root) -> list[dict[str, str]]:
    matches: list[dict[str, str]] = []

    # get list of files with provided extension
    for file_obj in Path(path).rglob(pattern=f"*.{ext}"):
        # cast Path() to str
        filepath: str = str(file_obj)

        # build list of files to rename, and parse their contents to memory

        if not ".Radicale.cache" in filepath:
            with open(file=file_obj, mode="r", encoding="utf-8") as file:
                # split name from rest of file path
                filename: str = filepath.split("/")[-1]

                # TODO: remove
                # if the filename is a UUID (always of length 40), then retrieve contents
                if True:
                    # if uuid_pattern.match(filename):
                    # read files line-by-line into a dictionary
                    content_dict: dict[str, str] = {"ORIGINAL_FILEPATH": filepath,
                                                    "ORIGINAL_FILENAME": filename,
                                                    "FN": "",
                                                    "NICKNAME": ""}
                    for line in file:
                        # filter out non key/value pairs
                        try:
                            if ":" in line:
                                # parse key/value pair from line
                                k, v = line.strip().split(sep=":", maxsplit=1)

                                # assign key/value pair to dictionary
                                content_dict[k] = v
                        except:
                            # TODO: print failed reads and/or log somewhere
                            pass

                    # append complete dictionary to list of files to rename
                    matches.append(content_dict)

    return matches


def rename_files(ext: str,
                 files_to_process: list[dict[str, str]],
                 rename_map: dict[str, str],
                 new_name_sources: list[str]) -> None:
    for file_dict in files_to_process:
        # retrieve data from dict
        # old_name: str = file_dict["UID"]
        old_name: str = file_dict["ORIGINAL_FILENAME"].split(".vcf")[0]

        # retrieve base for new name from dict
        potential_names_list: list[str] = [file_dict[x] for x in new_name_sources]
        new_name: str = next(x for x in potential_names_list if x != "")

        # append filetype-specific information to replacement map/dict
        extended_map: dict[str, str] = rename_map.copy()
        # extended_map[old_name] = new_name

        # TODO: normalize names

        # replace file name string contents using map
        # new_name: str = new_name
        for initial, replacement in extended_map.items().__reversed__():
            new_name = new_name.replace(initial, replacement).lower()

        # generate full file path w/ replace
        old_path: str = file_dict["ORIGINAL_FILEPATH"]
        new_path: str = old_path.replace(old_name, new_name)

        # rename file (using full path)
        if old_path != new_path:
            print(f"Renaming: {old_name}.{ext}")
            print(f"Old Path: {old_path}")
            print(f"New Path: {new_path}")
            

        rename(src=old_path, dst=new_path)

        # assign "file modified" time using contact metadata
        if ext == "vcf":
            # REV
            pass
        elif ext == "ics":
            create_time: float = parse_time(file_dict["CREATED"])
            modified_time: float = parse_time(file_dict["LAST-MODIFIED"])

            # update file timestamps
            utime(path=new_path, times=(create_time, modified_time))

            # TODO: if one DESCRIPTION is "Reminder", append "Reminder" to file name
            # additionally for ICS files, prepend timestamp to file name
            
            append_time: str = strftime("%Y-%m-%d_%H-%M-%S_")
            # TODO: prepend start timestamp to name? or use create time?

            # TODO: append UID to avoid name collision!

            # WIP: handle recurring events which have multiple top-level values for keys
            # FUTURE: consider appending type (Task, Calendar) to file name as well

# get timestamp from file as unix timestamp
def parse_time(time_str: str, format: str = "%Y%m%dT%H%M%S%Z") -> float:
    parsed: struct_time = strptime(time_str, format)
    return mktime(parsed)

# TODO: parse props files into dicts
# def parse_props(path: str) -> dict[str, str]:
#     with file as open(path, mode="r", encoding="utf-8"):
#         # there should only be one dictionary
#         for line in file:
#             props: dict[str, str] = loads(line)

#         print(props)


# TODO: generate commit messages using event name and timestamp
#       don't forget to update the Radicale hook!
def commit_changes(verbose: bool = False) -> None:
    # IDEA: 2024-10-03_00-00-00.000000_Task--TakeTrashOut.ics
    pass


# main method
if __name__ == '__main__':
    rename_contacts(verbose)
    #rename_caldav(verbose)
    # commit_changes(verbose)
    print("Success! Restart Radicale server!")
