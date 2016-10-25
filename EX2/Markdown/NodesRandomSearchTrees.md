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

Node Depths and Subtree Sizes in Random Search Trees
=============

Initial analysis
-------------

To give an estimation on the depth of a given node, i, we would need to consider how many of the other nodes are its ancestors. For this, an indicator variable can be defined as follows:

$$X_{ij} = \cases{
1 & if j is an ancestor of i,\cr
0 & otherwise
}$$

With this indicator variable, analysis can be performed taking the indices as those of the  sorted set when in order: $z_1, z_2, ..., z_n$. For two arbitrary indices $z_i$, $z_j$ only three possible scenarios apply:

1. $z_i$ was selected as a key on the tree before $z_j$, so $z_j$ is a successor of $z_i$ and thus $X_{ij} = 0$.
2. Neither $z_i$ nor $z_j$ were selected as a key on the tree before, so a key in the range $(i, ..., j)$ or $(j, ..., i)$ effectively splits the range and thus $X_{ij} = 0$.
3. $z_j$ was selected as a key on the tree before $z_i$, so $z_i$ will eventually be found and selected as a key preceded by $z_j$ and thus $X_{ij} = 1$.

Expected depth
-------------

With this analysis in mind, the expectency of the indicator variable can be computed as follows:

$$E[\sum\limits_{\substack{j = 1\\\j \ne i}}^{n} X_{ij}] = \sum\limits_{\substack{j = 1\\\j \ne i}}^{n} P(X_{ij} = 1) = ...$$ 

Given the previous analysis, the probability of $X_{ij}$ in the interval containing $z_i$ and $z_j$ on both extremes is that of the only case in which $z_j$ may be an ancestor of $z_i$ over the total amount of cases. In this case that means the number of elements in the range:

$$... = \sum\limits_{\substack{j = 1\\\j \ne i}}^{n} \frac{1}{|j - i| + 1} = ...$$

To explicitly take into account the two orderings between $z_i$ and $z_j$, we split the computation in two terms. The result resembles two instances of the harmonic series, which are then approximated to $ln(n)$:

$$... = \sum\limits_{\substack{j = 1}}^{i - 1} \frac{1}{i - j + 1} +
\sum\limits_{\substack{j = i + 1}}^{n} \frac{1}{j - i + 1} <
ln(n) + ln(n) = 2 ln(n)
$$

Concludingly, the depth of a node in a random search tree is expected to be $2 ln(n)$. 

Size of subtrees of a node
-------------

A variation on the same analysis can be performed to estimate the size of the subtree spanning from a given node. In this case, a similar indicator variable is defined with slightly different semantics:

$$X_{ij} = \cases{
1 & if j is an successor of i,\cr
0 & otherwise
}$$

The analysis and computations to be performed afterwards will follow the same structure as before, producing in the same expectancy results for the predicate.