#include "fdtguimodule.h"
#include <cstdio>
#include <cstring>
#include <dirent.h>
#ifdef WINDOWS
    #include <direct.h>
    #define GetCurrentDir _getcwd
#else
    #include <unistd.h>
    #define GetCurrentDir getcwd
#endif
#include <iostream>

FdtModuleLoader::FdtModuleLoader(char *path)
{
    char ipath[sizeof(path)];
    strcpy(ipath, path);
    DIR *db;
    char *index;
    struct dirent *ep;
    struct dirent *find = NULL;
    int error = 0;
    while( not find and not error )
    {
        db = opendir(ipath);
        if( db!= NULL)
        {
            while( (ep=readdir(db)) and not find )
            {
                if (strcmp(ep->d_name,"modules")==0)
                {
                    path_to_modules=ipath;
                    find = ep;
                }
            }
            closedir(db);
        }
        else
            std::cout << "Can't open directory: " << path << std::endl;
        if( (index = strrchr(ipath,'/')) and (index-ipath>0))
            *index = '\0';
        else
            error = 1;
        std::cout << "la stringa e': " << ipath << std::endl;
    }
    // beccare tutti i moduli //


}

FdtModuleLoader::~FdtModuleLoader()
{
}
