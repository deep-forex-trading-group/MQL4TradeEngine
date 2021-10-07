#include "all.mqh"

template<typename key_type, typename val_type>
class MapDeleteUtils {
    public:
        static void SafeFreeHashMap(HashMap<key_type, val_type>* m_ptr) {
            if (CheckPointer(m_ptr) == POINTER_INVALID) {
                SafeDelete(m_ptr);
                return;
            }
            foreachm(key_type, k, val_type, v, m_ptr) {
                SafeDelete(v);
            }
            SafeDelete(m_ptr);
        }
};

template<typename ele_type>
class SetDeleteUtils {
    public:
        static void SafeFreeHashSet(HashSet<ele_type>* s_ptr) {
            if (CheckPointer(s_ptr) == POINTER_INVALID) {
                SafeDelete(s_ptr);
                return;
            }
            for(Iter<ele_type> iter(s); !iter.end(); iter.next()) {
                SafeDelete(iter.current());
            }
            SafeDelete(s_ptr);
        }
};