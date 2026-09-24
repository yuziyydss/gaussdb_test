"""Bare aliases with explicit partition selection violate a documented rule."""
import json
from pathlib import Path
import unittest

from core.finite_sql_contract import inspect_write


class InsertPartitionAliasContradictionTests(unittest.TestCase):
    setup = ['CREATE TABLE p(id INT, note TEXT) PARTITION BY RANGE(id) '
             '(PARTITION low VALUES LESS THAN(5), PARTITION high VALUES LESS THAN(MAXVALUE));']

