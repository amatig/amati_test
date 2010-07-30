#include "irc_bot.h"
#include <stdlib.h>
#include <iostream>

IrcBot::IrcBot(std::string name,
	       std::string realn,
	       std::string passwd,
	       std::string serv,
	       int p,
	       std::string chan)
{
  nick = name;
  realname = realn;
  password = passwd;
  server = serv;
  port = p;
  channel = chan;
}

IrcBot::~IrcBot()
{

}

void IrcBot::connect()
{
  Socket s;
  if (!s.connect(server, port))
  {
    std::cout << "Error connecting to server..." << std::endl;
    exit(0);
  }
  
  s.send("USER " + nick + " " + nick + " " + server + " :" + realname);
  s.send("NICK " + nick);
  s.send("JOIN " + channel); // passwd canale?
  
  std::string reply;
  
  bool running = true;
  while (running)
    {
      s.recv(reply);
      std::cout << reply << std::endl;
    }
}
