#include <QtGui/QApplication>
#include <string>
#include "fdtmaingui.h"
#include "fdtguimodule.h"
#include <iostream>
#include <cstdio>
#include <dirent.h>
#ifdef WINDOWS
    #include <direct.h>
    #define GetCurrentDir _getcwd
#else
    #include <unistd.h>
    #define GetCurrentDir getcwd
#endif

int main(int argc, char *argv[])
{
    char cCurrentPath[FILENAME_MAX];
    if (!GetCurrentDir(cCurrentPath, FILENAME_MAX)){
        return 0;
    }
    std::cout << "The current working directory is" << cCurrentPath<< std::endl;

    FdtModuleLoader l(cCurrentPath);
    QApplication a(argc, argv);
    FdtMainGui w;
    w.show();

    return a.exec();
}
