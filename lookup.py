#!/usr/bin/env python
# -*- coding: utf-8 -*-

def tags_match(small_list, full_list):
    return set(small_list) < set(full_list)

def decompose_line(line):
    tags, desc, command = line.split(':', 2)
    tags, desc, command = tags.strip(), desc.strip(), command.strip() 
    tags = [i.strip() for i in tags.split(',')]
    return {'tags': tags, 'description': desc, 'command': command}

# ------------------

def test_decompose_line():
    assert decompose_line('a1, a2:  b   :   c:d:e') == {'tags': ['a1', 'a2'], 'description': 'b', 'command': 'c:d:e'}
