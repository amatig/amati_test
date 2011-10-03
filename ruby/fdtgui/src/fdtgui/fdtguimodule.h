#ifndef FDTGUIMODULE_H
#define FDTGUIMODULE_H
#include <string>

class FdtGuiModule
{
    enum Language {
        c,
        cpp,
        ruby,
        python,
    };

protected:
    FdtGuiModule();
    ~FdtGuiModule();
private:
    std::string path;
    std::string name;
    Language lang;
};


class FdtModuleLoader
{
public:
    FdtModuleLoader(char *path);
    ~FdtModuleLoader();
private:
    string path_to_modules;
};

#endif // FDTGUIMODULE_H
