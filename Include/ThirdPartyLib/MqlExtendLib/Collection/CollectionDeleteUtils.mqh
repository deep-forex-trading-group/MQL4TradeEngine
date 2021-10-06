#include "all.mqh"

template<typename key_type, typename val_type>
class CollectionDeleteUtils {
    public:
        static void DeleteHashMap(HashMap<key_type, val_type>* m) {
            foreachm(key_type, k, val_type, v, m) {
                SafeDelete(v);
            }
        }
}