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
  Socket s;
  s.create();
  s.connect("irc.azzurra.org", 6667);
  
  string reply;
  
  s.send("NICK amatig\r\n");
  s.send("USER amatig amatig bla :amatig\r\n");
  s.send("JOIN #casd\r\n");
  
  s.recv(reply);
  cout << reply << endl;
}
