""" MODULE DESC """

# Description: Rename files with date and time of file creation.
# Athor:       Markus Prepens
# Requires:    Python 3.5

__author__ = "Markus Prepens"


import os
import sys
import argparse

# Create an object of the commad line options reader.
parser = argparse.ArgumentParser(
    description='Rename all files in current directory.')
parser.add_argument('--verbose',
                    '-v',
                    help='print more verbose messages.',
                    action='store_true')

# Get the acual command line options.
args = parser.parse_args()

# Check the command line option --debug-target
if args.verbose is True:
    print("fdsfdsf {pwd}".format(pwd=os.path.dirname("..")))

# def create_dir(filepath):
#     """ ewrewr er erewr w"""
#     dir = os.path.dirname(filepath)
#     if not os.path.exists(dir):
#         os.makedirs(dir)
#     elif os.access(filepath, os.F_OK):  # check if file exists
#         if os.access(filepath, os.W_OK):  # check permission
#             os.remove(filepath)
#         else:
#             sys.exit(1)
