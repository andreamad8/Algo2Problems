'''h = 1; N = 2^1 - 1 = 1

        [0]

[0]

h = 2; N = 2^2 - 1 = 3

        [0]

    [1]     [2]

[0, 1, 2]

h = 4; N = 2^4 - 1 = 15

                        [0]

            [1]                         [2]

        [3]         [6]         [9]             [12]

    [4]     [5] [7]     [8] [10]    [11]    [13]    [14]

[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]


Even: i + 1, i + 2
Odd: 3 * i, 3 * i + 3


                                            [0]

                        [1]                                     [2]

                [3]             [6]                     [9]             [12]

            [4]     [5]     [7]     [8]             [10]    [11]    [13]    [14]

    [15]            [18]

[16]    [17]    [19]    [20]
'''
from math import log, ceil

B = 4
T = B - 1


def level(atom):
    corrected = atom + 1
    return int(ceil(log(T, B) + log(corrected, B) - 1))


def atoms_in_level(level):
    return int((B ** (level + 1) - 1) / T)


def index_at_level(index, level):
    level_offset = B ** level
    subroots_corrector = int((index - T) / (T * 1.0))
    return index - level_offset - subroots_corrector


def next_atom(i):
    i_atom = i / T
    atom_level = level(i_atom)
    atoms_in_this = atoms_in_level(atom_level)
    relative_index = index_at_level(i, atom_level)
    return atoms_in_this + 2 * relative_index


def left(i):
    if i % T == 0:
        return i + 1
    else:
        return T * next_atom(i)


def right(i):
    if i % T == 0:
        return i + 2
    else:
        return T * (next_atom(i) + 1)


print left(1) == 3
print left(2) == 9
print right(1) == 6
print right(2) == 12
print left(4) == 15
print right(4) == 18
print left(5) == 21
print right(5) == 24
