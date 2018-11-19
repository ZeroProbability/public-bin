#!/usr/bin/env python
# -*- coding: utf-8 -*-
import argparse
import tempfile
import re

def tags_match(small_list, full_list):
    return set(small_list) <= set(full_list)

def decompose_line(line):
    tags, desc, command = line.split(':', 2)
    tags, desc, command = tags.strip(), desc.strip(), command.strip() 
    tags = [i.strip().lower() for i in tags.split(',')]
    variables = [i[2:-1] for i in re.findall(r'\${.*?}', command)]
    return {'tags': tags, 'description': desc, 'command': command, 'variables': variables}

def extract_commands(records, lookup_tags):
    records = [r for r in records if not r.strip().startswith('#')]
    records = [r for r in records if not r.strip() == '']
    decomposed_records = [decompose_line(r) for r in records]
    print(decomposed_records)
    lookup_tags = [t.strip().lower() for t in lookup_tags]
    decomposed_records = [r for r in decomposed_records if tags_match(lookup_tags, r['tags'])]
    return records

def read_command_file(command_file):
    command_file = command_file or '/home/anbu/commands.txt'
    # TODO: read home variable from environment
    with open(command_file, 'r') as cf:
        lines = cf.readlines()

    return [f.strip() for f in lines]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--command_file', help='command file')
    parser.add_argument('tag', nargs="+")
    args = parser.parse_args()

    records = read_command_file(args.command_file)

    matching_recs = extract_commands(records, args.tag)

if __name__ == "__main__":
    main()

# ------------------

def test_decompose_line():
    assert decompose_line('a1, a2:  b   :   c:${d}:${e}') == \
        {'tags': ['a1', 'a2'], 'description': 'b', 'command': 'c:${d}:${e}', 'variables': ['d', 'e']}

def test_tags_match():
    assert tags_match(['a', 'b'], ['a', 'b', 'c'])
    assert not tags_match(['a', 'b', 'd'], ['a', 'b', 'c'])
    assert tags_match(['a'], ['a', 'b', 'c'])
    assert tags_match(['a'], ['a'])
    assert not tags_match(['d'], ['a', 'b', 'c'])

def test_extract_commands():
    records = ['a:some a: command a1', 'a, b: some a: command a2']
    extract_commands(records, ['a', 'b']) == [records[1]]

def test_read_command_file():
    with tempfile.NamedTemporaryFile() as fp:
        with open(fp.name, 'w') as tf:
            tf.write("hello 1\n")
            tf.write("hello 2\n")

        assert read_command_file(fp.name) == ['hello 1', 'hello 2']
