#include <cstring>
#include <iostream>
#include <sparsehash/dense_hash_set>

struct eqstr {
  bool operator()(const char *s1, const char *s2) const {
    return (s1 == s2) || (s1 && s2 && std::strcmp(s1, s2) == 0);
  }
};

void lookup(const google::dense_hash_set<const char *, std::hash<const char *>,
                                         eqstr> &Set,
            const char *word) {
  google::dense_hash_set<const char *, std::hash<const char *>,
                         eqstr>::const_iterator it = Set.find(word);
  std::cout << word << ": " << (it != Set.end() ? "present" : "not present")
            << std::endl;
}

int main() {
  google::dense_hash_set<const char *, std::hash<const char *>, eqstr> Set;
  Set.set_empty_key(NULL);
  Set.insert("kiwi");
  Set.insert("plum");
  Set.insert("apple");
  Set.insert("mango");
  Set.insert("apricot");
  Set.insert("banana");

  lookup(Set, "mango");
  lookup(Set, "apple");
  lookup(Set, "durian");
}
