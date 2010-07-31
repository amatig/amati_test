#ifndef __IRC_BOT__
#define __IRC_BOT__

#include "my_socket.h"
#include <string>

class IrcBot
{
 private:
  Socket sock;
  std::string nick;
  std::string realname;
  std::string password;
  
  void auth(std::string, std::string);
  void dispatcher(std::string);
  
 public:
  IrcBot(std::string, std::string, std::string);
  virtual ~IrcBot() {};
  void connect(std::string, int);
  void pong(std::string);
  void privmsg(std::string, std::string);
};

#endif
