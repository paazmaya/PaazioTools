#!/usr/bin/env python

"""
    Quicktime/MP4 Fast Start
    ------------------------
    Enable streaming and pseudo-streaming of Quicktime and MP4 files by
    moving metadata and offset information to the front of the file.
    
    This program is based on qt-faststart.c from the ffmpeg project, which is
    released into the public domain, as well as ISO 14496-12:2005 (the official
    spec for MP4), which can be obtained from the ISO or found online.
    
    The goals of this project are to run anywhere without compilation (in
    particular, many Windows and Mac OS X users have trouble getting
    qt-faststart.c compiled), to run about as fast as the C version, to be more
    user friendly, and to use less actual lines of code doing so.
    
    Features
    --------
    
        * Works everywhere Python can be installed
        * Handles both 32-bit (stco) and 64-bit (co64) atoms
        * Handles any file where the mdat atom is before the moov atom
        * Preserves the order of other atoms
        * Can replace the original file (if given no output file)
    
    Usage
    -----
    See `qt-faststart.py --help` for more info! If outfile is not present then
    the infile is overwritten.
    
        $ qt-faststart.py infile [outfile]
    
    License
    -------
    Copyright (C) 2008  Daniel G. Taylor <dan@programmer-art.org>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import os
import shutil
import struct
import sys
import tempfile

from optparse import OptionParser
from StringIO import StringIO

VERSION = "1.0"
CHUNK_SIZE = 8192

def read_atom(datastream):
    """
        Read an atom and return a tuple of (size, type) where size is the size
        in bytes (including the 8 bytes already read) and type is a "fourcc"
        like "ftyp" or "moov".
    """
    values = struct.unpack(">L4c", datastream.read(8))
    return values[0], "".join(values[1:])

def get_index(datastream):
    """
        Return an index of top level atoms, their absolute byte-position in the
        file and their size in a dict:
        
        index = {
            "ftyp": [0, 24],
            "moov": [25, 2658],
            "free": [2683, 8],
            ...
        }
        
        The keys are not guaranteed to be in order, but can be put in order
        with a simple sort, e.g.
        
            >>> keys = index.keys()
            >>> keys.sort(lambda x, y: cmp(index[x][0], index[y][0]))
    """
    index = {}
    
    # Read atoms until we catch an error
    while(datastream):
        try:
            atom_size, atom_type = read_atom(datastream)
        except:
            break
        index[atom_type] = [datastream.tell() - 8, atom_size]
        datastream.seek(atom_size - 8, os.SEEK_CUR)
    
    # Make sure the atoms we need exist
    for key in ["ftyp", "moov", "mdat"]:
        if not index.has_key(key):
            print "%s atom not found, is this a valid MOV/MP4 file?" % key
            raise SystemExit(1)
    
    return index

def find_atoms(size, datastream):
    """
        This function is a generator that will yield either "stco" or "co64"
        when either atom is found. datastream can be assumed to be 8 bytes
        into the stco or co64 atom when the value is yielded.
        
        It is assumed that datastream will be at the end of the atom after
        the value has been yielded and processed.
        
        size is the number of bytes to the end of the atom in the datastream.
    """
    stop = datastream.tell() + size
    
    while datastream.tell() < stop:
        atom_size, atom_type = read_atom(datastream)
        if atom_type in ["trak", "mdia", "minf", "stbl"]:
            # Known ancestor atom of stco or co64, search within it!
            for atype in find_atoms(atom_size - 8, datastream):
                yield atype
        elif atom_type in ["stco", "co64"]:
            yield atom_type
        else:
            # Ignore this atom, seek to the end of it.
            datastream.seek(atom_size - 8, os.SEEK_CUR)

def fast_start(infilename, outfilename):
    """
        Convert a Quicktime/MP4 file for streaming by moving the metadata to
        the front of the file. This method writes a new file.
    """
    datastream = open(infilename, "rb")
    
    # Get the top level atom index
    index = get_index(datastream)
    
    # Make sure moov occurs AFTER mdat, otherwise no need to run!
    if index["moov"][0] < index["mdat"][0]:
        print "This file is already setup for streaming!"
        raise SystemExit(1)

    # Read and fix moov
    datastream.seek(index["moov"][0])
    moov_size = index["moov"][1]
    moov = StringIO(datastream.read(moov_size))

    moov.seek(8)
    for atom_type in find_atoms(moov_size - 8, moov):
        # Read either 32-bit or 64-bit offsets
        ctype, csize = atom_type == "stco" and ("L", 4) or ("Q", 8)
        
        # Get number of entries
        version, entry_count = struct.unpack(">2L", moov.read(8))
        
        print "Patching %s with %d entries" % (atom_type, entry_count)
        
        # Read entries
        entries = struct.unpack(">" + ctype * entry_count,
                                moov.read(csize * entry_count))
        
        # Patch and write entries
        moov.seek(-csize * entry_count, os.SEEK_CUR)
        moov.write(struct.pack(">" + ctype * entry_count,
                               *[entry + moov_size for entry in entries]))

    print "Writing output..."
    outfile = open(outfilename, "wb")
    
    # Write ftype
    datastream.seek(index["ftyp"][0])
    outfile.write(datastream.read(index["ftyp"][1]))
    
    # Write moov
    moov.seek(0)
    outfile.write(moov.read())
    
    # Write the rest
    atoms = [atom for atom in index.keys() if atom not in ["ftyp", "moov"]]
    atoms.sort(lambda x, y: cmp(index[x][0], index[y][0]))
    for atom in atoms:
        start, size = index[atom]
        datastream.seek(start)
        
        # Write in chunks to not use too much memory
        for x in range(size / CHUNK_SIZE):
            outfile.write(datastream.read(CHUNK_SIZE))
            
        if size % CHUNK_SIZE:
            outfile.write(datastream.read(size % CHUNK_SIZE))

if __name__ == "__main__":
    parser = OptionParser(usage="%prog [options] infile [outfile]",
                          version="%prog " + VERSION)
    
    parser.add_option("-l", "--list", dest="list", default=False,
                      action="store_true",
                      help="List top level atoms")
    
    options, args = parser.parse_args()
    
    if len(args) < 1:
        print "Must supply an input file!"
        raise SystemExit(1)
    
    if options.list:
        index = get_index(open(args[0], "rb"))
        keys = index.keys()
        keys.sort(lambda x, y: cmp(index[x][0], index[y][0]))
        
        for atom in keys:
            print atom, "(" + str(index[atom][1]) + " bytes)"
            
        raise SystemExit
    
    if len(args) == 1:
        # Replace the original file!
        tmp, outfile = tempfile.mkstemp()
        os.close(tmp)
    else:
        outfile = args[1]
    
    fast_start(args[0], outfile)
    
    if len(args) == 1:
        # Move temp file to replace original
        shutil.move(outfile, args[0])

