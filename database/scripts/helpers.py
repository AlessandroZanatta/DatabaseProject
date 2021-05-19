#!/usr/bin/env python

def format_as_sql(values):
    formatted_sql = [f'({c}),' for c in values]
    return '\n'.join(formatted_sql)[:-1]