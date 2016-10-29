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

Pairwise Independency on Universal Hash Functions
=============

Given pairwise independency as defined in the problem statement, that is:

$$
\underset{h \in \mathcal{H}}{Pr}[h(x_1) = c_1 \wedge h(x_2) = c_2] = \underset{h \in \mathcal{H}}{Pr}[h(x_1) = c_1] \times \underset{h \in \mathcal{H}}{Pr}[h(x_2) = c_2] 
$$

Each of the probabilities on the right side of the equation are equal to $\frac{1}{m}$, steeming from the fact that there are $m$ buckets chosen in a uniformly distributed manner. The complete result on the right side of the equation is a probability of $\frac{1}{m^2}$. On the left side of the equation, $h(x_1)$ and $h(x_2)$ can be represented in full as:

$$
\left.
\begin{array}{l}
\text{$h(x_1)$ = ($a·x_1 + b$ mod $p$) mod $m$}\\\
\text{$h(x_2)$ = ($a·x_2 + b$ mod $p$) mod $m$}
\end{array}
\right\\}
x_1 \ne x_2
$$

Now consider the inner modulo $p$ expressions as $r = a·x_1 + b$ mod $p$ and $s = a·x_2 + b$ mod $p$. Under this lens, the original expression becomes ${Pr}[r \text{ mod } m = c_1 \wedge s \text{ mod } m  = c_2]$. Since $a$ entails $[1...p-1]$ possible values and $b$ entails $[0...p-1]$ possible values, and since both $a$ and $b$ are fixed for both $r$ and $s$, then there are $p·(p-1)$ possible values for $r$ and for $s$. 

Focusing now on $c_1$ and $c_2$, and when $p$ is sufficiently larger than $m$, the number of values that will match with a given value $c_i$ will depend on how much larger $p$ is over $m$, that is, on $\frac{p}{m}$. However, the context of modular arithmetic needs to be taken into account: not all values will have the same number of matches unless $m$ is a multiple of $p$. Adding this into the analysis, the number of matches are bound by considering the round-to-floor and round-to-ceil limits: 

$$\Bigl\lfloor\frac{p}{m}\Bigr\rfloor \le \text{# of values matching a value $c_i$} \le \Bigl\lceil\frac{p}{m}\Bigr\rceil$$

The joint probability can then be bound by combining both pieces of the analysis, giving us an approximation to the expected $\frac{1}{m^2}$:

$$
\frac{1}{p·(p-1)}\Bigl(\Bigl\lfloor\frac{p}{m}\Bigr\rfloor\Bigr)^2  \le {Pr}[r \text{ mod } m = c_1 \wedge s \text{ mod } m  = c_2] \le \frac{1}{p·(p-1)}\Bigl(\Bigl\lceil\frac{p}{m}\Bigr\rceil\Bigr)^2 
$$

It must be noted that the $\frac{1}{m^2}$ result may not be fully reached because of the possible values for $a$, which make it impossible to remove a $\frac{p}{p-1}$ term. Since allowing $a = 0$ would not make sense algorithmically, the result can only be approximated.
