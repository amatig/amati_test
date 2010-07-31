#include "irc_bot.h"
#include <string.h>
#include <stdlib.h>
#include <iostream>

IrcBot::IrcBot(std::string name, std::string realn, std::string passwd)
{
  nick = name;
  realname = realn;
  password = passwd;
}

void IrcBot::connect(std::string server, int port)
{
  if (!sock.connect(server, port))
  {
    std::cout << "Error connecting to server..." << std::endl;
    exit(0);
  }
  
  auth(nick, realname);  
  
  std::string data;
  bool running = true;
  while (running)
    {
      sock.recv(data);
      dispatcher(data);
    }
}

void IrcBot::dispatcher(std::string data)
{
  std::string prefix("PING ");
  if (!data.compare(0, prefix.size(), prefix))
    pong(data.substr(data.find(" ") + 1, data.length()));
  else if (data.find("ciao") != -1)
    privmsg(data.substr(1, data.find("!") - 1), "sto dormendo...");
  
  char* token; 
  token = strtok((char*)data.c_str(), DELIMETER); 
  while (token != NULL)
    {
      std::string row(token);
      //std::cout << row << std::endl;
      
      std::string prefix2;
      int s = 0;
      if (row[0] == ':')
	{
	  s = row.find(" ");
	  prefix2 = row.substr(1, s - 1);
	  row = row.substr(s + 1, row.length());
	}
      std::cout << prefix2 << "---->" << row.substr(0, row.find(" ")) << std::endl;
      
      token = strtok(NULL, DELIMETER);
    }
}

void IrcBot::auth(std::string nick, std::string realename)
{
  sock.send("NICK " + nick + "\r\n" +
	    "USER " + nick + " " + nick + " bla :" + realname);
}

void IrcBot::pong(std::string server)
{
  sock.send("PONG " + server);
}

void IrcBot::privmsg(std::string target, std::string msg)
{
  sock.send("PRIVMSG " + target + " :" + msg);
}
