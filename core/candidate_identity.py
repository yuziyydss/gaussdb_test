"""Concrete setup text identity, not SQL equivalence or runtime state proof."""


def setup_signature(statements):
    """Keep statement order and content; normalize only outer whitespace/semicolon.

    Candidate IDs, profile names, expected outcomes and teardown are deliberately
    excluded: changing those cannot turn a repeated input into a new experiment.
    """
    if not isinstance(statements,list) or not all(isinstance(s,str) for s in statements):
        raise ValueError('SQL provenance requires a concrete setup statement list')
    result=tuple(s.strip().removesuffix(';').strip() for s in statements)
    if any(not s for s in result):
        raise ValueError('Empty setup statements cannot create a distinct candidate')
    return result
