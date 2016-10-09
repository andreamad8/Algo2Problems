# About using the 2 functions:-
# For update, pass index of location to be updated, input array, BIT, value to be added to original number
# i.e. new value - original value
# For getting sum of elements in range l to r,
# Getsum returns sum of elements from beginning to index
# Pass index, input array & BIT to function
# getsum of l to r = getsum of r - getsum of (l-1)

def update(index, a, tree, value):
# index is index to be updated, a is input array / list, tree is BIT array, value is value to be added to original
# number at index location
    n = len(a)
    while index<n:
        tree[index] += value
        index = index + (index & (-index))

def getsum(index, a, tree):
# index is location upto which you want the sum of elements from beginning
# tree is BIT[], a is input array / list
    n = len(a)
    ans  = 0
    while(index>0):
        ans += tree[index]
        index = index - (index & (-index))
    return ans


inputArray = [2,3,5,6,7,10,8]
inputArray.insert(0,0)
#Initialise Binary Indexed Tree to 0's considering that input array is all 0's
BIT = []
for i in range(0, len(inputArray)):
    BIT.append(0)

# Now we will construct actual BIT
# The 4th parameter is always an additional value which is to be added to element at index location
# since we have considered input array as 0 earlier (while initialising BIT), for updating, we will pass actual
# value
for i in range(1, len(inputArray)):
    update(i, inputArray, BIT, inputArray[i])
print "input array:"+str(inputArray)
print "tree       :"+str(BIT)

s=3
f=5
print "from index:%d"%s
print "to index  :%d"%f

su=getsum(f,inputArray,BIT) - getsum(s-1,inputArray,BIT)
print "sum:"+str(su)
