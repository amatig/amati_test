#ifndef __MY_SOCKET__
#define __MY_SOCKET__

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string>

const int MAX_RECV = 1024;
const std::string DELIMETER = "\r\n";

class Socket
{
 private:
  int m_sock;
  sockaddr_in m_addr;
  
 public:
  Socket();
  virtual ~Socket();
  
  // Server initialization
  bool create();
  // Client initialization
  bool connect(std::string, int);
  // Data Transimission
  bool send(std::string);
  int recv(std::string&);
  void set_non_blocking(bool);
  bool is_valid() { return m_sock != -1; }
};

#endif
