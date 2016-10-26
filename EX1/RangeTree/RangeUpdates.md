<style TYPE="text/css">
code.has-jax {font: inherit; font-size: 100%; background: inherit; border: inherit;}
img[src$="centerme"] {
  display:block;
  margin: 0 auto;
}
img[src$="tree"] {
  display:block;
  width: 400px;
  margin: 0 auto;
}
body {
  outline: 0px;
  box-shadow: 0 6px 8px 0 rgba(0, 0, 0, 0.5), 0 12px 32px 0 rgba(0, 0, 0, 0.25);
}
</style>
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
    tex2jax: {
        inlineMath: [['$','$'], ['\\(','\\)']],
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'] // removed 'code' entry
    }
});
MathJax.Hub.Queue(function() {
    var all = MathJax.Hub.getAllJax(), i;
    for(i = 0; i < all.length; i += 1) {
        all[i].SourceElement().parentNode.className += ' has-jax';
    }
});
</script>
<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

Range Updates
=============

Solution overview
-------------

Given the problem, in which we want to efficiently (log. time, linear space) work with values stored in an array contained within an arbitrary range akin to $[1...n]$ implementing:

+ Updating a portion of the range by adding a value c: Update(i, j, c).
+ Querrying the value on a given index: Query(i).
+ Obtaining the sum of all elements within a range: Sum(i, j).

A viable solution is to model the range as trees, with branches partitioning the overall ranges in smaller ones to efficiently operate on them. Leaves store discrete indices while their parents represent the index ranges contained under them. A tree for $n=8$, with indices $[0...7]$ is shown below:

![Tree for N=8](tree.png?style=tree "Tree for N=8")

Space-wise, this means that for an array of length $n$, we will at most require $\sum\limits_{i=0}^{\infty} \frac{n}{2^i}$ nodes in the tree, as $\frac{n}{2}$ parents will be needed for the n leaves, $\frac{n}{4}$ for those parents and so on. This geometric series converges to $2n$, leaving us a space complexity bound of $O(n)$.

The implementation of 1-value querrying is simple: we use the intervals to binary-search our target node. In doing so, we traverse only one tree branch, with time complexity $O(log\ n)$.

Updating and range-summing, on the other hand, are trickier. For them to be efficient, we need to process a whole work interval in $O(log\ n)$. To do so, we perform the same binary-search process as before, stopping when current work interval matches the interval of the node and otherwise further splitting the interval towards the following subtrees. On a given tree, such splitting will happen at most on $log(n)- 1$ nodes on either side, when the range covers all but the edges of the interval. When the intervals match, the operation will be applied.

Finally, to efficiently implement both range operations, branch nodes that represent intervals will require two variables: the amount that is added in common to all of their successors and the total sum of their values. That way, operations onto a given node will remain $O(1)$, with our previous analysis being applicable translating into a time complexity bounded by $O(log\ n)$.
