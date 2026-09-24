"""Actual system-column prerequisites, without claiming target errors executed."""
from pathlib import Path
import copy
import unittest
from unittest.mock import patch
from core.factor_package_model import FactorPackageRegistry
from core.factor_package_generator import FactorPackageSQLGenerator
from core.spec_generator import GenerationValidationError

ROOT=Path(__file__).resolve().parents[1]


class SequenceSystemColumnTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.r=FactorPackageRegistry(ROOT/'specs'); cls.r.load_all()
        cls.g=FactorPackageSQLGenerator(cls.r)

    def manifest(self,column):
        mid='manifest_create_sequence_system_'+column+'_a_negative'
        self.assertTrue(mid in self.r.manifests,mid)
        return self.r.manifests[mid]

    def unmarked(fid):
            values=copy.deepcopy(resolve(fid))
            values['owned_by_clause']['cs_owned_rowid_a_invalid'].attributes['owned_by_clause.properties.system_column']=False
            return values
