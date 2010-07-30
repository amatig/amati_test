#include <string>
#include "my_socket.h"

class IrcBot
{
 private:
  std::string nick;
  std::string realname;
  std::string password;
  std::string server;
  int port;
  std::string channel;
  
 public:
  IrcBot(std::string, std::string, std::string, std::string, int, std::string);
  virtual ~IrcBot();
  void connect();
};
