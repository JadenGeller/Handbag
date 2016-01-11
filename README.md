# Handbag

`Bag` is a counted set type suitable for representing unordered collections of non-unique elements. A `Bag` can be initialized from either a dictionary literal specifying the number of each type of element or from an array literal specifying the elements.
```swift
let blah: Bag = ["hi" : 3, "bye" : 2]
let bleh: Bag = ["hi", "hi", "hi", "bye", "bye"]
```

You can easily check the count of a given element in a `Bag` using subscript notation. Elements can easily be added and removed as well.
```swift
print(blah["hi"]) // -> 3
blah["hi"] += 2
blah.insert("hello", count: 7)
blah.remove("bye", count: 5)
```

`Bag` is a `CollectionType` that may contain multiple copies of each element. For example, mapping `print` over `["hi" : 3]` will print "hi" three times.

Since `Bag` is a multiset, you can perform common set operations on it, such as `union`, `subtract`, and `intersect`. Further, you can check if a given `Bag` is a superset of, subset of, or is disjoint with another `Bag`.
