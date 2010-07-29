#include <iostream>
#include <string>

#include "my_socket.h"

using namespace std;

class IrcBot
{
 private:
  string nick;
  string realname;
  string password;
  string server;
  int port;
  string channel;
  
 public:
  IrcBot(string, string, string, string, int, string);
  ~IrcBot();
  void start();
};
