#include "my_socket.h"
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <iostream>

Socket::Socket():
  m_sock(-1)
{
  memset(&m_addr, 0, sizeof(m_addr));
}

Socket::~Socket()
{
  if (is_valid()) {
    ::shutdown(m_sock, SHUT_RDWR); // interrompe tutti e due i flussu in/out
    ::close(m_sock); // chiude il socket
  }
}

bool Socket::connect(std::string host, int port)
{
  m_sock = socket(AF_INET, SOCK_STREAM, 0);
  if (!is_valid()) return false;
  
  // TIME_WAIT - argh
  int on = 1;
  if (setsockopt(m_sock, SOL_SOCKET, SO_REUSEADDR, (const char*)&on, sizeof(on)) == -1)
    return false;
  if (!is_valid()) return false;
  // end argh
  
  m_addr.sin_family = AF_INET;
  m_addr.sin_port = htons(port);
  hostent *h = gethostbyname(host.c_str());
  m_addr.sin_addr.s_addr = ((in_addr*)h->h_addr)->s_addr;
  //m_addr.sin_addr.s_addr = inet_addr("62.211.73.232");
  bzero(&(m_addr.sin_zero), 8);
  
  int status = inet_pton(AF_INET, host.c_str(), &m_addr.sin_addr);
  if (errno == EAFNOSUPPORT) return false;
  
  status = ::connect(m_sock, (sockaddr*)&m_addr, sizeof(m_addr));
  
  //set_non_blocking(true); // se si fa multi-thread
  
  if (status == 0)
    return true;
  else
    return false;
}

bool Socket::send(std::string s)
{
  //sleep(2); // si incastra a volte
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
      std::cout << "status == -1 errno == " << errno << " in Socket::recv" << std::endl;
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

void Socket::set_non_blocking(bool b)
{
  int opts = fcntl(m_sock, F_GETFL); 
  if (opts < 0) return;
  if (b)
    opts = (opts | O_NONBLOCK);
  else
    opts = (opts & ~O_NONBLOCK);
  fcntl(m_sock, F_SETFL, opts);
}
