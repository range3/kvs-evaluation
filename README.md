# kvs-evaluation
```bash
cd external/YCSB-C

# sudoを使ってlibhiredis.soが/usr/local/libにインストールされる
make
export LD_LIBRARY_PATH=/usr/local/lib

# 動作確認
./ycsbc -db basic -threads 1 -P workloads/workloada.spec
```

# YCSB-C
```mermaid
classDiagram
class DBFactory
class DB
class HashtableDB
class LockStlDB
class StringHashtable~V~
class KeyHashtable
class FieldHashtable
class StlHashTable~V~
class StlHashTableKey {
  std::unorderd_map~String,FieldHashtable*~
}
class StlHashTableField {
  std::unorderd_map~String,const char*~
}
class LockStlHashtable~T~
class LockStlHashtableKey {
  std::mutex
}
class LockStlHashtableField {
  std::mutex
}

DBFactory ..> LockStlDB : create
LockStlDB *-- LockStlHashtableKey
LockStlHashtableKey o-- LockStlHashtableField
LockStlDB ..> LockStlHashtableField : create

DB <|.. HashtableDB
HashtableDB <|.. LockStlDB
StringHashtable <|.. StlHashTable
StlHashTable <|--LockStlHashtable

StringHashtable .. FieldHashtable : instantiation
StringHashtable .. KeyHashtable : instantiation
StlHashTable .. StlHashTableKey : instantiation
StlHashTable .. StlHashTableField : instantiation
LockStlHashtable .. LockStlHashtableKey : instantiation
LockStlHashtable .. LockStlHashtableField : instantiation

StlHashTableKey  <|-- LockStlHashtableKey
StlHashTableField  <|-- LockStlHashtableField
KeyHashtable <|.. StlHashTableKey
FieldHashtable <|.. StlHashTableField

HashtableDB ..> KeyHashtable : use
HashtableDB ..> FieldHashtable : use
```
