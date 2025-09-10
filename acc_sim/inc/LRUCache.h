//
// Created by test on 2023/4/7.
//

#ifndef ACCELERATOR_LRUCACHE_H
#define ACCELERATOR_LRUCACHE_H

#include <iostream>
#include <unordered_map>
#include <list>

using namespace std;

template <typename KeyT, typename ValueT>

class LRUCache {
public:
    LRUCache(int capacity) : capacity(capacity) {}

    ValueT get(const KeyT& key) {
        auto it = cache.find(key);
        if (it == cache.end()) {
            // 如果缓存中没有找到对应的键，则返回默认值
            return ValueT();
        } else {
            // 将访问的键移到链表头部，并返回对应的值
            updateLRUList(it);
            return it->second.first;
        }
    }

    void put(const KeyT& key, const ValueT& value) {
        auto it = cache.find(key);
        if (it != cache.end()) {
            // 如果键已经存在，更新对应的值，并将键移到链表头部
            it->second.first = value;
            updateLRUList(it);
        } else {
            // 如果键不存在，插入新的键值对，并将键移到链表头部
            if (cache.size() >= capacity) {
                // 如果缓存容量已满，移除最近最少使用的键
                const KeyT& lastKey = lruList.back();
                cache.erase(lastKey);
                lruList.pop_back();
            }
            lruList.push_front(key);
            cache[key] = make_pair(value, lruList.begin());
        }
    }

    void clear(){
        cache.clear();
        lruList.clear();
    }
private:
    int capacity; // 缓存容量
    unordered_map<KeyT, pair<ValueT, typename list<KeyT>::iterator>> cache; // 哈希表存储键值对
    list<KeyT> lruList; // 双向链表存储键的访问顺序

    void updateLRUList(typename unordered_map<KeyT, pair<ValueT, typename list<KeyT>::iterator>>::iterator it) {
        // 将访问的键移到链表头部
        lruList.erase(it->second.second);
        lruList.push_front(it->first);
        it->second.second = lruList.begin();
    }
};


#endif //ACCELERATOR_LRUCACHE_H
