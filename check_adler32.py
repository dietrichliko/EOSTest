#!/usr/bin/env python3

import os
import pathlib
import zlib

from XRootD import client as xrd_client
from XRootD.client.flags import OpenFlags as xrd_OpenFlags

ROOT_PATH=pathlib.Path('/eos/vbc/experiments/cms/store/user/liko')

def main(root_path):

    for path in root_path.rglob('**/*.root'):
        print(path)
        chksum1 = int(os.getxattr(path,'eos.checksum'), 16)
        chksum2 = xrd_checksum(f"root://eos.grid.vbc.ac.at/{path}")
        print(chksum1, chksum2)

def xrd_checksum(url: str) -> int:
    """Calculate adler32 checksum of file reading its content with XRootD.

    Usage:
        checksum = xrd_checksum("root://eos.grid.vbc.at.at//eos/vbc/...")
    """
    checksum: int = 1
    with xrd_client.File() as f:
        status = f.open(url, xrd_OpenFlags.READ)
        if not status[0].ok:
            raise status[0].message
        checksum = 1
        for chunk in f.readchunks():
            checksum = zlib.adler32(chunk, checksum)

    return checksum

if __name__ == "__main__":

   main(ROOT_PATH)

