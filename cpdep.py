#!/usr/bin/env python

# How to use ?
# cpdep /path/to/chromium/src /path/to/platform/dep [--platform=[win,mac]]

import sys
import os.path
import shutil

def handle_args(argv):
    if len(argv) != 3 and len(argv) != 4:
        print "Usage: cpdep.py <chromium source path> <destination of dependency> [--platform=[win,mac]]"
        sys.exit(1)
    src = os.path.abspath(argv[1])
    dst = os.path.abspath(argv[2])
    os_spec = ""
    if len(argv) == 4 and argv[3].split("=")[0] == "--platform":
        os_spec = argv[3].split("=")[1]
    return (src, dst, os_spec)

def get_deps(fromsrc, todst, os_spec):
    deps_file = os.path.join(fromsrc,"DEPS")
    if not os.path.isfile(deps_file):
        sys.stderr.write("%s not exist \n" % deps_file)
        sys.exit(1)
    chromium_deps = []
    mute_error_code = """
def Var(str):
    return ''
    """
    with open(deps_file, mode='rU') as f:
        data = mute_error_code + f.read()
    exec(data)
    chromium_deps = [key for key in deps]
    if os_spec=="win" or os.name == "nt":
        chromium_deps += [key for key in deps_os["win"]]
    elif os_spec=="mac" or (os.name == "posix" and os.uname()[0] == "Darwin"):
        chromium_deps += [key for key in deps_os["mac"]]
    else:
        sys.stderr.write("sorry, we only support Mac and Windows")
        sys.exit(1)
    return chromium_deps

def copy_deps(deps, dsts):
    for num in range(0, len(deps)):
        if os.path.exists(dsts[num]):
            print "%s exists, will remove it" % dsts[num]
            shutil.rmtree(dsts[num])
        try:
            shutil.copytree(deps[num],dsts[num], True) #symlinks=True to copy symlink instead of its content
        except shutil.Error, err_infos:
            print err_infos
            yn = ""
            while True:
                yn = raw_input("Do you want to continue? [y/n]")
                if yn == "y" or yn == "n":
                    break
                else:
                    continue
            if yn == "y":
                continue;
            else:
                raise

def main():
    src,dst,os_spec = handle_args(sys.argv)
    gclient_root = os.path.abspath(src+"/..")
    dependencies = map(lambda x:os.path.normpath(gclient_root+"/"+x) , get_deps(src, dst, os_spec))
    destinations = map(lambda x:os.path.normpath(dst+"/"+x), get_deps(src, dst, os_spec))
    copy_deps(dependencies, destinations)

if __name__ == '__main__':
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.stderr.write("interrupted\n")
        sys.exit(1)
