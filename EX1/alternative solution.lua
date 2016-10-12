--[[
  In this solution we employ an explicit tree structure.
  We will limit ourselves to arrays whose length is a power of two. A generalization could be
  made by splitting an arbitrarily sized array in runs as long as power of two's, then building 
  and managing a corresponding forest of trees: the asymptotic performance would not be affected.
  The trees could also be made implicit and all manipulations done on an array, with due care; this
  would however make the algorithm even harder to understand than it already is, so fuck that.
  
  We will represent an array of N elements as a complete binary tree with N leaves, for a total of
  2*N - 1 nodes. Each node will possess the following fiels:
    - psum: something that resembles a partial sum of all descendants, but is not quite so (it's tricky);
    - label: the algebric sum of all constants added in update operations that terminated at the node;
    - min: the index of the leftmost leaf descending from the node;
    - max: the index of the rightmost leaf descending from the node;
    - left: the left child of the node;
    - right: the right child of the node.
    (psum and label are the foundations, the rest is for conveniency)
  
  The general intuition is to split update intervals into sub-intervals whose length is a power of two.
  Each sub-interval corresponds to a node. Whenever we do an update operation, we stop as high up in
  the tree as possible, i.e. at the biggest sub-intervals we can. When we stop, we annotate the node
  by updating its label field with the algebric sum of the update constant and the current label. When
  we visit a node (passing through or stopping), we likewise update its psum field with the algebric sum
  of the update constant and the current psum.
  
  When computing sum()... [TODO, just look at the code for now]
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
  n.psum = n.psum + c * intersection(i, j, n.min, n.max)
  if (n.min == n.max) then return end -- leaf node
  if (n.min == i and n.max == j) then -- the update interval fits perfectly below
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

sum = function(n, i)
--[[
  To compute this over an [x1, x2] interval you'd call
  sum(n, x2) - sum(n, x1). I'm not bothering.
--]]
  if (i >= n.max) then return n.psum end
  local int, tmp
  tmp = 0
  for _,d in pairs({ n.left, n.right }) do
    int = intersection(0, i, d.min, d.max)
    if (int > 0) then
      tmp = tmp + (n.label * int) + sum(d, i)
    end
  end
  return tmp
end

query = function(n, i)
  local cur = n
  local tmp = 0
  while (cur.min ~= i or cur.max ~= i) do
    tmp = tmp + cur.label
    if (i <= (cur.max + cur.min)/2) then
      cur = cur.left
    else 
      cur = cur.right
    end
  end
  return tmp + cur.psum
  --[[
  Alternatively, with same asymptotic performance
  if i == 0 then
    return sum(n, 0)
  else
    return sum(n, i) - sum(n, i-1)
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
We'll run the same update and sum operations on an array of integers and the corresponding tree.
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

sum_array = function(a, i)
  local retval = 0
  for t = 0, i do
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
    t = math.random(0, size-1)
    update(tree, x1, x2, c)
    update_array(array, x1, x2, c)
    s1 = sum(tree, t)
    s2 = sum_array(array, t)
    print("Sum("..t.."): tree: "..s1..", array: "..s2)
    assert(s1 == s2)
  end
end