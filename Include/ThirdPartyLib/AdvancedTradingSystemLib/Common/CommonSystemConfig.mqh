enum SYSTEM_MODE {
    TEST_MODE,
    PRODUCTION_MODE
};
#define TESTING_CODE_ST(system_mode) \
if (system_mode == TEST_MODE) {
#define TESTING_CODE_END(system_mode) \
}