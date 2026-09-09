import unittest

from scripts.build_pdf_book_ledger import classify, build_rows


def entry(number, title, path=None, route='general_sql_reference'):
    return {'section_number': number, 'title': title,
            'outline_path': path or ['1 SQL参考', number+' '+title],
            'variant': 'general', 'content_route': route,
            'start_destination': {'physical_page': 85},
            'end_destination': {'physical_page': 86}}


class BookLedgerTests(unittest.TestCase):
    def test_type_expression_and_cast_are_different(self):
        for number, expected in [('1.3.1', 'data_type'), ('1.7.1', 'expression'),
                                 ('1.9.4', 'type_conversion'), ('1.6.1', 'function_operator')]:
            self.assertEqual(classify(entry(number, '测试'))[0], expected)

    def test_prefix_does_not_confuse_1_3_and_1_30(self):
        self.assertEqual(classify(entry('1.30', '未知'))[0], 'reference_review')

    def test_compatibility_is_not_general(self):
        e = entry('2.6.1', '类型', ['2 SQL参考-M-Compatibility兼容模式', '2.6.1 类型'])
        self.assertEqual(classify(e)[0], 'data_type')
        rows = build_rows([e], {}, {}, {})
        self.assertEqual(rows[0]['variant'], 'm_compat')

    def test_parent_and_leaf_counts_are_not_coverage(self):
        parent = entry('1.3', '数据类型')
        child = entry('1.3.1', '数值', parent['outline_path']+['1.3.1 数值'])
        rows = build_rows([parent, child], {}, {}, {})
        self.assertEqual([r['node_kind'] for r in rows], ['container_with_possible_own_text', 'leaf'])
        self.assertTrue(all(r['semantic_extraction'] == 'not_audited' for r in rows))
        self.assertTrue(all(r['runtime_verified'] is None for r in rows))

    def test_duplicate_paths_and_missing_pilot_are_rejected(self):
        e = entry('1.3.1', '数值')
        with self.assertRaisesRegex(ValueError, 'duplicate'):
            build_rows([e, e], {}, {}, {})
        with self.assertRaisesRegex(ValueError, 'pilot sections'):
            build_rows([e], {}, {}, {'9.9': {}})

    def test_extraction_and_binding_do_not_promote_semantics(self):
        e = entry('1.3.1', '数值')
        key = tuple(e['outline_path'])
        rows = build_rows([e], {key: {'fresh': True, 'source_relpath': 'x'}},
                          {key: [{'factor_id': 'x'}]}, {})
        self.assertTrue(rows[0]['text_extracted_fresh'])
        self.assertEqual(rows[0]['semantic_extraction'], 'not_audited')
        self.assertIsNone(rows[0]['static_coverage'])


if __name__ == '__main__':
    unittest.main()
