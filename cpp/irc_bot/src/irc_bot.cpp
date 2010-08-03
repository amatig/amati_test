#include "irc_bot.h"
#include "utils.h"
#include <pthread.h>
#include <stdio.h>
#include <vector>
#include <iostream>

void *dispatcher(void *args)
{
  pthread_t tid = pthread_self();
  printf("THREAD 0x%x\n", tid);
  
  struct Args *a = (struct Args *)args;
  IrcBot *self = (IrcBot *)a->object;
  std::string *data = (std::string*)a->data;
  
  std::vector<std::string> lines;
  split(*data, lines, DELIMETER);
  
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
		self->privmsg(target, "sto dormendo...");
	      else if (msg.find("\\esci") != -1)
		self->stop();
	    }
	}
      else
	{
	  if (cmd == "PING")
	    self->pong(row);
	}
    }
  pthread_exit((void *)0);
}

void IrcBot::run(std::string server, int port)
{
  if (sock.connect(server, port))
    {
      //sleep(1);
      authentication();
      running = true;
      

      std::string data;
      while (running)
	{
	  sock.recv(data);
	  struct Args args = {this, &data};
	  pthread_t th;
	  int temp = pthread_create(&th, NULL, dispatcher, &args);
	  pthread_join(th, NULL);
	  //dispatcher(data);
	}
    }
  else
    std::cout << "Error connecting to server..." << std::endl;
}

void IrcBot::stop()
{
  running = false;
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
