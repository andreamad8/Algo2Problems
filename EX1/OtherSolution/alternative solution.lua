--[[
  In this solution we employ an explicit tree structure, a variant of a segment tree.
  We will limit ourselves to arrays whose length is a power of two. A generalization could be
  made by splitting an arbitrarily sized array in runs as long as power of two's, then building 
  and managing a corresponding forest of trees: the asymptotic performance would not be affected.
  The trees could also be made implicit and all manipulations done on an array (heap-like), with due
  care; this would however make the algorithm even harder to understand than it already is, so let's not.
  
  We will represent an array of N elements as a complete binary tree with N leaves, for a total of
  2*N - 1 nodes. Each node will possess the following fiels:
    - psum: the partial sum of all indexed (descendant) array elements;
    - label: the algebric sum of all constants added in update operations that terminated at the node;
    - min: the index of the leftmost leaf descending from the node;
    - max: the index of the rightmost leaf descending from the node;
    - left: the left child of the node;
    - right: the right child of the node.
    (psum and label are the fundamentals, everything else is for conveniency)
  
  The general intuition is to split update intervals into sub-intervals whose length is a power of two.
  Each sub-interval corresponds to a node (leaves are singleton intervals).
  
  Suppose we run update(i, j, c). We start traversing the tree depth-first, reaching all nodes whose
  sub-intervals are interested by the update interval. On each branch we stop as high up as possible,
  i.e. at the biggest sub-interval we can, which means at the first node n such that [n.min, n.max] is
  wholly contained in [i, j].
  When we visit a node (passing through or stopping), we update its psum field by 
  
  psum = psum + c * #([i, j]n[n.min, n.max]).
  {psum increased by c times the cardinality of the intersection of [i,j] and [n.min,n.max].
  ASCII maths is a wild ride.}
  
  That is, we add c times the amount of leaves (array elements) below the node interested by the update
  operation, which is the change in the partial sum relative to n's sub-interval.
  If n is a node we stop at, we also update its label field by
  
  label = label + c.
  
  That is, we annotate the contribution to the value of each leaf (array element) given by each sub-interval.
  
  In fact, suppose we run sum(0, i). We start traversing the tree depth-first, again reaching all the nodes
  whose sub-intervals intersect with the sum interval.
  Whenever we reach a node whose sub-interval is wholly contained in the sum interval, we return its partial
  sum. When we just traverse a node, we increase our return value by the node's label times the ardinality of
  the intersection of the sum interval and the node's sub-interval, i.e. the amount of leaves below the node
  that are interested by the update operation).
  
  The query on the value of a single element then becomes trivial: navigate to the corresponding node, summing
  the labels of all nodes along the path.
]]--

intersection = function(s1, e1, s2, e2) 
--[[
  Helper function: computes the cardinality of the intersection of the two intervals
  [s1, e1]n[s2, e2] over integer numbers.
  REQUIRES: s1 <= e1, s2 <= e2 
--]]
  return math.max((math.min(e1, e2) - math.max(s1, s2)) + 1, 0)
end

update = function(n, i, j, c)
  local int = intersection(i, j, n.min, n.max)
  n.psum = n.psum + c * int
  if (int == n.max - n.min + 1) then
    -- the update interval covers our whole subtree
    n.label = n.label + c
    return
  end
  for _,d in pairs({ n.left, n.right }) do -- for each child
    if (intersection(i, j, d.min, d.max) > 0) then 
      -- the update interval involves the child, so we go there
      update(d, i, j, c)
    end
  end
end

sum = function(n, i, j)
  local int, tmp
  int = intersection(i, j, n.min, n.max)
  if (int == n.max - n.min + 1) then
    -- the sum interval covers our whole subtree
    return n.psum
  end
  tmp = 0
  for _,d in pairs({ n.left, n.right }) do
    int = intersection(i, j, d.min, d.max)
    if (int > 0) then
      -- the sum interval involves the child, so we go there
      tmp = tmp + (n.label * int) + sum(d, i, j)
    end
  end
  return tmp
end

query = function(n, i)
  local cur = n
  local tmp = 0
  while (cur ~= nil) do
    tmp = tmp + cur.label
    if (i <= (cur.max + cur.min)/2) then
      cur = cur.left
    else 
      cur = cur.right
    end
  end
  return tmp
  --[[
  Alternatively, with same asymptotic performance
  if i == 0 then
    return sum(n, 0, 0)
  else
    return sum(n, 0, i) - sum(n, 0, i-1)
  end
  --]]
end

make_tree = function(size)
  local make_node
  make_node = function(offset, size)
    local node = {}
    node.psum = 0
    node.label = 0
    node.min = offset
    node.max = offset + size - 1
    if size ~= 1 then
      node.left = make_node(offset, size/2)
      node.right = make_node(offset + size/2, size/2)
    end
    return node
  end
  
  return make_node(0, size)
end


--[[
++++ DEMO ++++
We'll run the same update, sum and query operations on an array of integers and the corresponding tree.
We'll see that they match for large, randomized sequences of operations (which is not a proof but
still reassuring).
--]]
print_tree = function(tree)
-- Prints an in-order traversal
  local helper
  helper = function(tree)
    if tree ~= nil then
      helper(tree.left)
      io.write("("..tree.psum..","..tree.label..")")
      helper(tree.right)
    end
  end
  helper(tree)
  io.write("\n")
end

make_array = function(size)
  local a = {}
  for i = 0, size-1 do
    a[i] = 0
  end
  return a
end

update_array = function(a, i, j, c)
  for t = i, j do
    a[t] = a[t] + c;
  end
end

sum_array = function(a, i, j)
  local retval = 0
  for t = i, j do
    retval = retval + a[t]
  end
  return retval
end

-- The actual demo
do
  local tree, array, x1, x2, c, t, s1, s2, size
  size = 256 -- choose whatever, so long as a power of 2
  tree = make_tree(size)
  array = make_array(size)
  math.randomseed(os.time())
  for i = 1, 1000 do
    x1 = math.random(0, size-1)
    x2 = math.random(x1, size-1)
    c = math.random(-100, 100)
    update(tree, x1, x2, c)
    update_array(array, x1, x2, c)
    x1 = math.random(0, size-1)
    x2 = math.random(x1, size-1)
    s1 = sum(tree, x1, x2)
    s2 = sum_array(array, x1, x2)
    print("Sum("..x1..","..x2.."): tree: "..s1..", array: "..s2)
    assert(s1 == s2)
    s1 = query(tree, x1)
    print("Query("..x1.."): tree: "..s1..", array: "..array[x1])
    assert(s1 == array[x1])
  end
end