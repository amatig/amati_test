#ifndef __UTILS__
#define __UTILS__

#include <string>
#include <vector>

#ifdef __cplusplus
extern "C" {
#endif

extern void split(const std::string&, 
		  std::vector<std::string>&, 
		  const std::string& = " ");

#ifdef __cplusplus
}
#endif

#endif
