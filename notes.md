## Prior art

* [Jordan Walkes's Component Model](https://gist.github.com/jordwalke/67819c91df1552009b22)
  * [Take 2](https://gist.github.com/jordwalke/c60c91ff6c82d47bf605)
* [React Haskell](https://github.com/joelburget/react-haskell)
* [oHm](https://github.com/boothead/oHm)

## Optimizations

### Static Values

* Ember's [Glimmer Engine at HN](https://news.ycombinator.com/item?id=9139817)
  Glimmer pushes reactivity out of the root of the tree and into the leaves.
  In particular, it assumes that most of the tree is static and that each leaf
  is (essentially, but in a complex way) an FRP behavior. Leaves are resampled
  in a single walk over the tree and thus diffing can be done leaf-locally.
* React's ["Reuse Constant Value Types like ReactElement"](https://github.com/facebook/react/issues/3226)
  Includes the ability to treat ReactElements as value types and reuse them
  immutably. Nothing too exciting, but worth noting. Easy to implement in OCaml
* React's ["Tagging ReactElements"](https://github.com/facebook/react/issues/3227)
  Unsure.
* React's ["Inline ReactElements"](https://github.com/facebook/react/issues/3228)
  Unsure.
