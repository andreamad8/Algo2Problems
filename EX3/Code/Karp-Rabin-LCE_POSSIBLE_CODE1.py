'''
Karp-Rabin hashing on strings for efficient substring equality and subsequence finding:
    1. Create a data structure holding the hashes, with hashes of previous characters being held as a prefix:
        H[0]   = hash(str[0])
        H[1]   = H[0] * prime + hash(str[1])
        ...
        H[n-1] = H[n-2] * prime + hash(str[n-1])
    2. To compare equality of a substring of length l at indexes i, j, we need to know the sub-hash of the string:
        2.1 Sanity check: are String[i] and String[j] equal? If they are different we return false
        2.2 Take hashes of H[i] and H[i+l]
        2.3 Compute the hash from H[i] to H[i+l] (you can think of it as 'extracting' digits from a base p number where p is the prime)

            H[Substring_i] = H[i + l] - H[i] * p ^ (l - 1)

        2.4 Compute hash from H[j] to H[j+l] (same as 2.3)
        2.5 Compare H[Substring_i] == H[Substring_j]
    3. To compute the longest common extension, binary search from two indices i, j calling the previously defined equality function
'''

prime = 101
string = 'dabckabcdabcka'


def karp_hash(s, base):
    res = []
    old = 0

    for c in s:
        h = old * base + (ord(c) % base)
        old = h
        res.append(h)
    return res


def equals(i, j, l):
    if l <= 0:
        return True
    if j < i:
        return equals(j, i, l)
    if j + l - 1 >= len(str_hashes):
        return False
    if string[i] != string[j]:
        return False

    hi = str_hashes[i + (l - 1)] - str_hashes[i] * int(prime ** (l - 1))
    hj = str_hashes[j + (l - 1)] - str_hashes[j] * int(prime ** (l - 1))

    return hi == hj


def lce(i, j):
    low = 1
    high = len(string) - j + 1
    while low != high:
        mid = (high + low) / 2
        if equals(i, j, mid):
            low = mid + 1
        else:
            high = mid - 1
    return low if equals(i, j, low) else low - 1


str_hashes = karp_hash(string, prime)
print str_hashes
print equals(1, 5, 3)
print equals(0, 8, 6)
print equals(0, 9, 6)
print equals(2, 5, 2)
print equals(2, 10, 5)
print lce(0, 8)
print lce(1, 5)
