#include "irc_bot.h"

IrcBot::IrcBot(string name,
	       string realn,
	       string passwd,
	       string serv,
	       int p,
	       string chan)
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

void IrcBot::start()
{
  cout << "ciao" << endl;
}
