#include "irc_bot.h"
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
  s.create();
  s.connect(server, port);
  
  s.send("NICK " + nick);
  s.send("USER " + nick + " " + nick + " " + server + " :" + realname);
  s.send("JOIN " + channel);
  
  std::string reply;
  
  bool running = true;
  while (running)
    {
      s.recv(reply);
      std::cout << reply << std::endl;
    }
}
