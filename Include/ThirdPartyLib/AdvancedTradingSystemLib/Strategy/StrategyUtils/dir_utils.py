import sys, os
import pathlib


def go_to_current_dir(file):
    os.chdir(pathlib.Path(file).parent.resolve())


def go_to_prev_dir(times=1):
    for i in range(times):
        path_parent = os.path.dirname(os.getcwd())
        os.chdir(path_parent)


def go_to_root_dir():
    go_to_prev_dir(5)
