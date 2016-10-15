def update(ft, p, v):
  while p < N:
    ft[p] += v 	 
    p += p&(-p)


# Add v to A[a...b] 
def updater(a, b, v): 	
  update(B1, a, v) 	
  update(B1, b + 1, -v) 	
  update(B2, a, v * (a-1)) 	
  update(B2, b + 1, -v * b) 	 

def query(ft, b): 	
  su = 0 	
  while b>0:
    su += ft[b]
    b -= b&(-b)
  return su

# Return sum A[1...b]
def querys(b):
  return query(B1, b) * b - query(B2, b)

# Return sum A[a...b]
def queryr(a, b):
  return querys(b) - querys(a-1)

B1 = []
B2 = []
N=7
for i in range(N):
  B1.append(0)
  B2.append(0)


updater(1,1,5)
print B1
print B2
print querys(1)

updater(1,1,-2)
print B1
print B2
print querys(6)

