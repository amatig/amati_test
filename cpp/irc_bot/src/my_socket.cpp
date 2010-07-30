#include "my_socket.h"
#include <string.h>
#include <errno.h>
#include <fcntl.h>
//#include <iostream>

Socket::Socket():
  m_sock(-1)
{
  memset(&m_addr, 0, sizeof(m_addr));
}

Socket::~Socket()
{
  if (is_valid()) ::close(m_sock);
}

bool Socket::create()
{
  m_sock = socket(AF_INET, SOCK_STREAM, 0);
  
  if (!is_valid()) return false;
  
  // TIME_WAIT - argh
  int on = 1;
  if (setsockopt(m_sock, SOL_SOCKET, SO_REUSEADDR, (const char*)&on, sizeof(on)) == -1)
    return false;
  else
    return true;
}

bool Socket::send(std::string s)
{
  s += DELIMETER;
  int status = ::send(m_sock, s.c_str(), s.size(), MSG_NOSIGNAL);
  
  if (status == -1)
    return false;
  else
    return true;
}

int Socket::recv(std::string& s)
{
  s = "";
  char buf[MAX_RECV + 1];  
  memset(buf, 0, MAX_RECV + 1);
  
  int status = ::recv(m_sock, buf, MAX_RECV, 0);
  
  if (status == -1)
    {
      //std::cout << "status == -1 errno == " << errno << " in Socket::recv" << std::endl;
      return 0;
    }
  else if (status == 0)
    return 0;
  else
    {
      s = buf;
      return status;
    }
}

bool Socket::connect(std::string host, int port)
{
  if (!is_valid()) return false;
  
  m_addr.sin_family = AF_INET;
  m_addr.sin_port = htons(port);
  
  hostent *h = gethostbyname(host.c_str());
  m_addr.sin_addr.s_addr = ((in_addr*)h->h_addr)->s_addr;
  
  int status = inet_pton(AF_INET, host.c_str(), &m_addr.sin_addr);
  
  if (errno == EAFNOSUPPORT) return false;
  
  status = ::connect(m_sock, (sockaddr*)&m_addr, sizeof(m_addr));
  
  if (status == 0)
    return true;
  else
    return false;
}

void Socket::set_non_blocking(bool b)
{
  int opts;
  opts = fcntl(m_sock, F_GETFL);
  if (opts < 0) return;
  
  if (b)
    opts = (opts | O_NONBLOCK);
  else
    opts = (opts & ~O_NONBLOCK);
  
  fcntl(m_sock, F_SETFL, opts);
}
