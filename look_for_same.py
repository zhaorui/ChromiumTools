#!/usr/bin/python
# This is a simple script to find out same file from current folder

import os
import hashlib

md5_filename_table = {}

for (dirpath, dirnames, filenames) in os.walk("."):
	for filename in filenames:
		filepath = dirpath + filename
		key = hashlib.md5(filepath).hexdigest()
		if key not in md5_filename_table:
			md5_filename_table[key] = [filepath]
		else:
			md5_filename_table[key].append(filepath)
			print "Hey, we found a same file"