#include "irc_bot.h"
#include "utils.h"
#include <string.h>
#include <stdlib.h>
#include <vector>
#include <iostream>

IrcBot::IrcBot(std::string name, std::string realn, std::string passwd)
{
  nick = name;
  realname = realn;
  password = passwd;
  
  running = false;
}

void IrcBot::connect(std::string server, int port)
{
  if (!sock.connect(server, port))
  {
    std::cout << "Error connecting to server..." << std::endl;
    exit(1);
  }
  
  sleep(1);
  authentication();
  running = true;
  
  std::string data;
  while (running)
    {
      sock.recv(data);
      dispatcher(data);
    }
}

void IrcBot::dispatcher(std::string data)
{
  std::vector<std::string> lines;
  split(data, lines, DELIMETER);
  
  for (int i = 0; i < lines.size(); i++)
    {
      std::string row = lines.at(i);
      std::cout << row << std::endl;
      
      int s = 0;
      std::string prefix;
      
      if (row.at(0) == ':')
	{
	  s = row.find(" ");
	  prefix = row.substr(0, s);
	  row = row.substr(s + 1, row.length());
	}
      
      s = row.find(" ");
      std::string cmd = row.substr(0, s);
      row = row.substr(s + 1, row.length());
      
      if (!prefix.empty())
	{
	  std::string target = prefix.substr(1, prefix.find("!") - 1);
	  if (cmd == "PRIVMSG")
	    {
	      std::string msg = row.substr(row.find(":") + 1, row.length());
	      
	      if (msg.find("ciao") != -1)
		privmsg(target, "sto dormendo...");
	      else if (msg.find("\\esci") != -1)
		running = false;
	    }
	}
      else
	{
	  if (cmd == "PING")
	    pong(row);
	}
    }
}

void IrcBot::authentication()
{
  sock.send("NICK " + nick + DELIMETER +
	    "USER " + nick + " " + nick + " bla :" + realname + DELIMETER + 
	    "NS identify " + password);
}

void IrcBot::pong(std::string data)
{
  sock.send("PONG " + data);
}

void IrcBot::privmsg(std::string target, std::string msg)
{
  sock.send("PRIVMSG " + target + " :" + msg);
}
