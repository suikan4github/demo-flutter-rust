#include <stdio.h>
#include <dlfcn.h>

int main() {
    // ライブラリを動的に読み込み
    void* handle = dlopen("/home/seiichi/git/demo-flutter-rust/demo_flutter_rust_cpu/cpu_monitor/target/release/libcpu_monitor.so", RTLD_LAZY);
    
    if (!handle) {
        printf("Error loading library: %s\n", dlerror());
        return 1;
    }
    
    // 関数ポインタを取得
    void (*init_cpu_monitor)() = dlsym(handle, "init_cpu_monitor");
    int (*get_cpu_count)() = dlsym(handle, "get_cpu_count");
    void (*update_cpu_info)() = dlsym(handle, "update_cpu_info");
    float (*get_cpu_usage)(int) = dlsym(handle, "get_cpu_usage");
    
    if (!init_cpu_monitor || !get_cpu_count || !update_cpu_info || !get_cpu_usage) {
        printf("Error finding functions: %s\n", dlerror());
        dlclose(handle);
        return 1;
    }
    
    // 関数を呼び出し
    printf("Initializing CPU monitor...\n");
    init_cpu_monitor();
    
    printf("Getting CPU count...\n");
    int cpu_count = get_cpu_count();
    printf("CPU Count: %d\n", cpu_count);
    
    printf("Updating CPU info...\n");
    update_cpu_info();
    
    printf("Getting CPU usage for each core:\n");
    for (int i = 0; i < cpu_count; i++) {
        float usage = get_cpu_usage(i);
        printf("CPU %d: %.1f%%\n", i, usage);
    }
    
    dlclose(handle);
    printf("Test completed successfully!\n");
    return 0;
}
