// binary search tree (for numbers) in Io
// Jacob Peck - 20111011

// For study, not production use
// (hell, Io isn't for production use...)
// This implementation is unbalanced, and deletion always uses successor logic
// This implementation also uses the dreaded pointer-to-parent

// usage:
// create a root node by cloning BinarySearchTree
// i.e. root := BinarySearchTree clone
// perform all manipulations on the root node.

BinarySearchTree := Object clone do(
  // state
  value ::= nil;
  left ::= nil;
  right ::= nil;
  parent ::= nil;
  
  // constructor
  init := method(
    value = nil;
    left = nil;
    right = nil;
    parent = nil
  );
  
  // methods
  // add one element
  add := method(n,
    if(self value == nil, value = n; return);
    if(self value > n, 
      if(self left == nil, self left = BinarySearchTree clone);
      self left setParent(self);
      self left add(n);
      return
    );
    if(self value <= n, 
      if(self right == nil, self right = BinarySearchTree clone);
      self right setParent(self);
      self right add(n); 
      return
    )
  );
  // add a list of elements sequentially
  addList := method(l,
    l foreach(element, self add(element))
  );
  // search for an element, return true on success, false elsewise
  find := method(n,
    if(self value == n, return true);
    if((self left != nil) and(self value > n), return self left find(n));
    if((self right != nil) and(self value < n), return self right find(n));
    return false
  );
  // return the number of elements in the tree
  size := method(
    self traversePreOrder size
  );
  // is the tree empty?
  isEmpty := method(
    self size == 0
  );
  // return the in-order traversal as a list
  traverseInOrder := method(
    val := list();
    if(self left != nil, val := val append(self left traverseInOrder));
    val := val append(self value);
    if(self right != nil,val := val append(self right traverseInOrder));
    val = val flatten;
    if(val == list(nil), val := list());
    val
  );
  // return the pre-order traversal as a list
  // (note: a deep copy of a tree may be accomplished by running
  //  treeCopy := originalRootNode clone do(
  //    addList(originalRootNode traversePreOrder))
  traversePreOrder := method(
    val := list();
    val := val append(self value);
    if(self left != nil, val := val append(self left traversePreOrder));
    if(self right != nil, val := val append(self right traversePreOrder));
    val = val flatten;
    if(val == list(nil), val := list());
    val
  );
  // return the post-order traversal as a list
  traversePostOrder := method(
    val := list();
    if(self left != nil, val := val append(self left traversePostOrder));
    if(self right != nil, val := val append(self right traversePostOrder));
    val := val append(self value);
    val = val flatten;
    if(val == list(nil), val := list());
    val
  );
  // delete a node, using successor logic
  delete := method(n,
    if((n < self value) and(self left != nil), self left delete(n); return true);
    if((n > self value) and(self right != nil), self right delete(n); return true);
    if(self value == n, // in the right spot
      if((self left != nil) and(self right != nil),
        successor := self right findMin();
        self value = successor value;
        successor replaceNodeInParent(successor right);
        return true
      );
      if((self left != nil) and(self right == nil),
        if(self isRoot,
          self value = left value;
          if(self left != nil, self left = left left);
          if(self right != nil, self right = left right);
          self parent = nil;
          if(self left != nil, self left setParent(self));
          if(self right != nil, self right setParent(self)),
          self replaceNodeInParent(self left);
        );
        return true
      );
      if((self right != nil) and(self left == nil),
        if(self isRoot,
          self value = right value;
          if(self right != nil, self left = right left);
          if(self right != nil, self right = right right);
          self parent = nil;
          if(self left != nil, self left setParent(self));
          if(self right != nil, self right setParent(self)),
          self replaceNodeInParent(self right)
        );
        return true
      );
      if(self isLeaf,
        if(self isRoot,
          self value = nil;
          return true
        );
        self replaceNodeInParent(nil);
        return true
      )
    );
    true
  );
  
  // helper methods, don't call these directly
  // is root?
  isRoot := method(
    if(self parent == nil, true, false)
  );
  // is leaf?
  isLeaf := method(
    if((self left == nil) and(self right == nil), true, false)
  );
  // finds the smallest element
  findMin := method(
    min := self;
    while(min left != nil, min = self left);
    min
  );
  // removes the reference to self from parent and replaces it with newValue
  replaceNodeInParent := method(newValue,
    if(self isRoot not,
      if(self parent left == self,
        self parent left = newValue,
        self parent right = newValue
      )
    );
    if(newValue != nil,
      newValue parent = self parent
    );
    nil
  )
)

