#ifndef __IRC_BOT__
#define __IRC_BOT__

#include "my_socket.h"
#include <string>
#include <vector>

class IrcBot
{
 private:
  Socket sock;
  bool running;
  std::string nick;
  std::string realname;
  std::string password;
  
  void authentication();
  void split(const std::string&, 
	     std::vector<std::string>&, 
	     const std::string& = " ");
  void dispatcher(std::string);
  void pong(std::string);
  void privmsg(std::string, std::string);
  
 public:
  IrcBot(std::string, std::string, std::string = "");
  virtual ~IrcBot() {};
  void connect(std::string, int);
};

#endif
