"""Real file options and bytes must not be replaced by log_fdw or labels."""
import unittest


class FileFDWOptionsTests(unittest.TestCase):
    def check(self, options, wrapper='file_fdw'):
        from core.file_fdw_options_contract import check_options
        return check_options(wrapper, options)

    def test_csv_and_text_have_different_allowed_option_sets(self):
        self.assertEqual(self.check("format 'csv', filename '/tmp/factor_assets/f.csv', header 'false', delimiter ',', quote '\"', escape '\"', null ''")['format'], 'csv')
        self.assertEqual(self.check("format 'text', filename '/tmp/factor_assets/f.tsv'")['format'], 'text')
        for options in ("format 'text', header 'false'", "format 'text', quote '\"'",
                        "format 'text', escape '\"'", "format 'binary', delimiter ','",
                        "format 'fixed', null ''", "format 'csv', delimiter ',', quote ','"):
            with self.subTest(options=options), self.assertRaises(ValueError):
                self.check(options+", filename '/tmp/factor_assets/f'")

    def test_duplicate_unknown_or_malformed_options_fail_closed(self):
        for options in ("format 'csv', FORMAT 'text'", "filename 'relative'", "format 'csv'",
                        "filename '/tmp/factor_assets/f', logtype 'gs_log'",
                        "filename '/tmp/factor_assets/f', password 'secret'",
                        "filename '/tmp/factor_assets/f',", "filename '/tmp/factor_assets/f'; SELECT 1",
                        "filename '/tmp/factor_assets/f', format 'csv', header 'maybe'"):
            with self.subTest(options=options), self.assertRaises(ValueError): self.check(options)

    def test_other_wrappers_and_unproved_binary_fixed_are_not_positive(self):
        for wrapper in ('log_fdw','postgres_fdw','unknown'):
            with self.subTest(wrapper=wrapper), self.assertRaises(ValueError):
                self.check("format 'csv', filename '/tmp/factor_assets/f'", wrapper)
        for fmt in ('binary','fixed'):
            with self.subTest(format=fmt), self.assertRaisesRegex(ValueError, 'unreviewed'):
                self.check(f"format '{fmt}', filename '/tmp/factor_assets/f'")


if __name__ == '__main__': unittest.main()
