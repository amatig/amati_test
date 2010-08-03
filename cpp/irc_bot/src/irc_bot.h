#ifndef __IRC_BOT__
#define __IRC_BOT__

#include "my_socket.h"
#include <string>

class IrcBot
{
 private:
  Socket sock;
  bool running;
  std::string nick;
  std::string realname;
  std::string password;
  
  friend void *dispatcher(void *);
  
  void authentication();
  void pong(std::string);
  void privmsg(std::string, std::string);
  
 public:
  IrcBot(std::string name, std::string realn, std::string passwd = ""):
    nick(name),
    realname(realn),
    password(passwd),
    running(false) {};
  virtual ~IrcBot() {};
  void run(std::string, int);
  void stop();
};

struct Args {
  IrcBot *object;
  std::string *data;
};

#endif
