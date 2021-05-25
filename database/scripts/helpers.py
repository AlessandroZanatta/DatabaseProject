#!/usr/bin/env python

class InsertQuery:
    def __init__(self, table, *argv):
        self.table = table
        self.inner_dict = {c:[] for c in argv}

    def append(self, *argv):
        assert len(argv) == len(list(self.inner_dict.keys()))
        for i, name in enumerate(self.inner_dict.keys()):
            self.inner_dict[name].append(str(argv[i]))

    def get_col(self, col: str):
        return self.inner_dict[col]

    def get(self, col: str, idx: int):
        return self.inner_dict[col][idx]

    def get_zipped(self, *argv):
        cols = [self.get_col(col) for col in argv]
        return [x for x in zip(*cols)]
    
    def __str__(self):
        # sanity check
        assert len(self.inner_dict[list(self.inner_dict.keys())[0]]) > 0
        query = f'INSERT INTO {self.table}('
        
        # Columns
        for i, column in enumerate(self.inner_dict.keys()):
            query += column + ', '
        
        # Values
        query = query[:-2] + ') VALUES\n' # replace last ', ' with ')'
        for row in zip(*self.inner_dict.values()):
            if len(row) == 1:
                query += f"('{row[0]}'),\n"
            else:
                query += f'{row},\n'
        query = query[:-2] + ';\n\n' # replace last ',\n' with ';' and add newlines
        return query.replace('"', "'")
