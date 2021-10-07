#include "all.mqh"

template<typename key_type, typename val_type>
class MapDeleteUtils {
    public:
        static void SafeFreeHashMap(HashMap<key_type, val_type>* m) {
            foreachm(key_type, k, val_type, v, m) {
                SafeDelete(v);
            }
            SafeDelete(m);
        }
};

template<typename ele_type>
class SetDeleteUtils {
    public:
        static void SafeFreeHashSet(HashSet<ele_type>* s) {
            for(Iter<ele_type> iter(s); !iter.end(); iter.next()) {
                SafeDelete(iter.current());
            }
            SafeDelete(s);
        }
};