m = 179426549
b = 3
s = "abracadabra"

def h(s):
    return sum(ord(c) * b ** i for i, c in enumerate(s)) % m

# Array with hashes of prefixes: H[i]=h(s[0:i+1])
H = [ord(s[0]) % m]
exp = b
for i in range(1, len(s)): # O(n)
    H.append((H[i-1] + ((ord(s[i]) * exp) % m)) % m)
    exp = exp * b

# Rolling hash examples:
# h("abra") = a*b^0 + b*b^1 + r*b^2 + a*b^3 is stored in H[3]
# to get h("ra"): (h("abra") - h("ab")) / b^2 = rollLeft(2, 2) = (H[4] - H[1]) / b^2
# to get h("br"): (h("abr") - h("a")) / b^1 = rollLeft(1, 2) = (H[3] - H[1]) / b^1

def rollLeft(j, count): # Compute the hash of the string s[j:j+count] in O(1)
    assert count > 0 and j + count <= len(s)
    if j == 0:
        return H[count-1]
    return (H[j+count-1] - H[j - 1]) / b ** j

def equal(i, j, l):
    assert i < j and j + l - 1 < len(s) and l > 0
    hs1 = rollLeft(i, l) # hash of s[i:i+l]
    hs2 = rollLeft(j, l) # hash of s[j:j+l]
    return hs1 == hs2

def lceaux(i, j, intsize, maxlce): # O(logn)
    if (intsize <= 1):
        return 1 if equal(i, j, 1) else 0
    if equal(i, j, intsize):  # Check if there is a longer common extension
        if (intsize + intsize / 2 >= maxlce):
            return maxlce
        return lceaux(i, j, intsize + intsize / 2, maxlce)
    else: # Check if there is a shorter common extension
        return lceaux(i, j, intsize - intsize / 2, intsize)

def lce(i, j):
    maxlce = min(j - i, len(s) - j)
    if (equal(i, j, maxlce)):
        return maxlce
    return lceaux(i, j, maxlce, maxlce)

tests = [
    not equal(2, 3, 2),
    not equal(0, 3, 3),
    equal(0, 3, 1),
    equal(0, 7, 2),
    equal(0, 7, 3),
    equal(3, 7, 1),
    lce(1, 2) == 0,
    lce(0, 3) == 1,
    lce(0, 7) == 4,
    lce(3, 7) == 1,
    lce(4, 7) == 0,
    lce(1, 8) == 3
]

print('{0}/{1} tests passed'.format(tests.count(True), len(tests)))
