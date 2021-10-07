#include "Map.mqh"

template<typename KeyType, typename ValueType>
class CollectionCopyUtils {
    protected:
        CollectionCopyUtils() {};

        static CollectionCopyUtils* collection_copy_utils_singleton_;
    public:
        static CollectionCopyUtils* GetInstance();

    public:
        void CollectionCopyUtils::CopyMap(Map<KeyType, ValueType>& map_src, Map<KeyType, ValueType>& map_dst);
};

template<typename KeyType, typename ValueType>
CollectionCopyUtils* CollectionCopyUtils::collection_copy_utils_singleton_ = NULL;

template<typename KeyType, typename ValueType>
CollectionCopyUtils* CollectionCopyUtils::GetInstance() {
    if (CheckPointer(collection_copy_utils_singleton_) == POINTER_INVALID) {
        collection_copy_utils_singleton_ = new CollectionCopyUtils();
    }
    return collection_copy_utils_singleton_;
}

template<typename KeyType, typename ValueType>
void CollectionCopyUtils::CopyMap(Map<KeyType, ValueType>& map_src, Map<KeyType, ValueType>& map_dst) {
    foreachm(KeyType, key, ValueType, val, map_src) {
        map_dst.set(key, val);
    }
}