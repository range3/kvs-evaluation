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
## workload
| workload | description       | read | insert | update | scan | R-M-W | distribution |              remarks              |
| :------- | :---------------- | ---: | -----: | -----: | ---: | ----: | :----------: | :-------------------------------: |
| A        | Update heavy      |  0.5 |        |    0.5 |      |       |   zipfian    |                                   |
| B        | Read mostly       | 0.95 |        |   0.05 |      |       |   zipfian    |                                   |
| C        | Read only         |    1 |        |        |      |       |   zipfian    |                                   |
| D        | Read latest       | 0.95 |   0.05 |        |      |       |    latest    |                                   |
| E        | Short ranges      |      |   0.05 |        | 0.95 |       |   zipfian    | maxscanlength=100 random(uniform) |
| F        | Read-modify-write |  0.5 |        |        |      |   0.5 |   zipfian    |                                   |

## class diagram (subset)
```mermaid
classDiagram
class DBFactory
class DB
<<interface>> DB
class HashtableDB
<<abstruct>> HashtableDB
class LockStlDB
class StringHashtable~V~
<<interface>> StringHashtable
class KeyHashtable
<<interface>> KeyHashtable
class FieldHashtable
<<interface>> FieldHashtable
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
