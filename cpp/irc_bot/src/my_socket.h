#ifndef __MY_SOCKET__
#define __MY_SOCKET__

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string>

const int MAXHOSTNAME = 200;
const int MAXRECV = 500;

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
  bool connect(const std::string, const int);
  
  // Data Transimission
  bool send(const std::string) const;
  int recv(std::string&) const;
  void set_non_blocking(const bool);
  bool is_valid() const { return m_sock != -1; }
};

#endif
