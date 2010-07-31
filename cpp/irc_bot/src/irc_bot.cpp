#include "irc_bot.h"
#include <stdlib.h>
#include <iostream>

IrcBot::IrcBot(std::string name,
	       std::string realn,
	       std::string passwd)
{
  nick = name;
  realname = realn;
  password = passwd;
}

IrcBot::~IrcBot()
{

}

void IrcBot::connect(std::string server, int port)
{
  Socket sock;
  if (!sock.connect(server, port))
  {
    std::cout << "Error connecting to server..." << std::endl;
    exit(0);
  }
  
  sock.send("NICK " + nick + "\r\n" + 
	    "USER " + nick + " " + nick + " " + server + " :" + realname);
  //sleep(2);
  //sock.send("JOIN #channel");
  
  std::string reply;
  
  bool running = true;
  while (running)
    {
      sock.recv(reply);
      std::cout << reply << std::endl;
      
      std::string prefix("PING ");
      if (!reply.compare(0, prefix.size(), prefix))
	sock.send("PONG " + reply.substr(reply.find(" ") + 1, reply.length()));
      else if (reply.find("ciao") != -1)
	sock.send("PRIVMSG " + reply.substr(1, reply.find("!") - 1) + " :sto dormendo...");
    }
}
